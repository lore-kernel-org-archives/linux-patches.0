Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208648;
	b=Czkle9azygt2UDP2NvjBsO2vcJczWh9CXURe+ki516G0LCCUKsYiutH8g4zfZaGXfuWA
	 FMY2XLgkM/8Xag9JMXH/NLXpP/kLSKi9G2CLgY4o01ffaXa+TAuUJffRxupUQfkPPUP2O
	 GftVyHDahYsaoOzBeLVjTvltJGaW4y/3BifHDPGsZmjVbZHKMvQM5ZsewarDoWZX492FH
	 XwmMv8Yax/rMxKs5OaylP1QLL/gJ8vQO6ckJ12Mf09QXObOsDFHZgAB8chkzUgSXcnSbH
	 lqDpNHlEKK6qudkkYKtnJ3hrrdxNBVzH2lUNITe8cKnkflXbwc+IBmyqNX4vOPehx4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6sFPaKo02fL7I5difDlJ4WaP71Zvk5AaEQ1cXIV3Ync=;
	b=HKsjUd5dK5GaliOMiAJI0L/BE8qjd3T6LAveOblhFtSfzXh5g66brgBoz6Gcm45enXp7
	 IBO9sxSTj+VczarwgpuACmcvhpUU135/zPLwlhVF+Q/04ms1NvtBzdYxv50fQb5SHsPjE
	 UboVcohZlLS+5yM4UBJgeQnR3hET4VwN+l+AyPuaKpVghYCu9ByfrEUuLror6nyapeT2L
	 /3IAJkpMqRSyTQZtJ03f8XKptPVgINi6af8exokfrHA5oTXm9GFUkA0k8Ph740uzadZMC
	 uTGCZEcdyzlNLC3x/t3JO+6mQnT3EHaUR9Bl4AFVkA8Cr4vsQNUCFtuC+COUtooOmYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2f8mz+rn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B1C606A332;
	Wed, 28 Oct 2026 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2f8mz+rn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D5B1F01829;
	Wed, 28 Oct 2026 17:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208647;
	bh=6sFPaKo02fL7I5difDlJ4WaP71Zvk5AaEQ1cXIV3Ync=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2f8mz+rnFzbE3VHMsMVOJgMjrLYACRVT2Bk4y3Lzc0nbgdLgTLGAeeadrruJu1COv
	 PWQkJVGc9AgiRsNK4YM/mPKoAosbLL6n4O+U+IlqYWiNS7STJ9RUDTl6S6mgHyZepw
	 xgWQiHhZ9ZDDIAVdWPwNBNOKBQdcEMl28FcHjDjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/516] of/irq: add missing of_node_put() for interrupt parent node
Date: Wed, 28 Oct 2026 17:55:02 +0100
Message-ID: <20261028170007.061003587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit eb2b4ecf7299ee39ee9cecc4d3f2633aeb10cefb ]

After calling of_irq_parse_one(), the node provided in the of_phandle_args
has a refcount increment by one. Add missing of_node_put in of_irq_get()
to decrement the refcount once used.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Link: https://lore.kernel.org/r/20230117144929.423089-1-clement.leger@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 738fb9d204169..ecc74f12e3e65 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -407,10 +407,16 @@ int of_irq_get(struct device_node *dev, int index)
 		return rc;
 
 	domain = irq_find_host(oirq.np);
-	if (!domain)
-		return -EPROBE_DEFER;
+	if (!domain) {
+		rc = -EPROBE_DEFER;
+		goto out;
+	}
 
-	return irq_create_of_mapping(&oirq);
+	rc = irq_create_of_mapping(&oirq);
+out:
+	of_node_put(oirq.np);
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(of_irq_get);
 
-- 
2.53.0



