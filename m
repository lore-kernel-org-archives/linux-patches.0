Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021183;
	b=TdtCsQPUY3Wqbb59d67lehzLPsaqyXDDr9QaV5l8iszRPQGcnPE0XnLVdERECN+IMLkO
	 Iv3yuc+Xs98jMwvz9uq/I4gODI/GJVThDwLSIr11eYkEVQY4XOduKSLRtDz9gydowgPTi
	 HE0OIl2f0fNhk4DBrGxEvWYhLYRX7nVQxIoB/s9WIxWmfcf21UDGGzUGsgTSZNLXxYtW1
	 OEOJCoqHbqnLhnMF9BBwcFF5O9mwdoW5S7unT2R3myeN6mMuMaKFrFP2+ILynRq4gyIgl
	 r3QDOpC6LfK6cIDOmC2XNuPcPG0wyf4sBKdDu//luIpKnlUyWOEM2/3fZbFZTpSu0Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K/ND/ps4L6rO6+JOzNdTdT4sbdy1NNFcXEPRW+igdSg=;
	b=RmrX+sB13KloJ5Pp+YDlB97PSm64V2VCXGG53g0Yq2NqfvkO72You20gpwhhkBwaHYUd
	 m/obQFVMtKRAm4NsSUh0Ua5T2As27+G9zXjDvTJjnVQA5735rY9wfGg9g4t8YNPaklWeC
	 f2AbgL5NQfaSMGKJnBS5yN+vlPyn28NUwTzoJr4mdQhBd/TJo0TCzA11LjeffyqPPDq9r
	 gKZJUkJNa2QbgGNCd4YFWEw1mCLdYgetN/a06leFgCEsCb50BbRLXoZzTUJx9qSouuy7P
	 eQel7vzQU3SqYyxP/bsuPG3Nu/tBng9mOhGV1K6MnT1tS1s2GZF6JZcQuxHYqmNaPoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNaWUc2q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D7E606A31C;
	Wed, 18 Nov 2026 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNaWUc2q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3334B1F000C4;
	Wed, 18 Nov 2026 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021182;
	bh=K/ND/ps4L6rO6+JOzNdTdT4sbdy1NNFcXEPRW+igdSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNaWUc2qkiU6zBvLf3OqT9p1S0lagbu4yTHWYDnJ3CclNmQLEXTprxKmLXXqSBa/d
	 T6jktqjqaiwtQOzxZatqYL2G+VG+dEOIfkx/YCiuH2a+LJpNtlxVjK292QHXDfO2ao
	 Et3dePFNeGeStkXSS8CvDCXIJJqhbulGrFc0J5ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2215/2651] ntfs: set the attribute list size before reserving space for it
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150405.364581441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 4985f322659f1e667226370e4a7129ebd850c990 ]

ntfs_attrlist_update_locked() resizes the attribute list and then, for
$MFT, tries to reserve the maximum list size.  When that allocation
fails with -ENOSPC it falls back to ntfs_attrlist_repack(), which reads
the list through ntfs_inode_attr_pread().  The read stops at i_size,
but i_size is only updated after the reserve, so when the list has just
grown the repack gets a short read and returns -EIO.  Only -ENOSPC from
the reserve is ignored, so the -EIO fails the $MFT extension and with
it the file creation that needed a new mft record.

On a 32 MiB volume with 512-byte clusters whose $MFT has a non-resident
attribute list, 591 of 1500 creations of empty files succeed and the
rest fail with EIO while 742 KiB is still free:

  ntfs: (device vda): ntfs_attrlist_update_locked(): Failed to reserve attribute list space
  ntfs: Failed add attr entry to attrlist
  ntfs: MP update failed
  ntfs: (device vda): ntfs_mft_record_alloc(): Failed to extend mft data allocation.

Update i_size as soon as the list has been resized.  File creation then
goes on until the volume is full and fails with ENOSPC.

Fixes: b1d732e62a5b ("ntfs: repack $MFT/$ATTRIBUTE LIST")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrlist.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/attrlist.c b/fs/ntfs/attrlist.c
index 3660e7fd24b13..6edd5d2d9bf24 100644
--- a/fs/ntfs/attrlist.c
+++ b/fs/ntfs/attrlist.c
@@ -256,6 +256,9 @@ int ntfs_attrlist_update_locked(struct ntfs_inode *base_ni,
 		return err;
 	}
 
+	/* ntfs_attrlist_repack() below reads the list up to i_size. */
+	i_size_write(attr_vi, base_ni->attr_list_size);
+
 	/*
 	 * Reserve the maximum legal list size while the MFT metadata area is
 	 * still easy to allocate contiguously. This prevents a later list entry
@@ -283,8 +286,6 @@ int ntfs_attrlist_update_locked(struct ntfs_inode *base_ni,
 		}
 	}
 
-	i_size_write(attr_vi, base_ni->attr_list_size);
-
 	if (NInoNonResident(attr_ni) && !NInoAttrListNonResident(base_ni))
 		NInoSetAttrListNonResident(base_ni);
 
-- 
2.53.0



