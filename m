Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214856;
	b=OVNaDRbxQgB6g61gUQR6jZyeRaoPasjxfO9sYrSH0u50ijfLKQ1+bzV9+H9L2iNRs/hO
	 ElUSpx5U7HkiP+fBhln6t4AgF5PljwVMBflVgPBgVyXDeEow50ZqkdSBFzhF8Wkbxh4OZ
	 U2DZ+IKAYUojvSMFWCjQxI7hA4rdtVMq8BJ9IwoODZSg8h2/HQml5YVAdV4hye8HeFZKt
	 OtPYbpOfXXDuDj5QUxiDg15oXRyxIyZoaejw2NdkzVlG4lxzfQuFMyy+ZK1WnR9485Odz
	 l1nTpHTyjSqMv3KqaIca2tG8olHwGNJ1KT68RuLo7+hj8fTkbxPfsdapfwmPlkltR1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrQ+ls1BcpfmLJlIQbnHzkIVhXVCzXqelzvkxwcbGxk=;
	b=XNxJHC8u7h+5W1Vqg+C8+1JxfoeENDsQRlxrSQY2smQCk/+SHYf6Fui2pZX+T/nFhKg8
	 RGCN8mMpntu4td8irHwuiGypsUltCl/tjGESRmH+Fh2ev5rTfJTQw95y0pnsTZiYW9jI2
	 KULI4zFqRyBdXxzxLPgKtWh1tM1EhMOz6I4fi4jS2/s4bL2uvQBiYbf4UyBKAYx24gC9O
	 1veuDUps/Np/cEc4UTmSeL7d8nkZG0gSMChC/ZDMpuXozer+C1+4nQPjL2+s3+vZgFkwx
	 coEdByJX7dpClCU6H876hXO4eI8VigHW94BZWukwcWCqZ6ctiVJne9GbW5rCHou+u7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rub9a1Qd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF929606AB35;
	Wed, 28 Oct 2026 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rub9a1Qd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47071F01825;
	Wed, 28 Oct 2026 19:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214855;
	bh=vrQ+ls1BcpfmLJlIQbnHzkIVhXVCzXqelzvkxwcbGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rub9a1QdA4+ADgopTHg7JhlrJ51Fi/L+LPD71C6gobQhHK3U8YoTd0Bzj4fsRRTUQ
	 MRncX1+XzrRY2IJiU8de263/DWscIFA+yymD0e0Qv8XKMgejAhcwymM3zcLZ/dyfkU
	 I73bHM9aWbj+xehzKlHOMtmODaMhoHoyVbBakA8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1007/1887] btrfs: dont BUG() on unexpected delayed ref type in run_one_delayed_ref()
Date: Wed, 28 Oct 2026 17:51:43 +0100
Message-ID: <20261028170522.329652069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c7d1d4ff56744074e005771aff193b927392d51f ]

There is no need to BUG(), we can just return an error and log an error
message.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3ecb3d0018a18..fb3306ff616b2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1707,6 +1707,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int insert_reserved)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
 	if (TRANS_ABORTED(trans)) {
@@ -1716,19 +1717,22 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		ret = run_delayed_tree_ref(trans, node, extent_op,
 					   insert_reserved);
-	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		 node->type == BTRFS_SHARED_DATA_REF_KEY)
+	} else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
+		   node->type == BTRFS_SHARED_DATA_REF_KEY) {
 		ret = run_delayed_data_ref(trans, node, extent_op,
 					   insert_reserved);
-	else
-		BUG();
+	} else {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info, "unexpected delayed ref node type: %u", node->type);
+	}
+
 	if (ret && insert_reserved)
 		btrfs_pin_extent(trans, node->bytenr, node->num_bytes, 1);
 	if (ret < 0)
-		btrfs_err(trans->fs_info,
+		btrfs_err(fs_info,
 "failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
 			  node->bytenr, node->num_bytes, node->type,
 			  node->action, node->ref_mod, ret);
-- 
2.53.0



