Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1734B27604E;
	Tue, 12 Aug 2025 19:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025546; cv=none; b=XE+x90EwHixHVCWzMAIdlbg3AX+AlCMfOA6I2NYAdzvtKUu8fsUOK87MTl+JOhqTvdFPf3NBr/5gt6cbBkqxH6mfuriBSEeoSaogvOgPjj/hOJ9BWFBD6lBNDTVuJ9I7aFerUGPRMOxFR7cOvuV7p8vO3nJzjQtw9z4HN+7X4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025546; c=relaxed/simple;
	bh=JCmEP3YUUR7q/b5uxrS7lnAx2d5cLeJNvAdXdaDE/Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkYRNIUtzNAleaXVn/N4zPnoapNE+yNRHiYcBKLLzxSnNlKbFhdO/fenTxdA16QWbx0amRe7lMPpStppPtXuHwKejLTbs1OfmFcemGAJ4vRq/aNYO2idttnxjMHCyN8QCtCdpEveVT3bxpRt/qpXHWcx6QFb1uMSecQq4OQlrd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6Ol+p5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6Ol+p5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31954C4CEF0;
	Tue, 12 Aug 2025 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025544;
	bh=JCmEP3YUUR7q/b5uxrS7lnAx2d5cLeJNvAdXdaDE/Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6Ol+p5i4jbx7Or8DEBGZj3KJK0HrwlDn9f40on0bHUGSu/bj7/hiwm4bmzHrjIWO
	 3euOjIvsRBA+tHxoCRVJzGgqZvpgie5k7+BMtuWSZidcC9xvFqrdZ+0/DUjPNobql4
	 qg5QnuSF2kmsuq8k0L/cCjjiHvVoRJ4wRj3TN8O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Albin=20T=C3=B6rnqvist?= <albin.tornqvist@codiax.se>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 071/480] arm: dts: ti: omap: Fixup pinheader typo
Date: Tue, 12 Aug 2025 19:44:39 +0200
Message-ID: <20250812174400.357417143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albin Törnqvist <albin.tornqvist@codiax.se>

[ Upstream commit a3a4be32b69c99fc20a66e0de83b91f8c882bf4c ]

This commit fixes a typo introduced in commit
ee368a10d0df ("ARM: dts: am335x-boneblack.dts: unique gpio-line-names").
gpio0_7 is located on the P9 header on the BBB.
This was verified with a BeagleBone Black by toggling the pin and
checking with a multimeter that it corresponds to pin 42 on the P9
header.

Signed-off-by: Albin Törnqvist <albin.tornqvist@codiax.se>
Link: https://lore.kernel.org/r/20250624114839.1465115-2-albin.tornqvist@codiax.se
Fixes: ee368a10d0df ("ARM: dts: am335x-boneblack.dts: unique gpio-line-names")
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-boneblack.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts b/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts
index 16b567e3cb47..b4fdcf9c02b5 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-boneblack.dts
@@ -35,7 +35,7 @@ &gpio0 {
 		"P9_18 [spi0_d1]",
 		"P9_17 [spi0_cs0]",
 		"[mmc0_cd]",
-		"P8_42A [ecappwm0]",
+		"P9_42A [ecappwm0]",
 		"P8_35 [lcd d12]",
 		"P8_33 [lcd d13]",
 		"P8_31 [lcd d14]",
-- 
2.39.5



