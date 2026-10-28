Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207202;
	b=TSnQMA9nMgf8Yd3ilY27zOJgxba00eCr3tH++6R7CjgB3VeWjyr6lHE5qELR69lRU19E
	 bPtnPVCkqYzSBp6d2sxP3XJeWd+VLWjXtQHJK/OoHlKpm/F6rgMvHru1vE2HmF2Jv5QYu
	 EqVSpePwdnV4rZtWAYUQ1xyNpBh8Fi8d8NHzvvcxMnD6PP4nfgXx0FeZzw7U+zt0uC72x
	 HOfWPdypeeohoqxXkCahB2B7rIVuPZA0wdA7cbIOKKFH/BbhF7zuPG3iRqa/l1HBjP1aX
	 MdAPeQ2knP38nKYXTWFm5h8EaB3In5dkaqlLWD9deJN6C+qyc/KF9frvzqFR1JT5UWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xpKG8iQF8iRUh2nuE9rwIwMew/DeBTS14e2kiC91d0g=;
	b=4moIH1SGMgZ3IdVTswzrAqIsb21UNQVd0yVq91QtXNosij5js3rglglufIpsqmjE62Ed
	 QpWoMDlSDoSx861gMnCuRdNg5EBoKXWucY6IdVFr+1xbWPL3A8iHtPpj64W6TXYx34S7s
	 Y67gugoxaMQyKeSIx3mlCxU7+x1Dw68JphPqSgyAOkC1p1NvGjDIa9iphe+hrcE/m6Ljp
	 S4xVt9t2kyMPwniEPuL//PbT26H4sqkR1SK9GLCIPwYmkJ50fl0zsHyVcuf2c6qwPli/L
	 DsASlTD6pPwSHMgZZjcRHk3rG2r0LPv4mdrf9kxyhO3Zo0z+1NlvtRSPTw3QWvCGAkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+xlemKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307B606A31D;
	Wed, 28 Oct 2026 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+xlemKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E411F01825;
	Wed, 28 Oct 2026 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207201;
	bh=xpKG8iQF8iRUh2nuE9rwIwMew/DeBTS14e2kiC91d0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+xlemKpJLmkMJBWaMP01V25z1aQneNQSgImy5rqQhoBkCa932JXIWVU7QtvuN/dL
	 /HMWp4wQcohtiCNjYv7AbctgT8mzoqac1WO/ufKNpwovk8bJAUsu3zuDX+Ld5bxtl4
	 jWwskqqwHmVUVKe2pSvo7yCeoI5JHJFMxLj4mH/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7.2 07/88] tools/dma: fix building with O=
Date: Wed, 28 Oct 2026 17:59:15 +0100
Message-ID: <20261028165942.286486416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


