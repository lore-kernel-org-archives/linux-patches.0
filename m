Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6EF189502;
	Tue, 30 Jul 2024 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358328; cv=none; b=NDOGF5gwKf4qByD4or4h5uKWX5c8MxpaHa7q3Kiev7g/RCt9HHgcvyRUqT9nKTTUkfa9F5skSSc4aZekz4cfZ0DLyMGmLymTIl8p6WMuAw409qP3quz9tJ3aFS9p3xqGOzMJjiAfmmMx6RrolMBlU5Ht8lRMpEmIo9uU3Rp8bqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358328; c=relaxed/simple;
	bh=wuhInRNvmZhob7vemhY8TyUCL0Hr7yN/EwCBGi17SGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzMhVnIrxAm9KfOfW/fo3NXIhmhfwyxGt0kK/YG/exUg4hvz0SmOKk5chCyzw8A9lGTYSwkkRjPnZqC56p8DePbUkqVUjsdBLajD47WhSMxz1T3xIhFkHtE6LdbVCMkULRbs+oUkxdUr2bf1Yp6NgAomdiA5/DyxE6O2TY3LBBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwXcMeGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwXcMeGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7D8C32782;
	Tue, 30 Jul 2024 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358328;
	bh=wuhInRNvmZhob7vemhY8TyUCL0Hr7yN/EwCBGi17SGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwXcMeGA9q9NSUbTRU/3VoH3WH6jYQZIeBYz7cDZrY9yw7INIDvBOkWXF2lBuw/Y/
	 HdNNNCkCqD2Z/CLfAc/oGu+UOefviSEo4TNpKXIZvajNaS5ve1+EJ+15ZzWlJuimdy
	 V/EZr7sT9gL0mUCfPlTB2ZTbHfp0tUi7fN2Xnw+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/568] fs/ntfs3: Drop stray \ (backslash) in formatting string
Date: Tue, 30 Jul 2024 17:47:20 +0200
Message-ID: <20240730151652.886463910@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b366809dd151e8abb29decda02fd6a78b498831f ]

CHECK   /home/andy/prj/linux-topic-uart/fs/ntfs3/super.c
fs/ntfs3/super.c:471:23: warning: unknown escape sequence: '\%'

Drop stray '\' (backslash) in formatting string.

Fixes: d27e202b9ac4 ("fs/ntfs3: Add more info into /proc/fs/ntfs3/<dev>/volinfo")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 10659817f98c7..79ebe62f00017 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -463,7 +463,7 @@ static int ntfs3_volinfo(struct seq_file *m, void *o)
 	struct super_block *sb = m->private;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 
-	seq_printf(m, "ntfs%d.%d\n%u\n%zu\n\%zu\n%zu\n%s\n%s\n",
+	seq_printf(m, "ntfs%d.%d\n%u\n%zu\n%zu\n%zu\n%s\n%s\n",
 		   sbi->volume.major_ver, sbi->volume.minor_ver,
 		   sbi->cluster_size, sbi->used.bitmap.nbits,
 		   sbi->mft.bitmap.nbits,
-- 
2.43.0



