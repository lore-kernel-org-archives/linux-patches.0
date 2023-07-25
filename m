Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8E21ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8628C433C9;
	Tue, 25 Jul 2023 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284358;
	bh=iAaUF0teOsbXKN3hXRk6oighR7kW2X2iLdln2artBEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCp6qM6HnvGlzowb6XEuckFli7nYYRC3BJ+RtHvLwxlkdBFDp3d0ZKFuzpCzcOiH3
	 2vlXfsl32QALbyiEISZRWG0AzRb1mmqMmiSGq+wFwG5BIVIX2/ZGEc2Sc7/FNK8yd1
	 Q5l3+CqMlKEOPrapyyhzNrdHZgDmSfxy4EseAdJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 328/509] tty: serial: fsl_lpuart: add earlycon for imx8ulp platform
Date: Tue, 25 Jul 2023 12:44:27 +0200
Message-ID: <20230725104608.712052711@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sherry Sun <sherry.sun@nxp.com>

commit e0edfdc15863ec80a1d9ac6e174dbccc00206dd0 upstream.

Add earlycon support for imx8ulp platform.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230619080613.16522-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2589,6 +2589,7 @@ OF_EARLYCON_DECLARE(lpuart, "fsl,vf610-l
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1021a-lpuart", lpuart32_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1028a-lpuart", ls1028a_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx7ulp-lpuart", lpuart32_imx_early_console_setup);
+OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8ulp-lpuart", lpuart32_imx_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8qxp-lpuart", lpuart32_imx_early_console_setup);
 EARLYCON_DECLARE(lpuart, lpuart_early_console_setup);
 EARLYCON_DECLARE(lpuart32, lpuart32_early_console_setup);


