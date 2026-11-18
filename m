Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031742;
	b=3NRk2VQPZZYeHiQIX+q7ZNWUIQN01Hj9BjVXjNV49A0u8WNcXwArwXNswFVd57k6JVW7
	 fNwSRpozkBK6ZrlpLQEx/PBRnOtyUMsDn1mR2lYSIKeeFjg9YIrHBjrQNM5VbYFlfwtmx
	 X4HZ0u2lal+T7ewzpZz/GxDYAJNzPskljPvboHC8E/VAMw7txqeWtw/Dkt6GwUl9ce/is
	 tUmexXjcIe4UtZIOfw71EIcVRKy7FkAZ9K6Ww7bYKSff1RB3L9GRuQ0P1xIYbQGdsHEaF
	 HC4L0Ia4KB8kvZFytfkscrnTyKBTAYNNVgsT5qudQUzAYvKVwDN1Y9wPrpJ8uHdBZ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jxr3tcLjaMfp//1z1bFRGhIeMTV+Ec0caesbNeBjN0A=;
	b=A1nLwPDftBVPPvzmCPgMWc60Hh4CO4/VvYqng1jdPqyh/t22/Vh7mVdlwqPFTLdWk1FQ
	 +buS03gKj9PLYd0YUxfQpFYY5MzxObo+18XICyqvrSxvoA9U4dKKBoGK2FCooXoLUpOMY
	 61m0IdXMRsRIiSBZFJdyY1R6/MLvWXFZfIvMr7jATFu/ZggYsdoijf7ec3i7SMzT54LTA
	 pSvfz941bAUxyiRIpvumEJTKJG+h99HmLmmQ06EMXt1VHZxzuxk7ykqHulmAtEWGlG0uz
	 glR3zNeMvTrnoXAlFPqf3ZiaoUit++puw2LV4EOT1GLpxqUja43uN83dGhhjiWYPA2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lx2nJVC8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAFE606A31C;
	Wed, 18 Nov 2026 19:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lx2nJVC8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078981F000C4;
	Wed, 18 Nov 2026 19:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031741;
	bh=Jxr3tcLjaMfp//1z1bFRGhIeMTV+Ec0caesbNeBjN0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx2nJVC8fq/RlkhmwxfCxn/bwiXodC7Nij2FbuuigW89V/fFE22PlBMMCYF1Gdy8s
	 tPzEPYgzDMxKxM5tKuytMyZ1Knso8Ywmd8DB34kjT3M4WuhvSvaxK+rero7KEaFUmq
	 vPH10oVCN5eZX66RjSVF2AFbUaO1m9WmE26gsgII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1165/1756] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 15:54:52 +0100
Message-ID: <20261118150056.363782761@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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



