Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5BE47A64;
	Mon,  1 Apr 2024 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990795; cv=none; b=s/8HzRb5Ww1DnUV5YA92Pxhane2vrPbsSS7IrdKLfxbnGmvYv4WlDfN9Nad1XV/5zrn/Oe95RAAV7pUY7geOF8wVCyWkgX5FX9kxz9WWSbquDJuGYg5ILlHjRwHWlcFr7s/MfqnUEmY1HSa6Xm62TdCFtxjag07Iu7u6pE/sNMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990795; c=relaxed/simple;
	bh=g4J3MF2eyo3skaNXFxvcSGNKCXPjP+cKEQYIUaELzmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mr47HP2VFKy5ICyxboijFrBDvjlgykPupip7JFcvnt6zh6wJuvRJgcvt/t/1NMUVD1Gpyeitn5ZDUsMFDHi1qlUnKdHhsEdEBVZi2wY/9k//TBCDDgbAm2IoNxigld+x9jvX05CdmuxzLaHhRtWkqL31fRLU15krG1mrOi6to8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVwB7VdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVwB7VdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D140DC433C7;
	Mon,  1 Apr 2024 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990795;
	bh=g4J3MF2eyo3skaNXFxvcSGNKCXPjP+cKEQYIUaELzmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVwB7VdZjcB7EhbE3STPUF3D5EHdP4h6g5Zgnut5IcmDmE7cs6ch28ntGi38XJyrj
	 1N5yWmII1nd9U02Ed8VOA0nbUfc/PQdnnfcVisgi0ZvlIlpBO8XfFaJxjolxJV+4mV
	 DtZerYgYm+EO+lcEIAl3KyzmST4XGeWpFbz0I3r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jameson Thies <jthies@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/272] usb: typec: ucsi: Clean up UCSI_CABLE_PROP macros
Date: Mon,  1 Apr 2024 17:44:19 +0200
Message-ID: <20240401152532.718038833@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

[ Upstream commit 4d0a5a9915793377c0fe1a8d78de6bcd92cea963 ]

Clean up UCSI_CABLE_PROP macros by fixing a bitmask shifting error for
plug type and updating the modal support macro for consistent naming.

Fixes: 3cf657f07918 ("usb: typec: ucsi: Remove all bit-fields")
Cc: stable@vger.kernel.org
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jameson Thies <jthies@google.com>
Link: https://lore.kernel.org/r/20240305025804.1290919-2-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 60ce9fb6e7450..dbb10cb310d4c 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -220,12 +220,12 @@ struct ucsi_cable_property {
 #define UCSI_CABLE_PROP_FLAG_VBUS_IN_CABLE	BIT(0)
 #define UCSI_CABLE_PROP_FLAG_ACTIVE_CABLE	BIT(1)
 #define UCSI_CABLE_PROP_FLAG_DIRECTIONALITY	BIT(2)
-#define UCSI_CABLE_PROP_FLAG_PLUG_TYPE(_f_)	((_f_) & GENMASK(3, 0))
+#define UCSI_CABLE_PROP_FLAG_PLUG_TYPE(_f_)	(((_f_) & GENMASK(4, 3)) >> 3)
 #define   UCSI_CABLE_PROPERTY_PLUG_TYPE_A	0
 #define   UCSI_CABLE_PROPERTY_PLUG_TYPE_B	1
 #define   UCSI_CABLE_PROPERTY_PLUG_TYPE_C	2
 #define   UCSI_CABLE_PROPERTY_PLUG_OTHER	3
-#define UCSI_CABLE_PROP_MODE_SUPPORT		BIT(5)
+#define UCSI_CABLE_PROP_FLAG_MODE_SUPPORT	BIT(5)
 	u8 latency;
 } __packed;
 
-- 
2.43.0



