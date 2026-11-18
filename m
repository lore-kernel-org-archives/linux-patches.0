Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030101;
	b=iCeDdx5IhA+rpctZZgveksQCF9gSvK9YcRtt7NcSTtyKMLMe0mgtIb3Ucwj9AJVC8Ab/
	 UIim9ysMm22+9yfJ7V35LtUm2widz8/FZxvA4P5g1ms3+q6mPivgbOd4IBRlccjSOxpAQ
	 0orVqIDXt9E4q9KJFo87aAuQAgCoyOiZo9gbrqembVc7Irt3bwjD69BvtIM7mkEvy0NZP
	 /V2PDaQsDsext1uitmoxUzhhm6XNWjNEIDKzGUgWGWV/XyXQ+coCoyCoEHtov/w0ItE/e
	 Vl1SsZOGTLXAheTKcNiUebHD8zZ/6HsQeRytpaYydAZ0mDervdr8UhI/AAZoJ+kcNiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6cAJYW6+RpFgG0/RQ1/q3EHXQWw2Gio5JLa6CjCjGOk=;
	b=VLebG0f3jIOKIYOX9BDnmYuivlFiIog6pIFO7T57DZirU3ziHZ+VqeK0UG59bLeVd3T5
	 jhlZVH9/hz0BGZj/bDM3bE0UNZrUO9JG1+yJyiaeqMS/hM6spTrOPdqo8z1qoA7QZwIgo
	 ChzR1dLR2F/rqZZr2Xw0GKwVmOU7XfOjFo8+au/so9jVVJkIdpNNIq4y3rA4exxsNiNkn
	 2cu5TH517Yw1obffqJ9R3GQtTubOw/lMZno/cmDTgEy6dIBu+kyPFBlJoNUQDarg81Llv
	 MkXl8OQ2VPf/6JNa1nmZ2umhgS2Fqb+Y2KPZ6pcvCb9QgNM4aIl2IiNYEmClxPl8A/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Daig5dmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783960A6F55;
	Wed, 18 Nov 2026 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Daig5dmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB41F000C5;
	Wed, 18 Nov 2026 19:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030101;
	bh=6cAJYW6+RpFgG0/RQ1/q3EHXQWw2Gio5JLa6CjCjGOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Daig5dmmABuPv2NWOvcPUY9fOefEDVhH74+IHL0nqwq+5kJwlIsMnpQw0/7DqzSKJ
	 PC9bu9Fs/N8x9rExpRT+6tNzdA7VUZ4NwA+1pmEEMv6ECnv1PDf0u2h2lVV2GRGlUK
	 j2B9s5Ird3hRvaqFrG9YwerUb/rqMt2ikGO6IsKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0585/1756] arm64: dts: qcom: x1e80100-qcp: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:45:12 +0100
Message-ID: <20261118150032.309847049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit fd7d7b5d307f3a475e9555dfd89ff80cfae46b3c ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-8-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 9062eb6766f2c..8a9ddc2817e4e 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -812,6 +812,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <33 3>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



