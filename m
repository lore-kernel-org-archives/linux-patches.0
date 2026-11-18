Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017951;
	b=34hUvviJvdbUBW9QkM1KmHkZwtKkIvgLFovxLGTJ1hQeXgoLfsTgGqhvIxkDMJV8Icqm
	 26QrkPFC7/w1GlMaBUJ0Lr68yLSvGBJndWb12MwhefQbAljuSSdjbZdl+TbRIbm6rlU4F
	 Ws0zw81ReYL6stlAyLpYY9W5IOORNlacVeFxR1Qas9Tr0WSLW/SZak7VcHVUo+rcZ7yhO
	 USAmZsRQC6u+X/8uuOoLypj7YwAhwAnJdgos2aeyrB+q0/Ll1QmY/hhUbixRtEoaDLmzA
	 KgNG+Zug8MNRFsM0rhRAlT9F+pI5qXEHEbNH3Ucv+kK7KZeWE124DnZqc8NaxuUOK3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r6bNgVKzI495r0UcdlRG6GzYT7IvPYo7ouInt1tljqY=;
	b=xG/TfUhfQqa4QwURKeaV5Y7Qf995rIa/H+/9HZuo/ZWbIEl8a38GdDmNO/qdBc60M7TN
	 z8eHdhHILalQDuMvWAdOA4b22qiwrN7Hw47Xnivp3+nf3+/8Xf50onBMqk832/AG3d1FG
	 SJ0hySMSjxZHnXLGcoHwCJ5GaYdiam/ZkgbrF3x0y41kioYQF9f/CtNc0TqCDIejv+vjt
	 yjinzKaBqds1pCn2P9QFlw5bPJ2BePG5a47/+PbFJwkv7yiInH9aFB//Nvaa01mAxlM3d
	 +GjudkoCHyPOy+njGO+FiD5voIXcDhVAcOI+0cYnKSvhVKwVCYgqSOIPezGsxcKjVKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkfVSHzC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E9E606A320;
	Wed, 18 Nov 2026 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkfVSHzC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773C71F000C4;
	Wed, 18 Nov 2026 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017951;
	bh=r6bNgVKzI495r0UcdlRG6GzYT7IvPYo7ouInt1tljqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkfVSHzCyihyz8PdmwT+Ckl26Cszqr7HzT0nqcCX9x9w4yAmFFFANA3Sv7nn2FP1z
	 p41XAcxLohmdirX6wJ98vC/h3i3MAIkz++BqLi99O2xWeOhrV7zTG2w87hZkaLVdpG
	 mJKDf4YoTfgtNbDoXklgcnq7IZUARVQopLu+2pFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1067/2651] spi: spi-qpic-snand: set qpic_version2 flag
Date: Wed, 18 Nov 2026 15:38:27 +0100
Message-ID: <20261118150326.395074145@linuxfoundation.org>
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
index 684c3b9486b77..48628ae6e70f4 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -1701,6 +1701,7 @@ static void qcom_spi_remove(struct platform_device *pdev)
 static const struct qcom_nandc_props ipq9574_snandc_props = {
 	.dev_cmd_reg_start = 0x7000,
 	.bam_offset = 0x30000,
+	.qpic_version2 = true,
 	.supports_bam = true,
 };
 
-- 
2.53.0



