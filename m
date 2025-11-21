Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABE834D4DC;
	Fri, 21 Nov 2025 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732427; cv=none; b=i0kAafa0M5T17yrv0JKnH12/NUt5n2vuF/5O2DqdZf4F8hTeEuRDm9LAjKCyZEu5Z2zu60+miKfhJZVUd7EeZWRhrZTsQGB4tsywTHtUiniFZIjHFYtdqp1TpBOHBLvuFqUCPjEQ7fJxQ4lAaM1PWAA7FeMqoKNc//Hf/6mg32A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732427; c=relaxed/simple;
	bh=d+52R9nOwbTThR75qEFN1jLDJMsTutPOkG6PO9k9gUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD2ChBmpqssZUOBd/+ZLAfggGTg4jRIj59kxbkaQTElDHkuZD20gVqSChMPiOVb0b2sUr6dCP1hrFiVUi4EFPddMtheBcHEyXvCi7vEqbT1zJOEUelsrJt/QexG1qIpuCjPnv1LE0LKS6ze8QNWmjF+ZjifLgcAErk+zj1k4GuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFlf2bST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFlf2bST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FE7C4CEF1;
	Fri, 21 Nov 2025 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732427;
	bh=d+52R9nOwbTThR75qEFN1jLDJMsTutPOkG6PO9k9gUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFlf2bSTHhim5pBtkxYFOxudKuxch/xRJZY6uhhEGjUuGSmeDFrfFcZUXcbkbkTHP
	 Jdqq3jeHO0+TsYcdpIC85U/jN1ovw01a/iwhtYuFZ3m/ls2ZUBbMQSrVcLdhZSfuzH
	 sQ6Mnb/6Vf/Gp5ije2CYFlbWWZ7rYVy88FZuTPu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/529] drm/amd/display: add more cyan skillfish devices
Date: Fri, 21 Nov 2025 14:06:56 +0100
Message-ID: <20251121130235.186089186@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2f25f7096c4d6..277b2d205440c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -150,7 +150,13 @@ enum dce_version resource_parse_asic_id(struct hw_asic_id asic_id)
 
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
index e317089cf6ee7..b913d08a5e038 100644
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



