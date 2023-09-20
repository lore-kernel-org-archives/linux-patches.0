Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4942630FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47DEC433C9;
	Wed, 20 Sep 2023 12:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212929;
	bh=yLzGhFiN0s1HqUn+kLtTdVtZvZSQ2Z+OwC6qxBJcg78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeJcV8rVMdbQrpS5ko5J7YoCYx6Vli18iaCPAYzyvW3YMH0yGpCDLnyNhj3X9otfn
	 aJMEv2DKEqdLTZkVZwXknx8ofYgJGSaq3gVfzjTojWON3wYJiv8rU9IyFViQrI2V3A
	 gkaYnpctlgMgMAcMciNG6Q+k2ZMGPMhZEydoYBSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/367] hwrng: iproc-rng200 - use semicolons rather than commas to separate statements
Date: Wed, 20 Sep 2023 13:27:28 +0200
Message-ID: <20230920112900.360085928@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit f9dc446cb959d1efdb971fb3cde18c354a4a04c9 ]

Replace commas with semicolons.  What is done is essentially described by
the following Coccinelle semantic patch (http://coccinelle.lip6.fr/):

// <smpl>
@@ expression e1,e2; @@
e1
-,
+;
e2
... when any
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 8e03dd62e5be ("hwrng: iproc-rng200 - Implement suspend and resume calls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/iproc-rng200.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 92be1c0ab99f3..472f37f41317e 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -202,10 +202,10 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 	}
 
-	priv->rng.name = "iproc-rng200",
-	priv->rng.read = iproc_rng200_read,
-	priv->rng.init = iproc_rng200_init,
-	priv->rng.cleanup = iproc_rng200_cleanup,
+	priv->rng.name = "iproc-rng200";
+	priv->rng.read = iproc_rng200_read;
+	priv->rng.init = iproc_rng200_init;
+	priv->rng.cleanup = iproc_rng200_cleanup;
 
 	/* Register driver */
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.40.1



