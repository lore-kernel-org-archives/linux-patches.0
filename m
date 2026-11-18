Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052126;
	b=yf8LGNNAhzNibx68xXbUUZIB5Y7r7fakjqzmAnnuHjnT3CuMtPShE30IfVJKOCpZ1ljx
	 PfRyiruIb5H8h/GeCegccQ/926Y0DcLjLVZF5MAOkWssxO44CXdkSfTTZ1x4lGhnR8AQM
	 L4FZ0yjHKULsNEk5f5ol1Ej195WAPPY8J+rdZ+7j3FS5MvqE1xSeX3UO1pMaRMtfRVbh9
	 F22oxVpz6EffEjEt970y01Q5J2r9A0aoWh8r+gE9cYY0opTNdgvYh4B2XUrd29O9D//I1
	 ZchtmaolSS/AcsL2sf6kzDfJ6UUzyJbpF9nN958G4wQygownqRznS4otvs5/qmWvmsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdR1oEaNY0rBwizW2Z5c92r/P0yR2UAetZp8gDy1oVM=;
	b=aXZTBKnj+Gc0su9AMGx6B/cG3ibC0aSVl8CHHNIjqaUneH4FMDUHQFdCUX5pydL4yh3Q
	 bzXXtyyuNftFu7wNUnfbpKgkdef/sNJgGyerbjuoVQFKsiTfGVVUw/VTa5VEo+IjTGKjW
	 Op//Hp6fDY3TkcrFoRxYt5xOI1bQVrwNFEfW/Wl10NB7KQyx6beY7mr8Bi5oCX4XzgbGV
	 n8XjdUpyhlHEC6qvIs5ed5XTwBLjC8T7BmS35pjoIEPZqid95Z6ZD7py49kb55l4FNOjf
	 pveHbQfIdo32LJvaz451Z/AZsJwfAuTmiBKQ27QNc+t8vgbez7bfYiDMKaZ1LP7nMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gkwN/tX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1FA606A325;
	Thu, 19 Nov 2026 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gkwN/tX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136011F000C4;
	Thu, 19 Nov 2026 01:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052126;
	bh=QdR1oEaNY0rBwizW2Z5c92r/P0yR2UAetZp8gDy1oVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkwN/tX/G0LZ6huy4L4tPsPIh/kD1OkUwi1nGsjw7EnDVEndjacVaScOlLk9i9mFE
	 ZL3HiISWpfHZNsMUDuOaq2ciBZ4hum/tOc7NDzTSsPie0giTNt1F0CG8Ovr5js8pgT
	 ZB4U0jyUkakHZ2Ayl0DFUqD6jW7h+1ayPbL62oG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0452/2214] bpf: Fix queue/stack map u32 index overflow
Date: Wed, 18 Nov 2026 15:35:28 +0100
Message-ID: <20261118150029.192313170@linuxfoundation.org>
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
index ef95b796a0fa3..e9e9122c0385d 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -61,6 +61,9 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
 		 */
 		return -E2BIG;
 
+	if (attr->max_entries >= U32_MAX / attr->value_size)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.53.0



