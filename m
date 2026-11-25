Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622023;
	b=BWuLWlnammUmMpT9a5R/kHboVfsStBWs+RxgWqPEYmZd5Myqto0bErS+/7+FWUSbSorF
	 ftz+LjoDt+MTXUsDoqlyBHU8WMGxFlm5suPoQ5W9JpPzBabo4kdrERzePtVoORxuHVhu3
	 5SvsXmQQf0IFMR71A3/PFCpPXBVrjuoXXJlFa/eLmYEIBopKGKkFRdFBznGgv1BprwGol
	 mMpBdlXKcgt0qPSr8zTUNLlQ3aq8z+AMyTX49z8sFZPnU0YW6rfb4iPuFOOoCMr/MxpRa
	 86swKST05vd/5T5ovl10nEOKVofFFiGvVZMaUiVx6FvcYnvzmqkBhc5UgmL6sSLlZuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ab17g1C1KYnRE/LlMAVM7yecqOILac+JOQNEuIv/3zc=;
	b=vmKYDXJdWa2ym8gmLZv4EFn8Tj2lSHmxM2ytrdzNcqfJ1WlV8B1XZDntzXFDzrg28l9V
	 AIobt2JZKJAEpC9ykGGdIz1BjFOxxw31X8ShdDlJ+IIiadgZXJqJ3b6F4BCMIfoglfbVv
	 AOc+U22Jde/+EhTnjTAzxaab86FWBlzqK2WhI+o3btF0Ol9k/Dnv0DcBSWw6zseoP+Gt/
	 Z+4i2qw6F2Rp0RkZXCMfe/Ig95Wn+AWB6iwbhyzpdNAHwWW86/ER45P0PkamKyOnyKMdw
	 CHY2y0QhamvyG2Z06ASqNJio3z8WEhdthkp2SPfM9kH5fKL2J7tetIyUZXXbyEU9xaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhVlCOa6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850E6606A321;
	Wed, 25 Nov 2026 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhVlCOa6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556E01F000C0;
	Wed, 25 Nov 2026 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622022;
	bh=ab17g1C1KYnRE/LlMAVM7yecqOILac+JOQNEuIv/3zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhVlCOa6YCQFrSnjeqk8hmcjV/Jhgk+JAZNnXE71rkKYB++dt8jtIdXsXFw58qCiq
	 a6DJJwLztPPC82T6lnr/gHbPWi6rAEeZRoCkQgMBOJ51th6AYy4/iSM6++ASRNZTb/
	 PFlz+GSXRt/lYGslhmeYAcxfv665FWAK98glfUfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/990] drm/xe/xe_late_bind_fw: Fix firmware leak on missing manifest entry
Date: Wed, 25 Nov 2026 15:28:38 +0100
Message-ID: <20261125143830.315105206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit 74f1a6f03f2d46537f929a1b13f7dcd378437a4d ]

Release firmware when the "LTES" manifest entry is not found in the
firmware header.

Fixes: efa29317a553 ("drm/xe/xe_late_bind_fw: Extract and print version info")
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20261102172527.2794537-9-badal.nilawar@intel.com
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
(cherry picked from commit 3e4b2a6349ed7258057fa95a1e58730615703dae)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_late_bind_fw.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_late_bind_fw.c b/drivers/gpu/drm/xe/xe_late_bind_fw.c
index 768442ca7da6d..1bddfaf0fb9f0 100644
--- a/drivers/gpu/drm/xe/xe_late_bind_fw.c
+++ b/drivers/gpu/drm/xe/xe_late_bind_fw.c
@@ -335,19 +335,19 @@ static int __xe_late_bind_fw_init(struct xe_late_bind *late_bind, u32 fw_id)
 	if (fw->size > XE_LB_MAX_PAYLOAD_SIZE) {
 		drm_err(&xe->drm, "Firmware %s size %zu is larger than max pay load size %u\n",
 			lb_fw->blob_path, fw->size, XE_LB_MAX_PAYLOAD_SIZE);
-		release_firmware(fw);
-		return -ENODATA;
+		ret = -ENODATA;
+		goto release_fw;
 	}
 
 	ret = parse_lb_layout(lb_fw, fw->data, fw->size, "LTES");
 	if (ret)
-		return ret;
+		goto release_fw;
 
 	lb_fw->payload_size = fw->size;
 	lb_fw->payload = drmm_kzalloc(&xe->drm, lb_fw->payload_size, GFP_KERNEL);
 	if (!lb_fw->payload) {
-		release_firmware(fw);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto release_fw;
 	}
 
 	drm_info(&xe->drm, "Using %s firmware from %s version %u.%u.%u.%u\n",
@@ -356,10 +356,11 @@ static int __xe_late_bind_fw_init(struct xe_late_bind *late_bind, u32 fw_id)
 		 lb_fw->version.hotfix, lb_fw->version.build);
 
 	memcpy((void *)lb_fw->payload, fw->data, lb_fw->payload_size);
-	release_firmware(fw);
 	INIT_WORK(&lb_fw->work, xe_late_bind_work);
 
-	return 0;
+release_fw:
+	release_firmware(fw);
+	return ret;
 }
 
 static int xe_late_bind_fw_init(struct xe_late_bind *late_bind)
-- 
2.53.0



