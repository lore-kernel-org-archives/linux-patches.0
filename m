Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0BE20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC18CC433C8;
	Fri, 21 Jul 2023 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966632;
	bh=v3q6iOFd57LN3peKlvR/MEs4hnm9JuTc+dUi2cn6GtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0FSXivzeyZ5AETNRQff+lmXn+4cKBlFVIATDZUKmZqYKK0Ds707zDXjLyjjwJyzy
	 6zpMvN+/ey2liaqTlymm+X3eVYIPAeST6+ga7KC5GY4IbITH7YryxsHIH8nAMouw6U
	 C1ER4CzTwIN6YVWplZePvov9pViUmjHMz9FSg0o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 385/532] tty: serial: fsl_lpuart: add earlycon for imx8ulp platform
Date: Fri, 21 Jul 2023 18:04:49 +0200
Message-ID: <20230721160635.362530413@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
@@ -2632,6 +2632,7 @@ OF_EARLYCON_DECLARE(lpuart, "fsl,vf610-l
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1021a-lpuart", lpuart32_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1028a-lpuart", ls1028a_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx7ulp-lpuart", lpuart32_imx_early_console_setup);
+OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8ulp-lpuart", lpuart32_imx_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8qxp-lpuart", lpuart32_imx_early_console_setup);
 EARLYCON_DECLARE(lpuart, lpuart_early_console_setup);
 EARLYCON_DECLARE(lpuart32, lpuart32_early_console_setup);


