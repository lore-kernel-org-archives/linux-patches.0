Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC613AA4C;
	Tue, 27 Feb 2024 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041266; cv=none; b=MLc7yhh6sJu38vCB1seoFJe+rGIKd8jF5D8+4MZpgZH/c7oQcIKFXTukM/Onim5r8Ta2no9Os1TYhJknGgYJT5+m8Ye991NIhaFItgBXDJgBrGJ8WAAkJATNFbhsGTBqiwzFc1MnL0uik/rHba3MJf65uCctuwmuo/ndjCneU68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041266; c=relaxed/simple;
	bh=tKNyB9EbHs7v5vYz9/7m4lM/87J9gNSyzwCWcIGrcug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+LSzp+BA/guK+QfXlAXSknKZZVxg9WVTQXvQM5fAKG7RM80wrhxoLIezqQWHqmQbE5VMWNtwCvsqM7Jqf6VpyTAUMJADbEDk3kFMVAAkB2LpNOVOPD0Uj9o/ZXfTljqPzXDVevZTYeCME3vBP+xvmTRxoP45R01BVVT8SAuEnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9HvUBr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9HvUBr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F0AC433C7;
	Tue, 27 Feb 2024 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041266;
	bh=tKNyB9EbHs7v5vYz9/7m4lM/87J9gNSyzwCWcIGrcug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9HvUBr+3VOK2nhCTjp0h4tBspBgdp8ACmJyfdixyNgRmZWNGX3cQ/1xherl9EVLI
	 fClOCqxK+hGivNGOxnpqkIBpTwknalT4TJSyM4tLXoCX+v4DWg36WtlXIA9KcIZ0ck
	 MkA9Z99yx/j+koje83yom3evNLyRLyTghLVQRyWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 250/334] arm64: dts: rockchip: Correct Indiedroid Nova GPIO Names
Date: Tue, 27 Feb 2024 14:21:48 +0100
Message-ID: <20240227131638.984468121@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit c22d03a95b0d815cd186302fdd93f74d99f1c914 ]

Correct the names given to a few of the GPIO pins. The original names
were unknowingly based on the header from a pre-production board. The
production board has a slightly different pin assignment for the 40-pin
GPIO header.

Fixes: 3900160e164b ("arm64: dts: rockchip: Add Indiedroid Nova board")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20240125201943.90476-2-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3588s-indiedroid-nova.dts      | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
index 60f00ceb630e1..3b675fd0c5ea5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-indiedroid-nova.dts
@@ -196,13 +196,13 @@
 
 &gpio1 {
 	gpio-line-names = /* GPIO1 A0-A7 */
-			  "HEADER_27_3v3", "HEADER_28_3v3", "", "",
+			  "HEADER_27_3v3", "", "", "",
 			  "HEADER_29_1v8", "", "HEADER_7_1v8", "",
 			  /* GPIO1 B0-B7 */
 			  "", "HEADER_31_1v8", "HEADER_33_1v8", "",
 			  "HEADER_11_1v8", "HEADER_13_1v8", "", "",
 			  /* GPIO1 C0-C7 */
-			  "", "", "", "",
+			  "", "HEADER_28_3v3", "", "",
 			  "", "", "", "",
 			  /* GPIO1 D0-D7 */
 			  "", "", "", "",
@@ -226,11 +226,11 @@
 
 &gpio4 {
 	gpio-line-names = /* GPIO4 A0-A7 */
-			  "", "", "HEADER_37_3v3", "HEADER_32_3v3",
-			  "HEADER_36_3v3", "", "HEADER_35_3v3", "HEADER_38_3v3",
+			  "", "", "HEADER_37_3v3", "HEADER_8_3v3",
+			  "HEADER_10_3v3", "", "HEADER_32_3v3", "HEADER_35_3v3",
 			  /* GPIO4 B0-B7 */
 			  "", "", "", "HEADER_40_3v3",
-			  "HEADER_8_3v3", "HEADER_10_3v3", "", "",
+			  "HEADER_38_3v3", "HEADER_36_3v3", "", "",
 			  /* GPIO4 C0-C7 */
 			  "", "", "", "",
 			  "", "", "", "",
-- 
2.43.0



