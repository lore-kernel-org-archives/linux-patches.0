Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1228170838;
	Mon, 23 Jun 2025 21:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712931; cv=none; b=gHiwRHvAnZd00MIGMumXYUjhfizlN2u9/D3db0cAraHv06XIWBK97TKg7k48DfozgI+u6T6/avrpCwhl3rJpbqWXcxfNkzLoAZCbonIsWGjtkPNsY6kWBswdjfDNHyRthZ+Sg5GwX66HMPGuvTmqlXsR9a7j6w78SwfleKMmcLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712931; c=relaxed/simple;
	bh=95bZ4gvAFD2lTIWlFAmd8J3vugMD1xyBi/cCmpVRAaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKlS/ozmyb4roEvtrZwtLlMHbMLAXUbKMpP/p68yHCOFWZp6ten+4aI3XfQ9xrpFJlHFhS5whpI0vRC32ZD+r9a12Rzj4GD7eO+uTjEMjimgfBy4Du998iA03QbT+Bj03ijbWZ4S1Z17TsnV2by+OzRWZJqFNmxkig1r5ZBpYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz9C3+rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz9C3+rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95299C4CEEA;
	Mon, 23 Jun 2025 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712930;
	bh=95bZ4gvAFD2lTIWlFAmd8J3vugMD1xyBi/cCmpVRAaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zz9C3+rQIZPx/+4DrrDxUJrAcwBb7qspKMeDtYBk+FgNIBawREh3dRdtRc3LSeT5V
	 HLwSy6Q7Ghrkq2qogUsW0ME2654nXLDwlr6+fIis5jvQtT0outPRa/AppBce7vpRGj
	 KmfD3OdSiAZ6EEFxs3vTl88a3bPKqL0HAi8f23jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <jpaulo.silvagoncalves@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 019/414] regulator: max20086: Fix MAX200086 chip id
Date: Mon, 23 Jun 2025 15:02:36 +0200
Message-ID: <20250623130642.506349980@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


