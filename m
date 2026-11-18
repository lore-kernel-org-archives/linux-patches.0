Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041496;
	b=oI/E9mgQ9OsDkQd6msIWUbZrR5gQK/BXLfqHfDMZ6fCoQireMFEnBvVR4gVT71ShppKo
	 v7EmrMLNeU2seXAoVwt2785kLrlQ9Yo1GpNHWyG7NRloEgfIH9mO7nRVkCCjOnKf11rBb
	 N8qfJ9gBDsfSU0lobgf+ePU3lZkJweYn8YoDTMovkSGkE/Yvh5QL77PPixD01DjvK/5uY
	 TaXyjE8yYYomIUUtMevk+kv96JVHaU3oHWkV0fIZbGCp+ZPwlZL2Jfw4+3Xkftd/4Y4kQ
	 NVXCh17HVcFeNj2t2k/tbIoi/LZj6Fbl+KguSunNSyTZp/GyM956LU3J9mktIuspSYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UbN94Fct4klFkxGRzyf4C7BGM2STw0HCyPulGWcUdCs=;
	b=5UmFlf5gILIwBh3sq9GSZLTQif2hSKc2bnFm7+uR8qPKdccO5IdAVTmvaC5mQX9YW/7A
	 sI/Z7JbkKzwxbyYz3YNND3qPAB1jl99qIc1at1gXPM9aEqGqe40qDbxaKTjy67FpMkrLX
	 l0n29L4qQNkJS6BI3qEZGuzX2wDXZvZFS6WHVhmXRM69vyWaVKZbobHE2UCMH7JSPp1wR
	 4AdT+JaqyD73EHKhVhPpxQLWPxsM9fQZQq14Z4vTAi6XznT3QY0t9Pr+KS6dg/iVQdWeD
	 LZKI5YuJyZFtgX1Rd8WFQI2ys4KeRmDVkI717R28L/wIFs9vFLTG8XnDSpphn3+C+Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0O1SW75j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88600606A982;
	Wed, 18 Nov 2026 22:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0O1SW75j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938D41F000CB;
	Wed, 18 Nov 2026 22:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041496;
	bh=UbN94Fct4klFkxGRzyf4C7BGM2STw0HCyPulGWcUdCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0O1SW75jHtkqEubZEzYfcxNFzLjj5/fdqC7Pf/VFISn9nZPD7LMZBm5ak8r2fBaO5
	 L+SgS9ZNtfML5Pze4uFwhsA4rx5jrtiTMJTriEsZx8wceswlH0ftXwzaH6JZmtAM3C
	 V2UN7qQRX5UoJGyB9nG5z4E1gRMd9bOLrE3UuaKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2833/3318] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150445.618092081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77dad1e511b46..05e2678dfc678 100644
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



