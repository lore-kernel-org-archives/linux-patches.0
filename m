Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062988;
	b=Au9psaJDAm8djqlKzloGHlXF9VvT/lxirebbPQduZet/Xpwp/JaJBOTt9I/un2KMcSHt
	 LO9fFzpyEfM3Ssi3IdwbTpeqANiSyN4VtrEHH4920uhWSvip+S7oQUIwzkSZumTeiu35L
	 pUVzzD9bNMV461CXbq7iHgG8cxPWUexccWogi0WvXeLbySuDUgPK5C44nIHyrHSVbXcAY
	 CZaW3tuMO9eNsvk5uaqoK42Fb5BMaVMmFfGR5CWB6XRoHKYVxxk+jgKUCQTzpJ9KjtUCO
	 H9AcCPhKjPWkAQAYMZXzGfRt5FdBfkxKnDBdPCcFNthJnWV0PTVsyMyzqHL8y2vmJcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mlh8D0BbHEQP+00i5+7UnwzuniqaJeUHWcEzWNnMD9I=;
	b=n1+mFtSOYzD7txS///maX8VYw0kW5IzHhONkpeRHr163HLLNGjt2GS06xqvIgc+bqM3F
	 ZW9rsN3s7Y6UpvJxvha8T8a/STYkDr0hnyb53To8CoCYfMOCw9TrBmNE7rrg4wDIBxHoi
	 BdT03xVko4Upm5NTq5ITKBonA8eninSUxxiYjAF5CZp5272kpXFR7TIO4Q82V8K7rW2Zs
	 B6t9Gc7dnNIaUrVhzQbVDQCImFsSASLqYPJvFdqe2xfqHn2kBlVSH21gMV+uZ6folfDXi
	 CvgWqGBStBtQjUQc9CcBKIIzSC+tYeFazaiF5Z0fNiIHZAQSEa/FT+MUzZn3nXjvEpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpey0oPS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CB3606A326;
	Sat,  7 Nov 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpey0oPS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4951F0089F;
	Sat,  7 Nov 2026 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062988;
	bh=mlh8D0BbHEQP+00i5+7UnwzuniqaJeUHWcEzWNnMD9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpey0oPSNwMlH8DD6Ysq4aJyhYrrfBywF0hu6IlIoYG3nonvYs93bLsn/0yLQZr5a
	 C7v1pweOFf4skaq1dJgDwH9Z5AvU/mTFbbDe59CR9b1y+tuXiMaUmGKFzi9g+naNox
	 XsM0jZ302WbZuba50nrpmFZfhcyIGr8XSMhTwkwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/869] mfd: Fix MAX77705 dependency on regmap
Date: Sat,  7 Nov 2026 08:48:31 -0500
Message-ID: <20261107134859.617884083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 2fdae2d590a0a5ad4cd60bf8e7a6ecba7265f268 ]

The max77705 uses devm_regmap_add_irq_chip(), so add REGMAP_IRQ
and REGMAP_I2C to what the core driver selects in order to provide
these APIs.
This fixes a build error:

drivers/mfd/max77705.o: in function `max77705_i2c_probe':
max77705.c:(.text+0x250): undefined reference to `devm_regmap_add_irq_chip'

Cc: stable@vger.kernel.org
Fixes: c8d50f029748 ("mfd: Add new driver for MAX77705 PMIC")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260827-deps-reg-max77705-v1-1-c83a74d3d428@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 55a9fea95195b..ae39cbf317107 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -989,6 +989,8 @@ config MFD_MAX77705
 	depends on I2C
 	select MFD_CORE
 	select MFD_SIMPLE_MFD_I2C
+	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  Say yes here to add support for Maxim Integrated MAX77705 PMIC.
 	  This is a Power Management IC with Charger, safe LDOs, Flash, Haptic
-- 
2.53.0



