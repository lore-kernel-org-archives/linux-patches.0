Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23B14E2F4;
	Tue,  9 Jul 2024 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524119; cv=none; b=fMDUK82TVlvyYSxCa9W5aBzo67YVUHuPoJW2y2T39Exg0Njsw1I/GywjybfvAmaUOLYsyWb6E8FPNhNKRuzSVPF9ZyNlPOs9DG4A18M7zCNjm4BWa01QMYLRGcQrPuR/XQVcAqJ53cCRP9bn4b+osZH0xv4LeSjnbK/m83jbPFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524119; c=relaxed/simple;
	bh=buCRAF6m2N1QPFpp2Ru7DyjJZ5QcvGHZI/p9kM3tE94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQbZvEe8zO/gNcacYJ4Mjuzik0uRVhICQuJnDuiUVFxCVX9EL4bBIu4wBT7mgwVKc/sp1s/X7cw2nrwNFRoYBt36VQRTXAbwyz5ScPy1Pb7DudcRKpZtWW+L1pqv0YrSLXHwv2a/hJIt1VL7PUa4cwPGt3DrXH3oDoPlOt3bjKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+RmgqTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+RmgqTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA247C3277B;
	Tue,  9 Jul 2024 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524119;
	bh=buCRAF6m2N1QPFpp2Ru7DyjJZ5QcvGHZI/p9kM3tE94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+RmgqTEiUkgOhpaiAgunnYvpS3H/Y2PJUY6IQaSPxeVlLeckT+Yt/C5/QDK9iLXD
	 9O68CpfZYTplzFHVWFLSaIvHqcuzrbsJJnFu2rZYqGX5tD4OcNETwqHDZjwzVaA24Y
	 GbWrltvBR4U3XQI3nEp2kZ9a+NuDRFowIqNblpzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Lu Yao <yaolu@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 077/197] btrfs: scrub: initialize ret in scrub_simple_mirror() to fix compilation warning
Date: Tue,  9 Jul 2024 13:08:51 +0200
Message-ID: <20240709110711.948826427@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit b4e585fffc1cf877112ed231a91f089e85688c2a ]

The following error message is displayed:
  ../fs/btrfs/scrub.c:2152:9: error: ‘ret’ may be used uninitialized
  in this function [-Werror=maybe-uninitialized]"

Compiler version: gcc version: (Debian 10.2.1-6) 10.2.1 20210110

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4b22cfe9a98cb..afd6932f5e895 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2100,7 +2100,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	const u64 logical_end = logical_start + logical_length;
 	u64 cur_logical = logical_start;
-	int ret;
+	int ret = 0;
 
 	/* The range must be inside the bg */
 	ASSERT(logical_start >= bg->start && logical_end <= bg->start + bg->length);
-- 
2.43.0



