Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623577;
	b=B/ZO6ooqnWUh2AkFeDEfNHTzkbaOcAC4hyofM0RGJc/mWl3WYzEJ0M/jcYmUJQFEerU6
	 rOlX5v9+RjAVtfv6vg4ZzneZZERWsXO+cR/jkg1wrrA4m3c6yAwWsIJrgSTE7ixjHomvn
	 BJqLBn2JaSV7vOSJ+h/Eh+/bwWZsjut+tV+JTjk8bh9PqjxzOpaK77L0+IrIHYHeEQo3y
	 zEH2Q/CG7eMQI35fLpJ+NCQLx0K9KTu6pAH0H5mmec+5HdgMe8Bgt8hMUuT90oFH3ds5T
	 JUdRMoL7Ct9yEcOWOafEssaph6PrJNUtdVbjFgfMTckwu/EloET0g0IrWcOJwyXYVcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k/paMM+GFGhJwnyCC42ss19g89dTxIAdCBJhdd7l3dE=;
	b=qVxOdlAVv4TPvBtSISXHocgHRH6jCk2WWsHzL0u5c+VFNfx5MMO1SmwYrBxzCWKslL1x
	 dMrvnsyZ45fuu4z+UMG0Nq+7mez6bO5m1X9Ch2Gp2a6Dlw6Zy5GoFtL4QwpyAi1qGzPNC
	 Ki8pJE8O39XsjbKZMcBBLqZ+d8fOlHo+VCI7V6w26Mgwg1YFrzQs1JefJpUcrBACol40H
	 YDjgYr9ddP9dauGILo+lXX0FK9cC4aRmNWGiWCEkNhV2trp/HyotgYOiaoXiKfu/9RWPN
	 HUdTvxsS3PSa7phRM//zoSaYqwY+ZDVvd+lc+TMaUORwWG6kEgKlw7+ieLo/TTHbuQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4bWLagg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA982606A323;
	Wed, 25 Nov 2026 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4bWLagg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382DF1F000C0;
	Wed, 25 Nov 2026 16:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623577;
	bh=k/paMM+GFGhJwnyCC42ss19g89dTxIAdCBJhdd7l3dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4bWLaggEjGsiNkQ3Qw1BjYl/3+xir6PMVk90gBel36Jiyne32E99TJ/tBRpqE5bK
	 SbhAEowT8dWQaJCQiOZ8CcW//e9ekneMlTB0pjrm6U3uxX+ZGFbhTCGCD0dMssm0/+
	 Rbds7YptP844sDabolJTMdI4mOJfkFkWmLuLS3QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chaz Bailey <charles.s.bailey@gmail.com>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 905/990] usb: typec: nb7vpq904m: Set client data in probe to avoid crash on remove
Date: Wed, 25 Nov 2026 15:37:52 +0100
Message-ID: <20261125143843.206898617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaz Bailey <charles.s.bailey@gmail.com>

commit 2022b10726be78849626ea3fa33038ee96a54e46 upstream.

nb7vpq904m_probe() allocates struct nb7vpq904m, but client data is not
set during probe.

In nb7vpq904m_remove(), i2c_get_clientdata(client) returns NULL, leading
to a NULL pointer dereference when accessing nb7->retimer or nb7->sw.

Set client data upon successful allocation in probe.

Fixes: 88d8f3ac9c67 ("usb: typec: add support for the nb7vpq904m Type-C Linear Redriver")
Cc: stable <stable@kernel.org>
Signed-off-by: Chaz Bailey <charles.s.bailey@gmail.com>
Reviewed-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20261016122045.187862-1-charles.s.bailey@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/nb7vpq904m.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/mux/nb7vpq904m.c
+++ b/drivers/usb/typec/mux/nb7vpq904m.c
@@ -396,6 +396,7 @@ static int nb7vpq904m_probe(struct i2c_c
 		return -ENOMEM;
 
 	nb7->client = client;
+	i2c_set_clientdata(client, nb7);
 
 	nb7->regmap = devm_regmap_init_i2c(client, &nb7_regmap);
 	if (IS_ERR(nb7->regmap)) {


