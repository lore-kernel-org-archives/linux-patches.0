Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620444;
	b=sg0fiTz6s748pku2xUAfTZzRm/Yu/QfARY/Oc5PsErmAOm5KS/DxbUWCAwNn43sjhPoT
	 SCrhqMIuXhAa8h8b808hMCG2fXpnnvCXZ8oWNrCKOlPJM5viPyBMaMe+WYCOu7QHatmHK
	 nSDs5K5lV/T4jkTfs9rQhUfvjgeMhRV4RqYW6CgJ4BpWxF3/eKHMGc3RISY+RkkcfWFx7
	 1Bf/8GzeYINFFzq84BshoQefTxBDl8PFCnRIbgZTbYljioK2QMQkEfQ8YTFQ+r7QQ7vw4
	 rHgwGBDYVwAtB06jFrFUEX8DeIDjPI0Se47iaLRUYzplt1eDFlsP2YUfihA2c2OtdAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZV44N425CtifR8YCIc1EyjBWWMZhe1bIdS7GJU2WFo=;
	b=naOtE8s4RLNZaylQsKwgeuoG6hwqaGyqiKAPoB8/+n2TtJ+7CPoe/cLnZiS3WjIy8tSn
	 Scaq+CzBoNLl1DsYWfU9a8Z9beGd3OHyqXzMWCNoI8j9Y5y8kZJCnf6XEDTL7XIhtni/5
	 1HDxx8Ud/1ekDijmPaGRs/sLdLrHTwABxe6YaYt+9YZcek92+z601uiBnGFXF99/H1ALO
	 F2eFUylySXmrHlrdH6uuvIU603KZX1WeFuO0rY1T9TRkRKR/oaMkjFeZ64FrQRJW9A6SV
	 Tl1H6B++/bsGN0Y/CHiigEhuUmZvjVJ+MNhLSL7owZklvj4INj9rN25WvcCu6xf9ifA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWMAyM5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC46606A31E;
	Wed, 25 Nov 2026 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWMAyM5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1151F000C0;
	Wed, 25 Nov 2026 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620444;
	bh=nZV44N425CtifR8YCIc1EyjBWWMZhe1bIdS7GJU2WFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWMAyM5oqDNcp907J7SszXAkS50rn0j6iufXCBewmlPtxqsRqB1DQg9eUSJtk8IU7
	 FoNhRXR13w6erm949xpepSmFxP0zKKyftPjUh8A9dYU3+XSbtP1qIkKCgqwB3I4Kn4
	 9pX109l5Jk2YTYqZ22lS9dhKiL5AhTHTaCpMdzNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chaz Bailey <charles.s.bailey@gmail.com>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.3 0919/1005] usb: typec: nb7vpq904m: Set client data in probe to avoid crash on remove
Date: Wed, 25 Nov 2026 15:37:37 +0100
Message-ID: <20261125143843.218594430@linuxfoundation.org>
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


