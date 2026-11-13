Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585473;
	b=MEAfU1kzVKHqVwthyZVkshzg0v958JyEGMHke4Vl4JKf62uK2hK64L7qbviR8qeliNrg
	 uUCozxZ2YrX2gRaMfB83MpfUvR+S+wXspas/GYMHYCgLSQtdNrKt5pkHby1VwgW/qGM4Q
	 QbKn3ONAbHyAL0o/1nbcnnhx/c1XScsawxFCjfXyAuhM7qoRY+c/kDLN0FT4SRqDR8eht
	 +c1XcL2uRrJ8XFEkP9sYUBZg+fI79FezxA9x9RHx487FaD+thuOLKPjX2rOfEc2MB2ei7
	 YNIG0AVpnk7V2di/ckX14QwHWD83XtqTUoeYqidFHn8aDWOXbcxPNxsvMPrpqxCsZTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKgV4WGWtmItYRWo7KfP+kVFiUYmSxQnnke6Te+Cjbo=;
	b=pI5NWmfvMknQt1xm4zUfRmsgDJ5dxjSB/V48pS1zA4AUzk3oAid4oltOaJ5QYFkoKFpo
	 fCmhTPVl6RDkOVIvGGd0FsjdrK064qdGx+geTkJN9D9+8wt8Yb4iUZApShDvFtIrp6XrN
	 yvqP8pZzWrLAJJx5zhdbrHzyFCc+c8CQBEDFkvSWM0ak3kwuBTWQwlPaBLIV8aDHxsZcl
	 BLNA+ro+K7wZDLGcx2BOJh7dHij4JQdDnc5dDlqXKrPMMxcVgHmD4KxwJbFxfHSTKLT9m
	 3HvtuyquUUff2P3eQrQC961UAbtXYfwvkyJ30ZzvIMbZZRLOEaDwh2udmHD971ynjrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uCD9p6G+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD53606EB82;
	Fri, 13 Nov 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uCD9p6G+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B921F000CB;
	Fri, 13 Nov 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585473;
	bh=zKgV4WGWtmItYRWo7KfP+kVFiUYmSxQnnke6Te+Cjbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCD9p6G+r8FDzVxtPyOwhCZoqzuHr8cJWhENCR7Urc3ME2p+IHmPFPajzXNaVlVHc
	 gFRn5k6NSuySMWVObHuRDvL9W1o27F4T3yO8K1tBPZIwIMPOOtkEDeT0j/TGlyagIt
	 TLORRviDredIDgDJKXAcM9EwcFo/laevW8RIuDYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 126/507] drm/i915/display: Single scaler per pipe on WCL
Date: Fri, 13 Nov 2026 10:47:10 -0500
Message-ID: <20261113153758.717190992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Vidya Srinivas <vidya.srinivas@intel.com>

[ Upstream commit 25ea7671bdbc85820026776cbe22df41c560d518 ]

WCL has only one scaler per pipe. Set num_scalers to 1 for
WCL.

v2: Rebase onto latest upstream
v3: Fix up the commit message
v4: Split the scaler and joiner changes into separate patches (Jani)

Bspec: 74286
Fixes: f8e1c3e07db1 ("drm/i915/xe3lpd: Add support for display version 30.02")
Cc: stable@vger.kernel.org
Suggested-by: Charlton Lin <charlton.lin@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patch.msgid.link/20261028070404.1913843-2-vidya.srinivas@intel.com
(cherry picked from commit 8ff2ba499b20edf6c4aad89527a1e9a70c2b2074)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.c b/drivers/gpu/drm/i915/display/intel_display_device.c
index f17fc2c684724..c74256359c253 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.c
+++ b/drivers/gpu/drm/i915/display/intel_display_device.c
@@ -1813,7 +1813,10 @@ static void __intel_display_device_info_runtime_init(struct intel_display *displ
 	if (intel_display_wa(display, INTEL_DISPLAY_WA_14011765242))
 		for_each_pipe(display, pipe)
 			display_runtime->num_scalers[pipe] = 0;
-	else if (DISPLAY_VER(display) >= 11) {
+	else if (DISPLAY_VERx100(display) == 3002) {
+		for_each_pipe(display, pipe)
+			display_runtime->num_scalers[pipe] = 1;
+	} else if (DISPLAY_VER(display) >= 11) {
 		for_each_pipe(display, pipe)
 			display_runtime->num_scalers[pipe] = 2;
 	} else if (DISPLAY_VER(display) >= 9) {
-- 
2.53.0



