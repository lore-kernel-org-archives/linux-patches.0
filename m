Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036129;
	b=kUiP86PUq68vMpImZgWJz6F5cjm4i8pMVRFq9YYC3cEpBDxtlvhWS5l4/iHMEEZBTy53
	 M5Vlvt58guMcF95XLzIRQeb4KDVpCHukslyoqep6tFBzgVCUcccnfSKp7a48Z/IZ5r9SG
	 Yk8zrI5kwuM0yvaIRBwgrpAqjdEgM3lOx3nVDpsfmOF/2419jMOOdnRTMI9HkzuXJ1zi9
	 m/U2SV1ucOXnULN+FGYyGqX5A9gbhAx+f0FyvA8XgBQWs7y5nT3+JY7oZxykTs2fHDvKr
	 VJW9775jLRM4eZQngdovZ+tGqmb0cPIy/ZgNLDgOul7gwq9rNU//BusAyfKL+MPuvzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Vq/fvT0xUnnh+iRvmgO3TqRBKenNthygkhyTF+lF/s=;
	b=f9TTvEavggU1nVdKGa87tw1TCmbAFH+axEmq9CIV3ewxmXyUGNzMD+6ep/ONOrY3B5oX
	 i2uZ6Hs+yl/+tEKu3Taub+mv8lns3vssCcm5TqaWqcVYh+hUI596e8RpR6ZrHZRt+/s8z
	 g7bxN6ggaUIWmYhgaTcpdVQQQpY3+uDfVS84XEtdYOPQefeL+t8dzzlOW7XMB0Bmo1/6Q
	 qj096OSQm/StpM6Qb/f1AELEhlzyNhhgfb5Oi26y1QAOMFkz8jrMSJcp7rTelGlU/BLm7
	 MMKNMvCzwr2sZfjiYO/i8/149XJKIMnA6EHxK+vzgmzrXGb8kTlT7nO+D5icgG8p9Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sEH084T/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E86606A31C;
	Wed, 18 Nov 2026 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEH084T/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DA71F000C4;
	Wed, 18 Nov 2026 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036128;
	bh=0Vq/fvT0xUnnh+iRvmgO3TqRBKenNthygkhyTF+lF/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEH084T/kX/39ThBgxak+DO57PgzyRBRq4SS4hHg7Nrjtec1+0uV+ZE0uMBzuXVak
	 pM+q4Sp8VQYVsRe4m/OXr+ev4jpTQk7mqWTTRk0ojudOC7q66Mr01q2i2ZOkHHgr9/
	 ayeMeu9VC8216ptiGP1iVOmxvK8EhuS6AvDzmTRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0949/3318] peci: npcm: Initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:26:11 +0100
Message-ID: <20261118150348.077330548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 425125e6d408b5969afb99c3e95a391f1f1ad81d ]

The PECI interrupt handler uses the lock and completion object as soon as
the interrupt is delivered. Initialize both before registering the
handler so an early interrupt cannot access uninitialized state.

Fixes: 3e16184a1bd8 ("peci: Add peci-npcm controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20260902152256.3591658-1-runyu.xiao@seu.edu.cn
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/controller/peci-npcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/peci/controller/peci-npcm.c b/drivers/peci/controller/peci-npcm.c
index ec613d35c7962..d0442c9306a86 100644
--- a/drivers/peci/controller/peci-npcm.c
+++ b/drivers/peci/controller/peci-npcm.c
@@ -254,14 +254,14 @@ static int npcm_peci_probe(struct platform_device *pdev)
 	if (priv->irq < 0)
 		return priv->irq;
 
+	init_completion(&priv->xfer_complete);
+	spin_lock_init(&priv->lock);
+
 	ret = devm_request_irq(&pdev->dev, priv->irq, npcm_peci_irq_handler,
 			       0, "peci-npcm-irq", priv);
 	if (ret)
 		return ret;
 
-	init_completion(&priv->xfer_complete);
-	spin_lock_init(&priv->lock);
-
 	ret = npcm_peci_init_ctrl(priv);
 	if (ret)
 		return ret;
-- 
2.53.0



