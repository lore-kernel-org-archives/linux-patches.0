Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053806;
	b=IwxRm5T9eoCTL2tkGg23hej0GKJ/fgsKt9hStDWiVQip38SYVjh43+Po6SE8QO46x3W2
	 44iyTUE1qJe0Lz2tvGIJyG1i/hHtywVGyCshREtYZVf3ZWfrFFvbmwk+SikVPJ+Lktzii
	 s4un9ik4fJPRTJ0WYOduza9HjBQzKiiKX+o6AEGu0xRwfdZwsiPQdP+7RcR2Oa0mtCKzJ
	 u/FF/Dv2T2OI5wPT6djr61/jxkz2o0RvQC7yuYDkc/EvQMQaTwEalemrRpemiN+1MLt3J
	 4dO++gj9NiAdcORmelIa7sjvasqQinhLQTQjGcpVoflUiFcMEknhvH7AEamClDZEBeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=df047Okgc/dsnMMaI5AYkzsJNym3Ov+RYjvG13TG6L4=;
	b=tN8No8fBaPM+eiM4JScErGaLRTugT0UczJ4f6CfaO1G+wj7XiTRD30jPcFwZcciYO9cl
	 n8jeApUNz3EyPVVdHl4HWL7zbbANb1sqmR5UKJuH2hiN0xBh9PFmU6MhhRu5fpr2ZVlVW
	 qHl9xkwLfLpdYHQbSF64SQfuIe2BxFFolnE92+DjRblWaz60klFuFwgo8MyCyGa1VcSTz
	 InDI92dQumv11MxjRtGuaJwcAvlV4mYnDlx5VoRy16rYyJY6IrT7asRAnEPowxeui2j9z
	 hHxs33b57apxDtMy6sX20xnZpJhZ0kjYVe0NKZFG273HNL3truaJ2j/xLByTJ6wu1gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AayjZuHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5324606A32A;
	Thu, 19 Nov 2026 02:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AayjZuHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFFD1F000C5;
	Thu, 19 Nov 2026 02:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053805;
	bh=df047Okgc/dsnMMaI5AYkzsJNym3Ov+RYjvG13TG6L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AayjZuHWS12ZXAGB4wYAnyfOvPNCMTgb0vuMX4C7y+4NLQgcvBjL+dnLNrd8YdM4q
	 1JrZXMSq092MKHTcN89oRJCJpj0GbJBe7asUWRdExjUZvNfEf4jX921uafCpPMLNVd
	 yHwf+ee2eFTAKrWpr/tH72N3naWfqyIG8oNV5VLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1049/2214] mfd: twl-core: Use i2c_check_functionality as boolean value
Date: Wed, 18 Nov 2026 15:45:25 +0100
Message-ID: <20261118150054.301037712@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 7ee4fa2674e51a0d100b9240cd8a50355141362f ]

i2c_check_functionality() returns a boolean status rather than an error
code - directly use it as a boolean value.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260505114543.159381-2-thorsten.blum@linux.dev
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 3c5c55d979dd ("mfd: twl-core: Unregister the auxiliary platform device on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index ae5f101167b45..acfc0b96b4a1a 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -791,7 +791,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return status;
 	}
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
 		goto free;
-- 
2.53.0



