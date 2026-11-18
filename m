Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057394;
	b=xfhsaBqnWqOIyOwE+A39AcjVGAX8kN5Ni2ga+3q1mDUOzqMWwVTl+oAaH8paxRLknBwb
	 pk4DPqSOjfEwK3mPUeV7OSUV8U41t6sNanwxYsS479CpBGQSf9enWBJYP75schs5DYAz/
	 fe1QYIkj8qwFC5zofEXAB2x5G1cbRwWd/VtF1gMcWqlS4XB3bGEk9oXYAgJd4VRAXyGgM
	 mEect3y5PJTO21t0G/aOz4OFV5J2YHlCeLfDLx4+fqjJWWgNYhPLAp9KSgKb6kgnTr1ie
	 tvlvYN+fxSAo/zPBFi62476oXPZHTXIHgGJujPg7DSTvwDUOM4qOqvE8C4l290c8TrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4+qmhq4+fEWtKjwGlUn/+H+FzP5ywd+nYmiUGPRf/ao=;
	b=2k0FycMlcRiwb20QnlvX+3QtNhJOQYn1Ce2chY5hpYIf5WKYd3k2PisDfwbhoSVUtbL1
	 OfzwCD18iH8FMTRSx03uiKef3FFBf9jQMbboRz4y5Xq9IvaJwg8+wFxYRsqbWpPSxJrSM
	 LmKQC5rFFNhOmTP3pXD4FPafg4yrc0/R/yhIHFDla2Sc5XkXBe7QUnpKmVHahnaMk4obD
	 RRW6ouvGnO1m4BYSHl2siGmapzOW5xjzNaSvGKHM+9GnxITXM9XfFaC26qHdYwDMhduIX
	 SUo1hkO6oyM3T01xDS58/l3wk8RlKH6plFPyTGxPLyr2I9c4HLp5rEj8OaU4JYVG+iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L531aMOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845C660A2608;
	Thu, 19 Nov 2026 03:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L531aMOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB271F000C6;
	Thu, 19 Nov 2026 03:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057394;
	bh=4+qmhq4+fEWtKjwGlUn/+H+FzP5ywd+nYmiUGPRf/ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L531aMOnkt4RwVF6uBpAbe78o6EwIVBOd777bV6M4FmJfWmweeNJYCShNyxn3HA66
	 OsRytC714kLU1t39sxHL3HOMs0sIw9U+s05nNvCWtFfHKMboLl9RlSGJDFsbxitaNt
	 RGYA3THW0PqWSNscZRBAos7PMNf5gu4P4WK+g/58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0115/1848] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118145915.809823497@linuxfoundation.org>
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

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 065a800717bd5..cb3c228cdf84c 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -454,6 +454,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0



