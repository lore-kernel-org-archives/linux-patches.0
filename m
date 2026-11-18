Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053536;
	b=R/mmjRvRUvbUhFhONpzRWhXuNOsCY8tPfyfVQS9RduRUkwPFroZrysrMcCzKzJ8WdRAy
	 DL3tXbpExzl4zwmQUuMkYvM8cliH1EZJn5ytqi/KDVMZSkerIOZGmP+BbjShw/Jp6vJlO
	 ASKaliZ5HJdMGjdDtkIzO9BXU+LszDSUdrsrm935qvnbg9UOLFjIXe/uTkLbeWWH9K2Be
	 mk7u/UkPllCmSc1BDaqR45R+/yHTpT9X1Po7MpniSPG9PRJ9m2zW94wfBglN1lMZCKpc0
	 SuS/0oA+GCfAgt8VqUZFZqO5Nq8qiuJYOTbBdWxizt73zNz4F7z/MjDsF8VI8p5rU0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eGNKuDLNBJ3VYznzN8NbmuuShZg+8hVOQkzAFGd7//Y=;
	b=cviaGjjxynjT3zm2qfd/oxYI2g1jwmX7FCCIFqGS/09G8/OLB25OJU4qnZdftNdCeKZF
	 LUk65+/P2EbPzF/npgLYvyqJ6QwJLTvpM3cR67KP9q0CiVRxhPNGbK8HJ5zP4I5MaBcoV
	 fzmnngZJuuHBFczJqRNKxKsDYgfMdKm6PlueYhOv4TaqZzsXsQx8IliFzxNDGs8kNzKap
	 pEmynjwTJCzplhBnxUSsLb1n3gbVcZ1YPIgXh549fYLuN6J4YCITnKs/AQY+kACjai1F9
	 DSuf33Y+1Dks0tF4faQBgq4TjQfPmFP+JNZanK5s99sfvuy6Fd+a9xW8RAYdV7k5xRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO4ShZXH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7A606A320;
	Thu, 19 Nov 2026 01:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zO4ShZXH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859EC1F000C4;
	Thu, 19 Nov 2026 01:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053536;
	bh=eGNKuDLNBJ3VYznzN8NbmuuShZg+8hVOQkzAFGd7//Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zO4ShZXHnr1T95CYSsk2FHrDE8aL0FXByJ4Q2R0GptC9oWoqMZkWE9UvqfTk/fy9+
	 ognV6/ubNE7slY8GRmgljfLKEN3bO+N2kmrax1ii7y/7vrNweVvWQpj4awCXv8eGZD
	 O5fWhGsAEfJKHfekAPTTkrVmL9aKT8+w7Tc90Opg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0954/2214] f2fs: allow pinning empty compressed files
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118150050.487130868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Chang <joannechien@google.com>

commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17 upstream.

Commit a64a3fec11e7 ("f2fs: force out-place update for all writes on
compressed file") updated f2fs_should_update_outplace() to always
return true for compressed files. However, this function is also
called during f2fs_ioc_set_pin_file() validation, so pinning an
empty file with compression enabled now fails with -EINVAL before the
compression flag can be stripped.

Fix this by guarding the f2fs_compressed_file(inode) check with fio in
f2fs_should_update_outplace(). This preserves forced OPU for actual
compressed writes (fio != NULL), while allowing f2fs_ioc_set_pin_file()
(fio == NULL) to proceed to f2fs_disable_compressed_file(inode).

Cc: stable@kernel.org
Fixes: a64a3fec11e7 ("f2fs: force out-place update for all writes on compressed file")
Assisted-by: LLM
Signed-off-by: Joanne Chang <joannechien@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
(cherry picked from commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17)
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b8da6784e2c44..4b47d7316d4c6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2675,7 +2675,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out-place to prevent metadata-data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



