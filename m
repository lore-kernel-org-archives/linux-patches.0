Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F046F2494FE;
	Wed, 25 Feb 2026 01:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983916; cv=none; b=cZu/PngTplCVmI2/9NngLgOiCtgQ906xy38X9oWedmnr3wZoCauk6YiFFC9D8iOTJ8Tsb+4QIGGmVmktTnwSattVwlHvpPY1C240BBO0r+3bVBJYTYhR8aqDcAoqnVfNnCTRS7piOOWwQ2AL0WSlpXeSQJXN5IWwxgitxRDEqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983916; c=relaxed/simple;
	bh=7/fwMb0iESw8E/YGL7RBQ8wJqnc+4Yza2IEBswsDCxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVk8y89qYyGtxGBhVXTH6lOmA9NcMQL2luuXNoa1YHqlC5btIeTcQgKB48qF+m2rvDVXF2hKzXensDzrI4Ad20yhKcaSlg5k41wog+o1qR4P3fDvq1v0nDP80YulD3uV9qOzWX36b1RSdcAt5TdFOuAPjmnchWmZzLCjCKhsbSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oi6V5qs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oi6V5qs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EDEC116D0;
	Wed, 25 Feb 2026 01:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983915;
	bh=7/fwMb0iESw8E/YGL7RBQ8wJqnc+4Yza2IEBswsDCxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oi6V5qs5UidwZ+vGwkCvl8GDxZRAX0LTUgRU3fDd0T2O8i7H/XwllpezD+3VEJ7sK
	 wPatHUiC4Ezy5Mu9tfNAC4x1WWL7y4xpiMLoh4urv3HpLeItgnoOH88RMDPOYpA56V
	 9XtIU3c9wP6VThl3roEJPItQwjglrkvtAeEcJhi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/641] arm64: dts: renesas: r9a09g047e57-smarc: Remove duplicate SW_LCD_EN
Date: Tue, 24 Feb 2026 17:17:45 -0800
Message-ID: <20260225012352.495561222@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 44cfd102ce28e749a07bb0f1668cf932077b1175 ]

SW_LCD_EN is defined twice.

Fixes: 9e95446b0cf93a91 ("arm64: dts: renesas: r9a09g047e57-smarc: Add gpio keys")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/1f93558c62f4461f50935644ec831a7d2cb52630.1764089463.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts b/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts
index 08e814c03fa85..ed6fcdc337a0b 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts
+++ b/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts
@@ -8,7 +8,6 @@
 /dts-v1/;
 
 /* Switch selection settings */
-#define SW_LCD_EN		0
 #define SW_GPIO8_CAN0_STB	0
 #define SW_GPIO9_CAN1_STB	0
 #define SW_LCD_EN		0
-- 
2.51.0



