Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063856;
	b=DPKfk54mrOjWQySiKosnmNtg95vdSIwxRHSK+Lmte9tZs7eQxBrPo7iOCQBYImLhul40
	 y8LCo9tJQyAakTAwNHJ4tg4Pr5ZewYx3ncnDv9W45pwUJfy2/YU+Nso+vutvJDhMK1mzr
	 /2mwmgy7CkZcCEWLGaLvg7RX4jt9htq6HABs3MdnCb5NYef7tcmiyEr/DRndwi10+SrzR
	 mwmt535aKrpjFElv1rFazV8GjxNFN1xLjTmz8VsjTeANhojZ3Dxrj01R5KjX33Et2wa+e
	 06iu90WAaZocZTbrYT08R7mkwxi7iHtLR8UnA3bYxnpwf8M8rbbIfM3PI7N9AG+U02g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JOf4US9q8yCjkIDHxkVxboNmsCCVoI8Rrw4UkxO2NEM=;
	b=Eti4o8txDImrrzMlXnFn2sFO3Y9EqZ9hUHyINhQtJQ6FEHtKps0DWL1tpi4spXDNisY+
	 inUglykrVLoK9Gy2Tv+N5TtxkRKV2oyz3LszHYmQN6LEzSep617lzhFuI4OTcI9q/B9Tt
	 QtdPjZvvbNCrE0utRUezqiVanyqH4H69zbygmFU1oCa1xBzlBKi/na/TJDt/09RghltAw
	 3dgPV4T0PDOLA78lSk7SfUVXZKOPZlgdC61DfpNm+j9bsWhes5jDtPBk3hYu5r8mAGPBH
	 AO6hhHowfEDxdfGwOwLBcHarUx4ttIHQmhRU82zjTVYWS7E6qRYQfUKIyFB37Fjx+BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFJCTuaD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F93606C03D;
	Sat,  7 Nov 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFJCTuaD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0501F0089F;
	Sat,  7 Nov 2026 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063856;
	bh=JOf4US9q8yCjkIDHxkVxboNmsCCVoI8Rrw4UkxO2NEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFJCTuaDNIT0MXBhJINkBdGewpzXUa1LTvmrOh5UXI0SQ9/bLYdNDRDAwmPQ5n0gf
	 WSU5W1javkDB4N14V3h+ad1IMeGoLZ22HFETfISvkrefdFGSqvgyEfgsZ95hFPxoVX
	 EFT+gO8OoKNf5qFNuibb89HTLNZirBKRdm8pd10s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0064/1257] bpf: Fix queue/stack map u32 index overflow
Date: Sat,  7 Nov 2026 08:39:20 -0500
Message-ID: <20261107134941.167797103@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 802a30c5db726639df7f93b3a1982ecc64202abe ]

The queue/stack map addresses elements[] with the product of a u32
head/tail index and value_size, but the storage itself is allocated in
64-bit arithmetic.  When max_entries * value_size reaches or exceeds
U32_MAX, the product wraps and push/peek/pop operate on the wrong
element, corrupting map data and leaking stale values to user space.
max_entries == U32_MAX would also make the u32 capacity counter
qs->size (max_entries + 1) wrap to 0 and permanently break the map.

The original bound check was removed by commit a37fb7ef24a4 ("bpf:
Eliminate rlimit-based memory accounting for queue_stack_maps maps"),
which deleted the bpf_map_charge_init() call and with it the
U32_MAX - PAGE_SIZE check that had earlier been moved into
bpf_map_charge_init() by c85d69135a91.  Oversized queue/stack maps can
therefore be created again.

Restore the bound in queue_stack_map_alloc_check() with a single
comparison that rejects any max_entries/value_size combination whose
element storage would reach or exceed U32_MAX bytes, keeping the u32
index multiplication overflow-free and the capacity counter valid.

Fixes: a37fb7ef24a4 ("bpf: Eliminate rlimit-based memory accounting for queue_stack_maps maps")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260831063226.621309-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/queue_stack_maps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 6e8b18c32a106..1cee2ba6e332b 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -59,6 +59,9 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
 		 */
 		return -E2BIG;
 
+	if (attr->max_entries >= U32_MAX / attr->value_size)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.53.0



