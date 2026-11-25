Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618010;
	b=NqxSZ2fqMsAsI5TXdh1QEZhfGgXL065gMh3QgV6/uFHNL2vlSqiHv8XW6yqMHSEFvMvb
	 S0lSU9FWMrNRIRXPRPdGl+iPMEEoo1DRQ1dOg4cgkE+QskGHR89PSIDe7Qi/CfKv1TtUC
	 I6i++pTdw0FEtDBFZfr5X0O4+hzP6CC0gRIF8XJ9W2qCgGmpj0hGzADQrR7VevsPCf/+q
	 un3cJaSG9pGl6xzEAv49acjB4S4E1kggEkhtM75QQKBu8Y7cy5m82EMU8g0WjlTvrpvwY
	 ZL3a2QFa/IL7mQ1ZEEQq8/n8q+LApbSGjbusirnubuuK4mZvyM1PyeBYC2CB3r3tmYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NroquS5uUMLVgA/0AoIRPX/ee6zotjj+XZWkOfxP7U=;
	b=oiG0PTlUpXA34+nxVpoQv33ok2ThwE4dLuBHmSDwsnPpulvcXuKxFLpsWI6peHMqa71N
	 8GgQw3lpjfKhW7XYjlVyvFDZQW6JxodBvLl9hQic+FK7PSBV73fgQlPiwKdy+kmFKvQCO
	 ojXLdQ26aux1vtVnX0/dcKzoJFsPNAtqnkgQ4RhDG21z65dTIhEGM0CC3sgpoazO9mS10
	 w4yhROXQ3QLFQnXqZVx7PmHjWQtmw2lTDMxCwobwbP3A6YTQktuaqDEdjalKeivTvKmjW
	 9E51ggzRs+RO3nzP5A/cJ9Yn4qZ5KAQb1cSM9K2zZ1+SzNtQcnXAZDWsFmCXabj1aDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8cvMX5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872BB606A31E;
	Wed, 25 Nov 2026 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8cvMX5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5941F000C0;
	Wed, 25 Nov 2026 14:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618009;
	bh=+NroquS5uUMLVgA/0AoIRPX/ee6zotjj+XZWkOfxP7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8cvMX5eaDEwbnfNcwZsWEH/xEvCG4M0l72U9RYc3yDK+6o/oqwpAZ8XdWQrSO2Rl
	 MgTwf/dEbQbPQGMV+KFvZg3Ou+hNolrYsQAhyTTlFESPgTnLySWmOjOtrajpAEiJks
	 eCq4iVbKJ4rvvnaoFvlj9JOjgon/tl3b3+QmDYQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0144/1005] erofs: apply the stacked fs check to extra file-backed devices
Date: Wed, 25 Nov 2026 15:24:42 +0100
Message-ID: <20261125143825.111969775@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit e9aeaa63fd94b0d2bb9b303be5774b33ca9c01cf ]

erofs_fc_fill_super() rejects a file-backed mount whose image is on a
file-backed EROFS or on a filesystem with s_stack_depth set. This
bounds the nesting of reads. Extra devices given by device= are not
checked. File-backed mounts can still nest through them without limit.

Apply the same check to extra devices.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd9983..ee01a5ef85931 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -122,6 +122,14 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 	return buffer;
 }
 
+/* see the comment in erofs_fc_fill_super() */
+static bool erofs_is_stacked_file(struct file *file)
+{
+	struct super_block *sb = file_inode(file)->i_sb;
+
+	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth;
+}
+
 static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 			     struct erofs_device_info *dif, erofs_off_t *pos)
 {
@@ -161,6 +169,11 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		} else if (!S_ISREG(file_inode(file)->i_mode)) {
 			fput(file);
 			return -EINVAL;
+		} else if (erofs_is_stacked_file(file)) {
+			erofs_err(sb, "%s: file-backed devices cannot be on stacked fses",
+				  dif->path);
+			fput(file);
+			return -EINVAL;
 		}
 		if (!dif->dax_dev && test_opt(&sbi->opt, DAX_ALWAYS)) {
 			erofs_info(sb, "DAX unsupported by %s. Turning off DAX.",
@@ -701,9 +714,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * It MUST change if another fs plans to support them, which
 		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
 		 */
-		inode = file_inode(sbi->dif0.file);
-		if ((inode->i_sb->s_op == &erofs_sops &&
-		     !inode->i_sb->s_bdev) || inode->i_sb->s_stack_depth) {
+		if (erofs_is_stacked_file(sbi->dif0.file)) {
 			erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
 			return -ENOTBLK;
 		}
-- 
2.53.0



