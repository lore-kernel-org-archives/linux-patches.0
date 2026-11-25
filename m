Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620052;
	b=PRFsonbL464TtOgrmNcNcOQYOalzWtLRkyvqezDTqHmL3AekZuhgYkZZPD9FVnY3KpBf
	 xEvAov0ENJcEL9rMQNu5668HvA6UwN6TfjOMyUS/FjJM+sxkEYB/3jc5Eld3BMYFNzaRd
	 5m79xE4hBfNXEELBCxg8JKCtKpbvFOfHvFDTNIWfpLF2yGjC8+Z0wbezCbFrGrB+qmtUS
	 PrLQ/RjQlyCU2Vs5zAlfEbtmYsKk2hCZY89AoGAmZro1r80Ri8zd/lY8URJO1VxumJu6N
	 8DWxIAdQ+h06YxUxCsOpI0sTQ9K9pBctIJUotQaW38r1GeEALf5XgXw6eNQ9pVQ7Cvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y8cEIAo1bBAQx0a5WGiAWuFBykl0QeIt9MkmZcvbtto=;
	b=fwGHCLTHw9jymhExJKkPf3M0MYGP2kwS/P0jR+ffrI7EkiJLvrfUJKn+XIEsxGk+lF8A
	 3EERAfs9oI0oOOQAgqvsGgZZlvw+J3FuL4/Cz73GBF8sEd3if0Y20dl1XJn+NNk5EnPaH
	 1EJ+x6UStT3wni6tW+517tKIKdLsUGTsX24+HxhcfTQWJP9OqNR6Yo5bE7NxLMB8ljtRk
	 t1kl1YYMZiqYt8ZgA3URqW6gNoorZVdo6kBEjCP5PYRKxkiY/YC6RJkFkhjyzXiJFJx0I
	 mKGJwUxot91LMegp33JXwl3/XBWwxPNOEthRODmphpakbATZTnZuXUmlTx4VR+ADnhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lFTCf3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70705606A326;
	Wed, 25 Nov 2026 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lFTCf3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4B61F000D0;
	Wed, 25 Nov 2026 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620051;
	bh=y8cEIAo1bBAQx0a5WGiAWuFBykl0QeIt9MkmZcvbtto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lFTCf3ck+x/y0xUULK3tJWgMn3kgVIfd5XNOBg9Y/vGOr7s+dybd4dPKdtkAKlsV
	 OF9Bh2OHr/dvHX/WAEM40GdQ+0jP8et10cn0M/Lmj+2nhzve5Lc9jWWea1vc9uDnm0
	 4PmVwSe6xgzN5dgN5o1DhLgUP4DOd1tOQ38arEvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Mazzini <pmazzini@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0748/1005] hwmon: (sy7636a) fix negative temperatures
Date: Wed, 25 Nov 2026 15:34:46 +0100
Message-ID: <20261125143839.272813830@linuxfoundation.org>
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

From: Pablo Mazzini <pmazzini@gmail.com>

commit fc8519fab34e162b0c29dacccf73031820878917 upstream.

The thermistor readout is a signed 8-bit value in degrees Celsius.

Fixes: de34a4053250 ("hwmon: sy7636a: Add temperature driver for sy7636a")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
Link: https://patch.msgid.link/20261108093602.329554-3-pmazzini@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/sy7636a-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -29,7 +29,7 @@ static int sy7636a_read(struct device *d
 	if (ret)
 		return ret;
 
-	*temp = reg_val * 1000;
+	*temp = (s8)reg_val * 1000;
 
 	return 0;
 }


