Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026759;
	b=EB5c+9UNzOdzeGoNzwmZkSADOnSw5ViJHV79KEcO1U+pJr5Qro/4+wulCbON7NhISAvG
	 M/Rih2+Luti/9duDGhzrvGc4DJgxsOn8CIWuJUJuiK9t/TEIzmxVUzaOSwjICAd2tMrP9
	 WPeK5E7ix6/IUTpIZEMX7Ngg69rPa3idK/l9quq5IrSqs80mjiwTs5PPmH/nNTOiZhTs7
	 O+PyDFrKjFVqR/WWqOBIrM0Wbs9MA5ViU7FJ5OGOrIjWxSf2dVK8CHt55Iv7TtX2UXr+F
	 H+p+zYjDHORolPSAAY7VlThbWP4XBe//FXLRI096Er9TdHHDN3DGD7loyvMiijz/6Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gtgj6kUy1+tkBy2HP0d2f2YV4VcOgstqZPu5dSEQyls=;
	b=mbAfpxcniBdgrFAWOV02zxfrLaT/sTiiLZRHHw7Tu96nWmlD0c/+b+yCeh4D3qm2qQ6h
	 l4Yi9kd5w98ha3Fh680Zp5c4cOOKAn422uTSXpZcrH5gw+tc2AYaY7Hooj8srUO37rMwW
	 kwaYYbflGkzDtDJIqwBVExPFuk69zKj6RktYq2u5JXCmq2zZsH6At6AbG7hmZp+8fAJaV
	 z9K/5O6FZopfBh7Il2VJ62CI4PP6FM90l9QzzeKRjznJRBBFEloeKq6QgPbvheDfm+L4c
	 jB+djpAbHLgTByyLl4pe7Kruf9WvBmDM12SejWbH8rEe6Ac2maKJrC3kRT0WsvlPIIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhIGlzI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D22D606A31C;
	Wed, 18 Nov 2026 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhIGlzI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A191F000C4;
	Wed, 18 Nov 2026 18:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026759;
	bh=Gtgj6kUy1+tkBy2HP0d2f2YV4VcOgstqZPu5dSEQyls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhIGlzI1YbObBgYBRQ0DM6S/5pNEcOHxQDi+ZOdw7NF5e9+ppIEUGvkmo7JyAxFIW
	 FOYFa25xnOL1/xObh055EWDMz3pOA/kGA7WrCRDecf7D7OLks28b/JTSJn9/Cx4vo4
	 00LhRIv9qpczSieHYzr8sxOm3YqVJWr6lPGNMLHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1548/2151] Bluetooth: btintel: Zero version data before parsing TLVs
Date: Wed, 18 Nov 2026 15:54:43 +0100
Message-ID: <20261118150218.302046314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit cf87709d7ff83b4de5d42b61e4a9806fe374cb9d ]

Firmware may omit optional TLVs, leaving their corresponding fields
unset in the caller-supplied struct intel_version_tlv. Since the
structure is typically stack-allocated and not cleared beforehand,
fields for which no TLV is received retain uninitialized stack
memory. This stale data can be logged via btintel_version_info_tlv()
and copied back to the caller, leaking kernel stack contents.

Clear the structure in btintel_read_version_tlv() before parsing so
that fields with no corresponding TLV are deterministically zero
instead of containing garbage.

Fixes: 57375beef71a ("Bluetooth: btintel: Add infrastructure to read controller information")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 704feeee3233f..f56a4ebd26ed8 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -732,6 +732,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
+	memset(version, 0, sizeof(*version));
 	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-- 
2.53.0



