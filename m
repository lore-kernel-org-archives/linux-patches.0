Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626133;
	b=5U0QA9+zXzIqFGv5/dXE6wbAYweOgUto2cDbJdV6eGMl5uyk3ZGfDTPdWog0+950COTM
	 IHO2TPYkiclOR3tdtV57+TknyizT+89FtdAPccdiWxvVA1zunm1KLu9x7dqwWv+Ivi/Rd
	 pVkS9gm7QpHwcGUPSmXKOE1ilWOADxoat+dOUDKwbswZYrbO/e7urV5Ctv1c7KlnqfWhg
	 PmxJNa/siVSJ/9D939M1vKuJBo1DkfiCDwbp+0iE2lhJhbmQpg5vXhCXh6CqeOSMKfoS9
	 nF4xvxMYQ6l/1nSQ0BI2r4yY6QztTfdW+oAwwr7ozBpw6wmeX+aQvTJqsC/umZPEweA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5/W3UQVPq6kSA0I+hCpn3VogQFI9IusshSvpXhqN6O0=;
	b=K0iucwZsAE0DxViHVOfQx1i1moh5u4GtsCRahNO8L2pVRrrfQeTmSxe9LVWvm5I6CXVt
	 88yASsk1KEjr6PyzilSoQdxX2267IrwR57f8DFNiRi3tN7vU5/MubzFiNZBcOjEn5tpPS
	 Uc9vU2hnuTjfmo95IDgZ5EUaDtxahruXzOtXmjEDhP8Y4mVX/N8zLiMpThOnBpvDQ6Gjn
	 VEgWmjU6+lq3V8n2f8Dsf271Ui1U0eAEULAwfYisnkXhZqIpBWtiyfqc08WC4OW0teFhd
	 +GHpf6sDUGevJCk6CeLT9IGkQe21gawGP93RwG5G1f2f41jPWYjo85uiuEGan+pk/mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcdnjAnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C98606A323;
	Wed, 25 Nov 2026 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcdnjAnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A7C1F000C4;
	Wed, 25 Nov 2026 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626133;
	bh=5/W3UQVPq6kSA0I+hCpn3VogQFI9IusshSvpXhqN6O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcdnjAnNUCiITOZlPfF9X5PNJXgNYjn7lPMBZI6QXroinu13OE/TvlwCfu3ITq08C
	 gK/3cDdEAeOxnydZEfbzP2JD89aMaa9kMT1CqM37kVABAa3hQs8P7fZjaQHPHpjCU7
	 ag87NSnSSr/8K3tHTk0eNXV/S/mNt/0m+na2cUuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chaz Bailey <charles.s.bailey@gmail.com>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 742/816] usb: typec: nb7vpq904m: Set client data in probe to avoid crash on remove
Date: Wed, 25 Nov 2026 15:38:10 +0100
Message-ID: <20261125143906.352950013@linuxfoundation.org>
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


