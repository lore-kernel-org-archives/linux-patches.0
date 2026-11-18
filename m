Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015387;
	b=2bZcxzQFbH0LnqclkTkSbtU3ghIB+2nZ9Xa43MmLVAjeQgonqdP7uJWLuOG5l93Ts9id
	 3iJxtYnXnzndK7iXB0VEGoFDThpkrBAY3HkajKBTmfnUOGFj+uld07QcCpPwUTFMk6eJ5
	 fdiliWhHckC1moeitB6v8XgBzVsiBSTGMO0w7LgdzrGHEFTF3CuHcZEBHm52N8v96tOy3
	 qwY4Q1MybSaUXkZDvux0PEUK94Fzil/hgyCkcN7JMmUzQ0IjhkFZigOYIcrFuTUrUeLgF
	 QrCRqg1jaKLnxNcQsYCCct8lttV6iSQb5RA1Q4i0yaRtsL7kaMF5rJzT26o+ZYTEgWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IV4VMM4GRcFjASL9hAWA1DADjuksYx7vCTaqZExvp3Q=;
	b=ZN11Zp73Esg/exytp1wprbcVCMyGOi1aJJEilOh9/nZ0mobiACszzInAjb1lco2bKg5i
	 hjILF30xo5olZk42QTOs0KhBVwEKnRzrrPQAaxHvoVHVEMbnXr/vDMAxIYNJqrVX8ac75
	 B0x8rJ1XmB+mTAy/GvKRlBelYadI3B63Bq+0XiW0pQe3419Brq0pP1VV0Mif85OoLTJck
	 XZhTf/jUx01lXkS7jm4m0eDHJUAXcNnggRXIwnO+aRUWD1OjZYyptp01m1KYKlO/QudIH
	 Wf9pMLblrcrAxZRrRsleVmzM6z5VsgAo/Xv9NkousR5AQXQbYj1fYKSPvAjyqq3W8Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReoO+QDR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074B8606A31C;
	Wed, 18 Nov 2026 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReoO+QDR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1BE1F000C6;
	Wed, 18 Nov 2026 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015386;
	bh=IV4VMM4GRcFjASL9hAWA1DADjuksYx7vCTaqZExvp3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReoO+QDR1eFeDs+biyWjo7ELbAAoN07g3fmsjyRqmo568s1EaFU829znOTms8O5WI
	 NCJbR+NUqtUs31ph6Jy4wDgy+uCcHgXAUt5JrwhfJtFAlnOsH39mkNaIx5CVcFYHsg
	 33V6+Ub/WxCdzBVXqDN3EKlXDsDKl0Bbd3mhWXHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0154/2651] wifi: rtw89: coex: Fix wrong constant check of GPIO MUX signal
Date: Wed, 18 Nov 2026 15:23:14 +0100
Message-ID: <20261118150253.397139968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Gongwei Li <ligongwei@kylinos.cn>

[ Upstream commit fc17fd87d9f210850f81e547ee88eba89d6f2d50 ]

In _fw_set_gpio(), the check for an invalid GPIO signal uses `sig == 0xff`.
However, _get_gpiosig_for_ver() never returns 0xff. Both of its failure
branches return BTC_DBG_NUM (defined as 32) when the requested signal is
unsupported for the current firmware version.

Check the result against BTC_DBG_NUM instead, the same as _show_gpio_dbg()
already does.

Fixes: 5c90259b9748 ("wifi: rtw89: coex: complete GPIO debug configuration handler")
Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260826031959.2555359-1-13875017792@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 5a9dc4d8a00ba..12bd5539e8c6d 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3365,7 +3365,7 @@ static void _fw_set_gpio(struct rtw89_dev *rtwdev, u8 type, u32 val)
 		gpio->mux.data.dlen = CXDGPIO_SET_L2;
 		gpio->mux.data.sig = _get_gpiosig_for_ver(rtwdev,
 							  FIELD_GET(GENMASK(7, 0), val));
-		if (gpio->mux.data.sig == 0xff)
+		if (gpio->mux.data.sig >= BTC_DBG_NUM)
 			return;
 		gpio->mux.data.gpio = FIELD_GET(GENMASK(15, 8), val);
 		l2_h2c = gpio->mux.fmt;
-- 
2.53.0



