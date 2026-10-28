Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216043;
	b=duJS+1yn7bWdaOjrTqZ+3SqfjvcCdtEG9CwgrTfwXKXGriMfTGE/yNiBzabjCWo1v21w
	 vgxXVd/m5dv4csRdLD7ouMIJ6Qqg3uBBvZmAqpr+bdK0nQibGHFmw3WetXBpe57yWTqkz
	 ivefvcgLjw1naPCS7o4LZ+lWiHAlUVn/3lefwDLBghWj9DTV9Udh1iNN79tfxFvzhEpKY
	 f0GEUEsJDsUkeHEk8AMFG6C6QRaP4Uiiw/cLeutSHYl6ByGiDpgz08Zjv4ckH0ute7yVx
	 RObAw2m8Eehrz3ozc0d4X1Bz8ehFNktaGvhj8DbG93+JNAkf6fGK6js1NKC/gOj6uSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWLJnVjDqnIcFe/Gm8qJJBFiIEB10+KgntutQrhhmeI=;
	b=qI9+s8Ny4hbppKZ2Bxh1StaFkHpUT2I/fpp6x/A+atWnzWXn2uN8BlBE3VpqMN8xoUO6
	 FShk9ndWO4SMgOQmFebYCU+neP3erm5RVNuPoDRR3NAIHll50SDmQz6IwwptNnIkpYB9P
	 o3Jh+rgO5VFv65Tb7TbZGvhWkyC6wYSHiq10N2nniZd1fwz+mel2ekyuq/a++Nzxsp6Hv
	 ZNi/6AEhdUJdmhFCVXICJ7KChc0fEV5ypVjieIBIWocBGeyPnRzHvNHqNpUuXBYVmuVs3
	 SA0WVpNAuRBDkHXOmsnLJy7LV3j9QK9gYJP/3mLnengl1Bd2Y62amgx2TQK37k07MHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1R4yVm3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CA0606A31C;
	Wed, 28 Oct 2026 19:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1R4yVm3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F121F1F01825;
	Wed, 28 Oct 2026 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216043;
	bh=cWLJnVjDqnIcFe/Gm8qJJBFiIEB10+KgntutQrhhmeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1R4yVm3eA6CnrXHp3JUYmR68/EK7u0FwU9zxvyAxIwDUXLDxzl8tc81mq7ElR1lcS
	 qT3vtfPBu0cAEh6izfvk48hBlx3UHcuStdp/KPqPHC3+7+D6V46GLq9vze6Is4mCMP
	 hq8bzWlCop/uaZ2Cn6r3Mgo36TcPXp6xNYylVcfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1422/1887] btrfs: rename ret to ret2 in btrfs_recover_relocation()
Date: Wed, 28 Oct 2026 17:58:38 +0100
Message-ID: <20261028170531.816980611@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit bd0d9a619a870f8c6745d2b4f57508bc5106e282 ]

A preparatory patch to rename 'err' to 'ret', but ret is already used as an
intermediary return value, so first rename 'ret' to 'ret2'.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 6d8ba4572922 ("btrfs: drop recovered reloc root refs on recovery failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 616e103fb5a9f..7def1a16fd488 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4244,7 +4244,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	struct extent_buffer *leaf;
 	struct reloc_control *rc = NULL;
 	struct btrfs_trans_handle *trans;
-	int ret;
+	int ret2;
 	int err = 0;
 
 	path = btrfs_alloc_path();
@@ -4379,9 +4379,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	}
 	err = btrfs_commit_transaction(trans);
 out_clean:
-	ret = clean_dirty_subvols(rc);
-	if (ret < 0 && !err)
-		err = ret;
+	ret2 = clean_dirty_subvols(rc);
+	if (ret2 < 0 && !err)
+		err = ret2;
 out_unset:
 	unset_reloc_control(rc);
 	reloc_chunk_end(fs_info);
-- 
2.53.0



