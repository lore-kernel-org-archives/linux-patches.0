Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029649;
	b=2MwYtQh00nq1DYXeSPLtvOP78Wl5b+J6RftrpZv2GE6kWM4PBFF+Soo476IELum9yDq2
	 n+NJrwF5NAvwfgwUmqRk3XxlwVy4sP5bDr6+UIMAUps1gRTyaaGVb/rd2KLkawI/YG6rj
	 Ja3xQcwZa9OHYuqznuDYvC/8K8utc/eOTHYhfc1giqOG0qo6HCHbrqkyiWUwAWN999vVU
	 NYJMTrUAHwfHPpOGuldIAm06C+0ld7hSehuNWKibDt8Ur+SsRtkZ4Tg9aMZSOF7fv5fzI
	 yaSCIlnsc9Df6C7/0GzS91QqoWIaYq+BFU2KXD+9JRlC6hUHjauDgF43oYqAUgT+Jhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BV18pGXHyKCiy43FSses472iXdLMmAnNN5JZprFlZ1g=;
	b=GnvTOCKZAX8k4TKREsjg9+AQlR6eKKj5doOUqej002wzXnfGXAfJ+1BnBcScu4AnRan7
	 ILwm0zUSZIphT2LF9y4GsF/tEuiwYH3EMlD4NE0rFTOs5wcmYpBLNnlOLaRuJR+fiijTI
	 DxGSn7SJwvpmgpLdB3oK1PgdtR2Y0FIqVJHE+C712JHdj3/cO3qnRFDnaU9CgeXFEqnTP
	 Cd4auIWEaPruuRDcDb+w9vJaqukH/01JYjc1wkQn5w+3rlPd+MLiNtlzaZSl9T3R/dWME
	 4HmQAx/UOQzQVVN324sGJ2IUP8p9LKJqf+sb+Xs4X/eY5d/F+1OjMlB7OQry+xtuzOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APtq4T3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AE3606A336;
	Wed, 18 Nov 2026 19:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APtq4T3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4341F000C4;
	Wed, 18 Nov 2026 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029649;
	bh=BV18pGXHyKCiy43FSses472iXdLMmAnNN5JZprFlZ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APtq4T3MK+f3iJigtgjmf13+X+LrM/K224fMSedGlawL1cOn9RLgVFEipdY+kZw5L
	 WyJtFXUl1tZBWmmsgamciAAtsDJgNb9gjvYuTGM3sV8FKF0Qc/w9jSC9qTjUJQtH2j
	 hcOWkrYsylm85nKplM2yWl5zEJdrwSBo5Pv6kGg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0380/1756] spi: Fix the return value in spi_new_ancillary_device() kernel-doc
Date: Wed, 18 Nov 2026 15:41:47 +0100
Message-ID: <20261118150023.683179098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3742867ce96539100ed5f4c754f04273d8aa00d7 ]

spi_new_ancillary_device() returns the new struct spi_device, or an
ERR_PTR() on failure, but its kernel-doc says "0 on success; negative
errno on failure", which was never true. Describe the pointer.

Fixes: 0c79378c0199 ("spi: add ancillary device support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260911230211.11755-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 780a8c4bef392..c5cd38e295f56 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2577,7 +2577,7 @@ static void of_register_spi_devices(struct spi_controller *ctlr) { }
  *
  * This may only be called from main SPI device's probe routine.
  *
- * Return: 0 on success; negative errno on failure
+ * Return: the new device on success; an ERR_PTR() on failure
  */
 struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 					     u8 chip_select)
-- 
2.53.0



