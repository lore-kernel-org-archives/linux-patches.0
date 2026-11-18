Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020402;
	b=ycoQ05qHNRjXHwjWdJoGguwdFFXC1EsYrceZ/daCYhEqM17Bo7N5h9lSXgXt2gLrIvcu
	 4vvzSR+408kGyFm+4G6r+CMJWToAObP0u0ANOq2mSPMLpNYdc9eLB//QbziNqwCl1W2ag
	 6/sHCkMpgUc/iVGsPACv8ccoziHozBH3h5FeIAACTuB2YAIjkyIQFc5M0iP0f5RUwN1kc
	 jC8WNpoA9JRfqEufpStzi0Zu39ou+AK37f7N7jIp2pMyatFXgVE+CWB2PuQXyto3cdLK1
	 o9X0/cb45I8Sp+9MDbLa+CSMq9WdqbqyqG5v3xm5aW5TuAKK2CZnNKIB/msiDe1gyXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+esiDl8rA5uidmEJemYJM8JblQR5428HW1veib6SwrI=;
	b=A6ZTmNTYnW7FmC1lxxlqwWwbiCmRVPGh1L1i9Boxn1oAlA8xwBzj+QIzl+s9KI5x/lQr
	 5yNB736mlHABFpd3a2yRbDvld9Nw9vVmsTP4Aq7VxPeN6+RsQjxjDf0Q5/jjVGhUsS79Y
	 mKLGi63+IhOLXlHDLmSsUwsPH/3hb7znTMrcUdiBvZPqAjXolx/FpOtsm3JSzY+NMyWvx
	 DZ8r2j1gDNhvXLotgioi5ASSWWEa23Oqi8P+i7xuJko/HXcMSa+D/zXAznv3+NEIl9uu+
	 d2z7JC7uZOC9HwdBD78P/TgD+idMDUucCiiC4+Ww6XGCUueqQjuOEyELejEsexyuElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vECwydqS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F581606A320;
	Wed, 18 Nov 2026 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vECwydqS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67ED1F000C4;
	Wed, 18 Nov 2026 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020402;
	bh=+esiDl8rA5uidmEJemYJM8JblQR5428HW1veib6SwrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vECwydqSMbzXggZHSq5c49dGCP06Drfcd4ym5DdzdTQ2/bHXYzHUybsAnl9pTaeQV
	 cui4m9UD4nxVY8tFzaXtzAMTIs9dHZtITUy6cfI969EwyUAe9uL2URyu0gVgF9KmzQ
	 DS4VLvPvxfYnyIl19/uiIYuG1U9YvNedXBqOlu4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1940/2651] irqchip/qcom: Enable compile testing for QCOM_PDC and QCOM_MPM
Date: Wed, 18 Nov 2026 15:53:00 +0100
Message-ID: <20261118150356.469758987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 1b852de05f74cfc96c58caad9df4cc1fa2dc7689 ]

QCOM_PDC and QCOM_MPM do not reference any architecture code, thus
should be compile-testable.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727-irqchip-qcom-defaults-v2-1-466f3c407937@oss.qualcomm.com
Stable-dep-of: 8e6b8708f925 ("irqchip/qcom-pdc: Fix linking against QCOM_SCM firmware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 20b77fbc51ee0..5a881ddfa3abe 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -522,7 +522,7 @@ config GOLDFISH_PIC
 
 config QCOM_PDC
 	tristate "Qualcomm PDC"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	select IRQ_DOMAIN_HIERARCHY
 	help
 	  Power Domain Controller driver to manage and configure wakeup
@@ -530,7 +530,7 @@ config QCOM_PDC
 
 config QCOM_MPM
 	tristate "Qualcomm MPM"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	depends on MAILBOX
 	select IRQ_DOMAIN_HIERARCHY
 	help
-- 
2.53.0



