Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044945;
	b=Fg0YiOwlIgeJ6cSmfUji3udVCad6MiZrOaPR6y9euYjF4qQ7zxszEMA4hU/6ly5DLal7
	 P7YTqaxLimSxH9O3iEP7Y5y6Dw4IW4iRyRL802UMG7WNXbm9EVnOvlKP8G9uVNYh8qP/g
	 d6uHe+PzfkhIlSTuhvkNkhm6zm8mttyvFh0bwTPwKupeoKHsAPjqfufQf1blaeVOD9ToG
	 ZBohRAilMzf74HL+wxl/yMN1QQ4Cl653F3AK1CmRN8XRQlxnJLn3PQ3cTDNEBR7Q9BtXj
	 2jZVcZc8KwPal275KgYdH+eiCJQKcX00I2r9IxhPcttQSWq37t9Pf4upxNndf5PQRuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jydgW45lFgG4e4ND4uMRxR1J1tWOp5XzHXbv2shJcfs=;
	b=YExC7owRaTZKhscXZNIV8TfifzfZg2gAbntyAys4SJjdK6Xv6QEaNjqd/Fj35rPTQrD4
	 sT/cIAqgfbWpSMAHZYTO3EdM4Ghv7SohNPxniJpW2cSPiP/ZiJBeMs5e0Z1Vs9cjziHXL
	 KAoM/BWlcDVluxno5EaASalmfIY89wVbEnM9JURFXEcExaYzhRDmMwC2EaeJR12X38ye4
	 VeiU4HC8yeKhXLaVSn4UWLdzu1bME50M/qmxStGtDTVSXrHMqLOZCiRGDOl+dyb4Uh4GP
	 6mntCYsQlsFb0gP2lYQZsug7g4+Wwt8/jm9JjDIM210nfTDj+tlHeEq+yJg/9PoCnPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCjjdsHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C32606A32F;
	Wed, 18 Nov 2026 23:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCjjdsHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CD21F000C4;
	Wed, 18 Nov 2026 23:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044945;
	bh=jydgW45lFgG4e4ND4uMRxR1J1tWOp5XzHXbv2shJcfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCjjdsHHgizN4fbm+iUWeMPqFxsFx89CzRsqmS9h64xfCKQ6QtfjFInAIBbPCYYsv
	 zvZmrSPFjlBnNHevOT9UisSS3ksBk82Ql8ZfpjGBu/2zPNAx55/45QwOyhnjSsrqfl
	 quWm4BYxpEc+epW+VRzFouWDfCwOx8QEJdPETTk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0731/2857] mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table
Date: Wed, 18 Nov 2026 15:29:25 +0100
Message-ID: <20261118150227.870803714@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit b9f34a95a81021fa1f3c9cb8cfd458e66824cad6 ]

The spi_nor_parse_profile1() sizes its buffer from the table length the
flash reports in the SFDP parameter header. But it then reads DWORD1,
DWORD4 and DWORD5 without ever checking the table is that long.

So if a flash reports a length of one, the buffer is only four bytes
while DWORD4 and DWORD5 sit at byte offsets 12 and 16. With a length of
zero kmalloc() returns ZERO_SIZE_PTR rather than an error, so the NULL
check doesn't catch it and the first read dereferences it. And the value
doesn't just get thrown away. It ends up as the dummy cycle count for
8D-8D-8D fast reads.

To fix this, reject a table that's too short for the highest DWORD the
parser reads, the way spi_nor_parse_4bait() already does. The table is
optional, so this isn't fatal. The spi_nor_parse_sfdp() warns and
carries on.

Fixes: fb27f198971a ("mtd: spi-nor: sfdp: parse xSPI Profile 1.0 table")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sfdp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index f738f6d5219a9..d13f5988c34ff 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1142,6 +1142,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 #define PROFILE1_DWORD5_DUMMY_166MHZ		GENMASK(31, 27)
 #define PROFILE1_DWORD5_DUMMY_133MHZ		GENMASK(21, 17)
 #define PROFILE1_DWORD5_DUMMY_100MHZ		GENMASK(11, 7)
+#define SFDP_PROFILE1_DWORD_MIN			5
 
 /**
  * spi_nor_parse_profile1() - parse the xSPI Profile 1.0 table
@@ -1159,6 +1160,9 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	int ret;
 	u8 dummy, opcode;
 
+	if (profile1_header->length < SFDP_PROFILE1_DWORD_MIN)
+		return -EINVAL;
+
 	len = profile1_header->length * sizeof(*dwords);
 	dwords = kmalloc(len, GFP_KERNEL);
 	if (!dwords)
-- 
2.53.0



