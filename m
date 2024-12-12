Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C0E2135C1;
	Thu, 12 Dec 2024 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017867; cv=none; b=gzx7uaT0fgu8kjBEZi4CrqwKLRL1bRDtPbigwoMwiPBh2E9TJGtbiEE4qEoQrsi894BjGnISesgeWmXEatFiRkiIMhkAvFfDLxZVNPY71hhANNEEOYydWrCEVxAFDeSW+a7JUbNr6Cuo8Au0EUefyUUO7IbDjdar69WF3zABGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017867; c=relaxed/simple;
	bh=edYa0bbFZ/UIQcrgirKfVNiNuOEySc/iCg8pz1FvgGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OgPlxLDy1bjnNKXTjDUgyYlaQzBzjpzLFDHmbWFrWJS64mmPDVr65SH/F7h5pdYhzaIEcOz49NE4J/o+k/p6jdzhNYLneSO32oeb+wDRF4jMlx1T//g73rS9rS1J0MlJOXqt278wTE7nNI6mKNynvuQcwGFwf2ZW7Bdu5CfSi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exxhVCBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exxhVCBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39125C4CECE;
	Thu, 12 Dec 2024 15:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017867;
	bh=edYa0bbFZ/UIQcrgirKfVNiNuOEySc/iCg8pz1FvgGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exxhVCBAaxmTObBQFPw7cbSxG+XdV/zcU21dizSJ21Olg+k+LoSSaHlwK7aSlywFn
	 qJwk/NkiU/qkYAmvvv7hL+MPUDO2KQeydomcZ0JaClac9dP7csfWJ+hxzytHZ2Gfah
	 rwrIDgIHvpwweiFcn2EJk+c5WSsHNo46ckT7VRQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/356] bpf: Remove unnecessary kfree(im_node) in lpm_trie_update_elem
Date: Thu, 12 Dec 2024 15:57:33 +0100
Message-ID: <20241212144249.943139570@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 3d5611b4d7efbefb85a74fcdbc35c603847cc022 ]

There is no need to call kfree(im_node) when updating element fails,
because im_node must be NULL. Remove the unnecessary kfree() for
im_node.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20241206110622.1161752-3-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 532d6b36b2bf ("bpf: Handle in-place update for full LPM trie correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/lpm_trie.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 0b1931ad3b1dd..db1b36c09eafa 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -307,7 +307,7 @@ static long trie_update_elem(struct bpf_map *map,
 			     void *_key, void *value, u64 flags)
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
-	struct lpm_trie_node *node, *im_node = NULL, *new_node = NULL;
+	struct lpm_trie_node *node, *im_node, *new_node = NULL;
 	struct lpm_trie_node *free_node = NULL;
 	struct lpm_trie_node __rcu **slot;
 	struct bpf_lpm_trie_key_u8 *key = _key;
@@ -441,9 +441,7 @@ static long trie_update_elem(struct bpf_map *map,
 	if (ret) {
 		if (new_node)
 			trie->n_entries--;
-
 		kfree(new_node);
-		kfree(im_node);
 	}
 
 	spin_unlock_irqrestore(&trie->lock, irq_flags);
-- 
2.43.0



