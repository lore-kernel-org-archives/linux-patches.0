Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056192;
	b=A0cGjmafM2Vmxhd7vcrD/+2PdwOgswnp+Iw49/b6t9FBp5MrFRt5c6QBQHUAXKCpbPSW
	 JX0pKXLfUfKwtaYb9g4wQnpvgQEwrrqs13YDawKUkpHT2Ld08jIZ+kxOnrMC1jfD8EZ/M
	 oRGx5Jl4AJoS9py6kfCf7ylLe9MvDrnz+VvK85d07C3feFUgepxJ8ngyF6pJDUhInrbl1
	 jFcXDFDuxxdu/ooZPJgX7Fw6BMcnY5pmWpdNSDudAtiY9qJ2Tn/8qPQSQV8qr9pQz2nyM
	 +o+HOJNjx/7ZcNpfNtdlPiq4hGYj4VNlkN9Xpxn6+ywbt0JxiceiAytogHRmw2TfFXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vnexBoTC8oADHrF8T5z6wx21tPU+a8L0sjN+8fXKLA0=;
	b=LW0sF16p7ImN/vXzWM7ynAnsJ46ianmp6F0h+Ee85NyGYzakwgG0ArntbAbbRz1mzv0G
	 K376ZrWEYqKFASBEfE8XYxvLqGH7KEEJjk4GHJlEFDNSw5DNA3xmxUTzZDTIRVkRVQrkJ
	 sslcvT1tJJvaQNzGInI4g3z2BuqJAjc81yIQC4ieog1kk/6rH3a9JMEIZMGDfNRtEC/2/
	 gOB1VjFTOY4C1USrECoDKCPTifcD85GT56EpewFGW/LWt6fmBZvrsePfzHjoRPUxIK/xT
	 PUBFZ2hHge2zIH2I5OJN90G3sBQyHt+DjUMco2y2VbHlzcxECuKR/3aJsUrE8bJ+gQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TUMAE42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C053606A31C;
	Thu, 19 Nov 2026 02:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TUMAE42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B5C1F000C4;
	Thu, 19 Nov 2026 02:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056191;
	bh=vnexBoTC8oADHrF8T5z6wx21tPU+a8L0sjN+8fXKLA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TUMAE42SGJLXm2ZRiZGhYYrKcrp8kXP506wc6Fc03seWj7bpeDU++zu7zARCRSW7
	 UEYd6A+4tjchjOu9iNd6SM1jG5K50dQC+unXDjboFtMb2eyPn++UmCThf1eV8CqQTd
	 6J1O0JnfHqvMqnSRu1Oj9kmsxV16a5nSIXUOatLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1898/2214] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261118150127.087963139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



