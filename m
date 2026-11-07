Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060684;
	b=B0MBud5cO9KkdK1za/tPGV5xkWPKf68x8mP7uPHxUCDBbVpycq1UOzdZSGHD81YOVFPy
	 pNILBK35muNITx4fBbX5EkkUPkVEp0TGL7iPVO1o63KFDdn4ss0gBvz/QDrhxtdoykGXT
	 06h9tpWQx4QgrGl76M0lvB/XUmJbMaidZMNcdObnUNOCrsm2KZW/WNbrJoLBJJO8C3Tu7
	 S1sHRhXz6+3H4EmOdO8z5HdEFRp//QGDYz8vTNolHbn8pQn4asAJChgJEWHkLQx3xTvHG
	 3QtcZ08fc4TsD+yPyZD/KmVi3PmqdvsUi+wum4vaS9Al7uLZkFaz1w4INtdcKLH0pVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a4IxFkbuRwcGX4uG11zewPu2SVEAAqV1x4X6Oy6uyVY=;
	b=nc86D8oyvrKuAAX1WIoeVzO8bLG9RNt+TtO3sTYn9Wz/o7k/HVcYJVAELNvDxKQ/wc37
	 kxE4M0CgrpkkWwBb3k4LATqv341ALEEceqkI7OrxahitkOh23j9qxSHPtWtaDOfXylcsa
	 KpyT324k9ajx1ZABUhuZlPGyQMlCXf+Pix9M7h8mnQxfSN2WG+U0fWrzoLj2fw1ESC+Pa
	 sGrSXaM+OzbGWVULB1/wKBAFyiGG0niHwoTUpTgHjHgbeYjXcbT3Z7r0i3L8HCRMWNPLc
	 pDSX0liq6BapggDdN5ivCuEKLMgt6a+Aij3MxIBRbn8XU997W/wxuvtzk+CAqQA75wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZmjPYP6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBB7606A32C;
	Sat,  7 Nov 2026 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZmjPYP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CE01F0089F;
	Sat,  7 Nov 2026 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060684;
	bh=a4IxFkbuRwcGX4uG11zewPu2SVEAAqV1x4X6Oy6uyVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZmjPYP67E52k6VXmgxw8WmsTa9C7a3LmHadLQQQOcNYRbpyBpNM4IHmCHpBRTglN
	 j7rUvvYF2oWrEj8MPr0PMe/yUFsWm3al1J4w6pI2IrMwoA6i+aa6DAqYuFXT1RQvVM
	 w6tNg/GiuebF1gNJFyUZaNGZiZGZ2Yx/GlbtMIv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0116/1536] gpio: vf610: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:32 -0500
Message-ID: <20261107135000.941706973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 975a1d61260cf74d467f34898fade63165c80735 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260704122123.73004-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index c36a9dbccd4dd..1dcae1dbdd14f 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -83,6 +83,7 @@ static const struct of_device_id vf610_gpio_dt_ids[] = {
 	{ .compatible = "fsl,imx8ulp-gpio",	.data = &imx8ulp_data, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, vf610_gpio_dt_ids);
 
 static inline void vf610_gpio_writel(u32 val, void __iomem *reg)
 {
-- 
2.53.0



