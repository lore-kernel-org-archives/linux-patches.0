Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624042;
	b=aWA4qyXFJl4O28BJdNu1kLPog60RdxXKVKtECf+ukw8lduH0yetcFKjdKbMXUcbzNqDR
	 oPUieaIM/7wwcy9CQ4VmNomEjMmWIu1CSmmgbnbVHnPypdz2kXrRGjPLSotRhY+4+ROaJ
	 D4g8In5+PBboSsYerPe0nN8F3BajCoVF7Ww5sMaDngfc7O63cZk0JiSmMWqu9wRlFZ8ca
	 4jShDWQ3oAAi4XTCRC8Ucwj93KHc6OOWJ3RdM3CKX16F2IzfCXX+u1AfhomdMenfmWoPg
	 hZ6V5Fbv7A7vCYReiLtCZAdIEOY7FyOOyhtt9HCcAZJXw2EgAHlcwMBMFOQHCDOyHCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cZPceorez79woOTgGFdfItCYBJ2+8sUuRPMaCZksyUA=;
	b=LKjVwl+hEnLp+vEMGrhjp4xDo53nPgj8VXKiD6H7fBuWchwyLQ0wa4RzZWbtlXQ+Dbaw
	 f9UV6NUxIIpCpj7ZNm+PoWmjJBuTRDk/yTm5m1GubGXxWzRqsus7/w8y3B3z5Wk7s8Fmn
	 6AlVlVPcS7RGyJnvyf7jW3pWH8rMmoJ4qHgIPVssnf9Kqlk0sHd6s9MzGZMt7DecFHqOY
	 YihxKvm0Y8ozsHE/jHhJJjWiQxzGVnAJFR5Urk3AgDtSa1z/UVboFQGw3GHlNGF/i63N/
	 yBQHrI4md5u8N/ohJHO9m0NfIfWPJQb852DaYigv26kb3iPD/TB1V+JrW4y8LEFAajg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=voPsXHOT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B2B606A326;
	Wed, 25 Nov 2026 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=voPsXHOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E49D1F000D1;
	Wed, 25 Nov 2026 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624041;
	bh=cZPceorez79woOTgGFdfItCYBJ2+8sUuRPMaCZksyUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=voPsXHOTM3Z3pmb+42b2vaond6HGo87mxVolynoCBtzc4iVepvrnllR2CX9+0sNuW
	 M5ag+LiMbKP/w/Y52B3jZMJ4XSdBrtZneOhOImom1aUCgi4CXrHRoVsNohJ0TrSoI2
	 wi6pj4KtZk57VGIZjlm+nQxgtWcmvQCxhnyvYOp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Luigi Santivetti <luigi.santivetti@imgtec.com>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/816] drm/imagination: Align rogue_fwif_hwrtdata to 64 bytes
Date: Wed, 25 Nov 2026 15:26:54 +0100
Message-ID: <20261125143850.749107488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wilczynski <m.wilczynski@samsung.com>

[ Upstream commit 6c6200ffebf9766fd5d9293002298ea371c261c1 ]

Sparse (W=1) builds fail because `SIZE_CHECK(struct rogue_fwif_hwrtdata,
384)` expects 384 bytes, but the compiler generates a 336-byte
structure.

This is due to an alignment conflict: the inner member `cleanup_state`
requires 64-byte alignment, but the outer struct is explicitly marked
`__aligned(8)`.

While a non-sparse build implicitly pads the size to a multiple of 64, a
sparse build strictly respects the 8-byte outer alignment, resulting in
a size mismatch.

Fix this by aligning the entire structure to 64 bytes, which resolves
the contradiction and forces the correct 384 byte size on all builds.

Fixes: a26f067feac1 ("drm/imagination: Add FWIF headers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512131851.1WNXk3BC-lkp@intel.com/
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Reviewed-by: Luigi Santivetti <luigi.santivetti@imgtec.com>
Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
Link: https://patch.msgid.link/20261029-fix_imagination-v4-1-689745dd52ef@samsung.com
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_rogue_fwif.h b/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
index 5d590c4c25663..2f8daa93c9e68 100644
--- a/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
+++ b/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
@@ -2174,7 +2174,7 @@ struct rogue_fwif_hwrtdata {
 	bool geom_caches_need_zeroing __aligned(4);
 
 	struct rogue_fwif_cleanup_ctl cleanup_state __aligned(64);
-} __aligned(8);
+} __aligned(64);
 
 /*
  ******************************************************************************
-- 
2.53.0



