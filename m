Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585937;
	b=tBvoo9occf0VRngNwbC8KgrZtl+3yUnxvEF4YqpNcTvX3LyXoUrO2HC4xcgLHiBif3/7
	 jE69omVHAoMoXTjK2zLwGJL6zKFKjvnYGc94NbB6K79LPYCOyEjaPd+EHYAiedZSdpwcp
	 Swf0uFw466592zd424K64tYAcvvRAv4fdg03MMsVcplPVr4OvEkNN5237KwCNeo9D89up
	 OnW79CQ4vWFYA0f+6Fo69BSRH4prNYa6/MYM0j9NSjSBpCAOMUxUYbi32zmRapzf+nqgl
	 DvtzhqHIB+923ZZRQpbutwMRHaiR7mx4gZ8A2pg8AVyfSl/EC8Sd8QpKJohClPgxvJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gHT90loF+RTuWXwTyTuivExRq8+bsUzTTmUlM7Qkelk=;
	b=edFQ2m6ApJF71ctJsTBUXeXR7M/fHZcvKu5N1IfSvCTWQhp0dPlnjjgs6VrGW9DZB9y4
	 JmF1H7EfxMm+a8e4qQcOv3UPqNvOmVDMTxN/yEgfYsBjY9WZJnjD5yqXkV2bWq7XteTUq
	 qJ0SWxiPqzeBaU/AjXQdXlBqM4Tzg/BysFMdt3ydptcZbH5k9vA28A0+ODKKE3+/wXMB/
	 ZObeZIF4FNYpfxnA2ApGyVhMGiwfmZniAGXg2AZW68Ny5awRczCNcyvt5Xgx5bBFZvczm
	 mHzT771CZSnW4f+LMfCqUtTk2UE3xn2cThLUP/5/FSxOQB52vnfhB6xVbE77W4BYvLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JR2ESArL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8546070FC7;
	Fri, 13 Nov 2026 16:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JR2ESArL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE981F000C6;
	Fri, 13 Nov 2026 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585937;
	bh=gHT90loF+RTuWXwTyTuivExRq8+bsUzTTmUlM7Qkelk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JR2ESArL26NHnjqCSdoaLwjCvm6IqOHJHWtUukHrpQyXDQ4SrrT42//Qdw0GgLJoM
	 wWI/KYmK0b2YcICw+BkCJAMC7/teIH+I0RqChLFSqn81vL9bGIEuk9bLNxMPBxYaU3
	 OCbXcoRQzXNwnaFtiSqdmawhN3cx/AuHMIob/zQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 494/507] dt-bindings: clock: ma35d1: Add missing WDT/WWDT parent clocks
Date: Fri, 13 Nov 2026 10:53:18 -0500
Message-ID: <20261113153813.811848586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8c7453cb0b01bee47ec2f902a9ac1872d3b77f3d ]

The WDT and WWDT muxes have PCLK3/4096 and PCLK4/4096 among their
possible parents, but these fixed factor clocks are currently not
defined, even though they are needed to properly describe the clock
tree. Add them to the bindings.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-4-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
index 2d6a44a7e55c4..764d837d6162a 100644
--- a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
+++ b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
@@ -248,5 +248,7 @@
 #define ADC_GATE	233
 #define EADC_DIV	234
 #define EADC_GATE	235
+#define PCLK3_DIV4096	236
+#define PCLK4_DIV4096	237
 
 #endif /* __DT_BINDINGS_CLOCK_NUVOTON_MA35D1_CLK_H */
-- 
2.53.0



