Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE373242D90;
	Mon, 23 Jun 2025 13:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685468; cv=none; b=IHJdVtEXLFBTfw4PGcvkVnKrbR9OVS/rjOWfg1citj5fkzD98JT1JZHGuIAS2IlSXiuoXWhOgWb5BjpXAYG3Izb2h0UWY002P/Qrp9jccSfrgm2pvwGjNM+iJX1ttJF4kkTKkI0j12BCvAMO3ajzKaMaE5jb4H1sViPNy3UVguQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685468; c=relaxed/simple;
	bh=I7D+KhIoE/gJsMPpGD6O7Uub2trNdMjEYA3fI/S/PM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poRtSnEVIiSxhjgml49tlLBuKAj3gBfylHJJZvVfepTB0yDVpyAvbM5w5F9CPS0oVqFqXM7nKzSrc8gCoJEYm+RXL/hEIxveNHYycXo/oTPUza/Shd69Enr0Kqa1JrWrlQjneMn2bzNnclh52s9wHbZsWBTmrM+EWfE4Bml211k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2STAfeL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2STAfeL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82664C4CEEA;
	Mon, 23 Jun 2025 13:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685467;
	bh=I7D+KhIoE/gJsMPpGD6O7Uub2trNdMjEYA3fI/S/PM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2STAfeL8YiIxz/sVyHZum1+Bb7wFEcr6OiuPJIdJ2TBTxmIla/pLobai410KwFBrs
	 W5VovnlcTBk1BlayxyfK925nyn4/eZxd84QZWhsZhVse45iNKpF0Q8brbv+nUha3Jd
	 xUTNnDiPyavXDEe48mny1YrHDLg1e4KjBGDpGMsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <jpaulo.silvagoncalves@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 009/290] regulator: max20086: Fix MAX200086 chip id
Date: Mon, 23 Jun 2025 15:04:30 +0200
Message-ID: <20250623130627.246568121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>

commit 71406b6d1155d883c80c1b4405939a52f723aa05 upstream.

>From MAX20086-MAX20089 datasheet, the id for a MAX20086 is 0x30 and not
0x40. With the current code, the driver will fail on probe when the
driver tries to identify the chip id from a MAX20086 device over I2C.

Cc: stable@vger.kernel.org
Fixes: bfff546aae50 ("regulator: Add MAX20086-MAX20089 driver")
Signed-off-by: João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>
Link: https://patch.msgid.link/20250420-fix-max20086-v1-1-8cc9ee0d5a08@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max20086-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max20086-regulator.c
+++ b/drivers/regulator/max20086-regulator.c
@@ -29,7 +29,7 @@
 #define	MAX20086_REG_ADC4		0x09
 
 /* DEVICE IDs */
-#define MAX20086_DEVICE_ID_MAX20086	0x40
+#define MAX20086_DEVICE_ID_MAX20086	0x30
 #define MAX20086_DEVICE_ID_MAX20087	0x20
 #define MAX20086_DEVICE_ID_MAX20088	0x10
 #define MAX20086_DEVICE_ID_MAX20089	0x00


