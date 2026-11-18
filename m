Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041267;
	b=InAsKvX1vqBIN+ZfNcZgdunfVlqiwd04uTELV4z3qUDk4W5CER3c+2ma2dVidVW5zeiD
	 67ndlhY517ZGYjgcFQHD/1pEx1fCTvtInGfCbvH71Y52I1oydV53eaF7I3LAczy3e8rQJ
	 n2HvpLxMCVKiZLr6n2oUcwZ9urXinYvK4MOc8fizCmnj7aqtSsgnAyRZ+fUt7dPFLB5Aj
	 YjwzZoCSQIds2FCw7Dk+BTeaN5aE1i7p36u5eS+jDz5yowOhhMREKFLljpBYFnrPP+yhg
	 3fOFyzPrEa4dQIZH7PD19fZa5uV4Q+W50qZWDalO5KM0XfdqkuzJEgRdwT0xrGMTIQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ktmxq3PTAr2wlWwXw9xQb5GS16ZRI7IfSsyyawgKlcg=;
	b=OlqQfEFLEPwHgZUMrzIjbbzjM4RZXm1LfnMcK+uXU9bhojOJ9Lj8U+5LJJq9Y15omQeA
	 KNXqh84MOfWncDhSisGI/ilKNLXKUtvBumXdMIx9OccchjF9YwHNig+Vfp4PXxMVYkYcB
	 OXQGYVBW5KdD5oPfN29h9AgctXpmjvnQ7jKB/QLe+Scw0RxrKuTFGlulHtmLaO5gdMjp+
	 O7g12DaCq09A6cvQI3JQbRIGzXZK6eFM5VaqeSAt4GVxSOLBHvFm2eeCqThCT3GnI8iny
	 2hCHZghKA/i2agbxXoZuad4PWAgGq2dn6vgKRzhcS2fAnOeQjckMxWS253atAhKAgZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLXyurQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1C3606A320;
	Wed, 18 Nov 2026 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLXyurQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493081F000C4;
	Wed, 18 Nov 2026 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041266;
	bh=Ktmxq3PTAr2wlWwXw9xQb5GS16ZRI7IfSsyyawgKlcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLXyurQTrqKqwbWESgxsnhJydYospzUKu/KibXkYeH4ZBUgiLTs4/yaWRBQa8p9hq
	 4OWb1Tb9O1LiMz1OPjL9vPIYEElLnsV+ry+M7zZiEokHeLsqrSbL1ECpGBiPLKigNf
	 lJ3lUNNqAfqIfoOE8mDYahg9KGtuqIg3MUXAfEPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2751/3318] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 15:56:13 +0100
Message-ID: <20261118150443.288268113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit dd906477cc2c33c82ec17e6301bd4be4ea588565 ]

[BUG]
There is a bug report that when removing a child qgroup, if removing the
qgroup requires a rescan, it will delete the on-disk relation and qgroup
items but not the in-memory qgroup rb entry.

This makes all later qgroup rescan to fail.

[CAUSE]
The call chain looks like the following:

 btrfs_remove_qgroup()
 |- __del_qgroup_relation()
 |  |- quick_update_accounting()
 |     Which returns 1, showing this operation will require
 |     a qgroup rescan
 |- if (ret) goto out;
    Which skips the del_qgroup_rb() call, leaving the in-memory qgroup
    rb entry still intact.

Then later qgroup rescan/update will always fail and mark qgroup
inconsistent:

 btrfs_run_qgroups()
 |- update_qgroup_info_item()
 |  |- btrfs_search_slot()
 |     Which returns -ENOENT, as the qgroup info item is already
 |     deleted.
 |- qgroup_mark_inconsistent()
 |- return -ENOENT;

[FIX]
Do not treat "ret > 0" as an error.

Reported-by: c.f.a@posteo.de
Link: https://lore.kernel.org/linux-btrfs/14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de/
Fixes: 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e4c4d369eb8d9..6aff9f85cba14 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1722,7 +1722,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



