Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829411;
	b=PKeu86xKsq5NRMKRIerg1tACIhaaCpOxUpm/TXk4VaQUzN7tDUGGJZTA95xVrXJaE1Ii
	 ljeEY4DEM4excpX05QMOsKYOSi9Egh/IG6O6OTShslYv92gk0cQ8eT9ydic/ezsUqiYC9
	 MKftkgDpLxhuoinHyY9Z3w4GF9piJkX0RauohkneDYIeWoyIMw+iThRXJkU0IdEwvx5Qa
	 f/59NZnf9r9kfm7sisBT6l4y2dFcQLoHnU9KIXT5RbCFEyFW0sTsg5o9BT+UZrdOyIKPX
	 cDZmj8IhlWsZUK9KZ3HaHspcU6Vml+KrRoT/O6nIRRtg3pyTx+3xuGdhpGB7UKUMKJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tr+ore537cQjZqAV3Bj6sytz30MXKcnhCiq/NAH/8Gs=;
	b=ahaayuMWLRa65qV7l5BydYSXpeWde67+H4XgTujZVhp6YqGP/dy5ntmEPNOF9c86Wbpt
	 p9YEsbLQLNsxzqp1p1OA5z/NZEZrL2k0bGN5WbdYndLNHgWo0eTXZA5Papn7q6PR2qWkN
	 tx7ohAjKFxcRaX6vuf22uvw1NRXJFXxHze9UTPx48XIkGMPOkECV3Qsn63BMEebXcASm4
	 8f8pRaHzIYBt/+3OhnkW/1BNstAgAUvxOKJKFSf44LApvBltSEWVdo+k13uDqq+oS8kwp
	 qH3w37gzX/YvZ6ijU2NtFykNFhn3iXUz8XNc4qEy0wGBoc2Hvd3bIvVOQSeytgBTrZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0hSD+h2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB04D606A865;
	Wed,  4 Nov 2026 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0hSD+h2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF1B1F00A17;
	Wed,  4 Nov 2026 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829410;
	bh=Tr+ore537cQjZqAV3Bj6sytz30MXKcnhCiq/NAH/8Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0hSD+h2tgmYp2sqkmbwIK3ejnep+NrxuadNG1u+peo2zfniL49DeBjJ5+vKuHL/R
	 VvcrgMdv5X5hAiTxins+QYGK2ZW2ASWSWiDQNQLJDQaYmr0HSxwO3bH/DVncikb0CB
	 94KConZZunbO9s23h4b4n5lGOlEzuEMabDS7FAoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0110/1005] usb: typec: mux: tusb1046: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:23 -0500
Message-ID: <20261104211046.732146683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5e4eb5c96324b226220d29d025a334df28054ed3 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://patch.msgid.link/20260704124714.18404-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/tusb1046.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/mux/tusb1046.c b/drivers/usb/typec/mux/tusb1046.c
index 3c1a4551c2fbf..89b47aa56c7a9 100644
--- a/drivers/usb/typec/mux/tusb1046.c
+++ b/drivers/usb/typec/mux/tusb1046.c
@@ -179,6 +179,7 @@ static const struct of_device_id tusb1046_match_table[] = {
 	{.compatible = "ti,tusb1046"},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tusb1046_match_table);
 
 static struct i2c_driver tusb1046_driver = {
 	.driver = {
-- 
2.53.0



