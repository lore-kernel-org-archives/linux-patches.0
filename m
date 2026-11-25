Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620997;
	b=j7avEEMXbmTuqk7jTn2jOcOGRLjOTtiJYe9pyLNFMy0NerbVZP0waC84sesEcG7XR/6j
	 Dgblc1zcdcd//JMwSY8Ec17pwHsoGOlM/eTTaCE2DrGF6dsfHgauALTwHE4KN4qZFeaUG
	 /KRML1Lq2aBzewBhe8hNTBGOxe7959bMJcpY09TtJN2DOl/QSs6yhjKECiSLrGyE1RMUL
	 BRUBhuEDKhVxc18KQuDQhDRX5GzCkGon/TSRXHwzvdhSFTrlknR6oicjUvQ1CdD/zVbUd
	 1v5pg/w7czHys4t7LC/5qxudaK0SMD5siw4GvcKkO8JddFoL2unXbLQsEGR3sO6TF/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cUoqcvHEgczn0p1pL9L58AK89dGT8YhUn35jNUV1EM4=;
	b=3AMcW6tEXEHrx3E90ZTGepYADmZgERhDaDbqrKeZ3tCMobfmPeoz/KDuTR+2+sT5ruH0
	 fP/F4hlr3JjM0u6KgOyqQu7lQD3PF50eKF0MO1RD87TtSrgrrg0xDMi9oDHQNLX32Ftq+
	 xBKgn3623AlLFR8vJtfqVATyzN7sKM+uQiUqrnlbWRGObWQOIIkhftSURgCWd0M4LVbce
	 vNTNIJftqIgYPTk9CpGmAr0t4sY4HNb7qXFX9znjEFm3++kQwZ3bR1Qkw/dbmYzZT9zSW
	 Y5sqh50MV0M5f/pHovvqiAwHD+wq+uiXApDEPeuuzAkN6t3PgVv/D3QbLZGFX0aIB1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hr0btFAN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C27606A33A;
	Wed, 25 Nov 2026 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hr0btFAN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A619D1F000D8;
	Wed, 25 Nov 2026 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620996;
	bh=cUoqcvHEgczn0p1pL9L58AK89dGT8YhUn35jNUV1EM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hr0btFAN7o41p0jg1h1KX298zF9V++TyxlV4zLqC+gBapuLPIrtEXYjOc4nqt5IDl
	 mbbw0Jo8mrzl5nf04hZm1eRddelZVjMSX7gr6fDM7i99Ht4fxrZG8sNdq40Vo5Lenf
	 gyLOuBpLLgXe2UtDSqRbDBjpGicMtsb3odd3VL90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/990] btrfs: verity: propagate orphan insertion errors when enabling verity
Date: Wed, 25 Nov 2026 15:24:15 +0100
Message-ID: <20261125143824.153255348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bb2d2fc47ee91..0a8df39e82e49 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -609,7 +609,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.53.0



