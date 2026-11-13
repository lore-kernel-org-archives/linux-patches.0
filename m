Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591597;
	b=1DbgsjYn/Jhc8dnfGPvc+b3/EkaaYmgv0N5FTqXrbnWrzPqoKI/cg0uJr10UO/0praqm
	 lSVzxr9GQM2owq7IfAgpOljqmvgdEV7sQzEe6M94s+uwmKqgsUOjd3DYQHB5bKhF5KVVl
	 NncZDeb2V7RK7ZKQh8j8GdWZo1miawMGYY3Eb+MIB0MEpGsXK/VLltY3EoadBJ+S9tDRs
	 vJlZjKTrlzbxU/x2A7lB5kdM9brrAtclkfLqh+2n3vGKIoF78vIGCKy5SMISh5L4mZP7R
	 K5yVm8cIkbPbYQ2i8hwWRhNhdKGMc0jJEjYDnQ5KTwEU8PdAhPB8NPFW7iVDzN9r0Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gana4SsDkLHT6VibgtSnRgRcTRrSQ8O15m66Iml4XK4=;
	b=YGu9o7O/84eVMpDaik4+AigBnVf8p9AfLqX0xML9/g4oSP2NJfkwxIZHdKUHrnk0FJrg
	 Rr25m03y2qb0hzi/fmaMDuOUIDAL8U9RT6IS5fRSvSh6jxrbw4tzJ8YaZKEB6VChi+3/H
	 m7YECb8ag3kWwIMYWroQHN8ez8wTnyj/1CNmEu7Nn8aiiA8CmLyy2NotSdBuKUosmuT4Z
	 +V9xspdNo1i0+scfH/+8OSLMYqGIAEsSMHYjodtk6Ewv/CVgTBSEaiXWOJjYTLbILlqK0
	 rtz0UI5h8yhw/9WIVbSxKbQNhAwW0/gDS2NdYjv0+ippYGelYer8JfeHj24g2+QfRbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FVsoqJz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04415606B347;
	Fri, 13 Nov 2026 17:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FVsoqJz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F2C1F000C4;
	Fri, 13 Nov 2026 17:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591596;
	bh=Gana4SsDkLHT6VibgtSnRgRcTRrSQ8O15m66Iml4XK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FVsoqJzd73iyY6x1eZHCFtw7kB8TcxjLl5aA0Fkd4bB4RpbpbMg1lx38hwxQbyhJ
	 jw/OdM9D/tnDzDOQBfUBEhWyHI+wi4o5LmlT07g2pvyH3oLqb8uUrMC40uLOUKmYqM
	 f462bW2mLQGIwMiAX912KUPaHJvzvD0MwtGja4pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 640/670] dt-bindings: clock: ma35d1: Drop CLK_MAX_IDX define
Date: Fri, 13 Nov 2026 10:53:24 -0500
Message-ID: <20261113153833.482992586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



