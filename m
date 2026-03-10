Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A9438759A;
	Tue, 10 Mar 2026 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141974; cv=none; b=VfUEf0kArpx3Hxnos5bUK3u7qysG/BcaMEwda6hV2UvQ9f3FsW2lPKLI0yaMB+UHyzGup5XE0W/iIJv1H8YtoR9CNmBCertk+Mpxhu1hSF4WV131VHQNUTx434K7HcIDgzx6pSamc3C52ytQnTgKnlQbIl05MBCVbSN8ao9acOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141974; c=relaxed/simple;
	bh=Bq6EzdoN5n3aSZziYKoN0OU3Jv76FXK5lyCMZJBnisE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1waL4kaOIdlnLQPnMnDjPa8cmRmyqhIpvo7/35mDyr6uB4vMKBkBKgh7VuEm+8XlmcL6IcQchLYiQSz+L3JDwAg8CgjhaWi6thr0Z8ea9wUNLuZKY0eeZyoRDFQhdMqMDdv25qND84kFqK2zjfb2GprFH9BEzh+3Y8HLXX/2jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gluCE+x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gluCE+x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B4CC19423;
	Tue, 10 Mar 2026 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141974;
	bh=Bq6EzdoN5n3aSZziYKoN0OU3Jv76FXK5lyCMZJBnisE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gluCE+x19pYZHhhmxiL6Lce1O7ZtgkDAdJc9F7JPlGPRj8whubao5dqV2Js1Rz7+D
	 NV6ES7VXY9+jxjbQONeB9cFPhWiBiXBSpO5e58DU58rwdvR+W55oNcF44HlNQrhGRN
	 0ITeCqems9NJJ8FVneM2UIQPUxVk0JuJnWeq2tFQT/NaTsdFFqZZGizKyeMoxwKW5c
	 5NeFtxGsrpvG9K5fPpkD1HUsqRtVH/CWEnhdtniY7+hmKsLlR6fDu4mDleTdjfm7QQ
	 oHbpmM3HMEXuaEUVCQKApehYeTU5b4khsx1eqVyWrfVKa+3m8WNYLONxCpnqK/SwTn
	 WqgqpNwOyu+kQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Erkun <yangerkun@huawei.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/314] ext4: correct the comments place for EXT4_EXT_MAY_ZEROOUT
Date: Tue, 10 Mar 2026 07:15:58 -0400
Message-ID: <33b00b0d99d6971bad42b8576bad8eae6800825b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 88187fddc6424..459453e8bb16b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3756,10 +3756,6 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
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
@@ -3770,6 +3766,10 @@ static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
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

