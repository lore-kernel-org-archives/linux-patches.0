Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061908;
	b=EeVKzvYOS0KZcYCr54+Z9gGp5vHrizDIVoRqU3YoKuEUBxfNFmpX11pOjRXssb005mBx
	 25Q3/JOu2/CXsUDTC8aSWlixefPxi0ksBXW7NUA3ofXeOd8KswQ2araNJbYZVd9smtKlw
	 RjcAjbKYCb8oqpTFmNFhIrvgf6+m+R1MUiHg0aupQRPR7Fb+Q2XY958u0xFb3l9fNfzfS
	 AzccBWlHpGxMbcB8bV6pKbc0bcaQnLktguSMrm0uuZbcqLwWasjHFtQ37YX2UYqDoE0td
	 Zk9EyYn9dX7U/snmDW/6E5vwgPZBK5NS3zFoRYmSxTiPGtKfjrdFUys5XoRWKRe2D2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bnAzDReUsMVU7S7+bc8XVihyc4dIpoZs0gt0ruAARUg=;
	b=k3unf3c3Ob9TRj/N7jMmiB8ted3IDCgcYj7n14PWqwXa3LUGP7KzI4iJbKsWA14Am1Qp
	 hJFps+h5TFvORmivR+UzrZ4LSjjE1C149li+d8Ug59jcnqxPf9Dxe5bwK8EvV02bIkQ3y
	 YFp3p16FEMPWdYH6POMm3Ez6giYq7F1rbNyOwbx2g5CMOVaRgMCPVbnl6UEpYllSa9hBO
	 PxvmSfaB6vJkzhN7p7d2dAlPYj8osSGXxoMwH2l0q93PnGIDJ2Hjdh1SzKwKBrVXIKIBy
	 aq+DaExVTEF2/0VK7Bd2sO0vc42DV5BG3TLV+U7Z3DsBri7BGndvq/YytFg3FN5Q3pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2kbyigI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAFF606A326;
	Sat,  7 Nov 2026 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2kbyigI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A011F0089F;
	Sat,  7 Nov 2026 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061907;
	bh=bnAzDReUsMVU7S7+bc8XVihyc4dIpoZs0gt0ruAARUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2kbyigIQW1BvNUFXzDtH8ynIuyd1HsQh7HDGtFxInooJqlIOrsfZhAXrGfjFMBXa
	 D3haO62Ef/bj1pyh7cVWvJWdCPuJyeXbIimwzgazWXpNZ9rY1wDaRHZaBVnqdlrVw8
	 VbZ+xX+E+blRS6TkpKf5zp5gCbltx1WMiCppdNU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0917/1536] bpf: Fix queue/stack map u32 index overflow
Date: Sat,  7 Nov 2026 08:48:53 -0500
Message-ID: <20261107135023.396617188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



