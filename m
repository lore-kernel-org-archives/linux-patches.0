Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039978;
	b=x2JW34GxqfZdold/0ZSSbTAflfQc/DeDLCtDHwgbfyIl1BltEAyLkZGhMdOUB9nK5Pyh
	 aJueAMV7IxAUSq/eu1ToBNmy2jPSEOh6/Dgy3TSOKY1whg12VTkNWg7DPCPeE0Jondh6O
	 LAM/0fHqpPSdWgccvj5A+GCVW7JQfaAIYyGy0vUQn1OLvSZwALus3wEccAutBNY5oR9mr
	 j3rhdXTxKCSyauRPc3edil6+TRRg7aLUA8So/aTvEejKtS0ywq7jpgjQGnsKdmlReh1Yw
	 e+gD9xwfxC5PbKBKbX8GE2kVVWqTFbxL9LmqRMueCsTS6I8koEvb1WR+kHv6DXmoNeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82Yx5tww6/YkZqaYVzHaSlvA2r3h/rNTcjujYhCP/Sk=;
	b=TJKzUPb+XroH80T15x/qivMxeR2lImUTNaGzWgVxp4YAqRa4dmZhTHpaYbkDyLV6B9Cf
	 M0HFu+0bJTEVBGqIhPCtA+zDYQbNVJWGn0a/KXSIDML5nml9Im41yubYhBigwDkH9yi7a
	 jK8RUglSCiFyv6VVgtru73QkIThIWqB9NvNvW+wsX4mkkF3PaapaHBdq+TrgdFBHml0ef
	 JW/d52QbU6H61yYW9HBTFJnAhetp79KHIvgyItJwAVa9OYgvtJzHb1ipGtJFwT7dZ4u49
	 5bGXQ5jCNpMi9orhuudQRVFLMPmyygOR+rJUPeblImjr1aH2Srk41H6UPp0/Si0HPDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9RPMvLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEC2606A320;
	Wed, 18 Nov 2026 22:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9RPMvLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB171F000C4;
	Wed, 18 Nov 2026 22:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039978;
	bh=82Yx5tww6/YkZqaYVzHaSlvA2r3h/rNTcjujYhCP/Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9RPMvLr18LI+WT1jUaiFEhV+h0p49Ql9QM1OL8gBu1azII8c2Pab4MS6wbTm0gY8
	 hR9T+iJbs4+7WSIRazVfsJkQF9X5yec9/UWgWgzYkgHm8ciqHOX9OMWajpETBMQ2LZ
	 O7hnHRD9WhlUmVYs/xiRNGa28gO4PA60kMjwsRog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2293/3318] arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:48:35 +0100
Message-ID: <20261118150430.527433414@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 11a51e82e1f997975a28358a1dcffec190ea7282 ]

gpio-line-names sized main_gpio0/main_gpio1 for 87/88 lines, the SoC's
ti,ngpio values before they were corrected to 92/52 in commit
28c8f2189d80 ("arm64: dts: ti: k3-am62-main: Fix GPIO numbers in DT"),
four months before this file was written. Resize both arrays to match,
keeping every existing label at its original index.

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260914190943.50843-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 41 +++-------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index fc43b5c673033..73a7bd2cdb043 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -965,6 +965,11 @@ &main_gpio0 {
 		"",
 		"",
 		"",
+		"",
+		"",
+		"",
+		"",
+		"", /* 90 */
 		"";
 
 	verdin_ctrl_sleep_moci: ctrl-sleep-moci-hog {
@@ -1029,42 +1034,6 @@ &main_gpio1 {
 		"",
 		"SODIMM_17",
 		"SODIMM_155", /* 50 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 60 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 70 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 80 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
 		"";
 };
 
-- 
2.53.0



