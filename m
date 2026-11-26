Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704712;
	b=fy7FHudLhQu2Jm5/VRENkjGlBuepTLqVDPY9lOZxy700oSdnPUZvxyCwpmZIzD63QNR9
	 /Labr1vMlIvOqCm+tyCnFM6MkKeYidXuFaw6wDEMthgwiiybwVMzK/IwqHHcxaBCRN5J7
	 VfZoOLkGxgSnznfOOLiw5PWYGYEbj/6d59bzRSbrz6ozFTs3Ryx0O+J9Ic4+4XM4LV62a
	 Eq9A5WQtiJOzCpM/EZwcJMnx0cSIPZdQZ4Y0TB0VrYO8xK8tH5X+fzWI+tmK6aqdyWbmT
	 r/v8vQYrJfo+FpWXSWhglnVV4OFPU3n+aHlX3ugwdK3stQ3MdZ1HW2LBMcEvLDI7WGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yTSuhjz5ocCPgtsDCZuLGZM3TLOKBdUbuFjzxDcIuE8=;
	b=yTGRmLg26vN5+UfAb5IWPYtmZcixMNh36NvXEcqtvm11Fej8fkEf85WUsk5ykhK/euq6
	 uo7iVeaf+gt718aaDxtlnC/tP/xTqHertfABTuP43vFoeFCWc14Ef1tt091XU5BHOl69m
	 m7h4w9GJm7E39Z7/555og/ZFmWrUAUmsn7HFEexwRb+ySMtMc9S0W3/UD5Q/0S8XvMOAI
	 34d+KCmiIv/i2TotZYpFWJ0aM/bGRErOcKMJZBbwbDq7YAaeESzEX/S+9+L2bBVe3hGhZ
	 wXUqoBHbrKGMWjt+MeHXX3YgrR1gLIzw1FlFfDBQiBNHgIuoJgbGfcvTXgMLe7O2Hlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkoCB4j0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABB8606A31E;
	Thu, 26 Nov 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkoCB4j0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F2E1F000C4;
	Thu, 26 Nov 2026 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704712;
	bh=yTSuhjz5ocCPgtsDCZuLGZM3TLOKBdUbuFjzxDcIuE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkoCB4j0e0nPyz0/PqkJCamgQxv5MnakVw9Qb88qBEkYcnPoA9Jh+vBlNpQI5eAv8
	 lAFX8V2CODN27Z6l5wo7D0q5ZyU8okRf82WdRzIHgD+wouNyBZjcYR9rBiLkB2XChJ
	 Tos7ExZ8SU8hkwx5w6Im8tncbiHeS3Dr0Ti045bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.10 218/265] serial: samsung: put the previous baud clock
Date: Thu, 26 Nov 2026 15:39:08 +0100
Message-ID: <20261126143620.494149866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit eedf2cf3505c1562a2fb24f8b997056f023d242b upstream.

s3c24xx_serial_getclk() returns the best baud clock with the reference
which clk_get() has taken.  s3c24xx_serial_set_termios() stores it in
ourport->baudclk and disables the clock which was there before, but does
not put it.

clk_get() hands out a new handle on every call, so the new clock never
equals the old one, and every call of ->set_termios() leaks a handle: a
struct clk and a copy of the connection name.  Whoever has the port open
can repeat that at will with tcsetattr().

Put the old clock when it is replaced, and the new one in case it is not
stored.

Fixes: 5f5a7a5578c5 ("serial: samsung: switch to clkdev based clock lookup")
Cc: stable <stable@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-22-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -1418,11 +1418,14 @@ static void s3c24xx_serial_set_termios(s
 
 		if (!IS_ERR(ourport->baudclk)) {
 			clk_disable_unprepare(ourport->baudclk);
+			clk_put(ourport->baudclk);
 			ourport->baudclk = ERR_PTR(-EINVAL);
 		}
 
 		ourport->baudclk = clk;
 		ourport->baudclk_rate = clk ? clk_get_rate(clk) : 0;
+	} else {
+		clk_put(clk);
 	}
 
 	if (ourport->info->has_divslot) {


