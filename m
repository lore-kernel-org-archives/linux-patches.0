Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018463;
	b=smLkrLjNtsvExhrUvanjvtezKpeGflhUdMKtHavYinEIB3f8SmVNDhGeXMIF18KqbRuk
	 C8NC6abu8t1Vf78SMsHgGzcOdXzXWXyEYX1F4lJ4LQfjI8KFNszUzGjK9o6wyzigeYtMm
	 aTerxtbmA2DUoFk64TqEJDMw7/ELsGKSwv9VsHmkjCS3YrM3YBkQrWnUr8uoRp1+ninQy
	 RgoiPJ1w2Tvxum26FxNfqui8EVlj7RD7c59ga/GPa5Ns/1fKlM2d40H9GpJMzwJschy2U
	 hxNeSKlvRHJGBClVUTpOFT5KExqab54st14Agnfqd4oZaUv5QIMA1gdbhWeT30zkJcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxyv8Gbd+MNxaetNgad7KW3Uj75Qz4lmpyXj37eDgOw=;
	b=RT8wTgNwIkFaQKxixZwSI2J7c3iC4Y7aIMNKiRv8OfXvXnMKVgLnkbtw8cpQAEHM8L07
	 p5rlk8Qc7zPMcMvUgyyO4P3sAv/jImttUJLjWxUqSKxH4BfW2AcPn7HZKLSRaXl1gFf1w
	 Q6AGeaLxwI+5dl90WeCY8GXTZHP64soqbIGvkTkesY7IREMjGYbWjuBqwD061yz0bdWPM
	 0YrWNMJ3Rc7BJHFnoQrTUJcMh5cj+SkKpSz6n9wuzhb1gcvOzvzKmcRr1nm06G4IKi/ou
	 fpUdgLDxEnHnaH9LNwEqcG7kP0brvUIL9mxWmWBAfP98Xjcpm8mjtIb3vxTOBLHAcHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L2/EylYL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41217606A320;
	Wed, 18 Nov 2026 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2/EylYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939D71F000C4;
	Wed, 18 Nov 2026 16:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018463;
	bh=rxyv8Gbd+MNxaetNgad7KW3Uj75Qz4lmpyXj37eDgOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2/EylYL2e+RrHHlZ3hI8618pJh98v4EBLWJTGgLxws8y4WpOPVlmOZ6bDvbqxR/e
	 Yd5MHf2iP82lYW6omZpPkYVz2+rX4faZZfeKlTG/ksyZZYVydqmuwz8EbBPlC7S5Zv
	 dVTRTWG3jLEvWQPB3GDn8E0rvPO+AO3VUGtqJEeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1248/2651] iommu/arm-smmu-v3: Dont rb_erase() a never-inserted stream node
Date: Wed, 18 Nov 2026 15:41:28 +0100
Message-ID: <20261118150332.914891431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 2888520bdcbe0599cfc77b2fad8dc6c95505a3cb ]

arm_smmu_insert_master() skips inserting a stream whose StreamID duplicates
one the same master already owns (bridged PCI devices can present duplicate
IDs), leaving that master->streams[i].node zeroed and unlinked from the
smmu->streams rb-tree.

Both the insert error-rollback loop and arm_smmu_remove_master() then call
rb_erase() on every master->streams[i].node unconditionally. rb_erase() on
a zeroed node sees a NULL parent, treats the node as the tree root and sets
root->rb_node = NULL, silently emptying the whole SID tree and breaking SID
lookups (and DMA) for every other master on the SMMU.

Mark each node with RB_CLEAR_NODE() after sort_nonatomic() reorders the
array, since sorting relocates the entries and would leave the earlier
self-referential RB_CLEAR_NODE() pointer stale. An un-inserted node then
stays RB_EMPTY_NODE() and is skipped in both erase loops; inserted nodes
are linked by rb_find_add() and erased as before.

Fixes: b00d24997a11 ("iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids")
Assisted-by: LLM
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c6176394fc890..68f1f6e8ba7ef 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4176,6 +4176,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 	     sizeof(master->streams[0]), arm_smmu_stream_id_cmp,
 	     NULL);
 
+	/*
+	 * Clear after sorting: RB_CLEAR_NODE() records the node's own address,
+	 * which sort_nonatomic() invalidates by relocating the entries.
+	 */
+	for (i = 0; i < fwspec->num_ids; i++)
+		RB_CLEAR_NODE(&master->streams[i].node);
+
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
 		struct arm_smmu_stream *new_stream = &master->streams[i];
@@ -4208,7 +4215,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 
 	if (ret) {
 		for (i--; i >= 0; i--)
-			rb_erase(&master->streams[i].node, &smmu->streams);
+			if (!RB_EMPTY_NODE(&master->streams[i].node))
+				rb_erase(&master->streams[i].node,
+					 &smmu->streams);
 		kfree(master->streams);
 		kfree(master->build_invs);
 	}
@@ -4228,7 +4237,8 @@ static void arm_smmu_remove_master(struct arm_smmu_master *master)
 
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++)
-		rb_erase(&master->streams[i].node, &smmu->streams);
+		if (!RB_EMPTY_NODE(&master->streams[i].node))
+			rb_erase(&master->streams[i].node, &smmu->streams);
 	mutex_unlock(&smmu->streams_mutex);
 
 	kfree(master->streams);
-- 
2.53.0



