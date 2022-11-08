Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEEA15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB01C433D6;
	Tue,  8 Nov 2022 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916778;
	bh=UUp/1dCVOgRocXdqFeBIj8Rec8yroF2G1c9WjgzZUfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMRgpmaAvuTXSIHpny/4ZbXQeC0oTBaxN4HzZeoqbCGIcxgC9igNuiPEi6CyyQ0df
	 TZ6k8yYBH+oRUENDUO/4aFMc7UHZpIPImh5002JiJsISFNwZ6q03ddeflU+9tsiGMC
	 3DVY6QAlL1zn+P/obMtSZcHV3jVnoywEBr30H7Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 131/197] btrfs: fix a memory allocation failure test in btrfs_submit_direct
Date: Tue,  8 Nov 2022 14:39:29 +0100
Message-Id: <20221108133400.924752280@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 063b1f21cc9be07291a1f5e227436f353c6d1695 upstream.

After allocation 'dip' is tested instead of 'dip->csums'.  Fix it.

Fixes: 642c5d34da53 ("btrfs: allocate the btrfs_dio_private as part of the iomap dio bio")
CC: stable@vger.kernel.org # 5.19+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8142,7 +8142,7 @@ static void btrfs_submit_direct(const st
 		 */
 		status = BLK_STS_RESOURCE;
 		dip->csums = kcalloc(nr_sectors, fs_info->csum_size, GFP_NOFS);
-		if (!dip)
+		if (!dip->csums)
 			goto out_err;
 
 		status = btrfs_lookup_bio_sums(inode, dio_bio, dip->csums);


