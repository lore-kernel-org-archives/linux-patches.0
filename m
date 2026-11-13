Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585936;
	b=vzzuXaUElIsKiDZKnn550LsoIkOqJdoa+MgHnXUuBufni7cFSL+g77CLjdVY5UtSWVhc
	 a8DDKRk6mj57kM+aoVOZA9zjuhYApHFHItgZVmSR0b1QVK1FZZBBf7V2azM9XjtBasZ9q
	 1kWzo2jgQ4kXrqhz4PYHSVTK2JtlPjERFa4nkjUiA0extEi8kcv4zDxrUF900Eg+3HxQs
	 dN5vpCuTCI7XHqUNScxPYLulXHlUxUwqhB6xc/dSI4j7PH6kF6ONkUs6/4TwRcY9HECkO
	 QWzQyfkX/t5KME/Z3/WNrZ2gPbPeCXUnihKxcpB0na4zljLCeCvrlx6tYI0XL7u6ZDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zW/4touLxBVnyXshql23ivclHvMM5ObTtiCkSJ0dl7w=;
	b=MKyhC/2NpsfH4i8Am7/ZgECW9GN9f9oOj0j2LbVJMya4RZZkMz+hPTKatI4v9ool6kyd
	 iV4FrsB4rHIECh7A3dGZfkOJyZperFKqrOft/MRYwd7fsvWn+NPQlVEcweCWFtzGG45YZ
	 bgSYkobUC8kPUr1FtHFdJoKJvpoq3RrdO8Orpu4ypb+QDTj2K1PPYWYwVob99ZeHVejL0
	 ktoid6K99NrUN5iUD6O8k7d5VgcEYUwjQeU7yZbuJFUpwEfI7PABAL1+h4z/ChuaAXzya
	 t6T2/roinUoVwBbmG0oJsEyY1X1EiCF7C5gUaBZDdMU1Kl3VnIagiWSmuwx74N32njQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPjMjkS0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842806070FCD;
	Fri, 13 Nov 2026 16:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPjMjkS0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA281F000C7;
	Fri, 13 Nov 2026 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585936;
	bh=zW/4touLxBVnyXshql23ivclHvMM5ObTtiCkSJ0dl7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPjMjkS0HPHN2kyOVgMPt2lQ+3wHC46L7kffMGFTILjLBG1B5P5WzWQLGRiG4POBF
	 LzLLY0BUsy3KaQdsWa90TJI8o3eZjH93K77pdbRP0R+r2InQv7c22BGV1yX3krCECO
	 qzbm8O1vmmnYXUjkfZWdi9xn22I+W7q4HJhHRIHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 493/507] dt-bindings: clock: ma35d1: Drop CLK_MAX_IDX define
Date: Fri, 13 Nov 2026 10:53:17 -0500
Message-ID: <20261113153813.782326881@linuxfoundation.org>
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



