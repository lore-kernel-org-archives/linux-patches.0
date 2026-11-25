Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618395;
	b=ZqVBEc+1c4oJg+T88zJ7Z3ELtwcicaNEHpgGbj0WmsYR2WdjF5rbxznMxkqqHRwa1FwC
	 jYfiFMVUOhKwWwZY3CzAV3dlAbV0I2/CVOopBrGAO4SPF+yVzoU9iEZeVMy1DZJEEZTkx
	 EG9ShMmnrmVgbFdEV1TsOX2rBHKTpco7+CJ5rwGJsUt/NPrzMpy1DHDVMRcp7/CdmszAb
	 LEpNgN5We2Y6Xsx3kEfXiIdmH6Dscj8928FuR4Bp7h22MgPCXI/QLVBB85F/Ffl++BuK6
	 y4yGzYK9Z3g5bgBIpgbfiIdrcYaXqR9W5blrHxqsRH8LvaHrSAPh+oaCzqsxMcaZmMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1uEfZqqbe2SVW28FduVR+/fzAuPn2iE/X3b6M2K0/7I=;
	b=3NXH8HiP0POO44pB3bERdCRtLL9oyTvFEFgnx5svPDthgZm//x8CaPyHs6tUSG99nIo1
	 A03mhsZJ2XC4tn0OCHW6V5ivhOF/x9Z2cfXQlZm3kWoJiqHFbSx9HaZMsGX9ShqmLZTuH
	 EF/umiwWC578GYnhHwbxRF284ecCsqQE1xPgbLMpI2EM/zui3F6rX+aBsXdZsfRBT3DJ3
	 RF/ZL3ugxVo8u/g9Zr+UrY2J6EWBM+PPdYTimGdtjW+gIE55Zyt/QibSkDBHg4ID/78kl
	 m3iNExGwquE1rX3aTVUgvlmqsAlK1vWW49yntVElC0rLWsd2v4sjUUTG5F9VbLyNZ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIVdc7Vj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C190606A31E;
	Wed, 25 Nov 2026 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIVdc7Vj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73C01F000D1;
	Wed, 25 Nov 2026 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618394;
	bh=1uEfZqqbe2SVW28FduVR+/fzAuPn2iE/X3b6M2K0/7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIVdc7Vj9/WC3nK47QCZ974sR78gf+KgqJUQoqb8YmIZNE4K3FJQTsdOvyiP2IlP3
	 JWlLt9IKKlNf6Rg6Rmk9NHt9/w5hXXIYkNt1Zab1o2VYhuVAGCafNLAqJutOaUKNxn
	 nOv4vDPazQp3Uf4ZZ7MErGPw5MjTfu+PK3UpNz9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0222/1005] drm/i915/vrr: Fix intel_vrr_dcb_vmin_vblank_start()
Date: Wed, 25 Nov 2026 15:26:00 +0100
Message-ID: <20261125143826.942981927@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 01aa63eade529680cb28fce40f2357bf392a249f ]

intel_vrr_dcb_vmin_vblank_start() may evaluate
intel_vrr_dcb_vmin_vblank_start_next() twice, and given that
this is doing hardware access under the hood isn't really
desired.

Even worse, the double evaluation might even cause
intel_vrr_dcb_vmin_vblank_start() itself to finally
return -EINVAL (if we race against the DMC hard enough),
which we definitely never want to do.

Eliminate the double evaluation, guaranteeing a sane
final return value at the same time.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20261023165803.31016-2-ville.syrjala@linux.intel.com
Fixes: c4aba65c26fd ("drm/i915/display: Wait for VRR PUSH status update")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 9defa95510abce51f68d926b445567784a0a6701)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_vrr.c b/drivers/gpu/drm/i915/display/intel_vrr.c
index 6e03122743967..d415915e09f07 100644
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -1170,9 +1170,13 @@ int intel_vrr_safe_window_start(const struct intel_crtc_state *crtc_state)
 static int
 intel_vrr_dcb_vmin_vblank_start(const struct intel_crtc_state *crtc_state)
 {
-	return (intel_vrr_dcb_vmin_vblank_start_next(crtc_state) < 0) ?
-		intel_vrr_dcb_vmin_vblank_start_final(crtc_state) :
-		intel_vrr_dcb_vmin_vblank_start_next(crtc_state);
+	int vblank_start;
+
+	vblank_start = intel_vrr_dcb_vmin_vblank_start_next(crtc_state);
+	if (vblank_start < 0)
+		vblank_start = intel_vrr_dcb_vmin_vblank_start_final(crtc_state);
+
+	return vblank_start;
 }
 
 int intel_vrr_vmin_safe_window_end(const struct intel_crtc_state *crtc_state)
-- 
2.53.0



