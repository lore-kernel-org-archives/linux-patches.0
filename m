Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E725A64C;
	Tue, 11 Nov 2025 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822867; cv=none; b=WGTz/Rr3Nstw9Ec/REy6PgJxFR4TruNxCEf/5eu/Odv//TXAsqlpwS6f5+J5bM3/TmtHsSCxF+FdmXgRQiL5NGhbKHROAcrSnKEg2ubqeKEVjwMiUqo75/XK3Gqklv8YPnS44W1CXwf5Ek7jXZwvXVKEC2DvZFbnEx+ZphgLTv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822867; c=relaxed/simple;
	bh=0rgWvX7l+mxelczeWMb9lX0hhDx7rCSmCgZXYXE6+XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSFETwOfc7OSjY+PKXzRuYUq0DCKMQl2xaEmrsDW9EMwaMBHc86l55zH15S1oRQXEAdacy5u49O83NTWxTuVqPAiHz6utnpRpAlx4cQ8IAr5487EAaTI4+NjdubGgCmsshMwvOHIm2LGwWZ1QowFd0F6v/Om0AAv7iJCbDY8JdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdqejCxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdqejCxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15449C4AF09;
	Tue, 11 Nov 2025 01:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822867;
	bh=0rgWvX7l+mxelczeWMb9lX0hhDx7rCSmCgZXYXE6+XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdqejCxfwdaFItD+b7JbrGVoSYZhJ86dsZBCegCOu3D6oSci1LBI6i7scN/fetyXy
	 VeKR6qZ+nH9W3doqa3Y7Zqx/CYR8WH3jqvmNE42i/WCmkaYSINqyz7q6OyyDgb8I5b
	 idlN9IJc/2Huv4akqmpo4Z8dXdQ1PSnaIzvYpEGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 186/849] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Tue, 11 Nov 2025 09:35:56 +0900
Message-ID: <20251111004540.924391610@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 07c7efda24453e05951fb2879f5452b720b91169 ]

According to LP8556 datasheet EPROM region starts at 0x98 so adjust value
in the driver accordingly.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250909074304.92135-2-clamor95@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lp855x_bl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 7075bfab59c4d..d191560ce285f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -22,7 +22,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0



