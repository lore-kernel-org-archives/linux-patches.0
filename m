Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055664;
	b=k6PJIF/sHStsltWBYqdrjYQjd/HisNjM4SGQ8Q0/Z0+i6vNJoK5kjJ9Cq/i088Pt981d
	 nCrg/l4C23FqFczXEGaCcDlHzave/aArz8Bu00f7v/MfnnfePrZK9f1sof9Dh8rJX0Sia
	 VtoZNNo7WkyrkRcU4QOjEsRk5t7a48VgCdpBrpoDkpSrCzQEC3QnmRLxfsdP1Dks9Mbe5
	 ej+FA9/vTdGK7b8t9Un9S5Wci8PYEt2/bGyKL5pQ97whdZOx4zKxLvkpEr4qZxWPUuG+p
	 lXGzrKEOWV9gxFZCOAMTphXe4l26skvBb6jmwVLXtnrBGL1IH2YqDftXasWYvftxQ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kcr+kbJRlPuVa2LbeIOeU3SDy3K0oNhHwaVSXlUV4iE=;
	b=aG0OumSHrKQiG20h2U0GD2Yx1TVDsmqECTMyE/+dHrydC2RLmY1+a8NUs0yT7+6XwKlW
	 NApKgTUxpeczxyro9lENHcViq7f5T3VdY7u6Lfc9XQn7VRmmpl0rxW8Bza18D9qWfFK12
	 x2pZDez/zk8Wmu6KE249UJy9SeRSp4q1pJ/k+gVE46JwW7+aOEyCxwpsL+ntAm5QL1/eP
	 Cs6Ujkn5znPCi2WlH0HWSYU1sh5xjn6Yp8Wx1ZX77jzuWlvkS4IeMvqbe6nReAhwf674L
	 t072cSDnL3BMtaknx+h/4MktcJTU1nTMSNm/PvZlfafDlVfg18HRJ9NwRQWnOrd1hNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brjNBaTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E00606A320;
	Thu, 19 Nov 2026 02:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brjNBaTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD4D1F000C4;
	Thu, 19 Nov 2026 02:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055664;
	bh=Kcr+kbJRlPuVa2LbeIOeU3SDy3K0oNhHwaVSXlUV4iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brjNBaTrbvYQK+T576T+MoHEQdE9e0JCSuUlN6hyp6wh5HFx8t4Jt2tW6PkW79WiZ
	 CbcP0YLpozK3G5oXep3ec/kDtcz8CNbyeJwqWM2MAXPWmzZFh3LfNvoVjotpp9YKkv
	 C0bOFwYIV2sgz0qaZZJvGHH/3EhwNpnVXlKF4WQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1711/2214] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150120.212069044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 94f7116e96682..789a5c709ba87 100644
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



