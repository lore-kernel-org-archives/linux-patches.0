Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C428F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ECEC433C8;
	Sun, 16 Jul 2023 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539302;
	bh=kUTzVbt6v1+/7/8zkBSuQt7LSFTI7XSJrX6zI3myGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXaeknLaefUazrzIlEv7QnmjyhTixSBBYfOd8nn4Uz/Ab8Omf1b5RdwPP9KL8CWUF
	 E65JMbFPJ4eq8zL3KU6KVDBuxs6YyEAwAnLIFGPF3pbUCUCBvTG/Mky2d97u1/1lDs
	 U+H/yHhN+RK/xCmeXpEGFt30ePqz924uaSomS6z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Yann Gautier <yann.gautier@foss.st.com>
Subject: [PATCH 6.4 728/800] mmc: mmci: Set PROBE_PREFER_ASYNCHRONOUS
Date: Sun, 16 Jul 2023 21:49:41 +0200
Message-ID: <20230716195006.028198474@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 3108eb2e8aa7e955a9dd3a4c1bf19a7898961822 upstream.

All mmc host drivers should have the asynchronous probe option enabled, but
it seems like we failed to set it for mmci, so let's do that now.

Fixes: 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.4")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Yann Gautier <yann.gautier@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230612143730.210390-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -2456,6 +2456,7 @@ static struct amba_driver mmci_driver =
 	.drv		= {
 		.name	= DRIVER_NAME,
 		.pm	= &mmci_dev_pm_ops,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.probe		= mmci_probe,
 	.remove		= mmci_remove,


