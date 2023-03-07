Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953F1BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169C4C433EF;
	Tue,  7 Mar 2023 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214339;
	bh=28H1ONkz1lDv/Iw0RjJPxoKVjR46cl+b9yllVLbZiW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYBh9bVdygG70StujXsqQq/Qn640FGYUEkE8nyHt98/yy5PydAcpoY+nWC6zA4M6l
	 14tj72yFeK8WeTLYpkGAv75mYEEUkGb6q5xqMJ9ZPfx/IS5pFnWQya4dXPyloST/94
	 MlPLZebeX6rUs1CTYpt9q4ttgtMTu+A/+02zWKtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Michael Walle <michael@walle.cc>
Subject: [PATCH 6.1 790/885] mtd: spi-nor: sfdp: Fix index value for SCCR dwords
Date: Tue,  7 Mar 2023 18:02:04 +0100
Message-Id: <20230307170036.220087095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

commit ad9679f3811899fd1c21dc7bdd715e8e1cfb46b9 upstream.

Array index for SCCR 22th DOWRD should be 21.

Fixes: 981a8d60e01f ("mtd: spi-nor: Parse SFDP SCCR Map")
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Michael Walle <michael@walle.cc>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/d8a2a77c2c95cf776e7dcae6392d29fdcf5d6307.1672026365.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sfdp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1222,7 +1222,7 @@ static int spi_nor_parse_sccr(struct spi
 
 	le32_to_cpu_array(dwords, sccr_header->length);
 
-	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[22]))
+	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[21]))
 		nor->flags |= SNOR_F_IO_MODE_EN_VOLATILE;
 
 out:


