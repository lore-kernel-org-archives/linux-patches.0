Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039473;
	b=4vDlvfiNIfoQjJ9SQK5vNLepUO2t0hYX1aAaw0rR25HgI4GKjZ/lNTf4mGXiq8FWb/r3
	 YIYkIfZ9is9L/tobUhVRp6LYyBgSDeVUOph+TkPYyaY+UYC6hH/b7VWYQbSxZS43I1v22
	 jCfG9xFB+18b6KoVoD5EhLuYX+729NMV/FMnFT8kyQqhsei/NoM/KLW27RLVvcLSbWWyP
	 J4bYmpvRr0xvX39dIlaGwIq+5OLGWst18pLdtIgmy6iCYRTu93Uz7m4aTPXvnhlawowwM
	 mIVwuMmyRig1Om7xqu/1BhpnidpUelKumMSonemMIGPXH3/C78iBm7rgADhuE32VBfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yMOMyMlbOoaBLZvgcj53iRFLWpbwzdMACF8LYQ9sO1c=;
	b=lfJwtJcWyhONyshX7JeYUunWz/6+Esm5uqnp0IUhHLkpLTLXPJYNV7PrpsqnQgQ1QQjN
	 drcIwllqfkk4gpkfkEts1d1V7nqfP7smAkHwgRqQo5NtbWtw4WQOtRQ/pLIn4ytVTIjV/
	 rI8I7Vy1/djqk7ygHL/qT6nGqz6oJqvnkNEoCHeceFN26RQZYa7/bFecHVEjF1mhczWZN
	 KsFm+yi04+q7jjg/yT47tNZrZ+jy/ZdKry80bIDsQ/9eovFmL+zuo+G//CE67HZVGlKR3
	 RHa812IVoLtVThGZDmd8rG+Aa1V9onf7kWmSLJr/30gK8tth3Jb78ZqmXJuR8iQFXAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwOtkhIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9AF606A31C;
	Wed, 18 Nov 2026 22:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwOtkhIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA511F000C6;
	Wed, 18 Nov 2026 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039473;
	bh=yMOMyMlbOoaBLZvgcj53iRFLWpbwzdMACF8LYQ9sO1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwOtkhIqlE8MV8PIgoGw0Y0TMdUs5oP8V+4WFPvReQ5YgqpCguXAja27i0wdX2J/n
	 o6JnSyPB3tm3qIvQVLBi+ZPNWaQdv9ZVim8Y2OW9QSJISSIQGYtRCd+Me+pNUO+rrA
	 BJBv75UQuOk4k6X2g6u4FzdZ5anCNOrwIUTdZnK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2113/3318] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:45:35 +0100
Message-ID: <20261118150425.459810427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



