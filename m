Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016016;
	b=B3S/BX3MTX+TkMyc4r/70lqD0Pc87z5YIFVIXA4uae8S/vOvqS90ekCBz2btdtCDvWk7
	 hEjCd+lI5x9seVmcubz4Cm9nXNYuCgzL7aEAgiOzG0WmwtHjSo6zdznr+IbrWUEe9S3SR
	 uP08KbzAKPQ8jhtCUKMzmVfthcH2WEW4iljlwnuGbUsFXVzGCdp9KbvvmovzgyK6b1jVg
	 0EwWmVSu3AJXaF/8zqpoVHx4wxjJTFXygxmffxCjdQY51c1Oz3jq/yFvSsY43BVAfcb7g
	 Fi4OKsC+08+NogmXwizO0OSTOvq7fRVTu053HePw+5DparqWTTMLPayvF5ry64yMneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Or620Ee53uqkti/03lYfQ1CES8tiP8mf1ZrVU8gTW8U=;
	b=02X41nznFH7dqwD++i4VN4a4lTbOqyd6AQiP1C02CoF3X+FINA5YpnvzzWOrwtUZ44dc
	 1rXuN9brYJNeCiGjn0GYx4mBo3uUCVFNWEwUIOhRooYBWMPsbR5Z2xHi1xUNuZ5EBwGTr
	 p6/BD93El90mbFsGqh6z0FnpA60JW1LKerxe8BQQjhB1bIpqhVHkjS0OPvYoGabs/AULW
	 5qcOc4IeqSwvD93bzfEqqU+KrRCc57q6b0nnyZ+dX8v61RlJlKAqU1vhcr5QQY1NvNWAW
	 9ZZbe3R82hF6LatWyIflUryr6ePy3WnmHd5iQae1HYqrZgscp3I04PdmYqcoIqaCDBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g5/i/vqu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF05606A334;
	Wed, 18 Nov 2026 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g5/i/vqu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1877A1F000C8;
	Wed, 18 Nov 2026 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016016;
	bh=Or620Ee53uqkti/03lYfQ1CES8tiP8mf1ZrVU8gTW8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5/i/vquEr2hJMhSIJdTHx0TXlX64DQmyVT6iBY9I3dZ4Ui/GQ8JrtwTiRONJ2Qr3
	 fO6WW+PGGOY4mmu7VBaknQFkBFgyP/gnO3+dcRRbrrzlf2UcikaL8s6an+B4u71nqz
	 ezZ1sHNOFOJ00SOpaJm/kbSflikZfkkWCG5BrH9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0377/2651] regulator: ab8500: Fix AB8505 VANA voltage selectors
Date: Wed, 18 Nov 2026 15:26:57 +0100
Message-ID: <20261118150301.408473801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit dfdfda2a95843706428a9d95ab546cb10983e684 ]

The AB8505 VANA voltage table assumes selector 0 represents 1.05 V
and all eight selectors increase linearly. Selector 0 actually
represents 1.2 V. Selectors 1 through 6 cover 1.05 V through
1.175 V, and selector 7 represents 1.225 V.

Correct the table so each selector reports and programs the documented
voltage.

Reference: AB8505 User Manual, DM00046744 Rev 3, p. 257

Fixes: 8a3b1b8703fe ("regulator: ab8500: Add voltage selection for AUDIO and ANA on AB8505")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-1-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3705c98b07139..ca59406d42a85 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -264,13 +264,13 @@ static const unsigned int fixed_2050000_voltage[] = {
 };
 
 static const unsigned int ldo_vana_voltages[] = {
+	1200000,
 	1050000,
 	1075000,
 	1100000,
 	1125000,
 	1150000,
 	1175000,
-	1200000,
 	1225000,
 };
 
-- 
2.53.0



