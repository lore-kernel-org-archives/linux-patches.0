Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704898;
	b=4TyldAQpkqOqvqQzbhLxLl/oBXtEp64wmOK/Tkcjz+fUBIpKi3XgZ9ZVJGO9+K8Ev/ir
	 o0M4VBvWDUKLQ4HIL3CiBOSDVgOBSUem2/V8nlmDk2MIonXKl498XUSdtDXjkgCYhsh3c
	 mHmgAN0tACUHMQ5b7b80RVDdLXIyewWJdIS7Qi9+gZjpwZ/G6NyTPSdeXGpXj+2nYzLAt
	 W/T2o+PfAPZAPpuoofyGiiJXKtHC8lF39mHR1DNq39URwlLcYSwJI96uMHdeL8XyFjb8W
	 MACcXz5RvJdENtWjCkHLTdKDcNFZ+ZNcpYMuwXqrFNBnxX2buqRn9Fu8Hj7UP1Xngyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MALZG0MBgIberlXIYe4HVhv6D/MJblSL5YALpYzivL4=;
	b=YuSUgTvVTiGW/CNUkl3LTIzQaxd2Imj0mUD0T6RWoqZ2IWOTlgJt5ElsAt6IlkRJdbgy
	 5AuW59JXWXMOOtPEskPOryF3Wc+58xCFr7u1A78WlagCvL5nIrtgp19Jtw9oo1OnQ+3iB
	 ZlfZ80VyTMmaEllVxBc0Nmj3AIJzutxNVJVHdCJFr/ENvTP0MA3rZzsFu1eDjtYgQKXXY
	 hMaO3zzZvDHyCS0R+N0mKS5zY6ezI82K6uq1XaJxqEGAflaV6E2OPJFBfj+BrtaVoN2iU
	 D2YKV7O/BgDo4mjQ1k5Wa0iRL3qAmOWcBPY01c5TLkduRtaVd6g+N8PSsXIGC/jgI8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3j17qP9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2792A606A31C;
	Thu, 26 Nov 2026 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3j17qP9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489391F000C6;
	Thu, 26 Nov 2026 14:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704897;
	bh=MALZG0MBgIberlXIYe4HVhv6D/MJblSL5YALpYzivL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3j17qP9reYD4Sl4ENjzYDymtbKr+NJ0PNgI73y0UQ7bncJtU8hfzQ0tgRyWCwTqZ
	 DsrNsNX0+NZ4ddsm1+TEIe+oq0C0TAaShbNyePJThys6GRiiVNvzTDlZxLpdL/Yd4d
	 +1wKnE4SuBZnhCSW1mObA/jdyLxrDiKwem5SLr1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/319] udf: validate vat20->lengthHeader and VAT inode size in udf_load_vat()
Date: Thu, 26 Nov 2026 15:36:22 +0100
Message-ID: <20261126144007.061606309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 98f95f0b6f8a7..c7e3cf9721c14 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1226,6 +1226,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
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
 			pos = udf_block_map(sbi->s_vat_inode, 0);
 			bh = sb_bread(sb, pos);
@@ -1239,8 +1245,12 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
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



