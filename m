Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023546;
	b=0Dz9Fu3zIHzOmoezDrJN1Hp5RgzcBvicqfrB7Zh0kewtoZmm9M5uVoEXKLmk99tRorPE
	 qKmtjczZkYhVaUgMZCSQZY2EJ29J3dHD7oYcDSKHG9AVgGamZdElJreXD5LEzUQbG7Gn6
	 V184QdFjVkx4KrWKDm7b/n4Ul4sRxo14QE3ILU0QgoB3UEw37f0IqIOqxsvZo7Af05hdk
	 6hMT3t1pCWCF10wqNplhO+rVHAVJIWEY1N3VvBZdoz/OkSsShWrWtbbip0DC8E3UyuE5o
	 a6lwkhG3cwXs/GGB8a61+DAD7iL8U6RdTC62rKGm/6ZBw/zV24fFwvxJzlh0z2NdezA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KxwPsqnJ9b7LLtfoIETnEWhPDgGoS56BkYQpJlqrNzE=;
	b=zDM18sH6EAx8WBXRWw6MFUsiEKfkzrVxjB0B3YdrEKk/KeOroaiEHd3Id8ZNZsj869p4
	 quFOrd+82bW7RQ703XxUiTM4BL7W59euZ1Cka/7shREBfKWOt8fj4yXnhdr1J+95p3n5Y
	 +/iDxa04yIjUHysUoSqXsWY7/xm8IIBYFFf8W9JKmCqeOsyBq1TE2Mkwp+giZhE3UDzco
	 XRvXomZMwX9ivUU4MHM4e+svhNmI0ZltkBEk0Uc+2cW89oUErz5iljXuAIxlynl8sHWWs
	 XPKjxkvW4MknBa3kXkCmses+pdvY6t6NjFiZQtxI9XlT6vvWNukoaCd6Ww7B3wBnnsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UluqrgR2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E84A606A333;
	Wed, 18 Nov 2026 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UluqrgR2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84F11F000C4;
	Wed, 18 Nov 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023546;
	bh=KxwPsqnJ9b7LLtfoIETnEWhPDgGoS56BkYQpJlqrNzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UluqrgR2+qgFoQ3ag5/5sZfaP+kCMiB5xmoH4Td/ILTXgGfeO/yjUnDPQ4L3Yz8dG
	 VU56I61U3iE4zZFp358QGQ4vNHmBs4YV0SvB2DIKuctzxaEI0JzLvRm/lgWaW94t5h
	 7iZ2H71pMPpRycrW67zPzvPPs/REhtF2HkE5Ehjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0408/2151] ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp135f-dk
Date: Wed, 18 Nov 2026 15:35:43 +0100
Message-ID: <20261118150136.927441155@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 2f92d900f262a16c8ae02daf53ae2910d07185f5 ]

stm32mp135f-dk uses Microchip USB2514 HUB. Since vdda supply has been
added, the regulator framework wrongly associates the 'vdda' supply
dedicated to ADC, so the wrong regulator is referenced.
Only the 3v3 regulator is used to supply both the digital and the analog
part of the HUB.

Fixes: 673655f7944f ("usb: misc: onboard_dev: add vdda support for Microchip USB2514")
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20260821-usb_fixes_vdda-v1-v2-3-23cc919b59fb@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp135f-dk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/st/stm32mp135f-dk.dts b/arch/arm/boot/dts/st/stm32mp135f-dk.dts
index 9764a6bfa5b42..8ca1ab8ae02f3 100644
--- a/arch/arm/boot/dts/st/stm32mp135f-dk.dts
+++ b/arch/arm/boot/dts/st/stm32mp135f-dk.dts
@@ -567,6 +567,7 @@ hub@1 {
 		compatible = "usb424,2514";
 		reg = <1>;
 		vdd-supply = <&scmi_v3v3_sw>;
+		vdda-supply = <&scmi_v3v3_sw>;
 	};
 };
 
-- 
2.53.0



