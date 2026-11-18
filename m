Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018213;
	b=4ZLricAP5rQJW/EeLo/aPU+27doDCb3sqVU/omePXx8v42aZ7CNdrkBanUNC2r2+yW1e
	 WGLKFdDCiCI1qBGiFMol5n7ZIGxZ4iBUHFESog2lreqn4popS2sc0f0gdJL3L4DfCQ+2g
	 taZ3iC8kAoFicw9eLBL3oS9zgh7flt8nfI458h1kGb38i4Mp/XdC1DLOqm3Lc0zniqCSw
	 f078Hfy9EqCL4mugGoiZGrL3QPiNgQpgEzurvfq+JycC1mukSMcK8JdndYux6itSrfuQJ
	 dQSCULCEbXJiIFad8HZ4cIvJt62lzoGCoyUFNMMH8Lx7FocyWwjt63RjiG60eCcBWAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yT3pvloAJj88tRT4EAgmSEXOldsRpVLdCwdD/9Ttau8=;
	b=0z7wBD7wjuJa858X104mJ/iUj7Vh2bTpDTvmOqL8BDzCGmY9aFKQrA5BKusyhCceogfz
	 RBQKnB5wjQL0GpxVhoo+A3s1ZW1oyvDho9A/8Xr5pM/x7fu9DrkIgEaGWZ3DPY3RetllR
	 dsk5VgMx0LmSPawT3ClirxaNSE9lzu1exB80wbGNCC/6jEyW3Vvn+ddJ78QhCaQr5x3zG
	 Z1cRReqiPmqyB5qEhPmlFsp+3ABElvQ9/Km118igXQDTnVG5kW7cnHGj6ZfMGtNiwSV+7
	 3DGSbSZsrwEVYC1WLniyZIBIL8d+XEPgI381DySYy3c6rFfjalSeuqjZqAWlolAuT5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnGlrlh9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637DA606A31C;
	Wed, 18 Nov 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnGlrlh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53201F000C4;
	Wed, 18 Nov 2026 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018213;
	bh=yT3pvloAJj88tRT4EAgmSEXOldsRpVLdCwdD/9Ttau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnGlrlh98nu9ugPw1C8KcG+vIpXz5zKlYBDWlQEhFUuznyKMNIA1P/yL9zczCUXU2
	 SXS+sXTQH40KWNikCXfr+OE2XD+qzC+fEpBSG/AiL6huj07yK5YTJoCVcnD1RoA4Os
	 BXTwz4ydVIbNyFr+MEDcauv/4ZwidjJMB3v0MO6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1159/2651] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:39:59 +0100
Message-ID: <20261118150329.738723953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 4c3ca7c8c152278332590bfd3df1b0f086364759 ]

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 4aa91ee0e5041..f7f734881c681 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.53.0



