Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A841221D9F;
	Thu, 12 Dec 2024 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020923; cv=none; b=NNa8N53ZpQQGjav1IbYQmZZIFbu0CFXDpukrCOP+ac3PVdk4iSwk6juvw1of4pUcxdyw07dqv5AuIOexF41GcVqPYpDhx+uchAwsyuSlq/cgmAuzwvSv56bKvjUBODT7S+y/xwRektEgPnoX/8uuiwuDDBbej8PODk5PhcS/lUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020923; c=relaxed/simple;
	bh=GdZUDz5IsWX6kmWGO0a1xV7qreT6Q7G7caoknqXxQVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iP/vVwfybKd/S21sCAsCMlhR5hwihiWBg7wdY/f+nz/Tqgjpi+pGT0Q/BCC/+s19Y8CUS0OTrQzuH6zOqjYP8YSwgTIvVSVwuXiyeFZF8lLL8Uo2ucgV0H2t/o7tuz6xxSCUAl+U4fxva4kpSLplV6T9q2WqQ6hObhlP9AViV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1wX4lyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1wX4lyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7D5C4CED0;
	Thu, 12 Dec 2024 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020923;
	bh=GdZUDz5IsWX6kmWGO0a1xV7qreT6Q7G7caoknqXxQVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1wX4lycT9Lxpa6r/0JD6/aqABrk2rqNaUEV/HPux4gtqfiaTYbULB/Eqztqefnfv
	 1n0dlH6nZgmW+Zr/R1MsW4tln96iXrRcmdMMW3idyODVAVwRqmbs9qI3em11bRJ02q
	 G25KNU919cn9b7XqG2WjqJOlOrH9OKaPFeeH2nIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 599/772] bpf: Remove unnecessary kfree(im_node) in lpm_trie_update_elem
Date: Thu, 12 Dec 2024 15:59:04 +0100
Message-ID: <20241212144414.681288561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b35f1a9e901c..694fbf9891f4f 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -307,7 +307,7 @@ static int trie_update_elem(struct bpf_map *map,
 			    void *_key, void *value, u64 flags)
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
-	struct lpm_trie_node *node, *im_node = NULL, *new_node = NULL;
+	struct lpm_trie_node *node, *im_node, *new_node = NULL;
 	struct lpm_trie_node *free_node = NULL;
 	struct lpm_trie_node __rcu **slot;
 	struct bpf_lpm_trie_key_u8 *key = _key;
@@ -441,9 +441,7 @@ static int trie_update_elem(struct bpf_map *map,
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



