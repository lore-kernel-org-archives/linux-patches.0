Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591412;
	b=yo1VARbdEtG+QyQPVFe7k6jY34bT6zXUeIqhrQ+xBHKbv+2tKH3DiFuRYeMOM6sOq30X
	 eF0qcfRkXMyPMXzCg39fHmf8iGWG1rBQh7DdHMQSrJI3n7PtHCHMVcyYgBoSoV8PNvkbB
	 S9lhr/Z+M3CdaSr8iOS+I2zxs27z5frx3ZdwfArQSOAdORKVeqq2uIAMelKhSE/CkHHLq
	 3dKx7vwjl4qGPdBe1VtNiF1siE81q92Q8InPYJXSeO7S0TCNtXAvokTAV1ph5la6v/eTh
	 zUXjV4iwtZCIBz/D/sgDS6RGgMQrYvaLwO57SlOHJ8ccijQunsS60IW10lysnmrP5EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CjkELnuRmIAS24lGVYGEb5CjGQI10s9sY/GikSSJUJo=;
	b=BcirqsktlupE95GEHOkbFXGWuV9CeP3/P81zDGG1DLhh5FRWFl43exukR0TTgRroyKPo
	 HvEyZZOxKnHZkhBp/8AkVVnccVnh4h04MGVz2YjBLiBNuW69r6qOeWMq3IjPSWxJx3LRM
	 23UrTDDvsM6z1W/5AzhiE5OdcbfSN92BaZFqvWwAGUjC/Y0NtlRaBGixqueSyp1hD3Kcl
	 b18O8B/8FhDdc9+wgRwibqqLLhnwDkEvhqdGYFiOUk9thOXWPkeJ8RzGy4y7vrks38LF5
	 S/xbgDOS9MFFDxGJeLbSrKD3PYkXxaZJ3TfxCXN/wgxMXGakufEUgO8akbnPYiaZ2ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKqZ6h0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F296079D6B;
	Fri, 13 Nov 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKqZ6h0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1341F000C4;
	Fri, 13 Nov 2026 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591412;
	bh=CjkELnuRmIAS24lGVYGEb5CjGQI10s9sY/GikSSJUJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKqZ6h0KzvhSjFn5Er0PCSHsfYjXihXjbh35nfugyQ2XT5ke3/V8+32dxvxAEGg0O
	 U8pJEYprCwtIBkon2WOV0+nHRZL8ObVEcST58gVbLMc+PKB4yq1gHxFpgm3aPVXUOd
	 Y3vLSG1YCW0QbeZuPHM6l4X26nGhHTfS7+X/Wpxc=
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
Subject: [PATCH 6.12 507/670] udf: validate the device specification EA before using it
Date: Fri, 13 Nov 2026 10:51:11 -0500
Message-ID: <20261113153829.127005449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted udf_write_inode() changes to udf_update_inode() using its existing error handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 96934d42d9499..49d8a2b196414 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1339,6 +1339,26 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	return err;
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
@@ -1657,13 +1677,12 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
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
@@ -1811,6 +1830,10 @@ static int udf_update_inode(struct inode *inode, int do_sync)
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
@@ -1818,6 +1841,10 @@ static int udf_update_inode(struct inode *inode, int do_sync)
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
@@ -1959,6 +1986,11 @@ static int udf_update_inode(struct inode *inode, int do_sync)
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



