Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE81197521;
	Thu,  6 Jun 2024 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682972; cv=none; b=fTE+Yj/YCD0X+RYDVSkox66BWdXUcloH5zcqIpyphfmcPsLBuZPhy5ImDxHvbdzLsQIYGx+ppmtfzbvHsZcaNEEDnE3Y+aKg1Q4BePvOS3MtZG4aYWplzJOmWulU+I6Aw9kb3ssEoBQuWXD9tiMHMzM6nDKJvDgLl6XQxF95Tkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682972; c=relaxed/simple;
	bh=5muAA8RnlDVLJXG0sUWGh1o1UxRqn8M02cGkQSUgxrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJB46d8gpMNmsy78dcQXpnKvWrdIS8zxo8G0FmgAjs8dc8Qp/LyQ3jmiXT2Zsd3JBfKAJ0w/iq33Pohwg8I3LkQiJDRyO66/78lSnM7VRUTalEPM+iHk0aiIG+Mj7r9Lpls10cqqYxb7ARZ/BiFZWCRWGAiBCIEI6gjGALCMzu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ1ip0t2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ1ip0t2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078DDC2BD10;
	Thu,  6 Jun 2024 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682972;
	bh=5muAA8RnlDVLJXG0sUWGh1o1UxRqn8M02cGkQSUgxrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ1ip0t2hfPR5nUFg2vN6AsZYMn4WH9Z+cN1p8R6h6uVD09MaFpU5nlfChEp+zZUF
	 exlA58UKXZtqiSEujNcCKVKCqj34z24Ol2nv+hkC8Ma5Ip/wOJdQ4Z2lvw++CwSr8d
	 tJgPVK3zIecxQwjZfKleTwSUYEJ55KNPHLjGI+dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 146/374] Input: ims-pcu - fix printf string overflow
Date: Thu,  6 Jun 2024 16:02:05 +0200
Message-ID: <20240606131656.809882458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bf32bceedd0453c70d9d022e2e29f98e446d7161 ]

clang warns about a string overflow in this driver

drivers/input/misc/ims-pcu.c:1802:2: error: 'snprintf' will always be truncated; specified size is 10, but format string expands to at least 12 [-Werror,-Wformat-truncation]
drivers/input/misc/ims-pcu.c:1814:2: error: 'snprintf' will always be truncated; specified size is 10, but format string expands to at least 12 [-Werror,-Wformat-truncation]

Make the buffer a little longer to ensure it always fits.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240326223825.4084412-7-arnd@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 6e8cc28debd97..80d16c92a08b3 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -42,8 +42,8 @@ struct ims_pcu_backlight {
 #define IMS_PCU_PART_NUMBER_LEN		15
 #define IMS_PCU_SERIAL_NUMBER_LEN	8
 #define IMS_PCU_DOM_LEN			8
-#define IMS_PCU_FW_VERSION_LEN		(9 + 1)
-#define IMS_PCU_BL_VERSION_LEN		(9 + 1)
+#define IMS_PCU_FW_VERSION_LEN		16
+#define IMS_PCU_BL_VERSION_LEN		16
 #define IMS_PCU_BL_RESET_REASON_LEN	(2 + 1)
 
 #define IMS_PCU_PCU_B_DEVICE_ID		5
-- 
2.43.0



