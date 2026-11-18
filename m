Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024938;
	b=f13QuAhYWJmQIT704ep/SxX1oOK2hmbuRU9cHEKGy4LeyLwoRhrKT2aPMZZcWVAuTl88
	 aOnSb/pgKUuEXclqtGFE0iZrNp9pn4PJlu/exwKB3WN8pz6Xwruaxf2sVZsR+erbJTEKn
	 8Vm100DNeb8HoIDorO7Pcgo7+t7JufwJUXmK7sMbjFh0XAUbW0WLzjEx3FGrCMvPPLOJ1
	 LlB8Orkf6wHXeSl0Yesx4JclTSzISRyhyi8hhL+5Vciaq7EEN3LsO8rbwt2Ag5YI6ZQht
	 VL6nKAwegbX8N8ze+77NTnbbq3gjLPcNDLzRX+tg8En7ioueGI17zYHgHFLXmZEHN7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A/ElEcVFFY58BY05OXu0fgr4hkHSGwgKyMxN0AyJ4Q0=;
	b=A4U7OGhgxvG+ZArEFpY0EPu963WKWtGUNxHOC0xeze7hMBMJ0YA5BlBbM5gmaNvbxsUt
	 yDBr90njvVtlPxKNS1Pf9S9LTARz9GInjXmSDCzbv3IHedM0cJ+AJq3xfR+1GMfansytC
	 B2w/ZN3WCP7qWF/GD3Ll4RinzyI22z9amT8mxeF9rUiqpIBr2z8Kxx++Rs1vl3N8k88/a
	 6uhUtgg9Xf3+VSjfjdGGR531vF5Um1aAHl/2CaZp6H1z9Xj66KswaJMY/2nTThOlStleY
	 NylCEjatfIt8uH/gAPhGafPcoBnLdHMMY8zKXlz8AYHf4QNGhiDC/zSEKAvLA+eki7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QM/GP8zY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D05F606A31C;
	Wed, 18 Nov 2026 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QM/GP8zY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4CE1F000C5;
	Wed, 18 Nov 2026 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024938;
	bh=A/ElEcVFFY58BY05OXu0fgr4hkHSGwgKyMxN0AyJ4Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QM/GP8zYFPC0Z6gjWwMIz6ZWntc3mGbnq7Nc3BKMd9JX8P3dBiuDe4keY7hhS9R7v
	 5g0UcNU9Vg2NJTVlGU/toMF5mMHBz6OOmKOZYPLdfrvM4oLHAGWqFyaoJ8Ek7lvj99
	 zSvNdFNHc00hmCM0d9OAlTXnSVAM4CGmtqQwiUQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0901/2151] spi: spi-qpic-snand: set qpic_version2 flag
Date: Wed, 18 Nov 2026 15:43:56 +0100
Message-ID: <20261118150155.115123135@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 52efc89ccf664dcfa331fbdf2f5c8d3acd45a863 ]

The kerneldoc of 'struct qcom_nandc_props' says this about the
'qpic_version2' member of the structure:

  "flag to indicate QPIC IP version 2"

Since the SNAND controller is based on QPIC v2, set the flag in
the device specific properties.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20260924-qpic-snand-set-qpic_version2-v1-1-a0a9a3e0d06a@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 2f279516de4a9..9ac01f53c83b8 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -1642,6 +1642,7 @@ static void qcom_spi_remove(struct platform_device *pdev)
 static const struct qcom_nandc_props ipq9574_snandc_props = {
 	.dev_cmd_reg_start = 0x7000,
 	.bam_offset = 0x30000,
+	.qpic_version2 = true,
 	.supports_bam = true,
 };
 
-- 
2.53.0



