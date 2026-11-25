Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618615;
	b=4VkVBzZMnNxlJg1t3Nf2efrfpdeDTBWoc3ZC+07/5crhfxFrCBBrhjEkYO4WOE0q4WUc
	 fdINJZUxahmTPTStrlxVjy0bFLVHia49/++yCCY1Y5II0azSSpAbvP+LjA7aMlWnSMV5+
	 ZqdUrr9g+jYK4R19b8yzKj9P+BnKnBUrkmqMIj2R2672+GRb02hWZwJVHqUQ5MJTU96AE
	 K768mgTc2SpWTTkhcxhhyJf4sSEGB4APf6hYzK99g+WpXHa1O2zbXOW6FT4WpuBjCbXAi
	 TjrWFh0tlZbFdQXNikCsEWRclCU8VGyiB4ztwMqRkUrTgxAD4AFUfkqrVRCjbwEHr1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAp+N3rs1gP3iYC6Fm1WkwvXxs/7B1oJ68ND+Of0Gl4=;
	b=SeTYfxtNVRQlDkHdqn7jn6n+eXz/+IYY5pEy5UCq7N06ikZtVmoKkgXsZg2/VzEqC2rI
	 po6Nf3UnKKpHDQILQhN8Lm5Xidvrh4VUjyi2jcGcHWGIq/vPh3MSphXKvq7A/KPiZbA5F
	 5O4r20iXFs2GnbnXUD6/AMTyJ+qk18eYml6WooBEEFts2SkgxjyKK1rrqE60NOWEyjcfq
	 65hGNfVUOrUox2rNOwIpIf9Fs/wRG8dGPvvKtIHKhiGO2eBFjSMQpNAO3fLGmHpgyAsle
	 MNltgaAMJzSDpPfnP1r2OLQ5DS8C0Rktb+Dgb9Kj5FHQmmyqR21fPZ+ZCDSWfAmiRSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dl2+mbgc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32AB606A321;
	Wed, 25 Nov 2026 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dl2+mbgc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E991F000D1;
	Wed, 25 Nov 2026 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618615;
	bh=sAp+N3rs1gP3iYC6Fm1WkwvXxs/7B1oJ68ND+Of0Gl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl2+mbgccyWz6f9cZoy6N5z33wuSoYFnhrpkir+Xm0PRzNexa20Gq5jeLUFCBosop
	 M84kd1+xRspBJ9xAX/vo/EKRXhM5Oj4GaacKP0ijiFxmlqcOzqsas4fl4BPrFJ9g+o
	 Vj1Ci1d8oQB4m7SXL/orPpjG25ZnZMnWaGbBwum0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0335/1005] fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()
Date: Wed, 25 Nov 2026 15:27:53 +0100
Message-ID: <20261125143829.580490913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ccaaa454dce02..a7043e234e2f6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -333,13 +333,15 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
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
@@ -354,7 +356,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * long as offset isn't at the end of the file then the
 			 * offset is data.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
@@ -365,11 +367,11 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
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



