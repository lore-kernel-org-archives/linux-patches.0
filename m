Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035779;
	b=XfJ+rxvdGELaT4mxcbrB04aDsGJ9ACZwMCkFVD6axbIoBq0oIUSMTInMGTbo6zIIDaTB
	 i8T/TGIS3iQq1z07jwX3eWq+jkZlnlbkK2rTaBnKEWpnU6/KLvyntGB1HhckKmSafyhtP
	 0h8mDzHagqONAOJylauczKJRxFDUoRC8DVu2bxp/j7WLqQwc+tUWonnicXmu3bJ0F7Zqy
	 j7OKM7kdnebQGwK2trPj+GdHo3g48GU/7yN+XKdYONPv1GiFIgEyuCQdljL44cYDntrLt
	 +xmLNmf0BRZMJbZZCZkOEHK3JS/xkHFMv5LABLEky8ZhpwJ+Xzk8ODhaIezF8ktbEeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+QZNHAY/hTQclkoQY3b3bgcnViM55ehmC2P7Kmm9YQ=;
	b=fBLBTIkW537yGK9l/8TSVX+pzvvlcij+Y7yJ/VIrFEAT+Z/Q3im4RCO+jE0tqqHSDdtx
	 X3A8SSP8/buvgZLGHCfSSfLQgdoD5+YMcMIXwLpARw1lse8CXXCXh/W3jh5LT/dGChHRG
	 jp7DaiX7EBshEVB/6HYoVp26aUjdkYEQef7U2TxK9TF6M+pi+yV3scqyO76cmVSbpKUnE
	 tz09zUwHva9wOh3zG74OLFZ7RxooRnBc4J73J7Wmmpq1hwSo4rCw+4O1HEGspy5FqvJVW
	 sgagVSKsTGkpP6QAOn5mksUoV/YIMMke2wElCEaME86JZ1ij5uQpoiLfYCXVByxA/8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3rRnZM1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F20606A31C;
	Wed, 18 Nov 2026 21:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3rRnZM1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71F71F000C4;
	Wed, 18 Nov 2026 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035779;
	bh=H+QZNHAY/hTQclkoQY3b3bgcnViM55ehmC2P7Kmm9YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3rRnZM1BzCQ+JXTKaJcc6plBIVkOONnJ8nZSLT8Iu0G3+yWFsiQEnQX2+/+ddFFN
	 JsW+Y+zefzqw+9vuW0Rw10zwpu059OLUVjJIBIT5jI/Qf0TV/LYJHvpzfNKwj3YMm1
	 SMtgoFcfkb7uvAaxRC9VSEr961bnlPIKepzpmOuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0823/3318] mtd: spi-nor: sfdp: check the length of the SCCR map
Date: Wed, 18 Nov 2026 15:24:05 +0100
Message-ID: <20261118150343.757034498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 1413f38f37194673502e61cd3749e091c031370b ]

The spi_nor_parse_sccr() sizes its buffer from the table length the
flash reports in the SFDP parameter header. But it then reads DWORD1
and DWORD22 without ever checking the table is that long.

So if a flash reports a length of one, the buffer is only four bytes
while DWORD22 sits at byte offset 84. With a length of zero kmalloc()
returns ZERO_SIZE_PTR rather than an error, so the NULL check doesn't
catch it and the first read dereferences it.

To fix this, reject a table that's too short for the highest DWORD the
parser reads, the way spi_nor_parse_4bait() already does. The table is
optional, so this isn't fatal. The spi_nor_parse_sfdp() warns and
carries on.

The spi_nor_parse_sccr_mc() doesn't need the same check. It works out
the number of dice from the length it allocated with, so its highest
index stays inside the buffer.

Fixes: 7ab8b810757a ("mtd: spi-nor: sfdp: Add support for SCCR map for multi-chip device")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sfdp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index daa59fd416e04..a4dde12f33a8f 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1248,6 +1248,7 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 }
 
 #define SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE		BIT(31)
+#define SFDP_SCCR_DWORD_MIN				22
 
 /**
  * spi_nor_parse_sccr() - Parse the Status, Control and Configuration Register
@@ -1266,6 +1267,9 @@ static int spi_nor_parse_sccr(struct spi_nor *nor,
 	size_t len;
 	int ret;
 
+	if (sccr_header->length < SFDP_SCCR_DWORD_MIN)
+		return -EINVAL;
+
 	len = sccr_header->length * sizeof(*dwords);
 	dwords = kmalloc(len, GFP_KERNEL);
 	if (!dwords)
-- 
2.53.0



