Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624999;
	b=EAPpApdEjaCGt69YMr1Wcp8c5oExRzTu3jU8FXduu9TXFg/N9gRnVYeQ7Tv1ke8+MiHL
	 VOZDTXtrpsl7vD7l1OxEE4Gwazi6Z6ZusfaoQneaHHyjsBT461BjO7i5bq+wcbenFo5xE
	 zLTrGJCEacX/Cc9piEmYBaxpqr8Z/jEbsMnP7hFs1mhGYvU3+t0TZDjdMUadEHg5lTIwx
	 tAtBK2PcPbpsccMtlGsavoJ75ccle8MFilZKxTTS3SV1OuMQO0Kl329FCsNLAynH+HZjp
	 iVrGeogdL0c6p1iZ7ZBBP1fF9jR68rQBmDrjYz6v9nvgur6U4LKVi0JM2Ktu58HdrMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZXPBGhlGwPof/wIZ1MGbZ/lYNMwa1woIt/JPsgrW8s=;
	b=p1ri6cQh0FvqNifuJQMrgJDqFvd3NHrspwfV2GR5WJaXjZO+OTIrKT5lfRW9YUpnyfQT
	 u7ITQEsldJLnPJHM9hT4SYzmwl4bVXNXEEzUAJi5ah5anc2KC4r0qJRvdU0j9S80Hwz14
	 tZbipvqq+kg7yW/2gp9b3U183l8XoOlUfKJaLEr3Sc690jDOJ0mfS80w+Gv1CdE2j2x/m
	 C/FOFx4MZnUTxAyv9sjFgmii471NJFf81gmsRGK0JeWVtGhZJdGmz0IVYhx5KA+oApi2s
	 F2lz6jaoIcn0z4jathf9TkmdjQ9SoZd6LV1xI2K40JSs9I6jzheOlHhUV+QIitIFelw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPjNPWtG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B8C606A31E;
	Wed, 25 Nov 2026 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPjNPWtG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1691F000D1;
	Wed, 25 Nov 2026 16:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624998;
	bh=eZXPBGhlGwPof/wIZ1MGbZ/lYNMwa1woIt/JPsgrW8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPjNPWtGsIQAVFBJQ2ble4YyV8UKkCm0qUWp5EWwoAMCsRG0rYJR/DU8iNgEpBrWC
	 8n0zTO7cDEhgK1nTrSFFxRY+3ZcYj2lVjs0gbSGItRspTE/hF+7xXH9kizSyQtfT+i
	 jkq23TnRSEmyp3CcMjjuJNjNeiLein6X4O7V29f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Petr Oros <poros@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/816] dpll: notify about a reference sync pair only if it was added
Date: Wed, 25 Nov 2026 15:31:16 +0100
Message-ID: <20261125143856.793590538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7a3837929d049dac1f931620f30b100993ce2594 ]

dpll_pin_ref_sync_pair_add() sends a pin change notification even when
xa_insert() fails and nothing has changed. zl3073x gets -EBUSY when
another channel has already added the same pair and ignores it, so user
space is notified about a change that did not happen.

Send the notification only after a successful insert.

Found by code review. Reproduced on a ZL30732A board with kprobes on
dpll_pin_ref_sync_pair_add() and __dpll_pin_change_ntf(): loading the
driver adds one pair twice and the add failing with -EBUSY sends a
notification. With this patch it does not, and the successful add still
does. A test module adding one pair twice shows the same on the monitor
group.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Petr Oros <poros@redhat.com>
Link: https://patch.msgid.link/20261105131145.1010406-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 0a8db4dc25786..aaa576562ae42 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -999,7 +999,8 @@ int dpll_pin_ref_sync_pair_add(struct dpll_pin *pin,
 	mutex_lock(&dpll_lock);
 	ret = xa_insert(&pin->ref_sync_pins, ref_sync_pin->id,
 			ref_sync_pin, GFP_KERNEL);
-	__dpll_pin_change_ntf(pin);
+	if (!ret)
+		__dpll_pin_change_ntf(pin);
 	mutex_unlock(&dpll_lock);
 
 	return ret;
-- 
2.53.0



