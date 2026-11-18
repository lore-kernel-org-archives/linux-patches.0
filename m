Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024144;
	b=GEpSIEdhdJwioxJtW8lwdveBzJ3sKqNTJbob2UDcFoqUUi4IO/c9WPvcLwRbkuGvEZJ2
	 LbfptRmNGINAGWJtaBtPOYOIZ6tKrbzMYvPoZ2FQD7msXgfFsZCibtEnyUGhz+VYrS1Ie
	 fRIjZJ1oh2qBeBpAbdll7YijI3VGc5qdq7n3lplacpSnRwF542Yjp4qDRx/EHSp+1rx4d
	 Nwfa6yBesVhewbHjUji66mmeau8rd8as9YA5xzQs8D5ybzyDQo37ebwFkeQSEUYUYXKEZ
	 N1DovD3wKQmbahYKVp/PFhsNz3/CzzdeaYNC3qYZ/p4PV9LEdqKcnIM+pNwa7fdF8Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aeVGGJbQSAj40fX8KAepj6XlCqNqjZpfRL38epUPoXo=;
	b=CmirTyvQcLt0iwxBWL0C437gSdlm2rdY9Y4wvU8cJZhrNTqOHRZcch2UvIPzcVJCErn1
	 7tPZ72g84GyCkGQvC+2IjgKgWqxtsYm5ub+pz/tzhmxH5uPWIzft6jJWVOLpkGconvGk0
	 i+au6HHzZ27kMsyc/yjInGTXC+fAlvGYEQIQCZfwEG2+6uDz7cAzABy2oa1oSt6rCm/MH
	 4koUJFT3yrifkXuEXYlT5o7iFZ4jrNX9NuaSIaktrnIUdoB4e0/wz5YT+XSFs5VV0TkBN
	 sI3B/kEvSoDVnwA/kieiUXfGxDwAzCjf70fj3uQI3cpxHoCi5TnPYXHSusdvm7Xl+5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGQo6CPp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C51606A333;
	Wed, 18 Nov 2026 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGQo6CPp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0551F000C4;
	Wed, 18 Nov 2026 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024144;
	bh=aeVGGJbQSAj40fX8KAepj6XlCqNqjZpfRL38epUPoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGQo6CPplx/0i2Rqg+/EBa+vU6IT7wk873U+eOy8QFtzRT0R+AF00B7Pa3wwgVuju
	 mf6vkjAjRDYlELRBaOWX4Vvx9BXA+FVZLvdfyXNkxRGN78vT7k91nRziZpFqoMyRib
	 I56qXL/zQgWz3eRuGf3MHcbOr8/SMPqza75qm600=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0604/2151] arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:38:59 +0100
Message-ID: <20261118150143.945221559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5e8830fffb949..4a9017dc189d2 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -1000,6 +1000,11 @@ &main_gpio0 {
 		"",
 		"",
 		"",
+		"",
+		"",
+		"",
+		"",
+		"", /* 90 */
 		"";
 };
 
@@ -1056,42 +1061,6 @@ &main_gpio1 {
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



