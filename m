Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038638;
	b=15zP6HMcHeo+JSGJJvO+iWhNOkx2fmnDtiI7JbabmtEjv5iL+2Dr20Q2WW9KZBsDmTp3
	 1UNock/9Rm2U1Y+1eZjdE0jtoONXfqmMdzJ7V9GuOj+P54IqiRB8jdykv6WtJjpFLfGjg
	 c3xX2exI4ysikovWN5qqWimSKgke7zO0QCoPksjA4ZAksu0U0TIgaMUFBSOLQyXxTgiqS
	 kyIyJrC0pMiI3X1enIxp1Gb4zpJkLS5pWiXbeT0Ljv7didYZvNyPtm+w7aHtnXdJQjDRm
	 ksFMm5EoLA05utH8QZx6FmSox3W3G2vVKn1nzMmPUCaD8busGwCuNsiB5gFJ0bh5xvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N30bO4vMDjOc/krwhemhDqkOgKA/ZUkYOsnwZ9fbVmM=;
	b=WUWtKPnWs+D3UJ8MtV3G+YD1542rgKGG6MOv6AFRodenCClewFdHUbndjXggEQgvdmgC
	 kr/YDLOBrTej8KMffszm6EEm0ec6fYble7OMZVrls/3e+B5UEDtHcDnMQ8G/F/3Cuy9oB
	 0j/j5XoqmU0QcRsHTuV2Xww9oSXFpjKdDBY8MIp8GaCIC3Vm+E6DYLDH+2jJxbWgm+KpD
	 JWSjKYOunkzlv6YANfGXSuJj1lckdvF8TPkLJyO0hRSJF/96HpzMLkRZCtK5hTtxV84tR
	 q1tMQjSQ63ch937h0coUNOIvXVcJqNXUfZpSgzh+yJ16f1+cwqf6+COiKi8OoACm+xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNMimVc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ED0606A320;
	Wed, 18 Nov 2026 21:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNMimVc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0F91F000C4;
	Wed, 18 Nov 2026 21:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038638;
	bh=N30bO4vMDjOc/krwhemhDqkOgKA/ZUkYOsnwZ9fbVmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNMimVc7lDnCcx/VA7kCKspzZlkxVwoVDLacQ6Rhy6hJlFJB05libhKRx7N2CTkjl
	 h53Dw5skaJXjuuCR+Bi5b6xai24XRr2MLuKv5lS5gxHMmxS7SbpOqiJZF6tFFaz2Lr
	 nQI//Uixkj+5DBnSaunekCJZTRASugYLiuU5wns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1813/3318] dt-bindings: clock: ma35d1: Drop CLK_MAX_IDX define
Date: Wed, 18 Nov 2026 15:40:35 +0100
Message-ID: <20261118150416.245626794@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 653738db38c7c7f0fb959a7870f9461cf4987825 ]

Drop CLK_MAX_IDX define of MA35D1 include. This is not a binding and
should not be placed here. Value is defined in the user driver.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-3-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
index ba2d70f776a6d..2d6a44a7e55c4 100644
--- a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
+++ b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
@@ -248,6 +248,5 @@
 #define ADC_GATE	233
 #define EADC_DIV	234
 #define EADC_GATE	235
-#define	CLK_MAX_IDX	236
 
 #endif /* __DT_BINDINGS_CLOCK_NUVOTON_MA35D1_CLK_H */
-- 
2.53.0



