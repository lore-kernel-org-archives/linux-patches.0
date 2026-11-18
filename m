Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057153;
	b=wtIgYvZ6UDv0mW0rwoGoPKyBtcreM2YX8rO4m79l517ZnKWlS4HUoYuiytUk4/p7gGzI
	 fdIL8/sIlBJ1NjF/DwbrbupdwVX5ToPxlesfnh3T80G1nu18dwRPW7qMFt1a1qXo20AqO
	 54Fgkgw4loQiK/L4O4TYRtAihBWdLpA9vIQv2GvzQkRs2GS7CpqVDqZiYFZdQe7Z7PUzx
	 m1eKe1t1phUEe/99AKAWMGVlcFUThChaS9bskrT7pRh0tfAhyHtrV8B9afYnjSh7acvlP
	 rVW/I/0WUSMFmSiKX0LoFKo25tozBKrUJfqEXHJZvuLsQT9j+oFV2S1PZ6kq3ggLIcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gksxb8N5NkgprSiD7u8Kxw2WHO2mdA/H0ScM88LSTJA=;
	b=40qN8ikQ7/N9msDQWftrhwF4AeB1BKZK6T+7uF2PyQ0FJ56lsyFcFI4JQvTcwfghuNbJ
	 0oWsIqwE7/t3+LcT2/YfiJcxZHiPnE2ZVFPwwxbfPbDqqE0vqIxqAs9brXWC5XHGp1TxD
	 GwZccD3a1iaD4XvSxFIfZzqcq2sG/i+NgufbOsjkuLLhemSHDacDNv2U5qF64NrmI0Bmm
	 P4jLct11OhWVGnOcguzON+8vAV8YzKdlKQ0O+4rOmGfUXpOGt9/e2J1HzR02AeRwk5gt1
	 bBpR1Uuj3ITvFBMW4tpHj0QczWTWdNIFUwBtDhy1c45U81YBMG7DuyW1sfe9I7IxARg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ye5c0my5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A972B606A31C;
	Thu, 19 Nov 2026 02:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ye5c0my5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071E01F000C5;
	Thu, 19 Nov 2026 02:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057153;
	bh=gksxb8N5NkgprSiD7u8Kxw2WHO2mdA/H0ScM88LSTJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ye5c0my5xUgY9PEomwFgG3G0R7+MbrtVT5RDJXE8jy8Pmufut9jlWj6kN+Ztf6hOU
	 6KCJ82I12eTXGtjZd86DIeCrN/9xU4ne+V6i1yXIyjw6FeRVYXN51xf+qYAOsDARts
	 qIGy9aJkwFoPxGmPiLiJgllSdUemngwGxDN875Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0030/1848] w1: ds2482: add OF device match table
Date: Wed, 18 Nov 2026 15:34:28 +0100
Message-ID: <20261118145912.443845870@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kryštof Černý <cleverline1mc@gmail.com>

[ Upstream commit 53f33fd74d3993af0fbb5494b5be709f6ca6b712 ]

Add an of_device_id table and hook it into the i2c driver so the
ds2482/ds2484 can be matched and auto-probed from Device Tree.

This allows automatic module loading when instantiated via DT.

Signed-off-by: Kryštof Černý <cleverline1mc@gmail.com>
Link: https://patch.msgid.link/20260612-w1-of-autoload-v1-1-74e8a17626e6@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/ds2482.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index c7ba3e98ec0c3..61a46f48f13e2 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -554,9 +554,17 @@ static const struct i2c_device_id ds2482_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds2482_id);
 
+static const struct of_device_id ds2482_of_match[] = {
+	{ .compatible = "maxim,ds2482", },
+	{ .compatible = "maxim,ds2484", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds2482_of_match);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.name	= "ds2482",
+		.of_match_table  = ds2482_of_match,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
2.53.0



