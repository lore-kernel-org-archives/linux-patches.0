Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705053;
	b=VFsK70Fw/Z2jkh9OLcZWa1U/dR/QVw7rKcPQGcw4BZj0IiptHZE6Pc2wp8x8/66xbQQE
	 2e19R8TXbwzd22ZU+DvKX36xh6JTpjaW6uYaL0xDTzxHRjPhFeYE3wDJy/woCWCaXz91c
	 bzFFP1e1lBE6dIEsu/10/eXlp0bQZeaD0/DCWk4BwyqcSuvnJie6b9OQtFss20yMocNq0
	 LiC+IUUH+T+aloB5bylBB2z8yztQuUFvf5P1RQBIDNIUMBurMvycZODjZdTzmMbJTdGcl
	 /CZJ/TITUaR4gLyGuBsvfUc6tDBWrWePX9EidMnxXMyllLp6jmjn4Cxpz5Cbk26oOYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jMAiG6NtotNR+yXfhK5XOqbhRIn8ppi5G9Ks0KVEBs=;
	b=ivlk+aYBIPlK2gSYZt/xS0k0XBPDMcFv3usIQTQbOoQGzwP3MesFs3Jd9ZIiAn40D3QM
	 zGC+Rf1cF8YjF1U6Gz4t4jQa5ygfvv7EHQe6CHd/s0ZsqAKPx4u8k2QlHnTOP/SU62B1j
	 yfWcuyTLQaCwZ8GmyToSuUK1xTGkGF0h4QJstdb93xwQJY0j3TykAj6Zf5wI8FPBN2h3T
	 kyblQf+sEK7Mn5EtwiGVRuo7ZYkLVYnDBiFkqVhrAS4cdj6c/7s0mi3qgX++YaqW0A36T
	 zn+4WnS3W0zbBGPbE5JsH2ZWKU5RBH1WDkT/9yhau1U9AuKT+WIQZ45NJZYkjbb9TlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2L6HoLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45531606A323;
	Thu, 26 Nov 2026 14:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2L6HoLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648961F00ACF;
	Thu, 26 Nov 2026 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705052;
	bh=1jMAiG6NtotNR+yXfhK5XOqbhRIn8ppi5G9Ks0KVEBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2L6HoLguggfmwXGqX6aAMWbylKln3dyGw7cncINSo+HjXO1kQatNpEFnlRqv1FT6
	 SjIfSsLDLZIlftcVfZ4RLwZYeuiX7FEozmVV3V0TdGbrVh9mGrYosna2j/EpE/E6Zl
	 zVHJXlfYJj/D0eGD7zdPea9aMNx9QI/v7ZBhPYf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/319] btrfs: verity: propagate orphan insertion errors when enabling verity
Date: Thu, 26 Nov 2026 15:36:38 +0100
Message-ID: <20261126144007.421405719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 45a686dff6b91c3667cd8188d3a02c69f62f4d00 ]

btrfs_begin_enable_verity() ignores the return value of
btrfs_orphan_add() and unconditionally returns 0. If orphan insertion
fails, btrfs_orphan_add() aborts the transaction, but the generic
fs-verity code still proceeds with Merkle tree construction because
the begin_enable_verity callback reported success.

Return the error so that fs-verity stops immediately instead of
continuing after the initialization failure.

The transaction is already aborted by btrfs_orphan_add() and the
handle is released by btrfs_end_transaction(), so no additional
cleanup is needed.

Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 4968535dfff0a..e5d7763fe6e0f 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -605,7 +605,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.53.0



