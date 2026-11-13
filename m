Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591595;
	b=u3X3gIOf2gKTexWZUyfLfkfSuVXz8nU47n9NrE3K+Gac/z5jcTcRHCqzBt50POkn9p90
	 iAuDJ/qVI7MJwMxGHPaoo7IBuWMPIwVs69B/+M9QSG+wsl0Ij3lGwQAMW39CIM3lWv5uK
	 eGuheY/Q6wjckWn0fFJ8cvAOLeYvxtvSnHevDIzSCcqW3TCGPyw+5lcL2QM3ekjnKhVj/
	 mxYF5IFUQ9kaBqjAJU8vFk3Z2hDDPJCIrs0ipnvhxwLYBKgNZdDSzIlgBNJ6GbZzpWlAs
	 RPgQa8WNbnl3k9ZjjpQJzlWthzk2rsud8ZyLj+9sH/i/roT1arJegDuhwyCcUnqF9rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vUi7lY8v3x+on/wswUM/2X1+CtbpQrEVLFE2Rh1BU38=;
	b=D7vl/TzikAKA45J0HojpVAf5JyDWy37FCm7tr9Mg92A84nsgNyOP2v5G9k076PzKhLCF
	 Wfm6vmIH3S695RDI3YgAClylQhZXi9l17aCZS3ozzybTk8yfS6RcnYN4yiFIXNzarGbsC
	 143rFmz4+SCMLgqMrhltWB6WEeMkd4lo/k/TOm+8OCdlPeuTgiAmSclwQG1otvB5TZnol
	 JXgrF9VhE2XX5Mhdrb9q4IVNzgyBHEBkTkVdw2/ossKt1TNJY/b8+TN2N8Yk3xcFyoXFa
	 FhXTGPsq+nba3ecb1lUZlYf3ZqPcwto20cwTOMctAo08sYPE+G6ZqedhNlXdexSRI3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UD4PPctG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB934606A89C;
	Fri, 13 Nov 2026 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UD4PPctG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6778F1F000C4;
	Fri, 13 Nov 2026 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591595;
	bh=vUi7lY8v3x+on/wswUM/2X1+CtbpQrEVLFE2Rh1BU38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UD4PPctG6uyQSZ4O/IBgzH7QbxCvcSUY2Ms5mLioIKoMn09sxwmvqOE//n5CqFFnz
	 l9ETum6xRsU08CC/7PWOaIQ5idn2fCqY2PqPSBTktT68/J7XN/4zuBqwW71KevzafP
	 x3dQzpvwuz/iw8aPvTMwmYjgaGKfQFTpmFiu1Pvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 639/670] clk: nuvoton: ma35d1: Keep the clock count in the driver
Date: Fri, 13 Nov 2026 10:53:23 -0500
Message-ID: <20261113153833.452962401@linuxfoundation.org>
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

[ Upstream commit 26ec588063d9b6c70773b8729372e2bf6d3ea95a ]

The number of clocks is not a binding since this is a value that can
change. As such, in order to support the missing watchdog clocks and
allow the deprecation and removal of CLK_MAX_IDX from the bindings, we
need to switch to a local definition first.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-1-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1.c b/drivers/clk/nuvoton/clk-ma35d1.c
index 9f65d0623517a..6aa42a3e1be3b 100644
--- a/drivers/clk/nuvoton/clk-ma35d1.c
+++ b/drivers/clk/nuvoton/clk-ma35d1.c
@@ -17,6 +17,7 @@
 static DEFINE_SPINLOCK(ma35d1_lock);
 
 #define PLL_MAX_NUM		5
+#define	MA35D1_CLK_COUNT	236
 
 /* Clock Control Registers Offset */
 #define REG_CLK_PWRCTL		0x00
@@ -467,12 +468,12 @@ static int ma35d1_clocks_probe(struct platform_device *pdev)
 	int ret;
 
 	ma35d1_hw_data = devm_kzalloc(dev,
-				      struct_size(ma35d1_hw_data, hws, CLK_MAX_IDX),
+				      struct_size(ma35d1_hw_data, hws, MA35D1_CLK_COUNT),
 				      GFP_KERNEL);
 	if (!ma35d1_hw_data)
 		return -ENOMEM;
 
-	ma35d1_hw_data->num = CLK_MAX_IDX;
+	ma35d1_hw_data->num = MA35D1_CLK_COUNT;
 	hws = ma35d1_hw_data->hws;
 
 	clk_base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.53.0



