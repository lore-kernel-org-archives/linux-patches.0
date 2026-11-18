Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057422;
	b=gK4212MfozwzyLI0L7qjKnZrQlBju7payG6IN/VltAkjiHXD1ghKaMvWKKn+cXSboeeA
	 KHANZK5ejKGZVr7UI3AmKCo1XF5O/analNAkZtX0/IP1yglkThS/4QWedueJOVYGknGuu
	 ZPbWUnMh06S/HQfbLlvdFfNZJdw31juzKfU1zRGv1E/WxD5hHoKtigspUBpm24BbGdKuE
	 Wf5k3nqz2ZHHPjeXvcia8ifV+cZhU2W23t1xprq6owRuWHrSowtpikKZ37A0SJTvsdlH6
	 vVpF9IOXsdpXpOmu+Vfqp+g4IhDdlrQhSKfiqJlk5yak5rtaf3oLv8+9bxj33JBNUsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lvt9N7M8hD/uvwgCnN20P7Oafw/kbziHoZxTLojTNLs=;
	b=mmyUAQmBoZ/PNbTjhG5tJ6axb7G348AccdF4L05afbGKnBrhNCYzClGX5uwuudYf8ai3
	 CpAUTDVdBvnnHVLg/WFdlpMi3Z2kSoCx8dXWY1+DZ/7DaAoiCRjms6kmy8QTM+iTUDzJz
	 SfZMIm7bkxNGuYI+avMjaN9WFtknvBEJcetmu+S+jke5XLSl7AVQtbv03ukpz1KyX6H9b
	 48HBp2iGtVrvdWBjaLDqXbXsvBMXW5WvwtVW/M8Pwr6tQ6Ls9kKZLgKOcZBaAFiUB4FBY
	 HKQwR/OMmJj9XqnFZKPXtNXXK0tcwwuRBYg1lM9aBguhMXrhfBmpdRrB3bttQnGapyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWRGqm5v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB8160A2603;
	Thu, 19 Nov 2026 03:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWRGqm5v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD5D1F000C4;
	Thu, 19 Nov 2026 03:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057422;
	bh=lvt9N7M8hD/uvwgCnN20P7Oafw/kbziHoZxTLojTNLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWRGqm5viXwnWoOPxveFI25KngwJcawHIbXb69t8EC2kDILzJLDwdDDyN+wzTqup2
	 SbqwztETbGIPt86NUQGH86Ddgci+m+3r6TR0bUgTuoEFN8o1kJYTk2RWlkPu3vGdCC
	 AKU8EPWl2Z4FDjHntA7dqguq9wn50Ah+xdJINKeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0124/1848] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:36:02 +0100
Message-ID: <20261118145916.229920049@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cd21fdcbef3fb32136f72075ab668b075423b3f6 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://patch.msgid.link/20260705001705.70400-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index 8c14e0bbe1a24..3084236911fbb 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -142,6 +142,7 @@ static const struct of_device_id imx8qxp_match[] = {
 	{ .compatible = "fsl,imx8qxp-clk", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_match);
 
 static struct platform_driver imx8qxp_clk_driver = {
 	.driver = {
-- 
2.53.0



