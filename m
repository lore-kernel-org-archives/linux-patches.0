Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214170;
	b=bhfBfpeDiErNdI+5EEkbINt1fz/291kHNHL/2bSbDyd/Td/j+tKBHUQc5lN/jwwYVrBZ
	 qIgUPU4Uzq/ZA0QjF2Yg0J1JaU7T5ea32LdRYk7fj+9M7QkKVhi/hqp5nHHChCIsrV1zI
	 io06sxb/GcKOQkEOmk2kBKkG2wjI6OIVgF7znEUwL/ZZY7EjTSQLi5Y3Tcbl+adotKMpU
	 k2IHoa5DvMZg2d1BzQqLMMZKP3cD/MStHkWAq2Ug+xRe4cVOqEjxNJo7Y/IC10QU8PgQK
	 fmhTBE1F4yukO3QEYRd09s+pCm6JNHZr98RZjujMCK+4pH717TpBLh76yvLLmpR8RhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/d6rYjUm51aidIoZIyFf7B061V/lPkIDwkxd+LI6z4w=;
	b=sjgNJpaySLifx9i2iJ8jqMo9Ms/3ECmjGUSdD9OkMl35+qAG6fdEgtnQoz3OQWLf4QBk
	 S6IftpBVnXwLEqn3nM4/M+3NBHm7zfIx/Wz7cBgNa5eD4nNzj5GqPDWtnSpl3llLott/b
	 Oeb9TSrsjorheymCDbMxJcuQpFLTZJsfIY/4pjlkvkmLPsngUD1P+Y9lHhCV9cvIG2Vc7
	 p//9jC/EOhbr1hFjO9mIlMc8SrRfhKKH8J3hFAfe5pAFx2J/ogFHMfyAnp1kyquSAXL9L
	 UJB/31vGHR+XmbJjaDRlu+pY5moes/vovvdTV+OYByNQclLdyIdoQKJ3kmGUM213Y6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PUfXOAb4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E359606A332;
	Wed, 28 Oct 2026 19:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PUfXOAb4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8363B1F01825;
	Wed, 28 Oct 2026 19:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214170;
	bh=/d6rYjUm51aidIoZIyFf7B061V/lPkIDwkxd+LI6z4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUfXOAb4k81Aj1lFQ4qWxWEP2peASuaiTV/KaXNiT7x+dVTZ9KovBLMlWK1WU9oJR
	 IgKFIX3Mij+RRn+UC2ZGjjwyEYKpVAywbcbIFoJmlrfqORyduSafvnuSX/e3as1yWN
	 H7wRUIJxoNT3oJXaGON1+NVWIJx8fKPNRnRA/MbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0721/1887] vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
Date: Wed, 28 Oct 2026 17:46:57 +0100
Message-ID: <20261028170515.848026531@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 22e87bf3f77c18f5982c19ffe2732ef0c7a25f16 ]

Fix an unwind issue in mlx5vf_add_migration_pages().

If a set of pages is allocated but fails to be added to the SG table,
they need to be freed to prevent a memory leak.

Any pages successfully added to the SG table will be freed as part of
mlx5vf_free_data_buffer().

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241114095318.16556-2-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fd6ccb8454a24..191d4c7b686a7 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -71,6 +71,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 	unsigned long filled;
 	unsigned int to_fill;
 	int ret;
+	int i;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
 	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL);
@@ -90,7 +91,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 			GFP_KERNEL);
 
 		if (ret)
-			goto err;
+			goto err_append;
 		migf->allocated_length += filled * PAGE_SIZE;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
@@ -101,6 +102,9 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 	kvfree(page_list);
 	return 0;
 
+err_append:
+	for (i = filled - 1; i >= 0; i--)
+		__free_page(page_list[i]);
 err:
 	kvfree(page_list);
 	return ret;
-- 
2.53.0



