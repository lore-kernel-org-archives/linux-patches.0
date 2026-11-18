Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060244;
	b=zv9XDTuQTkqNNiLV+d0bOeUhc3RND4kf2ybk2U0ufFk59Z2n+KnsSCL98wD6hWwwNVwP
	 eBV6GLqPxr+0lM7g+8S+5RZhQZhQU1wcOrD1uMbVnhXcYLOJpd8l5FONODb/d8esOceXq
	 Z3HAJkSIMP152kLdrQrHA9RuSgv/Lry1lg0B8G583vjnsVAWso+NJUlg4CTDCruJkaj5e
	 yBY+i2pXPyFA53U4dR3gKfsP7qfXbzRmSaEyFU16tQemgaxPY8TdiUW3IFnam4ejMqJnr
	 GuZgfBrGgMc6FerBjgLaWga06QCf9fGU0eIeHqDC78kxmtJXvoSOVq8X599mzmI/CPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQL5qME+QzBzcoPVcE6QtbL/MCe7nC6KQ585p6fAO4s=;
	b=gUovmD2LU7MOaNQirQrg77yO7GTe1+BwGyQmHoXH0AEke63sX2emjlXQCg+gJnWxiA7z
	 UOedt8ahnKgz2vtB7MfaJ9eRkqyCnU6DB9d59xwnRwzWRLSafVQoAU8ohy9YitbGm5uml
	 NJ+ytGa3D9cTu6aY2Ot1pKn/iBHIF6mNOjlgMpaqJrXE2YRhKTWc08DlNQMzdavWQF5SS
	 ySYw7aKQEFPn4E/g23s3dH8bYHPcph4AgVyaVoveW0fOyhMlpZ9r7gDlHwrvc80GJPeXc
	 C+MdgRMEO0ZRi18s6ifTTEsE0cged0pyNVXkQ1S2oJq2jgTQmRf4xe4kugiQVLLDZOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZMNjBCu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4432C606A325;
	Thu, 19 Nov 2026 03:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZMNjBCu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F01F000C4;
	Thu, 19 Nov 2026 03:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060244;
	bh=VQL5qME+QzBzcoPVcE6QtbL/MCe7nC6KQ585p6fAO4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZMNjBCud+KG7vxDkbo1BsuV65/1k8uoYrhAnCHY5xhN0ByrhELBY1yYngzkyYUet
	 gYklnQnFwC4bjNu2pxrsDCYmS5dHa4eN4egcMvDqgzNBhnWbXCVvwrgCBU93hUbySD
	 wijxL/cy+opdTgrTY2wfTmMMf/dIO24cbVJJeT6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1129/1848] ARM: dts: armada-388-helios4: fix vmmc property name
Date: Wed, 18 Nov 2026 15:52:47 +0100
Message-ID: <20261118150006.550336926@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 008e9faadef8c0aaa9b8a3ff05a2126e3c5b08b7 ]

The sdhci@d8000 node references the 3.3V regulator through a bare
"vmmc" property, which is not part of the mmc controller DT
binding. The binding requires supply properties in the form
"vmmc-supply", so the current entry is ignored by the driver.

Rename the property to "vmmc-supply" so the fixed regulator is
correctly wired up as the card power supply.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 654840425ae97..0e0e254366b4c 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -269,7 +269,7 @@ sdhci@d8000 {
 					     &helios_sdhci_cd_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



