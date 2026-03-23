Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F53B39A805;
	Mon, 23 Mar 2026 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277772; cv=none; b=JQ5dfrk8Zrz4TqZTLpME6KRF13taM22y+pFBMcmXuEBK0m8/u/ZgjBwPIiRBcZIqWWcC+9v0RgDkAbGOp4iA/DML+TccVh99H0JoxtE4RzOEu95Jdw7TiAtPolQ8jLTD63lDvbRhJqIK6TAYg63KgUUzt4kJlHDq1wxB9o4JjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277772; c=relaxed/simple;
	bh=rE5S71Y+5szBkq74TlQPKE+oAWiEhX9Rxd836k3KEi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGWW/jl4oRrBp8IZZCSef9HsQv/bqFE3SbUfDoyHrKzavNfPBLH+Qu7S8jF20IOORM/aTNbYCCt267ROBX+Qj+U4PyPBOz/AKMvsNmMapEnPUvAd7+nwuHS9tcFBLQqf1G12j40LsJ5NZ0ma3URrykHUycarQJSiWQy+vlUHkEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rL7wlmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rL7wlmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8840C4CEF7;
	Mon, 23 Mar 2026 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277772;
	bh=rE5S71Y+5szBkq74TlQPKE+oAWiEhX9Rxd836k3KEi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rL7wlmxXamjcNBvsNwNmmu2h3KxdcEd4GzYIpNsGSukUGo91QcnOR3fkPVdVxJ7H
	 Hs8TfXLtUbCOX9JIQoNFwCyc262hvwSV6+G1nEbiblM9WcDiB6deRynPSPqVnT8pww
	 BQcZaRMOTfYPNG1UvDQDzSlGHKmSFM92zH7OVdzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/567] ext4: correct the comments place for EXT4_EXT_MAY_ZEROOUT
Date: Mon, 23 Mar 2026 14:39:35 +0100
Message-ID: <20260323134535.175743123@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit cc742fd1d184bb2a11bacf50587d2c85290622e4 ]

Move the comments just before we set EXT4_EXT_MAY_ZEROOUT in
ext4_split_convert_extents.

Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Message-ID: <20251112084538.1658232-4-yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: feaf2a80e78f ("ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 86c814bede1c5..4507e42869854 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3727,10 +3727,6 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
 		eof_block = map->m_lblk + map->m_len;
-	/*
-	 * It is safe to convert extent to initialized via explicit
-	 * zeroout only if extent is fully inside i_size or new_size.
-	 */
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
@@ -3741,6 +3737,10 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 		split_flag |= EXT4_EXT_DATA_ENTIRE_VALID1;
 	/* Convert to initialized */
 	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
+		/*
+		 * It is safe to convert extent to initialized via explicit
+		 * zeroout only if extent is fully inside i_size or new_size.
+		 */
 		split_flag |= ee_block + ee_len <= eof_block ?
 			      EXT4_EXT_MAY_ZEROOUT : 0;
 		split_flag |= (EXT4_EXT_MARK_UNWRIT2 | EXT4_EXT_DATA_VALID2);
-- 
2.51.0



