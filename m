Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061618;
	b=fimMmL4UX0ml/CHo9A0/CYMN1IkJSjsbM4PdZz1xPJe3iucCCqcuXMsJwmHPpyE7vTg6
	 NA4uztbIshZQPiWi8xHantdCsg8mxwXnDeKz1w4TjeWw9B7yvLl/VuF+dDevqSy6UUGWZ
	 7j3ypSfHbLT6BAqzrRcco5KYXhVtBY+lsvpgglC2IJkkvBtEfa8nbHdsvbebZIrchNpXo
	 XPNdLDLK939dq2hA3l6QXYjo1MYsR2rexXuQOZoQD80ha/IfAx+Y65j/3GoQD1g1eP6LP
	 JU7i2lot59TlfzS6y2o2sLtrHAr12JrDOUhR1Tbjb8W3jAlY1kWvWY4OJCzHDUE9CTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FWlyPbnzXdWYXvn0+Vco4COq9e+21pzr5jo9hefOo4E=;
	b=0t8Ysynmf1hpm9Fw7xxzqkojSbzKoGvINx1BvwUhvytL0LW+VvAFasHxCM3CxJv0aTBa
	 FvTlSrtTEUb+MqB8IkQLbPv6L0cvNBqxNn0YhzEV0WIHssjE5mdVFOwxxz4vBqCl7dfjA
	 S/+OXKG8v4NI/fadOQeNUhxZEtrk4ZEk2oc25hpuy93RYKOP+g3+eotgMEoBrT+x20v4D
	 DID/0yIHItxTuuhG7RdKuqUQlX1NWFaxbtxXabtyB7yFZH+147tBr1sHd9ZASc2uoAnGM
	 lJS73XYHSNxa18/N6M+uB8v9XTLDyym/SqvzZMjfJ7R8S7NGOHf58cTAo3QIOPpKoPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuaXW5Op;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051D960A2601;
	Thu, 19 Nov 2026 04:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuaXW5Op
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540FC1F000C4;
	Thu, 19 Nov 2026 04:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061617;
	bh=FWlyPbnzXdWYXvn0+Vco4COq9e+21pzr5jo9hefOo4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuaXW5OpKxcq6hrNhdI8UI5R4VJd0c4Zxy/hY7ydbf4n0QBjFlI6m9LWSIBX/rVN1
	 Xo2SCiWrB5ZHe8OG4ydAlA2szDWRad9UTNu/2ogylIrMMzN5GrViOkY4/tvR+vEA4w
	 7vk8Xr++I3/09yWZxb2DpdgQz42AHb7tVQ9bEHkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1617/1848] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 16:00:55 +0100
Message-ID: <20261118150027.214546246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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



