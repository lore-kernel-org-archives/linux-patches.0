Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A7223316;
	Mon, 23 Jun 2025 22:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716767; cv=none; b=GKyVPuVN72Bl5gkGjd7gBoOj4NVfjvSYNrm5K/UgIS3VsQHq4sbnfCzwI+X2vYr7Qo8aoQkSJ/61LmsC27W7s7fW9BzHpUAkNj7SrKnHMYyaxE96ZAmsd/Gk2wbNdJ7tVYtEoscpsKBH6f6rwE+dEZ+1TOjar2RRODlf5n0FZtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716767; c=relaxed/simple;
	bh=rGWfF1O+Nz1PoiNKW803GmMJ4NTMWIRAkoeh3ssmYxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq9D8+XtJYMIuZ3J0siI5AdTgr1kX5jlpY1BQJjbP44evthOXcZuqRx7w/7GL8tSSLdTICOeuWYkDpkdCjgSNxkt2p1L2F6kL2jK3wCOIru0eVyQ+Mjf8NDXLLcBB24bbUTRd7IJCjcg0q53rXvjZje+Va+y+wUDqcEi4/Y73NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4tbWMgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4tbWMgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894E0C4CEED;
	Mon, 23 Jun 2025 22:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716766;
	bh=rGWfF1O+Nz1PoiNKW803GmMJ4NTMWIRAkoeh3ssmYxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4tbWMgi0nyG+IZajK6rZ5i/xu4IrdOCneH0eMF34nur0qdAsr+Xg55c+MCC9GtNC
	 6B85xEyAA5ut5/jnP1ChuE81ufsBD9v2VbAveLDQHRkuamsO+EOhhu6Ybo7T2B0IZy
	 cmw3QdY79OkQAGjw4HMGgByUKOd6JqSiBQKTx1Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sebastian Priebe <sebastian.priebe@konplan.com>
Subject: [PATCH 5.15 356/411] block: default BLOCK_LEGACY_AUTOLOAD to y
Date: Mon, 23 Jun 2025 15:08:20 +0200
Message-ID: <20250623130642.606622106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 451f0b6f4c44d7b649ae609157b114b71f6d7875 upstream.

As Luis reported, losetup currently doesn't properly create the loop
device without this if the device node already exists because old
scripts created it manually.  So default to y for now and remove the
aggressive removal schedule.

Reported-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220225181440.1351591-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Sebastian Priebe <sebastian.priebe@konplan.com>
Link: https://lore.kernel.org/r/ZR0P278MB097497EF6CFD85E72819447E9F70A@ZR0P278MB0974.CHEP278.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/Kconfig |    8 +++-----
 block/bdev.c  |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/block/Kconfig
+++ b/block/Kconfig
@@ -28,15 +28,13 @@ if BLOCK
 
 config BLOCK_LEGACY_AUTOLOAD
 	bool "Legacy autoloading support"
+	default y
 	help
 	  Enable loading modules and creating block device instances based on
 	  accesses through their device special file.  This is a historic Linux
 	  feature and makes no sense in a udev world where device files are
-	  created on demand.
-
-	  Say N here unless booting or other functionality broke without it, in
-	  which case you should also send a report to your distribution and
-	  linux-block@vger.kernel.org.
+	  created on demand, but scripts that manually create device nodes and
+	  then call losetup might rely on this behavior.
 
 config BLK_RQ_ALLOC_TIME
 	bool
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -741,7 +741,7 @@ struct block_device *blkdev_get_no_open(
 		inode = ilookup(blockdev_superblock, dev);
 		if (inode)
 			pr_warn_ratelimited(
-"block device autoloading is deprecated. It will be removed in Linux 5.19\n");
+"block device autoloading is deprecated and will be removed.\n");
 	}
 	if (!inode)
 		return NULL;


