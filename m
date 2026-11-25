Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626089;
	b=lfgzwzM2V+GZ7acChxZL+ipuApVC2C4osdGEzonWjT79Ofj0KGKQl9kleadfL/oiLwxy
	 DR9f/+gtUT0c9eYOut28AVR/a9vHfJYD0MIwKJ2rKl1VxSWd0pp9Br7JitPRhtKn73yqF
	 jll7ZLTNHIV0/kyAaiMAemWyq9aulLc/HaOWOqHBPgNPqnPukaUM/9CZlvPDmQzZiKd7s
	 uqHLqOLFtO6C0cX3NokqulVHvHOAEBTBqjMvunNmgdssCKBJPy+hmJdldeTifBMT8WGR2
	 O5Li6tF+NhuekQjVvQ1r8K58P/uNW8iSlD+GUFFwWyEgClydgAxr6YqFmgCvaewkvSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5346CA0Gtx+u5FyWY/oxoVnVIICSFGgkpEBWfCQ2PtI=;
	b=lX6RL4fv6tONCFu6WT7bcjQv4cgsikYNXorGfqVnsJYLL1NrtRUEOATt4yOvx3qFpV/l
	 FGw5ypXkT9AJ+v5/PHxcZLywlDV4LePOCDMeRDnlm+BYszrRzRyNdtvWfD92GSoH505/R
	 D1vFDJnEEdEJlg4q3SsmlvBAYtvUk7ssKfQkOW3HfLw9v8cailw3rAaA/xYuQSB7lAI/s
	 at3eutBg7fCpVOPys7fCPHGnJ4Nc3vWDRS7Dumhsc2+x6BsXMM6IK5fhyUjr9dx0ZtIat
	 OYOqb9hxC39y3B/O87nrFQWgWjqWGFpeinv4aWIdU/BdhLeLQhSPsEEougSYg45x4Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1wTqzhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A02606A31E;
	Wed, 25 Nov 2026 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1wTqzhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6332B1F000CF;
	Wed, 25 Nov 2026 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626088;
	bh=5346CA0Gtx+u5FyWY/oxoVnVIICSFGgkpEBWfCQ2PtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1wTqzhj8rF1LJO7/xs6pEu0Veu4hv20MnHHiweR4IZ6YF6KEezm+oSIHv9m1bzyX
	 Dbq+bWLt8BSZwoq2cI3wSt4CVCjuWKjZFpvFcQYUGAwfqRYzRxBz3JM8luCiBsoTwD
	 6VbEEUFv9uRCNGISFQ0CisW9/Nw08iUmWsWXGI/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 728/816] iio: sx9310: use the data of the I2C table
Date: Wed, 25 Nov 2026 15:37:56 +0100
Message-ID: <20261125143906.033197072@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit f3fc8718af9189aad13a2ad7f5b256475bb14b21 upstream.

sx9310_check_whoami() takes the chip information from
device_get_match_data(), which only looks at the OF and ACPI tables, and
dereferences it. For a client which was bound through the i2c_device_id
table, for instance one created with

  echo sx9310 0x28 > /sys/bus/i2c/devices/i2c-1/new_device

it returns NULL, and the kernel oopses as soon as something at that address
answers the read of the WHOAMI register.

The I2C table has the same pointers. Use i2c_get_match_data(), which falls
back to it.

Fixes: 21fd3b1373f6 ("iio: proximity: sx9310: Convert enum->pointer for match data table")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9310.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -885,7 +885,7 @@ static int sx9310_check_whoami(struct de
 	if (ret)
 		return ret;
 
-	ddata = device_get_match_data(dev);
+	ddata = i2c_get_match_data(data->client);
 	if (ddata->whoami != whoami)
 		return -ENODEV;
 


