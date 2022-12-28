Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489C21C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BAEC433D2;
	Wed, 28 Dec 2022 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244970;
	bh=s7lPuJO64XoxTpWwwWLil0xLgbrLrvjPg7f6L9jckcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF+uJmDhudpp3LR87p1iGtJOv4sHzyG7aMukZOwH9qzlbIY4t5yzybhFp0Wa6x1cT
	 jgOwJLVaHeaoOSn7f8CgJ/q7Y/ygv/LOn4d/bY7NLEcr0/LNHlPni4qlt/888Ttfdi
	 HFA0J8XWCGOazGiGxXnnX+CgxohVtYoC1ufXlkMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0808/1073] powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()
Date: Wed, 28 Dec 2022 15:39:56 +0100
Message-Id: <20221228144349.956320506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4d0eea415216fe3791da2f65eb41399e70c7bedf ]

If platform_device_add() is not called or failed, it can not call
platform_device_del() to clean up memory, it should call
platform_device_put() in error case.

Fixes: 26f6cb999366 ("[POWERPC] fsl_soc: add support for fsl_spi")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221029111626.429971-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/83xx/mpc832x_rdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index bb8caa5071f8..dddb5c6f8120 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -107,7 +107,7 @@ static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 
 		goto next;
 unreg:
-		platform_device_del(pdev);
+		platform_device_put(pdev);
 err:
 		pr_err("%pOF: registration failed\n", np);
 next:
-- 
2.35.1



