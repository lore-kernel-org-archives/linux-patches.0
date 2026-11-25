Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617765;
	b=xrVP/8pGFuuD1JNfSzq8uFJ5tmmYAakJADjxT13NZzQswXPPWiwDEFwfvb5jyMPmzMrE
	 SZ0E2Mnsw88rI8nLn7CE4I281Bkcrq6Aw6LMH6wOiN/4Qq81VysLoclR9Vsoy1+v2s4wT
	 cMgCCgpmHTgSzIiCba6MGGCc276yHxdnVcDzQKQCp6Ecq3rspX12GI1aXemGeogxCKScc
	 AeqgN1UXXGVYO28/PqfWBnjeUSI5EpuC2g2Gi9W2+5cveepqJp+VdSbz7Wh+TyqSLq2SH
	 Suv8BNDl4M+8XbdEH6DpoBBpEDZqGNW+TtFnN2XQ7TgQsBImL0inz54a158mx06//9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=so06mjB/oPE9OLl5HaBei0HleebjWHrnHTdIsir4ujA=;
	b=wmfE+cW6BCPJQLklE2Qn+zZPDAYgf4UQkmXUygljfRb8YY5Jf20SvgNUkEIRFD7ZlKgW
	 lneoI7zDRtuE7qhlNjiWEHJQsFuKGt5Q4W9uhtFUq/l6jFwxgN0irH4r2/Niusq5wA/EA
	 HsUu/Xbq0oC6FjwzHGuFifCpjWrkPkwvLh709T2YnnKWxdUPk5qy2oKX4+Vcp6IW69M0G
	 9U8rwJY7C3ztuKHzLSTFHwCmAokCbVNUYhHkJHKjF2B2dI4ZugmsVVcgMV6GNtZOv+m9f
	 5q8pxvXST4nQ9P6/+UkKqJvWFIFPXytcKSPnnaamHBUOtwkl4ulr/C7X4/3ahCtAXtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WA0L1Bcn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA952606A323;
	Wed, 25 Nov 2026 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WA0L1Bcn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466AD1F000C4;
	Wed, 25 Nov 2026 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617764;
	bh=so06mjB/oPE9OLl5HaBei0HleebjWHrnHTdIsir4ujA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA0L1Bcn3oucV0GJB5pHlJsaPqmvHQtQjtev7c1E2rQcEdIGURRKLLu+MMFNVLQYo
	 SgoD8tAh7F+Gn4k4w7UvmF/Ge12J0DLKxQsXFkljtByfa1+lQYpnlqnB79V/s9MnOX
	 bqD0ofZIF3IcfgpXdvvwtclS5jdcfUIx8CcxcrwU=
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
Subject: [PATCH 7.3 0065/1005] drm/imagination: Align rogue_fwif_hwrtdata to 64 bytes
Date: Wed, 25 Nov 2026 15:23:23 +0100
Message-ID: <20261125143823.265433128@linuxfoundation.org>
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



