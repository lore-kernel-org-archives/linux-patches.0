Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6C2820C6;
	Thu, 15 Jan 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497083; cv=none; b=UDC3zBweDEijSXsyXX7MWbu2m8GIflgWAFkymk3F8NNAkTSQTkf2PRDOfoPq4IiO8wlw94HMzXMcqpl/UOl4Tr8rFuzIAX4CbLk2s8tAZx+9wFrLIisfb0yregT2lr0raUX1OA/vxfjQY7Isejf3DmtLMWil7on0Ai4n59mlbiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497083; c=relaxed/simple;
	bh=DyzUzWKdy9KPWHQFDThAeA/IYfxcxN/jbphzlTSyLxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kufB0pIcuu7rnrjNnAsaQjsZQ7O24YabKtqdMbnN6ilsL2dATFUTp/0ED4zDQe4LA7tMF3vqkjXCHpIOzNqeVIcyrz5qCCndIvoGphsExhd6kal1T+/1xO7NtuFi83E35qhwPHNtYVwfH9rcFhkCl0+UP9yDB6IK1CmabKLaYZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ4GFv2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ4GFv2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20990C116D0;
	Thu, 15 Jan 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497083;
	bh=DyzUzWKdy9KPWHQFDThAeA/IYfxcxN/jbphzlTSyLxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ4GFv2IH9q+KEy8pacfN9JILKpKVv9AVQM49oVJ2OGNmeVvcJIrtSO0hm9gEsoyK
	 Ml7butgI6eeeKvBdfGVRa39l56u9QyC68nNyc3K/i9VFajLDCJ3UQo4t3R7rkgNgD8
	 48n4VZrZr8vBwo96pQ/4JSE2nE8jcR4omtraigv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/72] ARM: dts: imx6q-ba16: fix RTC interrupt level
Date: Thu, 15 Jan 2026 17:48:41 +0100
Message-ID: <20260115164144.624198924@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit e6a4eedd49ce27c16a80506c66a04707e0ee0116 ]

RTC interrupt level should be set to "LOW". This was revealed by the
introduction of commit:

  f181987ef477 ("rtc: m41t80: use IRQ flags obtained from fwnode")

which changed the way IRQ type is obtained.

Fixes: 56c27310c1b4 ("ARM: dts: imx: Add Advantech BA-16 Qseven module")
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-ba16.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6q-ba16.dtsi b/arch/arm/boot/dts/imx6q-ba16.dtsi
index f266f1b7e0cfc..0c033e69ecc04 100644
--- a/arch/arm/boot/dts/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
@@ -335,7 +335,7 @@ rtc@32 {
 		pinctrl-0 = <&pinctrl_rtc>;
 		reg = <0x32>;
 		interrupt-parent = <&gpio4>;
-		interrupts = <10 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <10 IRQ_TYPE_LEVEL_LOW>;
 	};
 };
 
-- 
2.51.0



