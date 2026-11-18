Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049502;
	b=qSYiIpszvAMcJlnQGVRyEDoFDi8DqXc0jjhlCuEwZ0M3Qj/MOkGVGnjhTBIjmcW04fHc
	 r4QLYSFFVFO5QVUEh/6s340jt1JKK1VzF1KS3KJibjnRO3LJ8zTZg+EpekT1gc/pPKE1E
	 n28kV9xHbOaPdQ9Tgyvr3C27aTLgbZeQghWYRUTPi0gxJVskVsKmw+W/5rh2jpAsNrRe4
	 UQrhTYIVheye4VVvt3gyuIHRu4cuOcLUyTLNsau5izyoei652VwOuKKjrFK57tFNt5PLO
	 ITtOi2Z9l/Ni+9qUj/pWe9h5KMfHvmKBNnRXTUL+YAnQ9zbB/Diyc1ye23kcmfGPRDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2Lku/N9TNmai/SSmhTXqbIn1GKWK515+FfAnyLJ+/E=;
	b=CCUvBLZqbYYZpG27Am16BT8+2lkSzS79byos/Z/gZsPYgox5WHcAR3pozdmoWrB/Lh8o
	 +YyAdF21BG50IjBAtgxm6qSyd9deujPSf4DwQ5Ss984x8FFk5wBFx8wI9cWSIeplq+D3n
	 bJM+N35Q0SlQQIjB2zPd35mWp3M5//prA80rTvAKLQHIT/aZlqq6TIX5c+6lgkGb4g20G
	 Ykf6IlHzkeMvJVh3ML0fVl56Ep7IGk/wdKpETAy1SHAfd6sPvld6tvpBE5sGVNbykn+kl
	 CN8V6WZ0wftGDKZcq6vur5N0kx+11HmGxLNsQnwF5NaIZe3hi0rbA121i7jAW2WdmLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGcLcqPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9205F606A31C;
	Thu, 19 Nov 2026 00:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGcLcqPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2C21F000C4;
	Thu, 19 Nov 2026 00:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049502;
	bh=F2Lku/N9TNmai/SSmhTXqbIn1GKWK515+FfAnyLJ+/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGcLcqPLDlwXfzsCXVwoYE79eSnQecRYD0c9vwK3KqOeuOZHorh1DcZpe0FEvm9B0
	 IAOk2Cd6SC6d5IAM2Vf4dEIeh4BJgSPKf9h8W6aUzNzqUXUYwwmRS2uaasZa603+8b
	 m6dwIOLoQApdAxGz/Z3fbrPYgLNnO7d7rFtECnl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2375/2857] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 15:56:49 +0100
Message-ID: <20261118150327.033480367@linuxfoundation.org>
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
index ff3cced9eff02..d3cecf863d70f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1698,7 +1698,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



