Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DBA1ED45
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37185C433C8;
	Tue, 25 Jul 2023 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285202;
	bh=50VYYlN5ZnXPVcTG10Pi+H9zWDwTDrgwuIK4gq47WTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPNwLSevLQlaX8Cuig1PK7PYK3kWbpv8+77QyuawJU2deJJoWdD8jYIUljvchKdPh
	 T8a9fdeIaqADcPh0GnDv9IValhUMkqL6aTNXHfUXFfe2rSEwxhubCYSVn8zLU1V6Eb
	 qCCr1PW/TQ5Wkw0PfFZyF4WHIHqNT6cBNqpzEjR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/313] hwrng: st - Fix W=1 unused variable warning
Date: Tue, 25 Jul 2023 12:44:32 +0200
Message-ID: <20230725104526.156913697@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ad23756271d5744a0a0ba556f8aaa70e358d5aa6 ]

This patch fixes an unused variable warning when this driver is
built-in with CONFIG_OF=n.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 501e197a02d4 ("hwrng: st - keep clock enabled while hwrng is registered")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/st-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index 863448360a7da..50975e761ca58 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -123,7 +124,7 @@ static int st_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id st_rng_match[] = {
+static const struct of_device_id st_rng_match[] __maybe_unused = {
 	{ .compatible = "st,rng" },
 	{},
 };
-- 
2.39.2



