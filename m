Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DBF1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73675C433C7;
	Tue, 25 Jul 2023 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284318;
	bh=zYNoOPJMh8ggkk+5ZQUOsFyH7CT6cJD8QHQ1TTyo7KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guHZ7nfGpzl9GUtNadvIeVpGVI9MKxF+fS4zGVX5qul+GzcsexHYkCJAPcCF6okIw
	 C18D4kCkRheQxWeJiLSiQObJFB7mJfsaTlFSqQ/Xa28i46lBOEfnQYJWaIcP3QjtaV
	 9K0s2ZbLDAvPxWFmHNXmwFRCJmQ6cfoAGjWH4jzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Yann Gautier <yann.gautier@foss.st.com>
Subject: [PATCH 5.10 285/509] mmc: mmci: Set PROBE_PREFER_ASYNCHRONOUS
Date: Tue, 25 Jul 2023 12:43:44 +0200
Message-ID: <20230725104606.777095369@linuxfoundation.org>
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
@@ -2386,6 +2386,7 @@ static struct amba_driver mmci_driver =
 	.drv		= {
 		.name	= DRIVER_NAME,
 		.pm	= &mmci_dev_pm_ops,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.probe		= mmci_probe,
 	.remove		= mmci_remove,


