Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591326;
	b=DayoHuXgc1wfDS+uiRGCIJZuCW5wauw8lRQcYf0faiRClLsS0ZajYgrrMntz4JUaElp9
	 II3xHyMlVo6hN+3QG1lNHvX0q4AHnY2jdVP+zYVRjznYYTMq3pVdK0yUy2+4FGM+Iein8
	 ITBW7HDieR60rMveY26M1UmoU5ay6z+GUPDdbjVRRuFIn3ewgsWFSAgjryWmpz3HQSyWq
	 uxVN00J1/jGx1qAI7NyPVlpSEoujvIeF0pyqwNsAwwPECUhFsqPqZK9maKqSapMXVptrW
	 oToIkyackUZPEBGJ+uwrC4v1CgwPz7kWWUrgyN/pku0UVhoAJn7DQWtNjRltFfWlTpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wt0chKe99+cSFHcXaN6Xbzgrd9slXnWLVG7UqTpqvDA=;
	b=3k8Ft5TfxXaQfP0BBYwhZB4F9X50O6P4frdfCkv4swZ8mDhE2eGcBx9L3aUPYglmp6nt
	 N2PxOdxjkQuxI1lzJzUuS5DDc+ztEL2CUJVS6CqrzFwmfKJT6nyPpTjCMVg0gJ97Y8lhX
	 BZZjjWLjOdSMrFkdBvuSQdeoxET7TtF1kKvJN7wIg6pdcSBp8+lpC7QKZ68zB/MBZ/n/C
	 9KH1WVM45XffsesrGk+lBn6zy4m7FU2HTh5G35cBWqzjd+xGM+R317JB/GRb8csw+n7Cd
	 n9EY5UUVn538kQHkxDoTXTivEK/Lo3VtayHQN62rjYyn9l8LsMOICQagNH5syNS6U8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXXI5m1N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA67C6077D7D;
	Fri, 13 Nov 2026 17:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXXI5m1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871621F000C9;
	Fri, 13 Nov 2026 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591326;
	bh=Wt0chKe99+cSFHcXaN6Xbzgrd9slXnWLVG7UqTpqvDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXXI5m1N5uvu/dCX/wCiM6+m+nakjE+SUsm/lgFIhXxLagSbLgUg6ToMYiUAxSz/u
	 YgGQb8YTZYPR6AuCCBMroRYrYpqNs5GhBVdDIMN9DZf7RJg1js9AV/RyDdl7In5s2j
	 qKQXEqWcj1j+P2dsdRm7zQfwqJKuO4cge01bdWoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 439/670] crypto: omap-des - fix crypto engine cleanup
Date: Fri, 13 Nov 2026 10:50:03 -0500
Message-ID: <20261113153826.772786955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 5d69ed4cd4f9c68ff9a6ebb2e8a1079223a4ec6e ]

omap_des_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-des.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 096df577fe127..cccd275ace675 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1093,6 +1093,8 @@ static void omap_des_remove(struct platform_device *pdev)
 
 	omap_des_unregister_algs(dd->pdata);
 
+	crypto_engine_exit(dd->engine);
+
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-- 
2.53.0



