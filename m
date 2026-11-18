Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023303;
	b=EvaA8jzClWeyOdE15l31edaLhSuc5mYdBEcUNj1g7CZT1JkttgBXmo6tMZx1KrWiBgdF
	 hWaXWbWft9bEXCEot60p8YCy0a96kRlWOICm4sivVl9kXlBgTug5xmIa8HdYBzNeJNPn/
	 y5cJjJRa7Ff8mDHmeOWwJhMAeQqJF1gboZ8zU5kPXGrNkU3ymR2SHe4Ib1dM6cz8yURLb
	 Nw1gyvZGDFlEkwohVgfI4f/MLFZIxO4pkEx3IOcdOcp+Fqm5vxvmjrUZdxLV43rnyUYh+
	 pMKkjTchBypp0J8rgYwZE3UZcizkvnbrdrZmOZrEbcSNj5jLb9jhbDVTDzGPYQHTCgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RO03j7HnzRkLpaKZ2NL3WHQNHKpgx4LuTOJWSC7X1pc=;
	b=qZJoMDAHfBKzxjHGb003qZc8zycPBk29T1ah8VLJMJiDWPVv5FHYWBU/1QzJTmNHPh0L
	 xlj16zDxdBz/lQJVtRxl1ffncsq/dXAToS164WvfqXNyCkb/2ncpuLc+cTUHUPltM41n2
	 1V570/s28r9v5rsJRQTn4paKo5yfoFufRwmnpnyLGHjczi0rAzrNxKqBhvuVzbHbMIudp
	 IVNDlRtxqw6tkyOxD2Yw3YQqTL287hkxWhaHYEmI52D6JRQrAo7GZtPdohls/pR3dVsea
	 F+heaTbA/NS8/AsfXFEMtcxvf15nYOwI737CmV0nwbROWwG2WqJHMSS/1CKipNutUuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjtcXX5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0DA606A33F;
	Wed, 18 Nov 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjtcXX5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC1A1F000C5;
	Wed, 18 Nov 2026 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023303;
	bh=RO03j7HnzRkLpaKZ2NL3WHQNHKpgx4LuTOJWSC7X1pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjtcXX5pXFJy/Z7Jx1gvm5O1k46OxH2CDStMneECeOd/e+NDFkqYI1Hx6O9xCjE4B
	 KycND6nT7reeo14wTjIyz3WwtnhPYCgywMgqxp/pHcZIKy5uyPcw01/neMNA9aXyOa
	 EitmneoGlZrqSiPQcxNe21V2c2AR6RteK6ci+pis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0321/2151] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:34:16 +0100
Message-ID: <20261118150133.649623557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



