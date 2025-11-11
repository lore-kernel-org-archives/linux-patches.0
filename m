Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4693346A0F;
	Tue, 11 Nov 2025 01:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823200; cv=none; b=IXITFjfwFJDj9oluicrvxU2P0cejaM/LyvdkdO5ELobTj0QNpnan16niR6mWG7ogB+0W3UVhziFkYdVhF/Fd2+mLvf3bo+mr701vjIUPGNlENa8AAAOjRN215w/M4aGaSf7251ytNJ7sbs71NYMKLEGOgGVXZzZKyO4L/Lvt4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823200; c=relaxed/simple;
	bh=/stVaWOGU5Byadn4FsqyxuMm7ZHGjMNzixyG86r+ErY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJDYGq14ew2fUgyZJVgFHyYDBCe9HbO1Ccb9JA/1bUdWZ0avtsDnYTtFw5L9ZMdC+tXuXn8Qq4sN+21Dh535TX/LoT68N4DjedPn8sGbfx1SU2csJWNfcVXAe7aEf8efLL6m6c1tLlvL2k3E2sgTcsrwolHfoLiXbbZVgk/kdzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLlWCrZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLlWCrZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E74C19422;
	Tue, 11 Nov 2025 01:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823200;
	bh=/stVaWOGU5Byadn4FsqyxuMm7ZHGjMNzixyG86r+ErY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLlWCrZSmwMfrXPNFO2KkMYeyKOFhnMvQMqZOeRMejQ//dnwJAPEAABv8eIQTygCQ
	 fDoT9xHU5xoXqhuYEWxCEBcszf6UKibcOdR7voRPABLTwtzO5zZjluUwb7DhneXBVw
	 dw2hEQWettmjraa6Ja/FEs6pSOXsUfKRGK9dqDb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 252/849] drm/amd/display: add more cyan skillfish devices
Date: Tue, 11 Nov 2025 09:37:02 +0900
Message-ID: <20251111004542.521540117@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3cf06bd4cf2512d564fdb451b07de0cebe7b138d ]

Add PCI IDs to support display probe for cyan skillfish
family of SOCs.

Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 8 +++++++-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 4d6181e7c612b..d712548b1927d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -165,7 +165,13 @@ enum dce_version resource_parse_asic_id(struct hw_asic_id asic_id)
 
 	case FAMILY_NV:
 		dc_version = DCN_VERSION_2_0;
-		if (asic_id.chip_id == DEVICE_ID_NV_13FE || asic_id.chip_id == DEVICE_ID_NV_143F) {
+		if (asic_id.chip_id == DEVICE_ID_NV_13FE ||
+		    asic_id.chip_id == DEVICE_ID_NV_143F ||
+		    asic_id.chip_id == DEVICE_ID_NV_13F9 ||
+		    asic_id.chip_id == DEVICE_ID_NV_13FA ||
+		    asic_id.chip_id == DEVICE_ID_NV_13FB ||
+		    asic_id.chip_id == DEVICE_ID_NV_13FC ||
+		    asic_id.chip_id == DEVICE_ID_NV_13DB) {
 			dc_version = DCN_VERSION_2_01;
 			break;
 		}
diff --git a/drivers/gpu/drm/amd/display/include/dal_asic_id.h b/drivers/gpu/drm/amd/display/include/dal_asic_id.h
index 5fc29164e4b45..8aea50aa95330 100644
--- a/drivers/gpu/drm/amd/display/include/dal_asic_id.h
+++ b/drivers/gpu/drm/amd/display/include/dal_asic_id.h
@@ -213,6 +213,11 @@ enum {
 #endif
 #define DEVICE_ID_NV_13FE 0x13FE  // CYAN_SKILLFISH
 #define DEVICE_ID_NV_143F 0x143F
+#define DEVICE_ID_NV_13F9 0x13F9
+#define DEVICE_ID_NV_13FA 0x13FA
+#define DEVICE_ID_NV_13FB 0x13FB
+#define DEVICE_ID_NV_13FC 0x13FC
+#define DEVICE_ID_NV_13DB 0x13DB
 #define FAMILY_VGH 144
 #define DEVICE_ID_VGH_163F 0x163F
 #define DEVICE_ID_VGH_1435 0x1435
-- 
2.51.0



