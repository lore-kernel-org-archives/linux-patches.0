Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE372C21C5
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775697577; cv=none; b=p732HpHm1M7EhKLG3FrnWBIsNvE2Z8F5Zoy21tZuo9BqVOTc1/FB5CCZCYXf8iVQYotvqZ3bymBFR4F3LXU81S0KaqTXTNYteRI1WL5L11eCdaMfVZlwHe9rq9astqmkCu75fvCwDwb7UKFP554vOPBHA1Y8gQPpRDDc/Vh0z7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775697577; c=relaxed/simple;
	bh=mGdFxlvEzJsj45G/IgSVK6R09uroiot+9ESo3B/avi4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yx35GL6DzcDC7sEUiqmNmZCL0xaSlBxgwfS3kDxv9gJ+XT1mvq6szNzooWEiATVtBdxtgcGQrB87CC9bXO/VgdAqf2qT6TDtq3GECyfXaoLSXXe+EpFe/CuNPR6yBzltF8/5wnVPrT+yFi+VFE/bkKkomXgny3z/hWnK3h2uing=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=JS30QA8o; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="JS30QA8o"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=boSTzcaUI66+h4Jv1Mhgim5Jw4x4c+i0N8ghK2ZkHlo=;
	b=JS30QA8ob7tzjOhVQvNU55hXSM0x786lEY/p1B8uSNixmL2cT+OpuGGB04HJYwrIZfgHTlprC
	L9u7yCEo6WEV2GO5IBEWl83mYIJLdvywGb1R8+Eu3KAomB9VuC5//cZVuAReUY3+ApIEy0l6HVk
	2aIwGAmSQXeCBsu7CE5RNjU=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4frhlG4gzYzpStP;
	Thu,  9 Apr 2026 09:13:30 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C91320226;
	Thu,  9 Apr 2026 09:19:32 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 09:19:31 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 9 Apr
 2026 09:19:31 +0800
Date: Thu, 9 Apr 2026 09:14:07 +0800
From: Long Li <leo.lilong@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, "Darrick J. Wong" <djwong@kernel.org>, "Carlos
 Maiolino" <cem@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.19 008/311] xfs: close crash window in attr dabtree
 inactivation
Message-ID: <adb9X3tSH8vdqKw-@localhost.localdomain>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175939.720196538@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260408175939.720196538@linuxfoundation.org>
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Wed, Apr 08, 2026 at 08:00:08PM +0200, Greg Kroah-Hartman wrote:
> 6.19-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Long Li <leo.lilong@huawei.com>
> 
> [ Upstream commit b854e1c4eff3473b6d3a9ae74129ac5c48bc0b61 ]
> 
> When inactivating an inode with node-format extended attributes,
> xfs_attr3_node_inactive() invalidates all child leaf/node blocks via
> xfs_trans_binval(), but intentionally does not remove the corresponding
> entries from their parent node blocks.  The implicit assumption is that
> xfs_attr_inactive() will truncate the entire attr fork to zero extents
> afterwards, so log recovery will never reach the root node and follow
> those stale pointers.
> 
> However, if a log shutdown occurs after the leaf/node block cancellations
> commit but before the attr bmap truncation commits, this assumption
> breaks.  Recovery replays the attr bmap intact (the inode still has
> attr fork extents), but suppresses replay of all cancelled leaf/node
> blocks, maybe leaving them as stale data on disk.  On the next mount,
> xlog_recover_process_iunlinks() retries inactivation and attempts to
> read the root node via the attr bmap. If the root node was not replayed,
> reading the unreplayed root block triggers a metadata verification
> failure immediately; if it was replayed, following its child pointers
> to unreplayed child blocks triggers the same failure:
> 
>  XFS (pmem0): Metadata corruption detected at
>  xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
>  XFS (pmem0): Unmount and run xfs_repair
>  XFS (pmem0): First 128 bytes of corrupted metadata buffer:
>  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117
> 
> Fix this in two places:
> 
> In xfs_attr3_node_inactive(), after calling xfs_trans_binval() on a
> child block, immediately remove the entry that references it from the
> parent node in the same transaction.  This eliminates the window where
> the parent holds a pointer to a cancelled block.  Once all children are
> removed, the now-empty root node is converted to a leaf block within the
> same transaction. This node-to-leaf conversion is necessary for crash
> safety. If the system shutdown after the empty node is written to the
> log but before the second-phase bmap truncation commits, log recovery
> will attempt to verify the root block on disk. xfs_da3_node_verify()
> does not permit a node block with count == 0; such a block will fail
> verification and trigger a metadata corruption shutdown. on the other
> hand, leaf blocks are allowed to have this transient state.
> 
> In xfs_attr_inactive(), split the attr fork truncation into two explicit
> phases.  First, truncate all extents beyond the root block (the child
> extents whose parent references have already been removed above).
> Second, invalidate the root block and truncate the attr bmap to zero in
> a single transaction.  The two operations in the second phase must be
> atomic: as long as the attr bmap has any non-zero length, recovery can
> follow it to the root block, so the root block invalidation must commit
> together with the bmap-to-zero truncation.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
Hi, Greg

The current patch depends on upstream e942498385bf ("xfs: only assert new
size for datafork during truncate extents"), otherwise, an assertion failure
will be triggered during attr fork truncation.

The following four patches are in the same patch set:

  b854e1c4eff3 xfs: close crash window in attr dabtree inactivation
  e65bb55d7f8c xfs: factor out xfs_attr3_leaf_init
  ce4e789cf356 xfs: factor out xfs_attr3_node_entry_remove
  e942498385bf xfs: only assert new size for datafork during truncate extents
  

Thanks,
Long Li
