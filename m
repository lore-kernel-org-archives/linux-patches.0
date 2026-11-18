Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035765;
	b=u46HJ+L67jE545e/bguqCXxoC0ogj/jguRykLzC8is7hhT1LwMKNvuEPLSUx1HenPcPa
	 A9kd93PMRhyExExrIewsugt9sUTrhiwuEv8bzysySnPUDyJlYiZlEm1QzmwWX+QLNMmYr
	 SBKWY0/lfNLxxwjZ0pkEU742O1fBiji7LXt3nIF9W3ThW0b/qSN6Q6tcKT5eD4EGh6hiG
	 fOsFQmgiBZGwRB1INeAjsG8+0JaxBwXNH+aRufeXO8wyE0MD2QZSp9IlM7YlavvAuON7Q
	 SmhLF529D3quwK6Z5JqliFE1nzQrKnRZHI/ehu6BzPlM2vkO/hXtZ2/NFl17FlwqNMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SBxH2H7x7NpaWNKevsT2FlVb7hz3catau7b/llAZ4ug=;
	b=tEc+6AKL9s3yXqX36pHYxA1dHiXtTJ/2sZ1nZS5+QugvLS4Tlo2teTY4JV03mGWCbUQS
	 9oHr3q8DW9CN+ZBtuTGM4u1oH2XHZ4qwwCYs23rfz/0k1l4sn8z32dh8P1YukUYle2pPL
	 vtVQ+66H3OBnBOnxUmkW6BWJKfXe3jRY84XoWG7hcmWdwsaOchdBn2hB3yUQSmUvcAZde
	 ZXnhVsh0K1zg/BgPUCGXBcZGKNxZL8MdSmDcFLy/96o03tq9a6CDlbVVvYojBlwzHeh9V
	 WbtC3WibqRx0P6rrO5lLisWs+s6Mea8/G/mIlS7IZo0U/184Q1zpuVnJ3hMBxPNkkSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwiS7u+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0F4606A325;
	Wed, 18 Nov 2026 21:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwiS7u+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A961F000C4;
	Wed, 18 Nov 2026 21:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035765;
	bh=SBxH2H7x7NpaWNKevsT2FlVb7hz3catau7b/llAZ4ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwiS7u+EgTgrJ1bR9tBIJEtpy5Cl7pKcnJ2Ljhc+u7J+uavyt0UzBStGFdILCCkKN
	 2JP4k2GJzkgq3Ch9R8iPTlqQdwbdC3AwIFimFFJidT33pnqgshcLubpoCF4DeEFbEv
	 NElH9sHjiRI+2N1OOnCQr0f68+/wXsg7X6/1/PLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0818/3318] bpf: Fix queue/stack map u32 index overflow
Date: Wed, 18 Nov 2026 15:24:00 +0100
Message-ID: <20261118150343.577023939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 36384342d7d89..d97aaa82d4271 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -58,6 +58,9 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
 		 */
 		return -E2BIG;
 
+	if (attr->max_entries >= U32_MAX / attr->value_size)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.53.0



