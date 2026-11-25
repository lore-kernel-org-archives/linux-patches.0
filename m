Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624099;
	b=nTj69vn1P+ny01jBaUYj+ldAFOqeXptSDJLTFcse4VQmYWgJmfprZF/YlF4mMlGfWQxi
	 /QvWEogrXg/u1A3dcPDdYx1yVsdwdUaL5a4ngOs2Q6ej0UHWtK3z7iDQgc+O5gl4Ehyjo
	 quiA+6HA+Q+Vbg+f4/A1gdz2eN9LESLMbHNMVlISYJOwyyMHwLVAifDePo20Dg9mkVaRx
	 PU6nRHAAF9BjfRWGYMisEx410t6XrygDyuYSwGuwOEbHaDPed9QdB7HOOCL3MQQwmvL3k
	 hkguIGscHtQD4EVuu7PETt7S/NmNmw4M/AkxzUav/GIDPDrPMLv8l0k98hG8kXu3ifA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JePGOeEJr8glEHNwZapVQnW4A/4A5zYHHW5dYwVtNVY=;
	b=QFMoDhOSLDjjGgGhgTBinoHcnsg99A8NcYuorrofkW5f7LZivPaBpsR4UotSJKcgOQqV
	 OqiYKn9hO+eUANx4kCqhHaKhPaHrGWGRYTvr6Y0AWVX73Rz/8Uj7Wx+6bA0/TtDlyeo7m
	 FZq9IRzJ3x93zQOgQ6zUKRgngZtkxSaOh9O9NTp0wDROmBdpXqa+a3oW+5IjF+mmew7Rs
	 NTff89+Ih6Gm4yZJEQgekfrFCyi2pUzTgQf2ArD9wUQrgUwd0NAI043hB383ytEbC3BrE
	 l9URE5j595dXGsaXxfcAy7uuNSdhlDo4f12JTQOLIbiCmxj9Ygp13z8xpjgtQdooY7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FU07WO1d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12880606A327;
	Wed, 25 Nov 2026 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FU07WO1d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F4F1F000C0;
	Wed, 25 Nov 2026 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624098;
	bh=JePGOeEJr8glEHNwZapVQnW4A/4A5zYHHW5dYwVtNVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FU07WO1dB1uYLGMbjZ7XMyizIMifoEaN0lPqpGYQVFxKItyWJfpSNNUQ1x+IbanJ0
	 KG0o0YOa+61Jlvc1CpcZjjn3sMziv9w/QfwVXWUFgYgU5hIIUbYKT98pA9EJ5ciMU7
	 lt3s5UKjeRML3cgS8RpBTvC0NWb7k+1bxFICRU8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/816] udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()
Date: Wed, 25 Nov 2026 15:26:18 +0100
Message-ID: <20261125143849.915478395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index ea9cd593ffbbb..09905f6c9ee1c 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1328,6 +1328,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
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
 
@@ -1345,8 +1351,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
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



