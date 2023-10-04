Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A151D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrPdsUe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D316CC433C8;
	Wed,  4 Oct 2023 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443306;
	bh=aB29Yyg9BmbcULk+av20IdxPCdG+3EoUEG4PDx3SsUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrPdsUe3Y2r+piFxSGc4AlOrLERuAmzXhuynn9wWtwodxFat8U+J5JneLinYNALgI
	 LtIfHYrmhsbniAzioYLyFxQxORNFSdKeW4R/G/vLA92FLtGu7lSH0KPpjZ+ufBPL5T
	 ZXKC1KsCV5jNgWuxBRDcSNRlgRVQFoznO8Te2Kvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Kearney <charles.kearney@hpe.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/259] spi: spi-gxp: BUG: Correct spi write return value
Date: Wed,  4 Oct 2023 19:54:43 +0200
Message-ID: <20231004175222.395255171@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Kearney <charles.kearney@hpe.com>

[ Upstream commit 1a8196a93e493c0a50b800cb09cef60b124eee15 ]

Bug fix to correct return value of gxp_spi_write function to zero.
Completion of succesful operation should return zero.

Fixes: 730bc8ba5e9e spi: spi-gxp: Add support for HPE GXP SoCs

Signed-off-by: Charles Kearney <charles.kearney@hpe.com>
Link: https://lore.kernel.org/r/20230920215339.4125856-2-charles.kearney@hpe.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-gxp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-gxp.c b/drivers/spi/spi-gxp.c
index c900c2f39b578..21b07e2518513 100644
--- a/drivers/spi/spi-gxp.c
+++ b/drivers/spi/spi-gxp.c
@@ -195,7 +195,7 @@ static ssize_t gxp_spi_write(struct gxp_spi_chip *chip, const struct spi_mem_op
 		return ret;
 	}
 
-	return write_len;
+	return 0;
 }
 
 static int do_gxp_exec_mem_op(struct spi_mem *mem, const struct spi_mem_op *op)
-- 
2.40.1



