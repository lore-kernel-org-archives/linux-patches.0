Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204112C028F;
	Thu, 15 Jan 2026 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496558; cv=none; b=mf8bKfqyu7OOc2cNJdJnycB5nhQfOWBOdGC5uCr3JfdgNoNbFzv66V9UKI6BttdbLPtXsopj1JMYPuKWYyaRSgG/5E/M+6EobYQCVdnyVihNcJpG4QdcvcTybQPuHTzXlJyBNz+pTV8irAHygxvCF6KouTtEt28Kn8wLxm1Ik1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496558; c=relaxed/simple;
	bh=Sel8pzhzfKd03Zf+2RD3qIN8egiJZr9Bz2jIK0VkuWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPbpqKNa8RxEkFAh9kYiy7cfTzTROO4IztKg0z1WW6886qDCXiVP9voyXlxj4k8pPLVmu1bxkobnEs4I+0dUkVLLWqoar2DfAm2I+COMTH5FRik81Xqr23iVLpPUntEbZtUTv57XKBbNZBUaIyiQkI5zKWjb2/ZETMyxe9cXkOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8QMdwMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8QMdwMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0513C116D0;
	Thu, 15 Jan 2026 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496558;
	bh=Sel8pzhzfKd03Zf+2RD3qIN8egiJZr9Bz2jIK0VkuWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8QMdwMgULVbTt668L1PuQAtlS/f5R2IDDAZO6ZuC7QqPvhSgi6jpAmlMYR0w1jCW
	 8K8+GHbyNeE4sxibco8kRKV8DWa0jZJ2bPS8WhaqIgoXjCR3Ob6w4hqghjQ3fcgKUV
	 xGgi2Vagkax7TANavmzwXDyFWqBOdWxD9T1IjKLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/119] ARM: dts: imx6q-ba16: fix RTC interrupt level
Date: Thu, 15 Jan 2026 17:47:49 +0100
Message-ID: <20260115164153.908710362@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi b/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
index 09d9ca0cb3324..0f28b140ec811 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
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



