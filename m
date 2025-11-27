Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A88728CF42;
	Thu, 27 Nov 2025 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255782; cv=none; b=uoKIwuFru8PQ9bpxGoJZuLCPA9CdYxG3Iqb/UoFjg6/Sekyn+2XYKfgt7tDYauKjMLlFRejLiZmMaLYre4m/4EL9JXDkdQYgVv0dGvIC49XX2j62yt1pA7HdmDrgslW6mDZVnJz3MKiJor57LcPSLQTzAfJbagf1t4cACpSYVDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255782; c=relaxed/simple;
	bh=JK0aR0y5rEi2FjmgzMH1ep31pPWAbOjzp/foDzLKGCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfsb3Z758PWSrcQkJItTFT4IITVe2y1owb4RVO7OCVSIIDmqUWrTLOjVsTitkAZdi6A7lWPOPdWKQRheHZKFI2pOWHto23Ze/koyS8x+0oko4ux3+tsfOgbqXygFHb2IU9VTQskHJqvDnoS9sLzfzVrZE4/gvDLUjmEpWHGv5zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dXRL2/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dXRL2/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCCEC4CEF8;
	Thu, 27 Nov 2025 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255782;
	bh=JK0aR0y5rEi2FjmgzMH1ep31pPWAbOjzp/foDzLKGCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dXRL2/nQ7LnidxXV+NaMNRBW3L3eZDV5GxW5n8QGK9nQy4s3ot6Myor9FeOYVlJE
	 wm1tseHh/a9omUX5fyQf4W2bdUAA3DK0MomGj7QigJjKVNuglAVoozIZQKfYQAW85J
	 dpipaGwoyD65Fqg+gJAoka8V5DtfAjVvutjTQptg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 113/175] drm/pcids: Split PTL pciids group to make wcl subplatform
Date: Thu, 27 Nov 2025 15:46:06 +0100
Message-ID: <20251127144047.085478345@linuxfoundation.org>
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

[ Upstream commit 6eb2e056b0e418718fc5a3cfe79bdb41d9a2851d ]

To form the WCL platform as a subplatform of PTL in definition,
WCL pci ids are splited into saparate group from PTL.
So update the pciidlist struct to cover all the pci ids.

v2:
- Squash wcl description in single patch for display and xe.(jani,gustavo)

Fixes: 3c0f211bc8fc ("drm/xe: Add Wildcat Lake device IDs to PTL list")
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250922150317.2334680-2-dnyaneshwar.bhadane@intel.com
(cherry picked from commit 32620e176443bf23ec81bfe8f177c6721a904864)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo added the Fixes tag when porting it to fixes]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.c | 1 +
 drivers/gpu/drm/xe/xe_pci.c                         | 1 +
 include/drm/intel/pciids.h                          | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.c b/drivers/gpu/drm/i915/display/intel_display_device.c
index 089cffabbad57..9023c15f3645d 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.c
+++ b/drivers/gpu/drm/i915/display/intel_display_device.c
@@ -1469,6 +1469,7 @@ static const struct {
 	INTEL_LNL_IDS(INTEL_DISPLAY_DEVICE, &lnl_desc),
 	INTEL_BMG_IDS(INTEL_DISPLAY_DEVICE, &bmg_desc),
 	INTEL_PTL_IDS(INTEL_DISPLAY_DEVICE, &ptl_desc),
+	INTEL_WCL_IDS(INTEL_DISPLAY_DEVICE, &ptl_desc),
 };
 
 static const struct {
diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 6c2637fc8f1ab..47236457e6a3b 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -367,6 +367,7 @@ static const struct pci_device_id pciidlist[] = {
 	INTEL_LNL_IDS(INTEL_VGA_DEVICE, &lnl_desc),
 	INTEL_BMG_IDS(INTEL_VGA_DEVICE, &bmg_desc),
 	INTEL_PTL_IDS(INTEL_VGA_DEVICE, &ptl_desc),
+	INTEL_WCL_IDS(INTEL_VGA_DEVICE, &ptl_desc),
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, pciidlist);
diff --git a/include/drm/intel/pciids.h b/include/drm/intel/pciids.h
index 76f8d26f9cc9d..97fde8356fb23 100644
--- a/include/drm/intel/pciids.h
+++ b/include/drm/intel/pciids.h
@@ -872,7 +872,10 @@
 	MACRO__(0xB08F, ## __VA_ARGS__), \
 	MACRO__(0xB090, ## __VA_ARGS__), \
 	MACRO__(0xB0A0, ## __VA_ARGS__), \
-	MACRO__(0xB0B0, ## __VA_ARGS__), \
+	MACRO__(0xB0B0, ## __VA_ARGS__)
+
+/* WCL */
+#define INTEL_WCL_IDS(MACRO__, ...) \
 	MACRO__(0xFD80, ## __VA_ARGS__), \
 	MACRO__(0xFD81, ## __VA_ARGS__)
 
-- 
2.51.0



