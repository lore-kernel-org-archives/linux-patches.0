Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063866;
	b=Cf6MzDXhclyWsBYt6zMdJwsfiB6fvqeeM9W5BHIIhEhm09wNLPOgCaRGPyX2ZsojA7ND
	 v39wzdBdAQS2k87jLa2Qgh/8VSm0QbTAubRE4xyuVjx2Y/HRjnsb/Lfk7u9Ke2rbtw+XA
	 +caQ+LkFa/tZdmzcoINPXf1JegJnPAT6h/H3TWjiGEOIp2SAXAbHHEnpedZ+Z7wqMYngG
	 xCdSA/tP2A0Y8RiqTr9OEGYQxdSQNPtHMmGe6qP8z2duKxS+D2rjRGIl0IFDZEGJ/8t7s
	 EVFF7ya9Be/IhXXiwRnmVThAjL06lyOzZWv2N2nUJ8U6AMFmpCWf9pDs0lBFUacm7zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0F2aXkura/PDY956ZAaTYnBTfrCOp8m/u29mNBPlPCM=;
	b=mQiDrOWUT+1dvmfFkhHIOIoK9YKrW9vQrz5VYThxdjRuaeuRfmh5BMbXIHJ/5tFXk8qm
	 8NG8HrGIwrPM/57ncTbWbK2xHaaLC3QlUtwz5CUZEIn9aVF28KU20lxGpCPg/vW3TfuN6
	 FyeAYHQuv2tWqqXCnUPKHjK+OzFjav7aawfD5nj6smKL+Ef470ZrEGFppTnAeMXUWk3fr
	 XgT2aRdr75aNSfTe3L10QBoQimwWjenoctD0Va3VG53g1fQjj7n4/GF+5UFDIz4unOfnm
	 AWUf+Engo8Ba/ZWrnjMz2SyUJhkiEomu+n3P0KVkKi59dxsshM42NY5mSllf310fcDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A+P3aNe5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2822E606B883;
	Sat,  7 Nov 2026 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A+P3aNe5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB85D1F0089F;
	Sat,  7 Nov 2026 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063866;
	bh=0F2aXkura/PDY956ZAaTYnBTfrCOp8m/u29mNBPlPCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+P3aNe5UWSBVWNl/dz3CkWVNF2Wj2PKdIjj2FZ24oUDZjBeya9hukkPa7rBozo2k
	 dFACwV/EpA6DcD34FwNv9sY1mJxOhgFZrf9maUkmxPS/iZ1iwJokstnirlmSb+h3x2
	 S4d/K+mzjQeZeoK3Ty6+5eCDRxl0CeLo2RLfNlAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0045/1257] soc: qcom: geni-se: Fix write to read-only firmware buffer
Date: Sat,  7 Nov 2026 08:39:01 -0500
Message-ID: <20261107134940.653563845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit 28b9c15f1829fff7b26db0dbbbde1c6b466cb156 ]

geni_find_protocol_fw() casts fw->data to a non-const struct se_fw_hdr
pointer and writes back the rounded-up fw_size value:

        sefw->fw_size_in_items = cpu_to_le16(fw_size);

The firmware subsystem maps the firmware blob read-only. Writing through
the cast pointer causes a level-3 permission fault on AArch64 and
crashes the kernel during driver probe.

The write-back is no longer necessary: geni_find_protocol_fw() now
propagates the rounded size to the caller via fw_size_out. Remove the
write-back and make sefw (and the hdr pointer in the caller)
const-correct.

Fixes: d4bf06592ad6 ("soc: qcom: geni-se: Add support to load QUP SE Firmware via Linux subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260821-fix-write-to-read-only-firmware-buffer-v3-4-43e6a3abd651@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 11ca8223fbcd6..6ac2bdc16984c 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -1238,17 +1238,17 @@ EXPORT_SYMBOL_GPL(geni_se_resources_init);
  * controller. Validates the firmware size against the hardware PROG_RAM_DEPTH
  * read from SE_HW_PARAM_2.
  *
- * Return: pointer to a valid 'struct se_fw_hdr' if found, or NULL otherwise.
+ * Return: pointer to a valid 'const struct se_fw_hdr' if found, or NULL otherwise.
  */
-static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct firmware *fw,
-					       enum geni_se_protocol_type protocol,
-					       u32 *fw_size_out)
+static const struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct firmware *fw,
+						     enum geni_se_protocol_type protocol,
+						     u32 *fw_size_out)
 {
 	struct device *dev = se->dev;
 	const struct elf32_hdr *ehdr;
 	const struct elf32_phdr *phdrs;
 	const struct elf32_phdr	*phdr;
-	struct se_fw_hdr *sefw;
+	const struct se_fw_hdr *sefw;
 	u32 fw_end, cfg_idx_end, cfg_val_end;
 	u32 prog_ram_depth;
 	u32 fw_size;
@@ -1290,7 +1290,7 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 		if (phdr->p_filesz < sizeof(struct se_fw_hdr))
 			continue;
 
-		sefw = (struct se_fw_hdr *)(fw->data + phdr->p_offset);
+		sefw = (const struct se_fw_hdr *)(fw->data + phdr->p_offset);
 		fw_size = le16_to_cpu(sefw->fw_size_in_items);
 
 		if (le32_to_cpu(sefw->magic) != SE_MAGIC_NUM || le32_to_cpu(sefw->version) != 1)
@@ -1299,10 +1299,8 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 		if (le16_to_cpu(sefw->serial_protocol) != protocol)
 			continue;
 
-		if (fw_size % 2 != 0) {
+		if (fw_size % 2 != 0)
 			fw_size++;
-			sefw->fw_size_in_items = cpu_to_le16(fw_size);
-		}
 
 		fw_end = le16_to_cpu(sefw->fw_offset) + fw_size * sizeof(u32);
 		cfg_idx_end = le16_to_cpu(sefw->cfg_idx_offset) +
@@ -1437,15 +1435,15 @@ static int geni_load_se_fw(struct geni_se *se, const struct firmware *fw,
 	const u8 *cfg_idx_arr;
 	u32 i, reg_value, fw_size_in_items;
 	int ret;
-	struct se_fw_hdr *hdr;
+	const struct se_fw_hdr *hdr;
 
 	hdr = geni_find_protocol_fw(se, fw, protocol, &fw_size_in_items);
 	if (!hdr)
 		return -EINVAL;
 
-	fw_data = (const u32 *)((u8 *)hdr + le16_to_cpu(hdr->fw_offset));
+	fw_data = (const u32 *)((const u8 *)hdr + le16_to_cpu(hdr->fw_offset));
 	cfg_idx_arr = (const u8 *)hdr + le16_to_cpu(hdr->cfg_idx_offset);
-	cfg_val_arr = (const u32 *)((u8 *)hdr + le16_to_cpu(hdr->cfg_val_offset));
+	cfg_val_arr = (const u32 *)((const u8 *)hdr + le16_to_cpu(hdr->cfg_val_offset));
 
 	ret = geni_icc_set_bw(se);
 	if (ret)
-- 
2.53.0



