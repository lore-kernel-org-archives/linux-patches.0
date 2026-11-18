Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025132;
	b=Yf1K990696RHADu3VUpPLCk+RGT4kmOAUwRBKOyE5bz/HjD3aKlRNqAOHS/F+ZheOT4D
	 uw0jyxKgeTFEQctuCq8rqmIplLF3pQ/udB/J+SSmEmQ+4VQKJ51hVBAFCu6XKzwqqxZbi
	 ZtigngxHAfYXZQaICsZF+BHFkJhAwXO7/PZsDRNdrpUZt1n3CjimwVv1iXiKi3vuFfVl5
	 8tqZmKrd9sEgcLv1TtZpC2s4tb/xvx1RU5iFCy5laLSXVTwvlVJR8GdJR687vVJ7jCFHU
	 eWZgIbd9+LjN8ZpEcv0bWjyfsX/FEHKfOzMzdpGL8039BEXugGiEEnC0yF+Fvh2oS5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbsYAzuXHPRWWZtweWrS1RkvjzrBu8cugHNKo3KHrJs=;
	b=MeJo5gpzEg6vkcJMVXyGdUUXDcVC5SqC8qHpTJprFNkTdNQ97ZwG8IhL+wSiHx4lCdVs
	 8uCl1LnvMRgQaXTjLJ3VZV+0DbiQAG4b5aT6tNot32CK7srqzjbsgj2ndAcDUeVbrCYDi
	 7kNlwdYOKobG0qUHQ0/MCl20xeta+dY9N9ORI+CHG2F1hMv5aSiycjy0+5CCyHesnDio3
	 e4AbHWdqS3dUOBtjFRILxkbwsTyyd/aqM0WIdK+UPzwMWcNuZOM5xr0lMtSVk4H8Yqj/G
	 P51g6Esdys9A8i07Gqa+xjeoaAxG2mBWjRxkHgrqo4CLuCIQ/8HhfywY529q6ta4usA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qh3TJsOH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB986606A31C;
	Wed, 18 Nov 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qh3TJsOH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273E61F000C4;
	Wed, 18 Nov 2026 18:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025132;
	bh=kbsYAzuXHPRWWZtweWrS1RkvjzrBu8cugHNKo3KHrJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qh3TJsOHDX9z1Zd4vGK6HEIpnjXled1x9kPak+Cx9/nyaD0KrLFKHlhv0WSLlXFrH
	 +E5uXwfRpwHateAjaMn+NtySJwetyFOZ7CvRR6i6W3eYhVcr29j72gEzWXaJYmfZz8
	 dpb2hmhIs0vVkk3UrWchSETFNphjmIKlUrq/3Ap8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Legoll <legoll@online.fr>,
	Iker Pedrosa <ikerpedrosam@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Jennifer Berringer <jberring@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0969/2151] riscv: dts: spacemit: set console baud rate on OrangePi RV2
Date: Wed, 18 Nov 2026 15:45:04 +0100
Message-ID: <20261118150157.810002018@linuxfoundation.org>
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

From: Jennifer Berringer <jberring@redhat.com>

[ Upstream commit 789eed2d8bfa83d79e24d185f736b038a121b3ce ]

Set the baud rate to 115200, matching what is used by U-Boot on this
platform so that the console is usable even when console options are not
specified in cmdline.

Fixes: bab8dea259100 ("riscv: dts: spacemit: Add OrangePi RV2 board device tree")
Tested-by: Vincent Legoll <legoll@online.fr>
Reviewed-by: Iker Pedrosa <ikerpedrosam@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Jennifer Berringer <jberring@redhat.com>
Link: https://patch.msgid.link/20260929120227.1791356-1-jberring@redhat.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts b/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
index 337240ebb7b79..23478a37d66a8 100644
--- a/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts
@@ -18,7 +18,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
-- 
2.53.0



