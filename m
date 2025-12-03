Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6314D341650;
	Wed,  3 Dec 2025 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779033; cv=none; b=WrzHf84FXrF89+nqFCub+xW8JaMKESSYaj30oI9IqO7BYGR9HgWRr7WB7DfOQIzb27qipd71FYoVNZPJe2dSiqW/yH3O/DNOtSNIvQUIDe/j+C57vX6rm0lEan3ySj6MLw2w/Hicx1EXgHos+x1IDtfTwoASkAjnoY3otw5SLjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779033; c=relaxed/simple;
	bh=3MSJ6EdcDNftjT7YD4sBD8GBX30Ceq/I7K3Yq55EZYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj4JxXkrwCrspcFJa/cBoSpqhW66yqicrKoalAaOcEj9ng2Y+vXDHJTp569IneR8c95CgdekU4on3+8D01kJNcSwQbptou0x4UHti+9YnYvywAcxala+zNVInxNMSfQnJ/IAey+VYPAcrUJ1xE07PQZ+E3LXLEIUCGYinAp1oRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjn++8/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjn++8/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED2CC4CEF5;
	Wed,  3 Dec 2025 16:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779032;
	bh=3MSJ6EdcDNftjT7YD4sBD8GBX30Ceq/I7K3Yq55EZYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjn++8/v4sIqsdQTgSbimu9ZQJrDDeuyKZESvNkbiHPKm6tcw6fFOTd79QFgKMf/P
	 WW45n/GKtswGX4R3j6cAuvEjeuavKninN6oJ8p1ECSI/acs24dF6HaJE2NF7d5f0ZE
	 msJAHkd1sDyYWh/dXFvh6/+fjFExCfPKsoP0+x7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/568] drm/amd/display: add more cyan skillfish devices
Date: Wed,  3 Dec 2025 16:22:15 +0100
Message-ID: <20251203152445.599890354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f036e9988a0d3..876b70157faa3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -136,7 +136,13 @@ enum dce_version resource_parse_asic_id(struct hw_asic_id asic_id)
 
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
index c3089c673975b..e044d8589d4f3 100644
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



