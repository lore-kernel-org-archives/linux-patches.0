Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620393;
	b=M0Sz4Fso4z6t9Fd8neOdD+GiEy/JMSNNMPvQ40JImCXjbIYE2rpgkJIW7wIkUxGkOOi9
	 lMXtP2uXkmAjIVSBidia8fHb8xW4+6wrmHS4UCBTnqZXqnbDk4nz7soZq2O5OVMRehQ6W
	 XRNh9Jsx1RepueyvhuL/R15bX6pRE11PYNp+bXRsIdIub7aQGeNCPIG9fnN8vfStVqCS4
	 pRrYzAqY09U8w2M8VOntHpgK5z9Kb9Jk0GaQRxa1DsgusUy5xfo5/nuw5a7BkoDUoaCto
	 gFpu7LwgTsCz/JFUa2IuwETe2BaOb5xiAUbiKViKPuc0vfoK7bMN8R4nhO1Dhiv/www==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vjryKb7mx+EW+nwKiaIIdIgOUn4Es6tXVx8zO+8E1iw=;
	b=BZ/kLM5pbhHa0EhRRBb+OzLvMxmCUHh3i8lH4q7HGaYiFMSLiRB5XGO4pFY0xzIDTm0A
	 a4dHK6A1GmmRpQyExS+GRc5xHJokhoF7GW1U0nBsJHRdX/KtS8ILqUUOBJ87KxANcrUdz
	 o6Rc76yTtB3HSEqhSWxsx7gQRNCcXKfwl+aXl6CJuX8awYBKH75XOxYrY88RdfUbTRAr4
	 wIsQrQnrb5NeCjlO7yoPo14QWLS/TUivGZS7+JWo1ILU/pntpJPgx3sBsBDfUNyCP78T+
	 A3Fhmx8LKgEqNkdY52Mm4kztADCzRuy3xvcGMfKj7jXOZo6WPZ6L4WQb42Iks9KbCLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0ijYHuQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13092606A31E;
	Wed, 25 Nov 2026 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0ijYHuQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402271F000C4;
	Wed, 25 Nov 2026 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620392;
	bh=vjryKb7mx+EW+nwKiaIIdIgOUn4Es6tXVx8zO+8E1iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0ijYHuQzWPl2dlkAXZqk9GgcFRepQlg7aVlaelQ5B85uwfgwGWvyYf5rFiIfJpBM
	 xfxkENRlwXnldga1EWQMaLMrNsguIwnvs5nxhCDnT3Om+fBWp91fv2CQa6Y9UwwqTX
	 BDLVJOdeAVharmdyLPD5PQSN7yiCgvPf9VEh1ZSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 7.3 0903/1005] serial: 8250_exar: check priv->gpio properly
Date: Wed, 25 Nov 2026 15:37:21 +0100
Message-ID: <20261125143842.844550684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 0353b51965883cf70dad162908e07395f242000f upstream.

priv->gpio is set by platform_device_register_full(), which returns
error-encoded pointers on failure, not NULL. Sashiko reported:

> Does __xr17v35x_register_gpio() return an ERR_PTR if
> platform_device_register_full() fails?
>
> If it does, we might be storing an error pointer directly into
> priv->gpio in xr17v35x_register_gpio() without validating it with
> IS_ERR(). Because the error is ignored, the device probe
> successfully continues.

Before commit 1145d1a0703f ("serial: 8250_exar: use
platform_device_register_full()"), __xr17v35x_register_gpio()
returned NULL on any failure (platform_device_alloc(),
device_add_software_node() or platform_device_add() failing were all
turned into a NULL return). The plain truthy check in
xr17v35x_unregister_gpio() matched that convention. That commit
switched registration to platform_device_register_full(), which
reports failure as an ERR_PTR() instead of NULL, but the unregister
check was never updated to match. As a result, a failed registration
left an error pointer in priv->gpio, and unbind would tear it down as
if it were a real platform_device, dereferencing the encoded error
value in device_remove_software_node() and
platform_device_unregister().

Use IS_ERR_OR_NULL() instead, so both the unset (non-EXAR vendor,
priv->gpio never assigned) and failed-registration (ERR_PTR) cases
are skipped.

Fixes: 1145d1a0703f ("serial: 8250_exar: use platform_device_register_full()")
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: LLM
Link: https://lore.kernel.org/all/sashiko-outbox-170895@kernel.org/
Link: https://patch.msgid.link/28c09cf858795491f66667781bf79fb6a603f159.1793704520.git.jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -1180,7 +1180,7 @@ static int xr17v35x_register_gpio(struct
 
 static void xr17v35x_unregister_gpio(struct exar8250 *priv)
 {
-	if (priv->gpio) {
+	if (!IS_ERR_OR_NULL(priv->gpio)) {
 		__xr17v35x_unregister_gpio(priv->gpio);
 		priv->gpio = NULL;
 	}


