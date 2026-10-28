Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216595;
	b=iadaIhJgP36I9nN5ksIbV5LDnePEscU8MBkfcfJJmVYgGs2Xt8KlRjWaGfAG4PD5r1X1
	 JrABegx1a4Bhavlq0rYiyQgoAfIT4n0EGf+bJ121qejsuG9wcIV1NzY7xbfI+t0MYjMug
	 yxgdosZ5+qlGwaCO+9mxWx9853/v9b4sdNVIGqHpqynHPYFUNHv4VHdt0vu2hW2GP4E7I
	 QvhyV8s6j2Exai2YertRrYK6cEsN8EYWAn2LnfXueTxBxzOMIVQtpAKUr32pvS+1Aw0GT
	 WM3RwKHXtaq7JIxHU027JpKQIIFF0+CgDbjcnQlyfztrlcVw7aS8bjIVYTGp9QoKvQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFjfC2he5sMwUR0gE8R6/Qdzg5RlbWTxGIEFtVPmlrE=;
	b=ntqV+0lvNDvNzHqNxMVo+IP0d/vnyvV05UfzK75nDj9M2ieYImaw/52tWqpt6MV6hkb9
	 qjbRYGe5bt4hutEvNM/tDLEuspTX19HrwWOszxIHszJkCultRfhftLN+Ch3nU0lRTEaRB
	 SpM/CPnuR+CM8ymxOHcD6K/9lCoRiDEUNskjFxPUzHYEwT+jztTFED4/NNE4XqzEmHJkf
	 VJDswBMwiwDdlPPtHZYPAfMT/ZcNW0i+WIHU2SwuEXwRakhAotIPC2k7J4FaibfOn70zk
	 LM+whf2QKtVjTXcuYHbFe+/kcCn2aaBK1oArHS9az4Ms2Db0NGDWft6qwR5+1xbUlQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03Gu1QK2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4530606A31A;
	Wed, 28 Oct 2026 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03Gu1QK2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA1C1F01825;
	Wed, 28 Oct 2026 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216594;
	bh=jFjfC2he5sMwUR0gE8R6/Qdzg5RlbWTxGIEFtVPmlrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03Gu1QK2KkF/Glb+x/mMaWNvjH5L+awa4n8kB61wlm3Kl0gCuywC0BZ03VRrrdQZJ
	 I3BVRuhuk4eeSfrkHVms79zazFKCHxrLOPSV9bFoMu1qv+445rid97mlS4ON3vkvHh
	 Y7W8gIunPjAz+oJ1X2gliIc5w7kdOnBbYH1fyxyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1612/1887] scsi: ufs: core: Validate string descriptors
Date: Wed, 28 Oct 2026 18:01:48 +0100
Message-ID: <20261028170536.149550047@linuxfoundation.org>
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit d96e83d028d7d8762e424e49c671d49ac2ecf14f ]

The string descriptor length includes a two-byte header while the UTF-16
payload starts after it. utf16s_to_utf8s() expects a count of UTF-16 code
units, not bytes. Passing the payload byte count can make it read beyond
the descriptor buffer.

Validate that the payload has an even byte count, pass a code-unit count to
the converter, and allocate sufficient UTF-8 output space.

The raw string buffer starts after the descriptor header but its size is
bLength. Copying bLength bytes from that pointer can read beyond the
response buffer.

Allocate a zeroed bLength-sized buffer and copy only the UTF-16
payload. This preserves the raw buffer size consumed by the RPMB device-ID
ABI while avoiding the overread.

Fixes: 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
Fixes: d794b499f948 ("scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260717153914.26321-2-liqiang01@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0e9ea032711b9..f441fc0903a8d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3530,7 +3530,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 {
 	struct uc_string_id *uc_str;
 	u8 *str;
-	int ret;
+	int ret, uc_len;
 
 	if (!buf)
 		return -EINVAL;
@@ -3555,11 +3555,19 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		goto out;
 	}
 
+	uc_len = uc_str->len - QUERY_DESC_HDR_SIZE;
+	if (uc_len % sizeof(*uc_str->uc)) {
+		dev_err(hba->dev, "String Desc has an odd UTF-16 payload length\n");
+		str = NULL;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (ascii) {
 		ssize_t ascii_len;
 		int i;
-		/* remove header and divide by 2 to move from UTF16 to UTF8 */
-		ascii_len = (uc_str->len - QUERY_DESC_HDR_SIZE) / 2 + 1;
+		/* Allow up to three UTF-8 bytes per UTF-16 code unit plus a NUL. */
+		ascii_len = uc_len / sizeof(*uc_str->uc) * 3 + 1;
 		str = kzalloc(ascii_len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
@@ -3571,7 +3579,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		 * we need to convert to utf-8 so it can be displayed
 		 */
 		ret = utf16s_to_utf8s(uc_str->uc,
-				      uc_str->len - QUERY_DESC_HDR_SIZE,
+				      uc_len / sizeof(*uc_str->uc),
 				      UTF16_BIG_ENDIAN, str, ascii_len - 1);
 
 		/* replace non-printable or non-ASCII characters with spaces */
@@ -3581,11 +3589,17 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
+		/*
+		 * Keep the bLength-sized raw output for the RPMB device ID ABI.
+		 * The two bytes beyond the UTF-16 payload are explicitly zeroed
+		 * instead of being read past the descriptor buffer.
+		 */
+		str = kzalloc(uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
 		}
+		memcpy(str, uc_str->uc, uc_len);
 		ret = uc_str->len;
 	}
 out:
-- 
2.53.0



