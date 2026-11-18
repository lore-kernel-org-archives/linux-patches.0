Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023782;
	b=ugOJRZ6J+SszJmVaC+MEgLy66JHLgLZv1AOgDEnWVeZPWyj0CwhGTCthOmE96/DUzczx
	 YwKXzQzAXppPMXP1KAhbtJ1CaNWIt9LpP+rUV6hJg+xzhJQRX6KBxPUh/Wyt1nj4pZH+U
	 +8qdroSZHx04ae58xIfDAr/90+LU+FE3EyghbLbFHTXgP3OvgHIK5RLoayQUIErEpp0zh
	 1Q8WLFj0X0nRScq5Cat5uDSMdcCjJtdbaTgpehto6UW0cK2QLq/AyhFEm0MjBtY3ORcDw
	 I9Clld3Ae3Qu+Thxio8Hm0RyDOYupPTYpoQK5IBjtDdYgzveBYpJxw4YhIwLE0CHF5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Mq2tsgksphgR0Olzbt9nxKeTT+2vZpbbyXcf5Ucg48=;
	b=N7S0oVeutfS1VMzZPNcxOkK+0Q1AGuII38eRtzHfIEdTIr/9X/UIsRZk4NOtOEhDmwmk
	 c+5RWXss3s9Az8DQJ7fFtpeb7EeNIIt3LD6gY5+n9W1jJvSHGNlA0M8BS4djFYozGK2YL
	 rNRP5f7MPKVQxJnnrC8ii+0CTSmEq4OaXrsi8be+rNECKbCdoLu+zZvuLkKzoic12ApQU
	 9aNJWFFA405ziXUWZAEipEnfdvzsnRCLoES4qnNd7b221oKGkBQRymXQZPk/lzsPAnPU/
	 UmwJ7UT+Czg72PZDVYvaYwUKLVjzarGSn0CuyrU+eJomHQ+Titt0EM5cL7sI1Ldv/tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJfCZtZm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B016F606A320;
	Wed, 18 Nov 2026 17:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJfCZtZm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3791F000C6;
	Wed, 18 Nov 2026 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023782;
	bh=9Mq2tsgksphgR0Olzbt9nxKeTT+2vZpbbyXcf5Ucg48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJfCZtZmFKtT4w7GE5GmIf31GOW+kVWKqUHRjRHN7cu7vWtnwPG0S2Pu8WBrv1MjP
	 ITfoqPyTr6BctgflwmJhYQedpd44wo9Rrkqo/f987Kx7k8ITSLxYo4cKCgVlrOCg4S
	 chDrJhF28lnAHmSBrzPg4PBSSs6RgToDOOoZPEOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0492/2151] clk: si521xx: correct the SI52147 OF output enable map
Date: Wed, 18 Nov 2026 15:37:07 +0100
Message-ID: <20261118150139.976572563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7a4cc47d715f08309089d40b8c29fb0ba79917db ]

The SI52147 data sheet assigns DIFF0 through DIFF3 output-enable bits to
0x17 in control register 1. The OF match data uses 0x15, leaving the
DIFF2 bit out of the map, while the I2C ID table already uses the
documented value.

Use 0x17 for the SI52147 OF entry so both enumeration paths expose the
documented outputs.

Fixes: edc12763a3a29 ("clk: si521xx: Clock driver for Skyworks Si521xx I2C PCIe clock generators")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si521xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si521xx.c b/drivers/clk/clk-si521xx.c
index 4ed4e1a5f4f2b..f167fd63c5040 100644
--- a/drivers/clk/clk-si521xx.c
+++ b/drivers/clk/clk-si521xx.c
@@ -375,7 +375,7 @@ MODULE_DEVICE_TABLE(i2c, si521xx_id);
 static const struct of_device_id clk_si521xx_of_match[] = {
 	{ .compatible = "skyworks,si52144", .data = (void *)SI521XX_OE_MAP(0x5, 0xc0) },
 	{ .compatible = "skyworks,si52146", .data = (void *)SI521XX_OE_MAP(0x15, 0xe0) },
-	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x15, 0xf8) },
+	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x17, 0xf8) },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, clk_si521xx_of_match);
-- 
2.53.0



