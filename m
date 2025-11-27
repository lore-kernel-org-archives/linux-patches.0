Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4D28135D;
	Thu, 27 Nov 2025 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255785; cv=none; b=TVNGqPrBq2cBZsCWyBiu7G5Q3qn35ztPRgZdZSsjgmAwWgukKXZ895Jz5dQ8ADIeXSqZyzUhZpVMh5OL4nuu/eGuHBHU29pe4I2P5IJ+7sgchpRDr6vIIXKXx4K0KQLO+Pw/2Uvi5vXwPrNrMT7D+M6OWGn6z9k4TZl/VvWa+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255785; c=relaxed/simple;
	bh=hvo4LeuwlLKhBvUOT+17qhdmJKlnLqb6Cxl/MvBLuy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOHpmsvUK8hpNFHFPDn1SAHpDh6hetpvdTAKopxDTpcZNnUZIKJ0R4ABsSLb4avwOypLhwJs1e/RVynLb/84HeEb2h/roFVoQ66LwwYx5hZAHh3QiiC6CbgtqLgPEnCDK4rtmC8WuKTa0qI2njg/oSh2trTggsqjK2pI/XpKmqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOW1dVkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOW1dVkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1830C4CEF8;
	Thu, 27 Nov 2025 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255785;
	bh=hvo4LeuwlLKhBvUOT+17qhdmJKlnLqb6Cxl/MvBLuy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOW1dVkGCX+VfJGFf76PbroC8YuoA+W/588fywlU1KlB2uxHNl8NLC0zOVzYKP4pB
	 OAhqTH9rlAs2Q0G5vQ8nzkS1SxDIjUJN4EGbFtqhR95wqM9QWSO5rnsptj8JkaT6NQ
	 AaS0d4EInadOneLlBwtQLkUq4f1SbSwXHUMeQ+f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/175] drm/i915/display: Add definition for wcl as subplatform
Date: Thu, 27 Nov 2025 15:46:07 +0100
Message-ID: <20251127144047.121872263@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>

[ Upstream commit 913253ed47b9925454cbb17faa3e350015b3d67a ]

We will need to differentiate between WCL and PTL in
intel_encoder_is_c10phy(). Since WCL and PTL use the same display
architecture, let's define WCL as a subplatform of PTL to allow the
differentiation.

v2: Update commit message and reorder wcl define (Gustavo)

Fixes: 3c0f211bc8fc ("drm/xe: Add Wildcat Lake device IDs to PTL list")
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250922150317.2334680-3-dnyaneshwar.bhadane@intel.com
(cherry picked from commit 4dfaae643e59cf3ab71b88689dce1b874f036f00)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo added Fixes tag when porting it to fixes]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.c | 12 ++++++++++++
 drivers/gpu/drm/i915/display/intel_display_device.h |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.c b/drivers/gpu/drm/i915/display/intel_display_device.c
index 9023c15f3645d..f7ea4ed2b176b 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.c
+++ b/drivers/gpu/drm/i915/display/intel_display_device.c
@@ -1391,8 +1391,20 @@ static const struct platform_desc bmg_desc = {
 	PLATFORM_GROUP(dgfx),
 };
 
+static const u16 wcl_ids[] = {
+	INTEL_WCL_IDS(ID),
+	0
+};
+
 static const struct platform_desc ptl_desc = {
 	PLATFORM(pantherlake),
+	.subplatforms = (const struct subplatform_desc[]) {
+		{
+			SUBPLATFORM(pantherlake, wildcatlake),
+			.pciidlist = wcl_ids,
+		},
+		{},
+	}
 };
 
 __diag_pop();
diff --git a/drivers/gpu/drm/i915/display/intel_display_device.h b/drivers/gpu/drm/i915/display/intel_display_device.h
index 4308822f0415d..dddafb54188a6 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.h
+++ b/drivers/gpu/drm/i915/display/intel_display_device.h
@@ -102,7 +102,9 @@ struct pci_dev;
 	/* Display ver 14.1 (based on GMD ID) */ \
 	func(battlemage) \
 	/* Display ver 30 (based on GMD ID) */ \
-	func(pantherlake)
+	func(pantherlake) \
+	func(pantherlake_wildcatlake)
+
 
 #define __MEMBER(name) unsigned long name:1;
 #define __COUNT(x) 1 +
-- 
2.51.0



