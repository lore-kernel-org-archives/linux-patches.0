Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618840;
	b=a3ZFGb7gkMPZtZ2iaCA7Xbab+rSEwTJa6p/V+cZykftu+pFGj5pcvHYReWXnKjtGr9OI
	 8D7/TwKkU9XugYiPMJieD3dotIUGzpaJIxBB7Gt3qUraBGsMAc8S2/t+Jx9CqVS5LVPzC
	 WOjue94xb4EcVv6UhGi3dRCxO7NO5De69KzSBqKGfws7FSf2qTPWhQcemL0K33+XpkQ+y
	 K3+tjS6kNzztFLzpX4jTSGTJeaLFvA2W3fCjKLGZWDNfiOQcV1B8VPzamqLD5ZarUnqH5
	 Ggh18Mvdzj3Jsw/m0ya00obbNzldn1ECBbMqvvFEd83lbR8KpT/Sbj9a3Cymb1K0Sfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jx9Ova79j7iDaxBm7lwcwmbSo6kP8IogAVnnklYYOmo=;
	b=YtAq/20Bhwfmqcv3WtorkVszcm6nQ2rDLddA9UAIg8N6FY7O5uhJKoLYJu66AB0hJaDO
	 DRm2+/Ozz/HYXZxGJUY3Xpt/a9QDjLllDZmZVO2NWPXTQ0m+XBzkYSDbbRuPXBH9l0L3o
	 SA8yJVKCPzwrzVSYLWu3LB3jb07QwcdAONdlJvTDJhPHCShLsl81GWCdMa3rls0G7o9R0
	 aqnpKYevgyg5HyGBa0V717QHRi1/Mcm8aJidaBh3MBSwr6TdQIu8yjRJ+Wc4ejgTVR5vf
	 kN6IGtZO4SdU15xjQ0RQUkxq1unQW9w93J+WVQWJCZt76/d5W5Vg7NpIiNW9Rnf4LYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRtxeDJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CBC606A323;
	Wed, 25 Nov 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRtxeDJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBF51F000D0;
	Wed, 25 Nov 2026 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618839;
	bh=Jx9Ova79j7iDaxBm7lwcwmbSo6kP8IogAVnnklYYOmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRtxeDJe7/dSmj3XyIAUq5uDwz1yL4zRFw8deQZUODeScwHFX+Y2rNwcHFtHjYwqu
	 +PtpIeGdLToldq/7rnIkyOd4216CFBLNRg5yWkgj6x42qBSf/f3jXABgY4QbEHdGat
	 NdiHX+nweOCZbd+ZXRUG5XvzY7iT5fDbbgPVzBlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0403/1005] drm/xe/xe_late_bind_fw: Fix firmware leak on missing manifest entry
Date: Wed, 25 Nov 2026 15:29:01 +0100
Message-ID: <20261125143831.192647617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



