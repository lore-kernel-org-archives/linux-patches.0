Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216202;
	b=a9PuUgz8HrFmwyckYtJ0BNx3OTpiihX+RtjGJhVqWUC0FGCFi4ITCtnc9L0X2DENpi6v
	 kz6cmuDlvKQ/68zEwk9f0FpGrIwykVdeCdtzXvynH83qND8bHTxD5vtsS4L+B9P8GYRou
	 s9srvxdedxXKI4/uWXpf27EGRr9rXgRWNN6LF7WQmOmlgtG81F5RqqzIR/whjYyC23Y0Y
	 5eRF+nrzs2dG41Uj2MzZoXAa19QB8Cmb9Dv9V+QMWRhJcB45oXgdbK/E4cUaVQxGWzIZl
	 Jpu8ZMTNP6lWcPXIXAvfIU+J6l40lCw7dzbJamTmaoDCkk9zpuI3g6lixEvcYLIJgQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BEKejvSOZhC/cny3p1G6bs96R5oeR6SuQ6VZYjk6FNc=;
	b=BQRTFcE/+t8g9L3QU3W+bTi3HMqgqxQ0CRHbxSzTuXujZ2uDF79guflS6PRwZOUEtOMK
	 UBc96Pr28LSotnMAw/pOOz6fp7CvB3tnHX8HH55w1qJ7Kik3T24v4XAhTNH0f49+WJ/dW
	 qB9DpaA/RZcnWL/fFcZjy9W2QneBTBWgZviWFOiAmWL11DGjyK/UjSHrH6ayG6TgFXVVh
	 GHNjdXaQMyME5hDsVtbnZIn/+vIS1ZZ+aJu+4uvI/0Jgh7alSWre6PnDCrmu8PU54l26g
	 r2xyjOThAhnfGxZnSn/rP0f9XO72JxYFKm1UmjupUIJ2hGHsjp1hr5fdPsL7Q3y4Vgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19z1xPSj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A98606A31A;
	Wed, 28 Oct 2026 19:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19z1xPSj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA0A1F01825;
	Wed, 28 Oct 2026 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216202;
	bh=BEKejvSOZhC/cny3p1G6bs96R5oeR6SuQ6VZYjk6FNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19z1xPSjusFAE39ePv38QTOIajb9GkvBM1WPPvtr0iPA36tFzyXS76Fp149oSSCYD
	 EsSIoaU4Agm/G2J5cA24nPucC8VQOA9XMdSzxSN+Fqw9jHB40Y12NDTDmr0FnTE/yG
	 ntzyQ+/xnDoVVhBVcUWXG44vOfCREYwW7XIXMc4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carol L Soto <csoto@nvidia.com>,
	Jamie Nguyen <jamien@nvidia.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1459/1887] fs/ntfs3: resize log->one_page_buf when adopting on-disk page size
Date: Wed, 28 Oct 2026 17:59:15 +0100
Message-ID: <20261028170532.661109692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Nguyen <jamien@nvidia.com>

[ Upstream commit 5a35454179fe1041d9cd286f5d320ce0d448c12a ]

log_replay() allocates log->one_page_buf using the page size that was
chosen from the host PAGE_SIZE:

	log->one_page_buf = kmalloc(log->page_size, GFP_NOFS);

Later, when a restart area is found, the log page size recorded on disk
is adopted:

	t32 = le32_to_cpu(log->rst_info.r_page->sys_page_size);
	if (log->page_size != t32) {
		log->l_size = log->orig_file_size;
		log->page_size = norm_file_page(t32, &log->l_size,
						t32 == DefaultLogPageSize);
	}

If the on-disk page size is larger than the size used for the initial
allocation, log->page_size grows but one_page_buf is left at its
original, smaller size. A subsequent unaligned read_log_page() then
reads log->page_size bytes into the undersized scratch buffer:

	page_buf = page_off ? log->one_page_buf : *buffer;
	err = ntfs_read_run_nb_ra(ni->mi.sbi, &ni->file.run, page_vbo, page_buf,
				  log->page_size, NULL, &log->read_ahead);

overflowing the allocation. This is reachable when mounting a dirty
NTFS volume whose log was formatted with a page size larger than the
buffer initially allocated on the mounting host (for example a 64K-log
volume mounted on a host that allocated a 4K scratch buffer).

Grow one_page_buf when the adopted on-disk page size exceeds the size
used for the initial allocation. On krealloc() failure the original
buffer is left intact and freed by the existing error path.

Fixes: b46acd6a6a627 ("fs/ntfs3: Add NTFS journal")
Reported-by: Carol L Soto <csoto@nvidia.com>
Signed-off-by: Jamie Nguyen <jamien@nvidia.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index c7762a24f8fed..df80905fe9805 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4061,6 +4061,22 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 		l_size = orig_file_size;
 		page_size =
 			norm_file_page(t32, &l_size, t32 == DefaultLogPageSize);
+
+		/*
+		 * If the adopted on-disk page size is larger than the size used
+		 * to allocate one_page_buf above, grow the scratch buffer so a
+		 * later read_log_page() cannot overflow it.
+		 */
+		if (page_size > log->page_size) {
+			void *buf;
+
+			buf = krealloc(log->one_page_buf, page_size, GFP_NOFS);
+			if (!buf) {
+				err = -ENOMEM;
+				goto out;
+			}
+			log->one_page_buf = buf;
+		}
 	}
 
 	if (page_size != t32 ||
-- 
2.53.0



