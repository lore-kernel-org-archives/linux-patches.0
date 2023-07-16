Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4442E8F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8A6C433C8;
	Sun, 16 Jul 2023 20:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539030;
	bh=J2lDcGqvpfLrSAW3RkTH9qO3IByZ+BTwfVAiaR7rBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdOQF/TXWghAJnVF3nphSdKbVbmO7n16KQky7GaHqNMCcq29OPXJzUhwO80/M1jos
	 qAdpW0M6F4f0DuievXo/yf2g+nQQUGhWrNAj5HvY9dnbmGG+qJmosNQCWAiJbCuw59
	 oQdBWOrLQxS6lwGWbQ6WUpkCp/oO7OSQDZc7AQRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 632/800] nvmem: rmem: Use NVMEM_DEVID_AUTO
Date: Sun, 16 Jul 2023 21:48:05 +0200
Message-ID: <20230716195003.792560068@linuxfoundation.org>
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

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 09dd7b993eddb3b48634fd5ddf27aa799785a9ee ]

It is reasonable to declare multiple nvmem blocks. Unless a unique 'id'
is passed in for each block there may be name clashes.

Avoid this by using the magic token NVMEM_DEVID_AUTO.

Fixes: 5a3fa75a4d9c ("nvmem: Add driver to expose reserved memory as nvmem")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <20230611140330.154222-6-srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/rmem.c b/drivers/nvmem/rmem.c
index 80cb187f14817..752d0bf4445ee 100644
--- a/drivers/nvmem/rmem.c
+++ b/drivers/nvmem/rmem.c
@@ -71,6 +71,7 @@ static int rmem_probe(struct platform_device *pdev)
 	config.dev = dev;
 	config.priv = priv;
 	config.name = "rmem";
+	config.id = NVMEM_DEVID_AUTO;
 	config.size = mem->size;
 	config.reg_read = rmem_read;
 
-- 
2.39.2



