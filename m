Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044896;
	b=Uj7eFFudxJ78spgeb06VrdB7swLtVle42LjSiRuBokt9WVR8sxF8w2j8zfBQbQHAaOgb
	 ikDqD8eVpItx+mJEB1jyw/6o4ScwAMMfTCTABwn3ACcQ00XdctlS4snmZhKpeF+z+ny+L
	 1f3XfcCwM9Sx/A9plZ/MkE/XP4pQIrcuphcr2994K9PkbY2sKbBslo4jZjMKm7vyqhdpT
	 gE9I0P7KTD1cuUFNiKnCF086MErjuM9Xfvjhne1UqScxZSJEIsP7sFRNDK5yITVspiDNE
	 GZqRlvhY47om6oLC0mCm9D6CWpmxwK+rV+ak7IX4J+5yhyAgzcFhWC174hfJREZ2X9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Jk+Ur6wpKQOtrLHl5dgzgXZLgWLgIDuHRDCpWF+H+g=;
	b=o4RjIlWmayAK9t4Xm/NpiNWO91rK4ZVl1FTpoxSa8GhOAbZKAkvEXFZsWcSw4P+5HWsA
	 mjO+q0MRSiFi72NjDEdnCaQY4aGMLm+c5S3Xe6P1iatN0jzfV9Q4y5KoYaoykpyWCkukJ
	 BBJdy2Q9uwXADEMZEYlvNpiFWBvW1z83Jh2O43gWX/X79kSfx1M1Q91GdbFb99SjEFgrs
	 2jIoQ0B9Q4SY4VsvrauGs4DTRmLtOade4G9EG0qTS0Bjo1W2CRkYKYe0rpRmmexSfCGs6
	 NXlGfhO/y7412HJsjdosbi5xNhug90gAf6A4fM0HjVzk8EI2RDyccJjFQ0sDxmACQTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQHEG3i5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335ED606A339;
	Wed, 18 Nov 2026 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQHEG3i5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA51F000C4;
	Wed, 18 Nov 2026 23:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044895;
	bh=5Jk+Ur6wpKQOtrLHl5dgzgXZLgWLgIDuHRDCpWF+H+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQHEG3i5WpiUNT1lL66Atb8DGTksdxEqM/wMDKvrAwD9UsykDFr0DkQZ942S9jMMB
	 VBOJCb0X3A1vNhxUJN/I+MENQ1nZepSiO+MwXaoik6yIJkTJE8053Oir6VAYnJzKIT
	 EojeYoiDkofdgRL498lzMJ3t/QxA/dtgCIaw0GEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0727/2857] bpf: Fix queue/stack map u32 index overflow
Date: Wed, 18 Nov 2026 15:29:21 +0100
Message-ID: <20261118150227.723296499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a088132163b1e..97399bfbe3528 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -62,6 +62,9 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
 		 */
 		return -E2BIG;
 
+	if (attr->max_entries >= U32_MAX / attr->value_size)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.53.0



