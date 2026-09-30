Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89DE370AC8;
	Wed, 30 Sep 2026 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783487; cv=none; b=KgfJTxioFFcgjj8hZwSe4QXCgyXo/LheiwURQfdHbJDLBnixLixG4vLyGxe7+sAxPQZYyjwhJCSMily5Vuuq9Pciy7HnCltysH9i6+Z868L+fE00ccLMnDOp9w6Xw7skiVOq6UxKRq8f4YjgZzwSv4hrd1M3rtrthlUFQUO9FpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783487; c=relaxed/simple;
	bh=1XKJG/wgE41vBrqMK2kevUoPd1Py6ph41rzjscGVnVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwXYZz/bPJIWKlBaERnXRlQXj434M/KMxh6UzJcaHX6zIzkDnv/TlGSLfQ0z9jAmJZX+yyJAiIDCKJV0NBFWUuO5maAxbAe9kYRiyYdZmf79Al0MiN+045MzpohTrn5MFiDrlNEoVy4VIIn/IdsHjRBYErmSeIwTSOTOd4JXbfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzANqY+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzANqY+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9551F00893;
	Wed, 30 Sep 2026 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783481;
	bh=eTBC8MP3s05ADra5aXcxAIaXcYZbAi+WIg2zXE92WUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzANqY+nctLFsdrkLvyTFek/uHS+bUH+ijmjBISBJwNZ/DcRxZphKwhM+xB6yvJkw
	 ibpfTA5RpdpzEgINIAWH6lh48B6ZsoP7vf8O9c36oPd6GWj5lQRedSKrmWHEe7B7Wb
	 SVD5JqniPpDx8XF8ljUhALcwpDx8EdM+tJdVZFzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/595] Input: eeti_ts - publish the OF module alias
Date: Wed, 30 Sep 2026 17:25:08 +0200
Message-ID: <20260930152356.605666470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit a52ae68a937efc353251aec27fc995ff66cbe1ca ]

The EETI driver matches eeti,exc3000-i2c Device Tree clients, but only
publishes the legacy eeti_ts I2C ID. The I2C core emits an OF modalias
for a Device Tree client.

Publish the existing OF match table within its CONFIG_OF guard.

Fixes: e32d7f1b246c ("Input: eeti - add device tree matching table")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905134004.66336-1-hppiscas@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/eeti_ts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 2e1404cd09ec9..e12601bb5280a 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -284,6 +284,7 @@ static const struct of_device_id of_eeti_ts_match[] = {
 	{ .compatible = "eeti,exc3000-i2c", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, of_eeti_ts_match);
 #endif
 
 static struct i2c_driver eeti_ts_driver = {
-- 
2.53.0



