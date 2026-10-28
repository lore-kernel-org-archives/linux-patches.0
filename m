Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212786;
	b=BdRKkp4fh5xk0mmTZ2NVNVxaNJnR50n+yq8yNF4aH0vF4B5i9fF4WVbPCsh9mWzFvVXr
	 9C5YBIx5zILH0sudTM+a663X9e0UDvYTYmwM5gzKEbtoNpKCUkwXTXnRE8hYn2cHdBRuW
	 RlROAX0sqxJzMALsrIgEu2+nBRu/tBbHT0ZDV/4Qin4cig88VQodQ2W0YcFkQRY99NIkq
	 AdCm4d8KM4veldo9YA4Yza2fIaH490qzvcqAC9dEzIzQTy7wW5+s8S1REacO+NVTzhXzY
	 mw89eNati00cQqy2CjIOM/7F54sVij11xHPuA8M968LrvGukMxzYudN7xYy2qC0CAuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ds5Ldwtfg0qIeAkcjJwRmYuPobB6suaIlRi89qCW+p8=;
	b=pYuyJHeJBm8P9fda1KfZP6qolcFkbXNbOd9bdNh8E80MW5mKTGr8ft8aKd1OcyiBAO8R
	 +16mbyIhIOM0O3TcDnyLJ+lEMd4uLMWuCLm0OeV39UCe2Q4SgL8YgZc4VUip0zF243fKW
	 JOQ42G4ZSo3DzRNx7jv7ONDmLLp1dw6zYTgs5L6RdjmVbmElIwldgZuxis6ebeX4ugyoc
	 6n6LeH1KWxAV6XcsXD29rLSaRmmZebWbj1wGyUUxBdBVF1NqXLLvlBfkPSu75HZDCpquk
	 ntw1wtMUdXELYspzsifgw0TM5o/FiqyEnlZZvJ0Xf0TUU+sDroJYNqJSFdP9XwKyTOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdSYco6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414B6606A325;
	Wed, 28 Oct 2026 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdSYco6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CEF1F01829;
	Wed, 28 Oct 2026 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212786;
	bh=Ds5Ldwtfg0qIeAkcjJwRmYuPobB6suaIlRi89qCW+p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdSYco6If7z4q9Uvq+kAt2HuS64/JfsADvi5GPwkvdMqJ2IUFUtS+VaUpN2gAsqWp
	 BAJMBpEiY4LVTmm0Dq1+sd9fa5tzvW6IkUumwF+iksNq1TOeDyTrhGQb8HmsSW+kAD
	 iu0TG+CgAh2SFZ19azTF00WvDF8DCwOsjUSVlAOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 0276/1887] usb: typec: anx7411 - stop the IRQ before destroying the workqueue
Date: Wed, 28 Oct 2026 17:39:32 +0100
Message-ID: <20261028170505.510036902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 469600d5d292b1482c90dd6853555821d11b8c5f upstream.

The IRQ is devm-managed, so it can still queue plat->work while
remove() is tearing the queue down. Disable it first.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260910011150.2966843-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1572,8 +1572,11 @@ static void anx7411_i2c_remove(struct i2
 	anx7411_partner_unregister_altmode(plat);
 	anx7411_unregister_partner(plat);
 
-	if (plat->workqueue)
+	if (plat->workqueue) {
+		disable_irq(plat->intp_irq);
+		cancel_work_sync(&plat->work);
 		destroy_workqueue(plat->workqueue);
+	}
 
 	if (plat->spi_client)
 		i2c_unregister_device(plat->spi_client);


