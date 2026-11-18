Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046907;
	b=358QfrKN6ojdmb3o6Yhcrvbhyehd+PZYvcPupuLpD5MNcgQcBPLByufHaMThyMjLNeau
	 uMl2gykQp/5IUEHsYrv+C16bdnzcPDFo0Mv9vtoIzQrHgozwzR+yx5wVlpOt4yErWgUBt
	 wmlcgWJ0p2Ow4c7dlHwzDfFtp6uKpJjYmEQjenxuvag36No7k7sJIsOpK0DVg36VFj2er
	 Au1R2onT5dm3FJThH7fULtKDthvuY76K/2+vTqv0FN1Ie0s0Jt4jLG1hmm6yePUAU/f8b
	 0A189B74UMSEY753oCPSv7H0/5IQp/YCrA18Cz1F7t5cma7h3i1VJx/T8HV1bioD8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uWMhL1jgBPfoJP7tSTmdVhKpxEPtDucZ3QUF4cKqs10=;
	b=SwhPmAmR8533pPzzTSRZdcuBLhlHtQqvskCJpe1lMk7D7koPJ6dQc3oHoAm+jHf7EzBp
	 pSxiTGRg72QsonAe2k/dGIWx9stWsCHd5oa3MrsfjcThufJQR7gpGIzHa42FLZnnmrHMf
	 spnnvLKceRb3dqoKMCDev+NeLTaapo3Y1bUqP1Krqab334MjRA89e4VIWswtMZUhpe1uX
	 vIZWuhTQsfjunC2iprl30bupVXU9fvZb3oAEslOZNN4pFRrGEMfo0qGc6gN8Wgm6jX8Ur
	 wQzrjb6HXmE71MJ31FqhpAWCfkNdYmWKWCpvsTcraQ/TeijV1I+x4V6qvrrjYdH+g3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0rYvUI8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7065C606A320;
	Thu, 19 Nov 2026 00:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0rYvUI8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A531F000C5;
	Thu, 19 Nov 2026 00:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046907;
	bh=uWMhL1jgBPfoJP7tSTmdVhKpxEPtDucZ3QUF4cKqs10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0rYvUI8Z2+8qZBWH1zpCuyX41HDZ1+uhMCFuYHwweI9156GIcwSillM6mlmZjm+w
	 uH+EfAOgKKQi8eYqvZ/lR/LkZaYwRVLAHoJFNG7iI8h6tdUkJiR7pK8HxSj9iekDa7
	 xgvPTgRDAMLUzs9bC2q/ZrqNmKBwyeJcz1ArDA+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunpeng Tian <shionthanatos@gmail.com>,
	Gongming Wang <gmwgg05@gmail.com>,
	Mingda Zhang <npczmd@qq.com>,
	Qinrun Dai <jupmouse@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1422/2857] udf: validate the device specification EA before using it
Date: Wed, 18 Nov 2026 15:40:56 +0100
Message-ID: <20261118150252.523319085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yunpeng Tian <shionthanatos@gmail.com>

[ Upstream commit 9a2390959685ac35a58c80c8016120849a2babf6 ]

udf_get_extendedattr() bounds an extended attribute only against
struct genericFormat, which is 12 bytes.  A type-12 device
specification is struct deviceSpec, which is 24 bytes plus a flexible
impUse array. Thus a corrupted filesystem can contain extended attribute
that is accepted by udf_get_extendedattr() but udf_write_inode() or
udf_read_inode() may access beyond the end of provided buffer.

Provide a udf_device_spec_valid() check to validate correctness of
extended attribute that is a deviceSpec. While here, check the result of
udf_add_extendedattr() before dereferencing it as it can return NULL in
case of error.

[JK: Removed duplicated validity checks]

Reported-by: Yunpeng Tian <shionthanatos@gmail.com>
Reported-by: Gongming Wang <gmwgg05@gmail.com>
Reported-by: Mingda Zhang <npczmd@qq.com>
Reported-by: Qinrun Dai <jupmouse@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yunpeng Tian <shionthanatos@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
[ sashal: adapted changes in udf_write_inode() to udf_update_inode() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fd4b8cc20f5f1..6b78df1f1625b 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1185,6 +1185,26 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	return 0;
 }
 
+/*
+ * Verify validity of struct deviceSpec on disk. udf_get_extendedattr() has
+ * already verified the generic header and made sure attribute fits in the
+ * inode so we just have to make sure attribute space is large enough for
+ * deviceSpec struct and required impUse information.
+ */
+static bool udf_device_spec_valid(struct deviceSpec *dsea)
+{
+	u32 attr_length, imp_use_length;
+
+	attr_length = le32_to_cpu(dsea->attrLength);
+	imp_use_length = le32_to_cpu(dsea->impUseLength);
+	if (attr_length < sizeof(struct deviceSpec) ||
+	    imp_use_length < sizeof(struct regid) ||
+	    imp_use_length > attr_length - sizeof(struct deviceSpec))
+		return false;
+
+	return true;
+}
+
 /*
  * Maximum length of linked list formed by ICB hierarchy. The chosen number is
  * arbitrary - just that we hopefully don't limit any real use of rewritten
@@ -1499,13 +1519,12 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		struct deviceSpec *dsea =
 			(struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
-		if (dsea) {
-			init_special_inode(inode, inode->i_mode,
+
+		if (!dsea || !udf_device_spec_valid(dsea))
+			goto out;
+		init_special_inode(inode, inode->i_mode,
 				MKDEV(le32_to_cpu(dsea->majorDeviceIdent),
 				      le32_to_cpu(dsea->minorDeviceIdent)));
-			/* Developer ID ??? */
-		} else
-			goto out;
 	}
 	ret = 0;
 out:
@@ -1653,6 +1672,10 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 				udf_add_extendedattr(inode,
 						     sizeof(struct deviceSpec) +
 						     sizeof(struct regid), 12, 0x3);
+			if (!dsea) {
+				err = -ENOSPC;
+				goto out_unlock;
+			}
 			dsea->attrType = cpu_to_le32(12);
 			dsea->attrSubtype = 1;
 			dsea->attrLength = cpu_to_le32(
@@ -1660,6 +1683,10 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 						sizeof(struct regid));
 			dsea->impUseLength = cpu_to_le32(sizeof(struct regid));
 		}
+		if (!udf_device_spec_valid(dsea)) {
+			err = -EFSCORRUPTED;
+			goto out_unlock;
+		}
 		eid = (struct regid *)dsea->impUse;
 		memset(eid, 0, sizeof(*eid));
 		strcpy(eid->ident, UDF_ID_DEVELOPER);
@@ -1799,6 +1826,11 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	brelse(bh);
 
 	return err;
+
+out_unlock:
+	unlock_buffer(bh);
+	brelse(bh);
+	return err;
 }
 
 struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
-- 
2.53.0



