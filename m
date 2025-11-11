Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B16726FA67;
	Tue, 11 Nov 2025 01:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823163; cv=none; b=Quwur7wR+Fj5TGddNXFGOB875HHa8ugdtKNJC9G1+ZaKWbTy4tMee54a1nj9j7xeJ/w1vBg9wT6KpPqf4y9T8di27Y686Oo4h4E2r2hwAuUyyQN1ngKoCgNvtZla6kt3D+ozkyyVfVdnExoJ2aZEKwvZnTP+GBuJxFgWx50xiSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823163; c=relaxed/simple;
	bh=QUPqdXYWZ4sEllJMJ9S3ZAx8a4c/2gD2lwnQT1qFVMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HApEH+4RJNNUD3aAKdDEP6mG+rZk2V5PHg1LIhJCm1dshzp+4QL/8nZASuYxNgSQwPWZxgWiCxzJ4CMbYH7HFRe7bPP0ZuxXDoWXYVuDiyWPCCpQXo6pku4QU5LZtSZXGwW+gJeqmX9qT6grEmEFPZSC7W1kSqc3aPu4UptgHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBmqdvbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBmqdvbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99ECC113D0;
	Tue, 11 Nov 2025 01:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823163;
	bh=QUPqdXYWZ4sEllJMJ9S3ZAx8a4c/2gD2lwnQT1qFVMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBmqdvbjaiQnfkWYh3kZ74yL2CpFrAdS8jYckQIV2ep4rtvuBokuK8p5liTsVhdr4
	 BSgH3REd62h/EHiCitFwiBlDAXnYHTPnqH9hjokYR+0j1cONnIO8k54razUP9I6+B2
	 VZAFuxDW23dtarbU4HPkurFm+UarBcR0vNQ81sY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/565] drm/amd/display: add more cyan skillfish devices
Date: Tue, 11 Nov 2025 09:40:39 +0900
Message-ID: <20251111004531.050830561@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6dbf139c51f72..36f8eb37e6710 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -164,7 +164,13 @@ enum dce_version resource_parse_asic_id(struct hw_asic_id asic_id)
 
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
index 090230d29df82..f030e167c58e1 100644
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



