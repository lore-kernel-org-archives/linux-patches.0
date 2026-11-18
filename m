Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049759;
	b=iN9g6OI5zAu/vPgy/NErCXYmCGstDJK4KyUaSuvwgpBwBO0GDUXuFn89iYQkHREbxgsn
	 JZkNsiFhbIt8qPqdhNi0D3M4tTeZabLgg0wrIQWKprBpZyZ19BSXC3Cmoh1SQESHRKXR6
	 itLE4kBb+BQluaF9dFtKQAFF49fJz0dzAIJcqzU6u7Py8r9zKMCArpC3RzxyRIwEnE0cJ
	 mm3o5ZB1V0TxJHeoPnQxgqbrhKSEG4ifWG6SIj0WsdoBJjz2zlQeDZoc/nwWwF8nBqdoj
	 BQ3eQZDgQHDgc8bNPmvGF/iTygUaH+PB6hh4E+1aW53YPiB3O4vblha81wOoPFCz+Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gt4RXbW4ep+9RcHeVC2Dv76QX3ms9ClQ9kl4btaPzhM=;
	b=eqVamxJvAdhZiNokeZTDG4B2D5iVjBt9E0+inQ+8eg95ZMjxZGD2kp+D2woECy91rUXC
	 aVGtTDOSDPtkgavAwJjxbhny3sJ/0heBBQmijN7z7Fthv/haPjR0Q0k3ud0xX5wuJYqh+
	 n6g6fXK0aFhYCWRf9lCSyj8oePmuwL2HlYvSBlZm0cCryIYY7oKk1DMW7hBuqkAwLSwz/
	 6ljwDDID7MJNNpz5IFKKXTJIVw+hv+E0JanseM+e+xHjgzDulqLRel7Jiq7O/7T6rN7av
	 9aKeuADK7Fnzwa4VfJMFtMCN01uY0BzG1jC/XclsggHdVxYvJgcabJKMl813sbwpceg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e4/vjVj1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C61606A320;
	Thu, 19 Nov 2026 00:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4/vjVj1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C56C1F000C6;
	Thu, 19 Nov 2026 00:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049759;
	bh=Gt4RXbW4ep+9RcHeVC2Dv76QX3ms9ClQ9kl4btaPzhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4/vjVj1eBcvkvSTK6TF9qORUIg2QGKzwQUWx1AthdNiiErM4WmsnPrvGYGwTFY2T
	 mOZyIUpiwJI4CxTk2xAtNULoSedDfA8/woUTq+/kNWWfKjYAAJ7doVEqfnJH7enxKi
	 PAbcVFIf0bH4iA+VQq64H+LDKnLSB1fh/WroRTh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2449/2857] sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
Date: Wed, 18 Nov 2026 15:58:03 +0100
Message-ID: <20261118150329.747375684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



