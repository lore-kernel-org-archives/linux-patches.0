Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2EABA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0C8C433D2;
	Tue,  7 Mar 2023 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216269;
	bh=4P5TuRBE3G2Dkoitm0Uu5f+v6362AKaf5b2iJeqENnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU0Xilx1MLfGl1k0tSak5gqZY413Uk9RxMujljtSgN6teRNezyx2uoxUmAaMvG6hT
	 Qbegl90lfrHumNrHHAceyqtR30FMhc15x8QcBngtZgime1cyhe+6UbHr8sJ5zFWQF2
	 YWbDAeP2yfJSLP9KR37enGhhSVsu/OIov8KHts5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Michael Walle <michael@walle.cc>
Subject: [PATCH 5.15 502/567] mtd: spi-nor: sfdp: Fix index value for SCCR dwords
Date: Tue,  7 Mar 2023 18:03:58 +0100
Message-Id: <20230307165927.724448078@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
@@ -1220,7 +1220,7 @@ static int spi_nor_parse_sccr(struct spi
 
 	le32_to_cpu_array(dwords, sccr_header->length);
 
-	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[22]))
+	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[21]))
 		nor->flags |= SNOR_F_IO_MODE_EN_VOLATILE;
 
 out:


