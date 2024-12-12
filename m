Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDF4213E97;
	Thu, 12 Dec 2024 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016049; cv=none; b=Lg8JTtXYDQ7l42JftEe0Uj7Ih/fsWbamSFc+wKOIWhVinIZ4RHbjmUpYyko0C4DY4fhkf6LY966ibmIrqmB9neeEUabe6yHLTkXxh2BMRk2t7VSsSyQJoDX4CZ7tmo0S2SZVr+zNxNNktptrbBS0uqMHH4jVB3DgIa9jeWD2Oxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016049; c=relaxed/simple;
	bh=CgJ91vbxXck4jTGGS81nzhvFz7unz5aw9+3zHjZx6f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljKDuPnxn0KmGLbkJFpIHXgLHn2FnNSB1nXBylk9S2CSgMnLaM+cLF4LHcEVYys9mqw4V7JfNrKrtlZppWd7RIzCWyoiwxv80AA+9Bw5ZTNSGQpFDWl0SX4o1g/IFxmmV/S1ZOJgK4VuFyCuL9/TQtfA8ZyOI5qBMOzagC+xSZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYF1u1F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYF1u1F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A74BC4CECE;
	Thu, 12 Dec 2024 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016048;
	bh=CgJ91vbxXck4jTGGS81nzhvFz7unz5aw9+3zHjZx6f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYF1u1F5oA4qZC3Du/w1kWAG3c5TRWLFipTY2CPUG7Ep7THCiKp99MVOVcqkbTMth
	 YcVDchnPJsrYXsyPG580EEFCjTdNHx08gsWc56CDJQskB8x4/Y1CJ59+V1XStvDL+c
	 o8TtMmWmee/vmmqLZpOd1v61W/oDrOd/koSsACrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/466] bpf: Remove unnecessary kfree(im_node) in lpm_trie_update_elem
Date: Thu, 12 Dec 2024 15:54:46 +0100
Message-ID: <20241212144311.438252369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a82cf3693778a..8a040f123e04a 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -315,7 +315,7 @@ static long trie_update_elem(struct bpf_map *map,
 			     void *_key, void *value, u64 flags)
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
-	struct lpm_trie_node *node, *im_node = NULL, *new_node = NULL;
+	struct lpm_trie_node *node, *im_node, *new_node = NULL;
 	struct lpm_trie_node *free_node = NULL;
 	struct lpm_trie_node __rcu **slot;
 	struct bpf_lpm_trie_key_u8 *key = _key;
@@ -449,9 +449,7 @@ static long trie_update_elem(struct bpf_map *map,
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



