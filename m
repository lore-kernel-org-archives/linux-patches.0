Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207134;
	b=sDpRczvrXS4ETty+puCe4yz5NEEvUVM1Lj7dGOzzuq96fHRGht1w08Uw5bloQd0Uq4Qo
	 BwqfhtWsGk2gkvZUT0A1BAo5J5Tuy84BvtVuSSci1WXEmUuQy8mJh3VdAC1+xla39npOC
	 Ead6CEDXn3g/TFntcaHzUwc4GnJS9tteO4l3AxBeE7UG/epR/gF/fLaA3MHatbg2qFs9i
	 wx/eydkTxL1qWHCnf6IO3wDQbftWL2F7f4l8zOBs8zzmi7wZ/OjMEgNsquZlbHPIjT7lY
	 AHhCKsWXxK9qTbdVUxBuC3VgxgBctAbb5gl7WHU75PoR5p2u5j+SD5jE9L0f4bywdTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6BFlXcBPUo7qopvoH2UPLOwhwXW3qosQ8+ttnBmgJw=;
	b=1iT0cU2KesVIhL4CblYDUYCJiNETRX8LoEwelmlo/v+U2TvG7xCnbh1HD2m5YNQy9vH2
	 b21D670Z5/v5LuT3jHzPR4YQTh+RYCUEAnQBZhskugsmNKDU8gevvvwzronh/itY6Swd+
	 CT52TJH56StsTIlEj1NMUVV6OG5mFkWbX8o8Utndd5LOxBeYBJwxxXxGm7KdRdDS7/28l
	 gZ98z3TaVIUlMOG7Y3lM1Lfgt42RJaTTN2DNvTI4vYzS8wgEI3SSSaq3DD6kVZzTygJ1K
	 cQt63k1m+xypKHWxcyaB2o0Bj9WT6mGxWjSMJHqPLH09f1LdN2G7JN82WSgIATMLu3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmfspsH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA845606A31D;
	Wed, 28 Oct 2026 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmfspsH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8241F01825;
	Wed, 28 Oct 2026 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207133;
	bh=v6BFlXcBPUo7qopvoH2UPLOwhwXW3qosQ8+ttnBmgJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmfspsH+rwV9GIytzMDjHZKHo3pc1lo2e0LHrCkFwDOyM/2xX0cx21b9vXE3q0qn5
	 rBr6bEho+pBB3U2lftBtjICl5VfcriCnGpl0pf72+0Wo0jwZhyCR4mhsWkG3JWwRvD
	 61Fv+ZESLKT0pAa5L0hNQmix5/2DwCZMfY0693/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7.3 04/38] tools/dma: fix building with O=
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028165940.517263219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

From: Sasha Levin <sashal@kernel.org>

commit 9441e7eca18c8004d1afe57b2f9b27717549562a upstream.

With O= set, "all" depends on $(OUTPUT)dma_map_benchmark, but the only
rule builds dma_map_benchmark in the source directory, and built-in
rules are disabled:

  make: *** No rule to make target '<O>/dma_map_benchmark', needed by 'all'.  Stop.

Build $(OUTPUT)dma_map_benchmark.

Fixes: f74ee32963f1b ("tools/dma: move dma_map_benchmark from selftests to tools/dma")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: Qinxin Xia <xiaqinxin@huawei.com>
Link: https://lore.kernel.org/r/20261011223358.2327625-3-sashal@kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/dma/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/dma/Makefile
+++ b/tools/dma/Makefile
@@ -38,8 +38,8 @@ prepare: $(OUTPUT)include/linux/map_benc
 FORCE:
 
 DMA_MAP_BENCHMARK = dma_map_benchmark
-$(DMA_MAP_BENCHMARK): prepare FORCE
-	$(CC) $(CFLAGS) $(DMA_MAP_BENCHMARK).c -o $(DMA_MAP_BENCHMARK)
+$(OUTPUT)$(DMA_MAP_BENCHMARK): prepare FORCE
+	$(CC) $(CFLAGS) $(DMA_MAP_BENCHMARK).c -o $@
 
 clean:
 	rm -f $(ALL_PROGRAMS)


