Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621777;
	b=AlUl7ij2N35Q6/4XYsUgJ49tH5o2/7ngXo9RPCik+zD+FPA6VAfW2hNX1a/hYX/sde2b
	 fHNMI4Nm6z/zEf14mz26ExdXBLVsYBMMghfiNGK+LB+u8MQ4rtjcA/+fcva108Ik6MV+W
	 0e1ptrFXeZr+Wkz/y6xV7S/ffLSvM/yW3lzYcKwf8hQZC4V6Pl0rRNAe5Bic63SISehU2
	 2lFTxpnvBZToNo4ok0Cot4bCt+FNMtFwCnOIqNBSNk29amuEGjNgX6Bxi0+0CnYOEw49H
	 AHMr/L8eW60TGoAepbB3uSq2Oo6ku3Z4ySSIpBXTsMvAUXuefPU09fZGFxmEEG8Uljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U3mpzy3zIiQNObn8+JDGKC+rfoRRtZTzMCY/ynqV06c=;
	b=txZIigCLesWwcHNKjXLuHrl/ER9/MxtIZL1RSNGCKzjCU3Qq4gAOmRJ5U8UojHedQzMr
	 Wp3OkvZfG3jRFvJAAhyHtFIXMXmkRhDWR4lfBwksYF9tt1oKpymwkNMJ1ljOjmwjmzPhB
	 shXmDEuXrd2N5H7xsm3Z0bV9gUKj7d4jICbwgk45wZZluXdMRSOVEwHNf+7La9/D+Zgbd
	 r4Sfl/ZxgXqP54zxYDi9QC7Yq10MZ8E7hoylH41dq8DGvjjpGEhGp6UfIq4nzPPee2NXp
	 xNAztKhwzoJTHHgXD2W/E1SiWYe2vUSbLg+2a4mleIYm3bqVAU26PMRcqfLByhUZZEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0shttGFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC26606A327;
	Wed, 25 Nov 2026 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0shttGFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D081F000ED;
	Wed, 25 Nov 2026 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621776;
	bh=U3mpzy3zIiQNObn8+JDGKC+rfoRRtZTzMCY/ynqV06c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0shttGFluwgm0o21q+sLD88dRwETmhveErx1uaacb2zxvUxPucakXV1Tdk7uVUJQ8
	 wi8Gd75unUT7DFuXGnco9HdgzB4Y8NTel4kXvyJAiHHHicN5MADNOHfXucDarbdTS8
	 nvIPDbhJVQ0F6yqDD2gqIFRcGbLH7Zss0Nw/VvB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/990] fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()
Date: Wed, 25 Nov 2026 15:27:53 +0100
Message-ID: <20261125143829.259790651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

[ Upstream commit 7a5783cfac71b3c12e7fb1c2894dd4538d57d513 ]

In default_llseek(), the range checks for SEEK_DATA and SEEK_HOLE compare
the signed loff_t offset directly against inode->i_size:

	if (offset >= inode->i_size) {
		retval = -ENXIO;
		goto out;
	}

When a negative offset is supplied to SEEK_HOLE (e.g. lseek(fd, -10,
SEEK_HOLE) on a sysctl file in /proc/sys), the signed comparison evaluates
to false and execution proceeds to:

	offset = inode->i_size;

This overwrites the negative offset with a non-negative value before the
final `if (offset >= 0 || unsigned_offsets(file))` check, causing
default_llseek() to update file->f_pos and return inode->i_size instead of
failing with -ENXIO. Similarly, for SEEK_DATA on a file with
FOP_UNSIGNED_OFFSET, a negative offset bypasses the range check and
succeeds via unsigned_offsets(file).

Read the inode size once via i_size_read(inode) after acquiring the inode
lock and compare (unsigned long long)offset >= eof for both SEEK_DATA and
SEEK_HOLE, matching must_set_pos().

Fixes: 982d816581ee ("fs: add SEEK_HOLE and SEEK_DATA flags")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Link: https://patch.msgid.link/20261101060049.81441-2-sidchintamaneni@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 011fe55c94cdb..96528614d4f33 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -331,13 +331,15 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file_inode(file);
 	loff_t retval;
+	loff_t eof;
 
 	retval = inode_lock_killable(inode);
 	if (retval)
 		return retval;
+	eof = i_size_read(inode);
 	switch (whence) {
 		case SEEK_END:
-			offset += i_size_read(inode);
+			offset += eof;
 			break;
 		case SEEK_CUR:
 			if (offset == 0) {
@@ -352,7 +354,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * long as offset isn't at the end of the file then the
 			 * offset is data.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
@@ -363,11 +365,11 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * as long as offset isn't i_size or larger, return
 			 * i_size.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
-			offset = inode->i_size;
+			offset = eof;
 			break;
 	}
 	retval = -EINVAL;
-- 
2.53.0



