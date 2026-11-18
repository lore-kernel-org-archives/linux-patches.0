Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031866;
	b=zL75xDlaHfkZWNKjPiNLXoKApaseYX1y4c41OJQBrrBNft26t0+TGoDUsdbyNSN1Rs31
	 /KB/f4I065lEllfYlM/+m8yyCD0L8/P1zv2sRHGjfB7nfiLyAxhIik+Me5JhlNXc3uxRn
	 d7jrEa7Owev95amAjXl0Je3FrTkF1JZebpT3EZA6qh1rwsQ5cLtphvxb3KGbgwL2yv+bE
	 vodbldyRfjdtoU0bTHPT6O1/EqlZGR0hYmLlOlMHboeIo2Fgi+89emlktezF6tIppkuUf
	 hkrcK5PaT8L3Lt236AwrEIP1LjENbhDQqzCQ/8w7jFuthJIcw3YhkBaB+21dm0RoZJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4UBcof2Z4zhup1m6nxzcrwdYTvAiWOqBKP+bRk00ZIs=;
	b=F2XeIJoW6pQrSu/E2+SVWzO8kklt/+1PTwgnAXbeLzq5LHywqR/x96xPn8tHOsC6mS8I
	 E7x/6Da3Xg/qMVVYve5+lbBcNCPKZr20SDLHMqFLQ/cH/FGZRuupDzBLytltW3ejWIX5g
	 Cy0ol0S6JPq654G7Qqp/sSXvcYETFpwXmTnn+I9crPkWlj3oGYunlzlF3JLD7MAPnvu+A
	 9QNi3vJi2GZZjOxA32QXsGnsNT8A/K04Pa+mScn9WED4qyk5DjB/IBP49gJKqJWPlsOja
	 efkrhZysDBCBsXxrcCIyo6vRWTia6fwB4uuHTYZeg8hIoLrMNPsk0NAi+BH9Y2NPsWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ueo/XL62";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7473606A31C;
	Wed, 18 Nov 2026 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ueo/XL62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AA01F000C4;
	Wed, 18 Nov 2026 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031866;
	bh=4UBcof2Z4zhup1m6nxzcrwdYTvAiWOqBKP+bRk00ZIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ueo/XL628OsZSQjawHBYJayvJrZhWuATOBH5U1pfam0GtptVq8AUbhP3juu2d/bSi
	 xOqPkGyWpzx97u2smPhlx4u45UQ/3GNsWPzrX4sIKxWycNfnNAwP2NKcSj8ZwjbLgT
	 xsJZJm1UXYSMn5Ky20svnY4L/HXpUjamuYjpODy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1192/1756] platform/x86: hp-bioscfg: fix oops on short integer attribute buffer
Date: Wed, 18 Nov 2026 15:55:19 +0100
Message-ID: <20261118150057.326757604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit fd7545cd398adc09ec2f9b603d72671560ee6bf9 ]

hp_populate_integer_elements_from_buffer() ignores the return value of
hp_get_string_from_buffer(). When fewer than 2 bytes are left in the
buffer, dst_size is 0, kcalloc() returns ZERO_SIZE_PTR and
hp_get_string_from_buffer() fails without writing to it, so
kstrtoint() faults on address 0x10.

Return the error instead.

Compile tested only.

Fixes: 6f2c06d5a467 ("platform/x86: hp-bioscfg: int-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-10-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
index 5577f571d7c06..f30a63e4fd318 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -331,7 +331,12 @@ static int hp_populate_integer_elements_from_buffer(u8 *buffer_ptr, u32 *buffer_
 	// VALUE:
 	integer_data->current_value = 0;
 
-	hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	ret = hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	if (ret < 0) {
+		kfree(dst);
+		return ret;
+	}
+
 	ret = kstrtoint(dst, 10, &integer_data->current_value);
 	if (ret)
 		pr_warn("Unable to convert string to integer: %s\n", dst);
-- 
2.53.0



