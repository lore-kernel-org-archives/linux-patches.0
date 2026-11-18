Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026518;
	b=g3nWzuTLrH7z+Hdou44Po6NTOQ+sDRwuLBczpoKJqhQd0uM7B3YpiV9h+IMJDsXMdbI6
	 W27FroXNdg7wUqijow90fiP1ddX4Yr1gSnmaXXskvvH2Thdy1bwcwtaYy1Hjzp0v966dk
	 1CFFlX1Z2hUP5bGDAYwAk9GVbt7JleXjm3hnxL/kuUNJP7ntchEMZyujxo8RSWJVOk+bf
	 T2N64W3jlrpDsREh/E4roDb2jkEbzslcVSPYGP2YH4587BlaJw15n7iqyhwE3eaG/fQYO
	 EX+neBE4dxsPIrFmk+ooPAud3hAMu6PT1+Fjj4wyOLSfhzoK3ZNdA8K4elGcAzrhnkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tF9eW1uUIpLfDBmoIsW9wVB8EOICxoHTR0HUqscSF1k=;
	b=ok0hS9ULBL1bxKuyASNQHpNc1EqAXa3zFvuleEfFkq7RGIBmfRCRaxJnidye9Z6YxviD
	 ZgES/8IUx/lDXzQRRRBjZ80S0b4g4I4G7sFJcheUkVfb2lj+cpmEpZerSnJElBUhd+4Jg
	 W+VIPBNr62pGdVsGy9Y4AtvJlEsBJBi1hrrfz7cKPcBG662K0SOeUO9X8419aDp46j2PT
	 sMApzwpG2O1NaUeI0Wn+KQ1nceVJuRr94pqwJpMvHhKeYmTbp+yFH34Y88GZGmoFJ/Po5
	 71IajJInIGgv+tVMOGHkd6rtW5qCpFtnCDXzZn32xb7O1fcbN9F9BmsmvaZN+PhYDqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOMswJTO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5905606A320;
	Wed, 18 Nov 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOMswJTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0708C1F000C4;
	Wed, 18 Nov 2026 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026518;
	bh=tF9eW1uUIpLfDBmoIsW9wVB8EOICxoHTR0HUqscSF1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOMswJTOmEcOi6CjZF1t0wraJyrPVei3Dax6Xvl02y/HIx/0ARyhrMjRx7N01WWlH
	 N3k3osa14jMPKXc0WJka3niHPiRaTjdEZRA4R6tPWFKXBp3z8rIqlb/knrDxWArNwo
	 B/2MR9KFc4dvtEPwC0gHx/wW2Fjo0ZFMOc7BoAtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1462/2151] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 15:53:17 +0100
Message-ID: <20261118150215.162814104@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3b8386ffc0c33b6b5a6a8e64e1487c1adec57dc9 ]

Before commit 44454baa7ca7 ("i2c: Dynamically assign adapter id if it
wasn't explictly specified"), a negative ID was replaced by zero, and
I2C bus zero was instantiated. Since that commit, a negative ID is passed
verbatim, instantiating an I2C bus with a dynamic number. As SH boards
still use i2c_register_board_info(0, ...) to register I2C devices, they
rely on the I2C bus being bus zero.

The SH7785LCR is the only SH board whose I2C adapter has a negative ID
and its PCA9564 controller becomes i2c-1, causing registration of the
R2025S/D RTC to fail and hwclock not detecting /dev/rtc0.

Set the platform device ID to 0 so that the adapter is registered as
bus zero again.

Fixes: 44454baa7ca7 ("i2c: Dynamically assign adapter id if it wasn't explictly specified")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boards/board-sh7785lcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/board-sh7785lcr.c b/arch/sh/boards/board-sh7785lcr.c
index 25c4968f0d8b0..b93423df582f7 100644
--- a/arch/sh/boards/board-sh7785lcr.c
+++ b/arch/sh/boards/board-sh7785lcr.c
@@ -256,7 +256,7 @@ static struct i2c_pca9564_pf_platform_data i2c_platform_data = {
 
 static struct platform_device i2c_device = {
 	.name		= "i2c-pca-platform",
-	.id		= -1,
+	.id		= 0,
 	.dev		= {
 		.platform_data	= &i2c_platform_data,
 	},
-- 
2.53.0



