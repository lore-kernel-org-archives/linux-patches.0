Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617586;
	b=GtX9uO/nI9Qli+eX+AcYKTz6eoxqSYYxvaa6ezyK/aQkpz0GIlQZ/Pp9XNnhxW7b8oxO
	 PvWIfrGGcyzTm+fPZaTAJQtZSRD+9S/7YRHbqa9I38XeB5N1S0e2ONh/0j34nhsxPrrdH
	 b0N/W+Th1Nfyx7EuLNI2PjhjLrFjTM8km87RpLnK2Lm+xXsWcAQw8B/8UUb9Hzfsssl+p
	 GMZ0bNn+PvDpRgrulB8FZnUVeX1A8Hice/uhYbrR09l2ZkDYID6KixbNdShIv4MPOWQIj
	 AuSDua7PDK6+wst/KXvtdB7mHYdm5Txb+dZRw+WhUcJM5cUyzcds75WlXgJpvy7OjfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gInzEnDgSOYTlHdYvt6MNrzXCUTPbAgZ57bmkqpAINA=;
	b=LJyS/FBthO3IiuplQDmLCxlwk3VEX/w99ycJyfePAiXSuIchU424++/zTs99iJDAurn0
	 KN3QIkNkb5PMs5VY3yg/O0Yi5qR12UsyKLdVi1pzFxKwjxEX3ndyTMuHmwMCunnVNjZGt
	 BAS5ZrgZXtxl/v/aF05oH+8ImXOOFSzjSPst/+GgunRVmRtgrRXJq8KqrIcSrtx3c4pCY
	 11qh/M4vTjVEAEZqcB4gJtTe4yG6U2chpRLIJ41tams7/sgW6FV9PBab3z3LLcBfCJ5Zz
	 qAQjUyGQrOprT3yrbg0oWKsc5MecDsIz6mtutxhjiyIHEZ3JuTYO/b490b9HBsXVLwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnTXmglS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB81F606A31E;
	Wed, 25 Nov 2026 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnTXmglS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AD91F000C6;
	Wed, 25 Nov 2026 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617586;
	bh=gInzEnDgSOYTlHdYvt6MNrzXCUTPbAgZ57bmkqpAINA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnTXmglSactGU7UoYiOG+tjAlQVrKy1u18QKOyiAwSzKEOpjv8Bm9s/0mR1fkdYDY
	 3r6QzDidpGM9UBBhJrnfMtbhHrRq9iJOphoSNqHqYg1luIpDmg8DAgr1QGwgD1qm3s
	 O0mOpSLzkolOCaYeBh8c5cm045XoitLdlSWf76Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0013/1005] udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()
Date: Wed, 25 Nov 2026 15:22:31 +0100
Message-ID: <20261125143822.047712728@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 49f771d14578733a350c45e34e1bc6ad14f56952 ]

In udf_load_vat() (fs/udf/super.c), validate that vat20->lengthHeader is
at least sizeof(struct virtualAllocationTable20) and does not exceed the
mapped buffer or VAT inode size so computing the VAT table pointer and
entry count cannot underflow or read out of bounds.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20260919222600.3793513-1-benquike@gmail.com
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 7570506ff2dde..a81a8509524a9 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1329,6 +1329,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 			(sbi->s_vat_inode->i_size - 36) >> 2;
 	} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
 		vati = UDF_I(sbi->s_vat_inode);
+		if (sbi->s_vat_inode->i_size <
+		    sizeof(struct virtualAllocationTable20)) {
+			udf_err(sb, "Too short VAT inode size %lld\n",
+				sbi->s_vat_inode->i_size);
+			return -EFSCORRUPTED;
+		}
 		if (vati->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 			int err = 0;
 
@@ -1346,8 +1352,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
 		map->s_type_specific.s_virtual.s_start_offset =
 			le16_to_cpu(vat20->lengthHeader);
-		if (map->s_type_specific.s_virtual.s_start_offset
-		    > sbi->s_vat_inode->i_size) {
+		if (map->s_type_specific.s_virtual.s_start_offset <
+				sizeof(struct virtualAllocationTable20) ||
+		    map->s_type_specific.s_virtual.s_start_offset >
+				sb->s_blocksize ||
+		    map->s_type_specific.s_virtual.s_start_offset >
+				sbi->s_vat_inode->i_size) {
 			udf_err(sb, "Corrupted VAT header length %u (VAT inode size %lld)\n",
 				map->s_type_specific.s_virtual.s_start_offset,
 				sbi->s_vat_inode->i_size);
-- 
2.53.0



