Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4A2ECE93;
	Tue, 12 Aug 2025 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023487; cv=none; b=mZbzXThgQI5+hJRhL4mW1jiM5OCkafJXqvI+kZ6KxYbJoty/Saap258oLYeUxL4PekqLxJ3rP7JVXApLp97zjFuV4G7OkIBFzhlfPMiPoxwhdmztnjnm2UysnD6ujq+J6aIa3Vp2OH0dMcTfwwlsANbe8jmI0kH1vI8hU9OOKOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023487; c=relaxed/simple;
	bh=Xl4i1Qv+nm82O3+YrNI8gZNxFJtWv2Gs6AsNMm+4mc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yjjkg7el9uj3wwam+2iXO8Y549kb4qvl2CD6lHI7Kwj8U4LbM9x3CuwZTHNpaelhXFpMnZVXIlct0ZKRJwfnXPQdD+7KMRV2C97Q+mwC7StJHGuxeSukZCeJSsqZYGIaUSV2OxFR1qVW7mX3NUtVp+6OrOCSCN2NIqMuSUZZ2jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTgnq5bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTgnq5bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2A6C4CEF0;
	Tue, 12 Aug 2025 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023487;
	bh=Xl4i1Qv+nm82O3+YrNI8gZNxFJtWv2Gs6AsNMm+4mc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTgnq5bnqP05rvJGVnj6y9j78i6hApG8wvb39Y9VFTeQVD0qRYtaOCDT3Hu4MUQCa
	 qUOOqLWdOEet6epK4cWgq2m0wt28gIdyOer/RQFYMnQqph8L2XaDB1rYA4C3v5hAcN
	 gXKkO9fM9Zd0LB7fEvnsoLzi/wB58joHAH5fENoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 093/627] arm64: dts: renesas: r8a779g3-sparrow-hawk-fan-pwm: Add missing install target
Date: Tue, 12 Aug 2025 19:26:28 +0200
Message-ID: <20250812173422.848146637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 7e5624e231eea73a6a2c2d0b837a085267590167 ]

The target to consider the dtbo file for installation is missing, add
it.

Fixes: a719915e76f2 ("arm64: dts: renesas: r8a779g3: Add Retronix R-Car V4H Sparrow Hawk board support")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://lore.kernel.org/20250701112612.3957799-2-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/Makefile b/arch/arm64/boot/dts/renesas/Makefile
index aa7f996c0546..f9f70f181d10 100644
--- a/arch/arm64/boot/dts/renesas/Makefile
+++ b/arch/arm64/boot/dts/renesas/Makefile
@@ -96,6 +96,7 @@ dtb-$(CONFIG_ARCH_R8A779G0) += r8a779g2-white-hawk-single-ard-audio-da7212.dtb
 
 DTC_FLAGS_r8a779g3-sparrow-hawk += -Wno-spi_bus_bridge
 dtb-$(CONFIG_ARCH_R8A779G0) += r8a779g3-sparrow-hawk.dtb
+dtb-$(CONFIG_ARCH_R8A779G0) += r8a779g3-sparrow-hawk-fan-pwm.dtbo
 r8a779g3-sparrow-hawk-fan-pwm-dtbs := r8a779g3-sparrow-hawk.dtb r8a779g3-sparrow-hawk-fan-pwm.dtbo
 dtb-$(CONFIG_ARCH_R8A779G0) += r8a779g3-sparrow-hawk-fan-pwm.dtb
 
-- 
2.39.5



