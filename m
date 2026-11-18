Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052089;
	b=DPQwWnC/3hn17phl6/PJxy8pi/4Kb1fFyN5AOB2Z9JbuFFHeQUxy+mcDtNy1Gawp1GsZ
	 xZMOpq0Wy0DLZfJUBXUGi5iu8fNtmvWgfgWuMq4bAPJG2q3T4BwptcgAtJAkz6uxWVqLU
	 e6nq2Y0iyuCsrpz9K90dEwqs1Y+xz2NrKQvftKNqxaPeikcbFgd8HIdSTfpVuGiBV0/1p
	 3urjz7CK9bMYMrdKHB87blXQSYFayJ7sR1pSnXLSzJWLA84RsGPf66MgE0fjHfvhDBV9l
	 CosDCdApJP95reYXVFBK3n7jJE4obwCT2KgY0ML3XMFu4ulCqhaSzbE86e0LLM4F1WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8xD8AGY4qRzeE+Ogmuq5IyBaDMPLEoRUgTd/k10YEJY=;
	b=0HQTaMCV6IIdv9EkyNVIUyIXU3FENI4ep9b8CCF3x0+Ec5aUjpKU9pFWXQLoI7SNHEcg
	 cCDo+y+IkqEwKwEVh7CVqmRWWz6fjckdntBTXnkqfi2vJcLnaGfUFVP8Bzdy2iA+Av66H
	 1trR7lM4do47r75JTxFfehvk5w0aB82nXbFAIB69b/PaYkMmOm7Dv5yRBkF4W4UUqC5/F
	 fGhjIKwGuFlfiYr1zeNpBJBl9TLtU21yXEZ+eWi/rDrzuf97VnOF2WwbgUFKd4HK1Heh8
	 lwpWGXNFYvv/HrlzXV15JmQ1vIena7zc+Q39ENz7mnaB40Nuv8XFdBG26sfd6UEgn1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AfaYIlmU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6227606A325;
	Thu, 19 Nov 2026 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AfaYIlmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1231E1F000C4;
	Thu, 19 Nov 2026 01:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052089;
	bh=8xD8AGY4qRzeE+Ogmuq5IyBaDMPLEoRUgTd/k10YEJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfaYIlmUjrfY3bkvlwFo1lom5oezsk3lWmFisxWsNtkNUrYd3pLb9/4G14VyqSh6N
	 GClZxIk1tNg000JFetAqrnwJNvTivBIlpafEF7W2UOxBvzTaMk+yVxKcPvrfvB0i+A
	 K6fOBoUwvdeoXqrsMESN5ghaPGDdvc9wDr8nEo88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0440/2214] media: meson-ir-tx: Ensure clock is disabled on unbind
Date: Wed, 18 Nov 2026 15:35:16 +0100
Message-ID: <20261118150028.697089801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1517326fcc9dfdb9acb24f42472366ac1b4b8237 ]

clk_prepare_enable() needs a call to clk_disable_unprepare() on
driver unbind. Make it devm managed.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 3055f8e1b6ffa..b8a270854e9fb 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -288,11 +288,12 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 	if (!np)
 		return -ENODEV;
 
-	clock = devm_clk_get(ir->dev, "xtal");
-	if (IS_ERR(clock) || clk_prepare_enable(clock))
+	*clk_nr = IRB_MOD_XTAL3_CLK;
+
+	clock = devm_clk_get_enabled(ir->dev, "xtal");
+	if (IS_ERR(clock))
 		return -ENODEV;
 
-	*clk_nr = IRB_MOD_XTAL3_CLK;
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
 	if (ir->clk_rate < IRB_MOD_1US_CLK_RATE) {
-- 
2.53.0



