Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063224;
	b=S3HdxKZzG1Hkfs4ZUnMiNF4hABhDuyrcEXHsaKdNdn+ybvNl7Jkw12np37PwG7NPY+Cs
	 mPnS3CqDEMtZqT1FsyYne8pQsSekdxGSOpRvyqAq2PKqk3z6Q6XDthl19lY8yEsqzE37/
	 HewqxDdI3LtfEgNHabqLgz78/9vRVH31v9gZP+dRk48PIQtGearTtotgNjNZgHhb9Ettg
	 hmfMknP0SjJHpRnYUzKOsvyfVmf8N6mPzE1biHGA1LimDPWF5jwj30049biuJMtTyo25S
	 Mgov/GiRNhnpp0F/bE2clwvNriAvzLZAUmw4mgQ6d95wsz6uygkbTGiHoX0n2MVD6hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=thE0Hp3vZhsVYzyX7TQCUVn+S91U3gQaWeiY+0p7ehQ=;
	b=uAqZTs6rayxf+vFL9SOvza+B8CO3S1oBOwnjr+A7WRUi7iRBHXFlWRvYFBvOga6uUHyO
	 W4BzZSZffQkPb+eTqY7KDFJJmc1UZMSSGHpCabf2qcgKJkXYE9cFNRI5dGDS4pGi7vMCK
	 XlC8RWM8mgvgK/q5kiftEGe0n9qt1a93Hk9C+oDiT3yLjAjkwqo2tT+Eo1WoCP8uFQP4t
	 mWSRujCsHFurf8z2lmVPNhJW0bRZIWSwMh0BcYTHdyxl59kwVObjxSANT6m7GCu69vZ5L
	 Y0SvEjyr4Aksa6IkW5sLq1dLvi3tA31FmXgDd4+wodXQTX1uBkVegktE0djKSsco3gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzMw3zGv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E608B606A326;
	Sat,  7 Nov 2026 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzMw3zGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974F21F0089F;
	Sat,  7 Nov 2026 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063223;
	bh=thE0Hp3vZhsVYzyX7TQCUVn+S91U3gQaWeiY+0p7ehQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzMw3zGvl9azASzaAZ1MAbXdEVQ0b1R28AX4yagPxczX62Ed5An7lTA3ycTp+sibv
	 xuIw7q9Whxnt53nsGTDFnxQy3Uc3uZnhQI0hzn9+HbhlePFqIdwg/NIk9GJ2kVPsf8
	 MNCbluSW46gOhwqRbX/sV5VC4UOIniuZwcDu6xAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 431/869] mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sat,  7 Nov 2026 08:51:53 -0500
Message-ID: <20261107134908.437057369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 91b4edb993e1549afdc3c2495216734b9f13f00e ]

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to zswap is
corrupted on swapin.

Enable the static key in zswap_pool_create(), covering boot-time and
runtime pool creation with a single site.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Link: https://lore.kernel.org/20260906135938.3568108-1-xialonglong2025@163.com
Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Assisted-by: Zcode:GLM-5.3
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zswap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e4b2f6abefafb..d2e5f0cff71db 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -288,6 +288,8 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	zswap_pool_debug("created", pool);
 
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1820,7 +1822,6 @@ static int zswap_setup(void)
 		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
-- 
2.53.0



