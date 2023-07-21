Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1F20F9D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760EAC433CD;
	Fri, 21 Jul 2023 19:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967551;
	bh=WHKpEHO3pGTM8hBvykkXGqWRseUZVZwmxk/uprVTlN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fe+dmIRaTomSxS39bon1S2gqjAaO0Yr9oargmJvE+4YkLrExBUV0AUyAxqhoeXBgh
	 x60s8NrM+J76HvbOiBuOieL9W0UaIhuayEljNcMFif/7GitL/0FcB4uFMy0XbDjOJH
	 ozcO1x1fy0EF5a381D3a8/sj9GP/A5mZ5bASFRfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 173/223] bus: ixp4xx: fix IXP4XX_EXP_T1_MASK
Date: Fri, 21 Jul 2023 18:07:06 +0200
Message-ID: <20230721160528.255288570@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 6722e46513e0af8e2fff4698f7cb78bc50a9f13f upstream.

The IXP4XX_EXP_T1_MASK was shifted one bit to the right, overlapping
IXP4XX_EXP_T2_MASK and leaving bit 29 unused. The offset being wrong is
also confirmed at least by the datasheet of IXP45X/46X [1].

Fix this by aligning it to IXP4XX_EXP_T1_SHIFT.

[1] https://www.intel.com/content/dam/www/public/us/en/documents/manuals/ixp45x-ixp46x-developers-manual.pdf

Cc: stable@vger.kernel.org
Fixes: 1c953bda90ca ("bus: ixp4xx: Add a driver for IXP4xx expansion bus")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://lore.kernel.org/r/20230624112958.27727-1-jonas.gorski@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230624122139.3229642-1-linus.walleij@linaro.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/intel-ixp4xx-eb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/intel-ixp4xx-eb.c
+++ b/drivers/bus/intel-ixp4xx-eb.c
@@ -33,7 +33,7 @@
 #define IXP4XX_EXP_TIMING_STRIDE	0x04
 #define IXP4XX_EXP_CS_EN		BIT(31)
 #define IXP456_EXP_PAR_EN		BIT(30) /* Only on IXP45x and IXP46x */
-#define IXP4XX_EXP_T1_MASK		GENMASK(28, 27)
+#define IXP4XX_EXP_T1_MASK		GENMASK(29, 28)
 #define IXP4XX_EXP_T1_SHIFT		28
 #define IXP4XX_EXP_T2_MASK		GENMASK(27, 26)
 #define IXP4XX_EXP_T2_SHIFT		26


