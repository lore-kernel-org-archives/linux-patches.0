Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046356;
	b=27ENIF2FubiArVa3/taNrtqpYwqBL6ty7Lu//9LjEhIRinQQGmX4WycQPK5ck0Gub70N
	 x5P1LUU4SjT5MyDJ/xucvokMnftaXSIp2YVfv1nVVV+kKziBMdMlyOgS+eknS8wicSOLK
	 Oy1mjIPcPHPc71qV7vRdHxN72RY3XCNssXntzx5Kd4NLDsk7OmKFCyqey/b7ExoEpXu9O
	 DcVSoyujDjmgbRQmN1YabrxeIUodcXfGN5tUnjRLOLTF9z93KrObj3Z4FzKGLcwh8UOCy
	 rSLtVSfqE4QwWxoqRbqVgElWAXFGAUsGnid33KH6LfexVg4Dg7cEO8nYeS4Mcv9IDBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x7gpajDSFQlJWoCiSe0skVAz60Xq0dru9JDaJP4guWo=;
	b=lL36SFVPlVPiOC37MPX3p179Fyk+qmCs8cnow/23Iq7UiAuQbwWkDpSKHZ8kM9hAuGW9
	 RemIvg17Cql4zWfR7or7iFRWXVYg6kT4VhTCVewJHu0CdfcQd0Rn0nZhdWZdLyX99v+ha
	 1T4Slu9uuoTxMNfH4a1iO0rFmYEkBxjt7QKU6MgReyBKUmi03Xqdcc45n/V1E5whhiy0d
	 r6LtT3x3mnvJukQffY7zoCrfk8gj4ImoJq5jzSXX7rjKnp0K3X/7DOda4tjzYsey32P2q
	 T4G2zOf5FMyWq5/U1BhlcA3I6lJWYnCghdlqyDiPmXqVVCx46GJ7GjQE9lHX6P/gysQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4UOFLP3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB409606A31C;
	Wed, 18 Nov 2026 23:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4UOFLP3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A68D1F000C5;
	Wed, 18 Nov 2026 23:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046356;
	bh=x7gpajDSFQlJWoCiSe0skVAz60Xq0dru9JDaJP4guWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4UOFLP3CeY5wMENo7lCQI6YddjUARf4t3IxZ0k/RfypgrHfCnbdQMnc65i9UQsoY
	 M9tiJ+nyyuYjTk57He56iAk82wVscyGNNy9blhnIIEb578QNitKCYvZz8AwaDiIFj1
	 u+BOymtjPYacWAWbhTpE0VUUFdMKISC8r3nEkxz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1211/2857] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Wed, 18 Nov 2026 15:37:25 +0100
Message-ID: <20261118150245.194507359@linuxfoundation.org>
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

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 4172be965c2ce887ebfb1117c634a68555be8c11 ]

btrfs_sysfs_add_block_group_type() sets up a NOFS context with
memalloc_nofs_save() because kobject_add() performs GFP_KERNEL
allocations deep in its call chain, and the function may be called
while holding a transaction handle or a lock required for a
transaction commit, where reclaim could deadlock.

Every other return path of this function calls memalloc_nofs_restore()
except the early return taken when another thread has already created
the kobject for the same raid index (this can happen when restriping).
Taking that path leaves PF_MEMALLOC_NOFS set on the calling task, so
all subsequent memory allocations performed by that task remain
restricted to the NOFS scope, which may lead to unexpected allocation
failures or deadlocks later on.

Restore the NOFS context before returning from that path.

Fixes: 49ea112da0e6 ("btrfs: do not create raid sysfs entries under any locks")
CC: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 2d911adc06f62..9c23ba7b4540b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1543,6 +1543,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



