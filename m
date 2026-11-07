Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065188;
	b=f9+2tZY/b1RvbeCIvEcQLDmmgt6O/gNad+TZMS51tnvVOKf6Yjs+AruxXCihq3HMs0cl
	 P9EmoyLHpbuJg5TqD4xC4BcduelqPL1A8eOcGk1qGu9XnSbn8hWjm+ZxSpSiMuDxXR6Cn
	 vhXB/D1aRnFmWXjDQn5/5Pxn1DYaOLFUbYpkqCAMwGEBffE8gzDxijbxz9WqtG4H3K2+N
	 cedEuc/Th+gRUs/KDtjm8GetSG5DyQf8wu0gv3d8KsepyhTigdxklwpFdyquqLrG5ATYV
	 hkWrR1iHMMeFE+yxcTPIbR9Neg5mCb8Mcw2etT1DQ3X6CB+YrbeFYveqpomojSe/CXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wXcMrEEvgsP83QeyO90WrBUSVrdyckT05YVTqKyWJ5o=;
	b=giytb34fBxqKVzN9R+Uk+IAHzQ/sbPob6jKN7l7d+/Q1x0MbEKqx+Qnj9R7JfEOqKUKM
	 lGKLjoz55GuG/oDduDd65+aUp+YnTW0P8TB9xmIZV5M1VYy4JE6CaTpy3cTh1qegQqcyF
	 fR2W/lTRm4H7hkqP0dHPyBJwEOy/+zNvlUZRNwjNp1xqBuYAUGLeQXkSLNgQaRz0gWFvU
	 075PnYqsgUhMqFX8U+DOACMGKBTPPN21/1tetTMFFiU+3CQ0NZ3BiQ8Leq9xUiNJwZ6IK
	 5UuY5tAMPmvOze9/8rPlYWPzmIttGscC4XvUaUyHj8CIULE0waIRpZlm4nIwD2oKPcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MniZBXXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B7F606A335;
	Sat,  7 Nov 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MniZBXXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE89A1F0089F;
	Sat,  7 Nov 2026 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065188;
	bh=wXcMrEEvgsP83QeyO90WrBUSVrdyckT05YVTqKyWJ5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MniZBXXd3esif/WMMHZG74d+ttSsC7pZWCXwsLqr4UZ8j/joOtORvJvmXNKQc+RnN
	 Bzabf0eG5SwKF9Cl5nCN160x7b4FOMQqe2QTXjIAPgOLoaxC7IXqZo65+zQ14KM1Ma
	 myi8rtOR4/27Cvn2cKdCh1BYEGLUo+cKh5VUOXHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0991/1257] exfat: free clusters beyond EOF when a write fails or is short
Date: Sat,  7 Nov 2026 08:54:47 -0500
Message-ID: <20261107135006.736583587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit b4c282c0d82e8715ea9ed0b35813a3f365e3f952 ]

Commit 82a81a7352bc ("exfat: add iomap buffered I/O support") and commit
867b9c96dc83 ("exfat: add iomap direct I/O support") made a write
allocate the clusters for its whole range in one step. They also dropped
exfat_write_failed(), which freed the clusters beyond the end of the
file after a failed or short write.

However, a write can stop early, for example when the process is killed
or when a part of the buffer cannot be read. As of now, the clusters for
the part that was not written stay allocated beyond the end of the file.
exfat_cont_expand() does not expect them, so a later write or truncate
that extends the file fails with ENOSPC. The directory entry records
only the size of the file, so the space can be lost for good once the
volume is unmounted.

The issue can be reproduced on a 64M volume made by mkfs.exfat and
mounted on /mnt, with a write of 1M from a buffer that has only its
first 4K mapped:

    #include <fcntl.h>
    #include <stdio.h>
    #include <sys/mman.h>
    #include <sys/stat.h>
    #include <unistd.h>

    int main(void)
    {
            char *p = mmap(NULL, 8192, PROT_READ | PROT_WRITE,
                           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
            int fd = open("/mnt/f", O_CREAT | O_WRONLY, 0644);
            struct stat st;

            munmap(p + 4096, 4096);
            printf("write: %zd\n", write(fd, p, 1 << 20));
            fstat(fd, &st);
            printf("blocks: %ld\n", (long)st.st_blocks);
            printf("ftruncate: %d\n", ftruncate(fd, 1 << 16));
            return 0;
    }

Before commit 82a81a7352bc ("exfat: add iomap buffered I/O support"),
the result is:

    write: 4096
    blocks: 8
    ftruncate: 0

After that commit, the result is:

    write: 4096
    blocks: 2048
    ftruncate: -1

This patch will bring back exfat_write_failed() and call it when a write
ends before the end of its range, so that the clusters beyond the end of
the file are freed again. It waits for direct I/O in flight first, as
exfat_setattr() does before it frees clusters.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index f106db945d8dd..dc57d2c2f0f0f 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -804,6 +804,19 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 	return ret;
 }
 
+/*
+ * The clusters for a write are allocated before the data is copied. Free the
+ * ones that a failed or short write has left beyond the end of the file.
+ */
+static void exfat_write_failed(struct inode *inode)
+{
+	inode_dio_wait(inode);
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache(inode, i_size_read(inode));
+	exfat_truncate(inode);
+	filemap_invalidate_unlock(inode->i_mapping);
+}
+
 static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 		struct iov_iter *from)
 {
@@ -862,7 +875,7 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct exfat_inode_info *ei = EXFAT_I(inode);
-	loff_t pos, valid_size;
+	loff_t pos, valid_size, end;
 	int err;
 
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
@@ -881,6 +894,7 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	}
 
 	pos = iocb->ki_pos;
+	end = pos + iov_iter_count(iter);
 	if (pos > i_size_read(inode))
 		truncate_pagecache(inode, i_size_read(inode));
 
@@ -909,6 +923,8 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		ret = iomap_file_buffered_write(iocb, iter,
 				&exfat_write_iomap_ops, NULL, NULL);
 	}
+	if (ret != -EIOCBQUEUED && end > i_size_read(inode))
+		exfat_write_failed(inode);
 	if (ret < 0)
 		goto unlock;
 
-- 
2.53.0



