Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688237C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44CDC433D2;
	Mon, 24 Apr 2023 13:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342893;
	bh=WCwKqnJbPO0ug/YEs/xjFE5nYUQexL3KC4dEgLZpWl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yN03Toc6KQ6JX5AYnfHPM4pKT4cy7oAGUJJ5Oxr9Wg8VSK7c+KITfFG855rIhF7Wx
	 w68JkDSQeU6hr8OOw3yABvFSSUFnG+lMnH0P1M77aOF+aryAsZuMbiTYHNl10RsCsE
	 75g0N3PcS7tZm6kOxPPhzW5a1AWu6TEvtsenjwjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 97/98] ASoC: fsl_sai: Fix pins setting for i.MX8QM platform
Date: Mon, 24 Apr 2023 15:18:00 +0200
Message-Id: <20230424131137.656198604@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chancel Liu <chancel.liu@nxp.com>

commit 238787157d83969e5149c8e99787d5d90e85fbe5 upstream.

SAI on i.MX8QM platform supports the data lines up to 4. So the pins
setting should be corrected to 4.

Fixes: eba0f0077519 ("ASoC: fsl_sai: Enable combine mode soft")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/20230418094259.4150771-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1541,7 +1541,7 @@ static const struct fsl_sai_soc_data fsl
 	.use_imx_pcm = true,
 	.use_edma = true,
 	.fifo_depth = 64,
-	.pins = 1,
+	.pins = 4,
 	.reg_offset = 0,
 	.mclk0_is_mclk1 = false,
 	.flags = 0,


