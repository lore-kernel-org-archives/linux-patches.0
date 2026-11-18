Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059006;
	b=vQgavooBS80SxpANx3krwdxX4Sv4fs2jouK1BK30LcETDsegmQ3l0r11trLj77eyz2cc
	 5NseLgTUpk9nECU0TUdofbssfva2F/56WZAJYU9wsoo3qlxAfn9yvzzWkBKekHlNw+7kb
	 fd2AQdN5Hyifmnst41V3troKquDghGHOPbMpt7qLzhGD94PB1bxDLQAsLPfJkR26hMi82
	 HFhocGayYZYgsPjBpRcvqDovCu9OGKjDWW1pnlTJUojGSANro4Spp2RhaAgFvy8wnJVL5
	 XLFF2jmYek1wotqQ7qkrVWuKaOXQVLBOsbZOupliFXSIJ1waXTKyVEfGN9jHjhY1j4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mqp7cJDeuIfvf6Nc0fVXDZaStDDFZ8xKoFpp47s7rAU=;
	b=sT+GaVcTBxFK5YPgc4yneEbY/Ufon25xiRTcc/8vmqivDc9lPmWWFFIUdli7zVQ8fwya
	 yEv5OWminVdW8FRBAhXRe5Yg9678a2/hO7ame+UY9o3TjI0pql9YYHCDr1Lo3jvzr2VRG
	 f5p+hormiZymDNnpNglL5eBVXxgLMGEDulTqRpygpcwEU+hOcXygJsKgTgGO1/dHebwk3
	 IGVBj8GyxA7xFUQNJ3rd6wHxCHatNz0S1CORA1X8L4MUXblgEAKpV6fnODYOIxBhJP+dZ
	 N8rpUzakZHOdJktkcvC9jVvJhTV/wbyIVFQmhMqYoXVS1rzmJZY74YlvuQ4GJc5myjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwgQbaGW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3590606A32C;
	Thu, 19 Nov 2026 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwgQbaGW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577E1F000C5;
	Thu, 19 Nov 2026 03:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059005;
	bh=Mqp7cJDeuIfvf6Nc0fVXDZaStDDFZ8xKoFpp47s7rAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwgQbaGWWeHo5Pes4RJbxO5Eb9GWXOCPtE7Uz/QMDLSvCFrtiqxR4MneB1Wk9R2O2
	 MS4yNcVVkhjSmSTADsro0ISo9sVyNH4UvfOqupRruTQS+7sXPqcj6gUjNPwDuCPKmW
	 MvCO8ffBnpwy5GQiVmx+pHFDGcHgqLkpbXIDEzLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0688/1848] btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
Date: Wed, 18 Nov 2026 15:45:26 +0100
Message-ID: <20261118145944.745900727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ecf190286377c..6fd7b531705e3 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1151,6 +1151,7 @@ void btrfs_sysfs_add_block_group_type(struct btrfs_block_group *cache)
 	if (space_info->block_group_kobjs[index]) {
 		spin_unlock(&space_info->lock);
 		kobject_put(&rkobj->kobj);
+		memalloc_nofs_restore(nofs_flag);
 		return;
 	} else {
 		space_info->block_group_kobjs[index] = &rkobj->kobj;
-- 
2.53.0



