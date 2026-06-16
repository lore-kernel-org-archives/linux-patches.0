Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9939F169AD2;
	Tue, 16 Jun 2026 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635035; cv=none; b=M8IVQrEF440+mCAhJYbNQhwvI7yfTnlGSxMAEkqDTXOhLJzpOegTC03248F34UMl0PP4egSI3J4vsdwGW23NK5f9d2h29PJQzhMlrEAfEqaUvYMdiwTEaiA1wrQrb4bDuTtwO8gOvCbWBW7Zzhld68xSzdoystHxFzqJtDR2Jqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635035; c=relaxed/simple;
	bh=9y0YRrQ17nHpQWlaEJBzX1GuWuPpuizERA0MTZYQw/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrUKl29yGtNqVD5nAUO6A5JQMlVy1r9RpUcMeOsyUWyZgupmFzQoTwXml8R/1qJGUe8rzAdKwpDV8GYiNxnsBVxJayusQOpbRp7R64BCh9gBKimX8jnxrF3mcEMp6obZ/iHCbxSOOPLUQPHmmbtBD54zHZQQj/x7TVFM8Z5s6XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovxwj27o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovxwj27o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7856B1F000E9;
	Tue, 16 Jun 2026 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635034;
	bh=/n4xd2TZY20MOdWFffiewBUlD/gNM2D5ma7iHOfAvGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovxwj27olRrjCvYnmWYd110QW2M36nIbZwmKCBLkJgIOHhx7gBpYA6N+fylWwZBuS
	 fWe1B6kKNaym4R8SHObGdxuhtf6XkT7HcMh4+9NmEl0Atg50iiwNe636QkZEWh2LDj
	 z7NsAcUhiyGqmQ3N7m+f3mOCxWSL5YCVLBVynhu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Deepak Rawat <drawat.floss@gmail.com>,
	"Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/411] drm/hyperv: Remove support for Hyper-V 2008 and 2008R2/Win7
Date: Tue, 16 Jun 2026 20:30:17 +0530
Message-ID: <20260616145121.434658929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit ac6811a9b36f3ceb549d8b84bd8aeedf6026df02 ]

The DRM Hyper-V driver has special case code for running on the first
released versions of Hyper-V: 2008 and 2008 R2/Windows 7.  These versions
are now out of support (except for extended security updates) and lack
support for performance features that are needed for effective production
usage of Linux guests.

The negotiation of the VMbus protocol versions required by these old
Hyper-V versions has been removed from the VMbus driver.  So now remove
the handling of these VMbus protocol versions from the DRM Hyper-V
driver.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Deepak Rawat <drawat.floss@gmail.com>
Reviewed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/1651509391-2058-5-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 13d33b9ef670 ("drm/hyperv: validate resolution_count and fix WIN8 fallback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_proto.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
@@ -18,16 +18,16 @@
 #define SYNTHVID_VERSION(major, minor) ((minor) << 16 | (major))
 #define SYNTHVID_VER_GET_MAJOR(ver) (ver & 0x0000ffff)
 #define SYNTHVID_VER_GET_MINOR(ver) ((ver & 0xffff0000) >> 16)
+
+/* Support for VERSION_WIN7 is removed. #define is retained for reference. */
 #define SYNTHVID_VERSION_WIN7 SYNTHVID_VERSION(3, 0)
 #define SYNTHVID_VERSION_WIN8 SYNTHVID_VERSION(3, 2)
 #define SYNTHVID_VERSION_WIN10 SYNTHVID_VERSION(3, 5)
 
-#define SYNTHVID_DEPTH_WIN7 16
 #define SYNTHVID_DEPTH_WIN8 32
-#define SYNTHVID_FB_SIZE_WIN7 (4 * 1024 * 1024)
+#define SYNTHVID_WIDTH_WIN8 1600
+#define SYNTHVID_HEIGHT_WIN8 1200
 #define SYNTHVID_FB_SIZE_WIN8 (8 * 1024 * 1024)
-#define SYNTHVID_WIDTH_MAX_WIN7 1600
-#define SYNTHVID_HEIGHT_MAX_WIN7 1200
 
 enum pipe_msg_type {
 	PIPE_MSG_INVALID,
@@ -570,12 +570,6 @@ int hyperv_connect_vsp(struct hv_device
 	case VERSION_WIN8:
 	case VERSION_WIN8_1:
 		ret = hyperv_negotiate_version(hdev, SYNTHVID_VERSION_WIN8);
-		if (!ret)
-			break;
-		fallthrough;
-	case VERSION_WS2008:
-	case VERSION_WIN7:
-		ret = hyperv_negotiate_version(hdev, SYNTHVID_VERSION_WIN7);
 		break;
 	default:
 		ret = hyperv_negotiate_version(hdev, SYNTHVID_VERSION_WIN10);
@@ -587,18 +581,15 @@ int hyperv_connect_vsp(struct hv_device
 		goto error;
 	}
 
-	if (hv->synthvid_version == SYNTHVID_VERSION_WIN7)
-		hv->screen_depth = SYNTHVID_DEPTH_WIN7;
-	else
-		hv->screen_depth = SYNTHVID_DEPTH_WIN8;
+	hv->screen_depth = SYNTHVID_DEPTH_WIN8;
 
 	if (hyperv_version_ge(hv->synthvid_version, SYNTHVID_VERSION_WIN10)) {
 		ret = hyperv_get_supported_resolution(hdev);
 		if (ret)
 			drm_err(dev, "Failed to get supported resolution from host, use default\n");
 	} else {
-		hv->screen_width_max = SYNTHVID_WIDTH_MAX_WIN7;
-		hv->screen_height_max = SYNTHVID_HEIGHT_MAX_WIN7;
+		hv->screen_width_max = SYNTHVID_WIDTH_WIN8;
+		hv->screen_height_max = SYNTHVID_HEIGHT_WIN8;
 	}
 
 	hv->mmio_megabytes = hdev->channel->offermsg.offer.mmio_megabytes;


