Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064510;
	b=ZXjEkb3DJgEF9rrmXgoyEodxjpGuoqj36ldcq8U+eRac0NmTCYEJFXtOr1LKVd6w3LFM
	 f+kRTKCPvVqOwvI2muYTblhyO8ImbOkI5DY8SoOGigI1/SdO04PD4+XM4Znj8ojiuteYJ
	 xbuDdkk7f8s9AxBL1ArK9C9H2a3L1By8RNRIaSi/ZgdlDagQsW/8DVmi9z/0Ix2hokc+1
	 UHv8EMMCg84IsHC0nMicpcQWQE9p2YxWDpvjT9cu4JCq1RBKjK111fZXd2oYWJjbwUN36
	 rI3UNxbytiltzeZRokRbJnaCAw8p1PJpDZcSmzSx3Pmabm3F34Su/gtXb+NyleUXSgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4sQYqe6FfEyaZsvqXlKeC3kLUgIEY5hCRxX775nhzAw=;
	b=2oPZER1n+HL+FY4wlESCb1vhz12Vwgz2kcnxd4BEegOvfNc1MZZ2oH/18LA4+YJeVVMf
	 /thTz4uzdPzCfvIqDS2ToQFL4Le86nxEdxh4WZPJpfmSIh2LrUAwmKAvLzrBcMuVdhB0Y
	 D8i/ode9Z/dLW+3eLrxlx6vKfYgcOFC+gLW5cDJMM6HgnLlOs+4tUK9xrKUVmkakq9qTE
	 lIAInER+z/u3NZ/15S4sPMOtEoAJOAx+N+yNLsGrvIQJ+doIOmcfneh1cK8TyKTQbKLuU
	 m5ICdSYXD/VEZLUaMHx4dSASOZR2Y9k2ewaGLUzKxZMNkm18mnRC8t6XYS8KpJOx/zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAtA0qxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FAD606CE57;
	Sat,  7 Nov 2026 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAtA0qxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45AD1F0089F;
	Sat,  7 Nov 2026 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064509;
	bh=4sQYqe6FfEyaZsvqXlKeC3kLUgIEY5hCRxX775nhzAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAtA0qxyXm+iCS0ISgFb3BtmuRDuE/hThv53cUEAX45cisKBmlzBdiFmP0xuZUz1H
	 3LMqbHKtBTwrEt+xxyIsFL6OdVub+R1R1ZF6sBsj8H+qCcPdu8o717eM7I300YxVbZ
	 XFIxUg3Urv3AyH9GS1ffWd7eiqVtCkkG8MUQiOWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0505/1257] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Sat,  7 Nov 2026 08:46:41 -0500
Message-ID: <20261107134953.374556799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit ac733f921d4fc02da70a98b175a6055a206b2a36 ]

The function for applying DAMOS_STAT in DAMON physical address space
operation set (paddr), namely damon_pa_stat(), applies DAMOS filters to
folios of the given region.  For that, it gets folios of addresses in the
region.  It starts from the region start address and advances the address
by the size of the folio of the address until it goes out of the region.
If the start address is in the middle of a large folio, and if the next
folios are small, some of the next folios could be skipped.  Fix the issue
by advancing the address to exactly the start address of the next folio.

The user impact is that the DAMOS_STAT-based page level monitoring results
become inaccurate.  Since the page level monitoring is supposed to provide
relatively high precision, this is definitely a problem.  It is arguably
not critical since it is only monitoring quality degradation.

Link: https://lore.kernel.org/20260901131850.98037-3-sj@kernel.org
Fixes: bdbe1d7bc325 ("mm/damon/paddr: increment pa_stat damon address range by folio size")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0b..2ab7b3842701e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -379,7 +379,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 
 		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio) / addr_unit;
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-- 
2.53.0



