Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043067;
	b=t/9VJ2jne5i2FpbfMx1+eT5xXy5WrZLQ+U8OExSYPxBzOuIzL747TfstjsUBIznIGmVW
	 BAqUgpxJRbGZShmJo4ejNvTznsdKxx3YnP8eRgTK7AAVEXTGnWRP+4boW8h8YLCfcsbSh
	 gWDfSAQtWzcDeAGGD0HVpZdiM1QGSpTe3nnGLIjoiVWU0zAYMoaUbhJNHt8CBFehpYYIx
	 zFTN46LNgPBMyhVgNmfIL+SwmMwMNhuigXx9nnkt+aHQKLkl1/4HYlBNd0wodQYWljROX
	 z4c9jBZC/PUB0y20R7bYShfv3DWcnCQwbCT6J0zbiIcxUj/0mXF72b+bFwv0BMLASHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6xpnXgd9T5SBkA3Wdx1eefbK/I+6khyBcv06lL/KC0E=;
	b=WF/jPiEQXNw6snp/O3etBLcG2XcVkcxf2yu6+iHZZl5OJtaOTOWVtBVb91Y9/haTrOta
	 3m8GjXHx+O8AOvve1uKhSN2pa10ewqX+Ip/ZozrS7fNPozcRsv1w9FTx2jq+P5breEyFu
	 0KIYZQBnjfNEgSAnSTtYuViCXhMLUxX+Sf9LSGCuYUgvyQODSQ+bBBJW+FaD0sFJHDZJm
	 u2G+xjtuIuGikhGmH/3vw9VRuGbFIiP8gXGLGk/Yxejza1GOp927cjVdbxYmIXPnxVDYz
	 Xv6cZKtx2N5e4RdGywZpYubYy66PiqUECiMAD9VvNPX04Uxf+aME9xQsY95Bov2BudA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HHC/Bx56";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A08606A330;
	Wed, 18 Nov 2026 23:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHC/Bx56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2381F000C4;
	Wed, 18 Nov 2026 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043066;
	bh=6xpnXgd9T5SBkA3Wdx1eefbK/I+6khyBcv06lL/KC0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHC/Bx568Ga2DloKxen7ZrEHI2c9qK3VQat2MdlzSy5o4aGD+2FYzT80x9HDFS5nP
	 QjsiezcphlPpQYj9BAJwT0zUmxlCcH5Kp6EzjrywJECDPWhOLr+GxvrjmE1nwWlmtJ
	 2PJrnhV8nMN5xVsJqHa9BndSJphXvKQEylzOhmvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0078/2857] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:18:32 +0100
Message-ID: <20261118150204.111936986@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-sx150x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index a87ea3b95cf47..c012f422f57ae 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -829,6 +829,7 @@ static const struct i2c_device_id sx150x_id[] = {
 	{"sx1509q", (kernel_ulong_t) &sx1509q_device_data },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, sx150x_id);
 
 static const struct of_device_id sx150x_of_match[] = {
 	{ .compatible = "semtech,sx1501q", .data = &sx1501q_device_data },
-- 
2.53.0



