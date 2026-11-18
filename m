Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048004;
	b=04ft+SpvfFBSCg/k7l7hq8WSUYKEu4o+0gCS72giMcdwojSN0YvE01D4gbKfPQuVtIMg
	 POJoVpmu9IG7kSpo4ejpfeFmXSk3pGW0/h0KdjIY8d/5VB9Opx9bEiYUGo6vN5izaqtFY
	 9AHorXOzERviH3IIj1uH8TIe/wUe12MzQtPtIlqtpLhDkCYQs4SmpQrgKqUcp9miYSZND
	 c8c0tU7ysQkpHs1Jyp8gYsysCl12kEFbyptlZnKuhZ8Md3o8otF4tFCFjKJhuMJkUPZmx
	 /x+yLKiQOzG9ENcEdN61f9GLYip2SdCwHQtaISFrHoHAlBb2QGtJs2bqoF/e7o1Qk8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jk809x2GeIQxnlpSJ9BYzU1XLG89FFaJS3sqQEnGoZg=;
	b=rTSY0AUnID2gM/jFSYGvKAuKJ6yciNNgw9PyIXWit/e9TfJyH9Oikl7oJv4L4MJKp4qQ
	 2Smbfq7rR8utUS75FVyjNXLPOKvNjkqOwEEllkUvwTpZEAExHYtqhm1B1CwNppB5uY4Yk
	 IOxd3E1mUYXANRhWeyTuaWUZ3hmVUm0LjxMsqkCe2yWH2Jcm0nJHtKT619YkAlLBV5v4V
	 xnrW2BVTDn1LyCZjMoQ5pITz7HPtl1golmbKIIuQCcP0E7Ps6Ukvc3nZ70oB4a1ILcjKW
	 EU9in6bYP6AZoeyvnmIctnhaeHGgz9WFHvIU7o/6qVc4dGmWUP/BZe28r2NCn4ofq7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jtws0/dz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D503606A31C;
	Thu, 19 Nov 2026 00:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jtws0/dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9AB1F000C4;
	Thu, 19 Nov 2026 00:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048003;
	bh=Jk809x2GeIQxnlpSJ9BYzU1XLG89FFaJS3sqQEnGoZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jtws0/dzhq2e7aP3ABgWoH7Q4r/vMMizj7McaxKamaKhWNtVt+5wyjfP4txXJ3EDI
	 9V+sTmTQifxhCCumVIzBfDwOW5PySKWOVYXBAcn+/QYPHR57vdiKl3OsuzKPCZZDjG
	 GSTmVTTJqD1jz9p+Qwqmt6jes8CAAFRHh35TyA2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1840/2857] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118150307.502880145@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 1101833121a447999309a01f03d5b35bc1652e09 ]

drivers/power/supply/mp2629_charger.c creates the attribute with
DEVICE_ATTR_RW(batt_impedance_compensation). The ABI file documents it
under the truncated name batt_impedance_compen, which does not exist in
sysfs.

Use the full name.

Fixes: fe27f04e0cdc ("power: supply: mp2629: Add impedance compensation config")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905101849.42830-1-kmehltretter@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-power-mp2629 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power-mp2629 b/Documentation/ABI/testing/sysfs-class-power-mp2629
index 914d67caac0d7..a85f926ce9c26 100644
--- a/Documentation/ABI/testing/sysfs-class-power-mp2629
+++ b/Documentation/ABI/testing/sysfs-class-power-mp2629
@@ -1,4 +1,4 @@
-What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compen
+What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compensation
 Date:		April 2020
 KernelVersion:	5.7
 Description:
-- 
2.53.0



