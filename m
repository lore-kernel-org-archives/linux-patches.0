Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044454;
	b=n6nBnc6/mge/Zvf6PmKtrcND+lcjzZY3QCI1TsY7pIN5pdYrfIPQkB5pQdkfaiVaqQHl
	 Xb9Vja5u2D9DVT+YCzFkopo18z7LNd2AyDdPU4IjSooWByDTadS2pdzdWRWnv3qju8uc6
	 ryQKfdWkrQ4MCdz849Pxxmk2sQOC5LXzmOzG8lEiyoqkk8wlviwBE6SFOnGcwyK/jZRYb
	 9o2XElh6okdIGc+7zhzH9gAOtAwRgLoOmkVEiMAu2YSjMb5SxbStBJU8Qbp+Jo5UeMwOJ
	 V/kA+P5LQZNAzoO96tvJkiiiKCrg3ExtVtHBjen1G+EgdUTXqKaldWbuT37D6MEwh7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxBvZSh2Gex2mRm1tX0iM9K/m/fvZutw14jIcvIelMY=;
	b=cnJBCCktqPl7APKYoYTPiNghSShf/C8jLpHIx1RWATBkqkwKLN80uFql7b+qbQojVGGV
	 nQk+IyIE07rGa4D4nTEnwy7lTDJwIiidz1Uy/54B7LmiOKm98sAPmp2B0ta+MqZni4QO0
	 JPNzKsmvARZH7t+jW0IOkHowV1xi2zlw4MfRpfuD4F919wV1/2wKrxVtMBnU8T/7oMk1Q
	 xKd0VwoyDGpa7FMjEpuFmbyMbnNG/cwmDxYIfY8EmsHK412iq7K7UXcZUduEjKebNxWmG
	 Zsa7eAMCJ6RAxpSj+QgQEhmlaNZswMsZbJh54vNMJTQNx7kXwDLJBO8XEgM91gbqe3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bj6CJyk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA36606A32A;
	Wed, 18 Nov 2026 23:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bj6CJyk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7F21F000C4;
	Wed, 18 Nov 2026 23:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044454;
	bh=SxBvZSh2Gex2mRm1tX0iM9K/m/fvZutw14jIcvIelMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj6CJyk8vVUZE8HQN5CewLsizqH9Fm5ndg8UXD9xSLrHYJtEMaRtwQTx2Z7dyHStA
	 qI+x7w88kglolu12qQNNNW/NmNXQu1H1Hhr3qr7J7WSegRTnTb/2qed12aSdTCYTQF
	 3nzpsscLKVDa3mGMw0Wq0N7X/nlyi3bPUEnJOByo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0524/2857] Revert "interconnect: Fix locking for runpm vs reclaim"
Date: Wed, 18 Nov 2026 15:25:58 +0100
Message-ID: <20261118150220.335722622@linuxfoundation.org>
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

This reverts commit ffb8917c70a4c88725ee40f9eeee9240ad1c1869.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 40e2f110c5339..09143aae680ef 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -29,7 +29,6 @@ static LIST_HEAD(icc_providers);
 static int providers_count;
 static bool synced_state;
 static DEFINE_MUTEX(icc_lock);
-static DEFINE_MUTEX(icc_bw_lock);
 static struct dentry *icc_debugfs_dir;
 
 static void icc_summary_show_one(struct seq_file *s, struct icc_node *n)
@@ -636,7 +635,7 @@ int icc_set_bw(struct icc_path *path, u32 avg_bw, u32 peak_bw)
 	if (WARN_ON(IS_ERR(path) || !path->num_nodes))
 		return -EINVAL;
 
-	mutex_lock(&icc_bw_lock);
+	mutex_lock(&icc_lock);
 
 	old_avg = path->reqs[0].avg_bw;
 	old_peak = path->reqs[0].peak_bw;
@@ -668,7 +667,7 @@ int icc_set_bw(struct icc_path *path, u32 avg_bw, u32 peak_bw)
 		apply_constraints(path);
 	}
 
-	mutex_unlock(&icc_bw_lock);
+	mutex_unlock(&icc_lock);
 
 	trace_icc_set_bw_end(path, ret);
 
@@ -972,7 +971,6 @@ void icc_node_add(struct icc_node *node, struct icc_provider *provider)
 		return;
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
 
 	node->provider = provider;
 	list_add_tail(&node->node_list, &provider->nodes);
@@ -998,7 +996,6 @@ void icc_node_add(struct icc_node *node, struct icc_provider *provider)
 	node->avg_bw = 0;
 	node->peak_bw = 0;
 
-	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 }
 EXPORT_SYMBOL_GPL(icc_node_add);
@@ -1138,7 +1135,6 @@ void icc_sync_state(struct device *dev)
 		return;
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
 	synced_state = true;
 	list_for_each_entry(p, &icc_providers, provider_list) {
 		dev_dbg(p->dev, "interconnect provider is in synced state\n");
-- 
2.53.0



