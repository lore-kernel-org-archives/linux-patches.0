Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90AC13AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AAAC433C8;
	Mon, 26 Jun 2023 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804162;
	bh=ix6j8afGVxIzL3s2P4mVFN2x2KgsncL7lEv2rQhiVU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXqMmrUGaqvoe9qkqaSVwox9dvDAvUy0gBA09z+MFPjLaC/4aDaiMBEH0RC5jVngN
	 xa/LpIJLElppV9ub10aLIr4nNxNDMn1dq/8Ut8P7q/T5yzOKfPwFROJYpoOhBbn/7i
	 1NL39ZKNfeU/3OOb2w/Wa6ktZtykqDubpNh1igTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Gabriel Somlo <gsomlo@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 063/170] mmc: litex_mmc: set PROBE_PREFER_ASYNCHRONOUS
Date: Mon, 26 Jun 2023 20:10:32 +0200
Message-ID: <20230626180803.410587710@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

commit f334ad47683606b682b4166b800d8b372d315436 upstream.

mmc host drivers should have enabled the asynchronous probe option, but
it seems like we didn't set it for litex_mmc when introducing litex mmc
support, so let's set it now.

Tested with linux-on-litex-vexriscv on sipeed tang nano 20K fpga.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Gabriel Somlo <gsomlo@gmail.com>
Fixes: 92e099104729 ("mmc: Add driver for LiteX's LiteSDCard interface")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230617085319.2139-1-jszhang@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/litex_mmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/litex_mmc.c
+++ b/drivers/mmc/host/litex_mmc.c
@@ -649,6 +649,7 @@ static struct platform_driver litex_mmc_
 	.driver = {
 		.name = "litex-mmc",
 		.of_match_table = litex_match,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 module_platform_driver(litex_mmc_driver);


