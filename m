Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062399;
	b=I/WpTf16qSMmMEG4Gxgraan2lDx98QAvPJUWYCED+OFSSkB8b49xf5ZanNfpv1FqVKSj
	 AjmQW7FZRGkKVqybYAmnTckieY7hCM79pdy18U1jLV3+/NFADLt7twEX8PbDea/mfchB8
	 kpPe9fl1tH/n8lafaxnOixsS27SKSlfuTedicB7PQyUOPhnHBle7WhAUoRpdPRMtyeYAo
	 tNiLZqUXGfQP+i1G7L8340HhNN97K2dZF8zYA1Ery0VoGd5r9xW/zgsV5iS+3YZt25nEi
	 m4LVRSp9LCK3iZvOYQzOf51kuPeB1e68mzXlR4yd+LdIvPQzG1LwHwAqFF1e9ec9qeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1Koiwn7qyN+mSbw1/F1d8z1+yJMYX7heppKO6/7M7s=;
	b=Fga30Qtr0jCcg/TIN/NleytoafhcSVjxvTe9ilZ4zoJOGNIYEOkrD7/F68SmVkqcjaw/
	 8L2TxB4AXdLBeLaEAQHQLMvcsSsT5vZkCB3Eo20CM49IJW0O3cL1dv9N3c2ZRQmn/ISOY
	 qJZjbfVKIcRGqhDz3Jvf7ihDmuh/thqfPJBV0DFgjg74fY1livUH58xhdFItYqnxEWawA
	 HPC0cg/0QZjgc22kRKmRrL3P7AuEAQzroRLRbVj+tMIkDcuEBRGYlorPe1p17ogw3wIBL
	 yoeirfJAVPQQjaBXdK3TrNrx89rtO5+FpAUaqbfV1MGowoqqTQMR2EwigW9oWGMvSKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lRDlOmg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DFE608362D;
	Sat,  7 Nov 2026 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lRDlOmg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F8F1F0089F;
	Sat,  7 Nov 2026 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062398;
	bh=V1Koiwn7qyN+mSbw1/F1d8z1+yJMYX7heppKO6/7M7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lRDlOmgUXBJ1Yg/jy5C6inN8OntMCPxYcZ5hLxz5Lw5ag8i5Jf61OreyVNdRnkXB
	 RUH1XQz62ncN45Fd9cL7VVngLV1G2MMHvy6+KVh/LFcoeJ8Uj5Mn5mdFkit+Tnckhz
	 hBXNq54odpDyVrrlbY5fdGMQ/6NpExa7JeRfYnlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1280/1536] pinctrl: stm32: Fix fwnode reference leak in stm32_gpiolib_register_bank()
Date: Sat,  7 Nov 2026 08:54:56 -0500
Message-ID: <20261107135033.730128533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 54c66b5e47a9b10cbf4a1efe9b01301b7ffee205 ]

stm32_gpiolib_register_bank() walks the "gpio-ranges" property with
fwnode_property_get_reference_args().  As documented in
drivers/base/property.c:

 * The caller is responsible for calling fwnode_handle_put() on the
 * returned @args->fwnode pointer.

The returned reference is never put.  The function calls the helper
twice, once directly and then repeatedly in a while loop, and each
call overwrites args, so only the last reference is even reachable
and all the earlier ones are leaked for good.

Put the reference as soon as args.args[] has been consumed, both for
the initial call and for every iteration of the loop.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: bb949ed9b16b ("pinctrl: stm32: Switch to use for_each_gpiochip_node() helper")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 857ce101fab0c..79aff59b54f72 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1319,8 +1319,12 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 
 		/* get the last defined gpio line (offset + nb of pins) */
 		npins = args.args[0] + args.args[2];
-		while (!fwnode_property_get_reference_args(fwnode, "gpio-ranges", NULL, 3, ++i, &args))
+		fwnode_handle_put(args.fwnode);
+
+		while (!fwnode_property_get_reference_args(fwnode, "gpio-ranges", NULL, 3, ++i, &args)) {
 			npins = max(npins, (int)(args.args[0] + args.args[2]));
+			fwnode_handle_put(args.fwnode);
+		}
 	} else {
 		bank_nr = pctl->nbanks;
 		bank->gpio_chip.base = bank_nr * STM32_GPIO_PINS_PER_BANK;
-- 
2.53.0



