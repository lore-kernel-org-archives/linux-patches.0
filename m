Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E52200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BB7C433CA;
	Fri, 21 Jul 2023 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966315;
	bh=J2lDcGqvpfLrSAW3RkTH9qO3IByZ+BTwfVAiaR7rBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2vqfqCxTxDvvwLGEL2eDaii8+8f+0kYrvGZkahKoGMWQGVwjvfuaGcA/BQ9o6l1k
	 kezmmIU73GBUuXPgYSIknVdwVS7eilPlj+llhDyAh0sCsZQhH2+RqHXqsDtT8dY5PX
	 6RyDgSKvi/QkIhIcfTas4u3rtD04E7PeN1prnQTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/532] nvmem: rmem: Use NVMEM_DEVID_AUTO
Date: Fri, 21 Jul 2023 18:03:25 +0200
Message-ID: <20230721160630.724973843@linuxfoundation.org>
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



