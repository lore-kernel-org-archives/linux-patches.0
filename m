Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029864;
	b=qjShwB8dAse/uWmfjxqK96dSoiPOPEwoA0zywdNYsHhxqapWhdWOg/FTFEDQ05znUml7
	 COvaHofxpYyvjZt6aOsSuYuU0d71duISgmLETolYnVx0qG8wJXV77VR/Va6KXfky6LG/n
	 qLbKwJKkSP+ZKxu4/aqeLu+6+M4eaOX39Un08yawGHnSmeodQotoDgB4AtuVp5m5D9lpF
	 CKogudtRE4HYXt/M9P8EUVMTjAVFzb1fhAvexWFURoRULaUqbbOVkuRmDwfITizqZZaJE
	 uNjpttdaXt3Wwx4Ga7mkGMkQttOPPL82wevxVJUB4HUNxg3nBzB0MQ84lmg5u6oL+DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIJ/5YIKQIVvw6RwdRF6i0DyovoPKimKDdATirdE8Vk=;
	b=lPd1WRMFDr7uJA7bHf+nLXuEVt8pbY8T2I+LsCS01bLwXdnhIK6VrVo+xNXVAZMfrM+9
	 yoodWz7Bscp/Qx+0gTEWZi5PanAk3BqQGt4Y5GW8BkhgSnpl9IhGcs3UOkGABmjhPGYsJ
	 vyZ1y/COslaEUUcjS/l+qknoJM3Wwex9zDZIUH9i+SnxTpYXuO1AUVq6cUnIjxyzSi1VG
	 CtBv02JLZ0rLxvhDAJyvfaTJkn6kiwhLLLZDG6SBxJqui4P5it5tA4XZagCw/v86dpDhK
	 0U0zY+J364EgnbWTB0EUQM33DU4MGMBIyOCyw3DFEoiNeEm1l+YBS+4g+ptbg2TtRBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKQt4mnO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204FF606A31C;
	Wed, 18 Nov 2026 19:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKQt4mnO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BACD1F000C4;
	Wed, 18 Nov 2026 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029864;
	bh=HIJ/5YIKQIVvw6RwdRF6i0DyovoPKimKDdATirdE8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKQt4mnOe1yfpF2NwtZ7XTVtCCbxmtgpPTCpsYDkfB0epvXRpxSECPEtam+m/u33L
	 s3/aOpP747AUfQRZKRX2A9G0vnaoz7ul23vZR8paloazAfNT0rHQFo9OiOrn+d31rD
	 oqGpbPBWqjhk+9NZv2PtOS47TvkGwoZVoo+xHBCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0500/1756] arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:43:47 +0100
Message-ID: <20261118150028.983591574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 7cb4d28a28845..47e32b05ea62a 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -994,6 +994,11 @@ &main_gpio0 {
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
 
@@ -1050,42 +1055,6 @@ &main_gpio1 {
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



