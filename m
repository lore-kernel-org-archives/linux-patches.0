Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAF722579E;
	Wed, 25 Feb 2026 01:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983049; cv=none; b=b9mnipzaQOzSWDiWrcHQ3ZRfD/DqO+7lXFkPFJk/3LJOP4pY/eNTMuRp1N7V7axOGvjMi5mPmcwL1tDr/lTjZEVHqHaXkWyq6sTxnjlrYqv21fqV+fj29N79SXni/jsBby0mGpLv3yY3VFjLxuRenn0bzWg3CyPXwn1zpRk3YZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983049; c=relaxed/simple;
	bh=irERDevZnC+i62fAtcWNVSTXgCLGgDQ0zEg4/vIcyXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ue+XT/rR8KVtEiHk9h4z47ly5g906qBkyIp0VmegPB38zX5NuGarG61AcwrYDLdFB9CnSOJxfHX7WsHnTprbRENGYduJ9yf89pzrcXyx8Ydr3ZeWUQJfbt7vnBEJ3ouIbLdCRWVM1Znlb46ZArfS6xidlywNQ0Zg1ybJp8JfjBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRsSOHdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRsSOHdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAC7C116D0;
	Wed, 25 Feb 2026 01:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983048;
	bh=irERDevZnC+i62fAtcWNVSTXgCLGgDQ0zEg4/vIcyXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRsSOHdj1lJ+8x316hME5lPSGju3zGv76nABICqvUIH86lSzUnYWJ4PtIa6IJIJQl
	 HdoMlfKkhDLrGlfdZ7GZxxHLOV6EIliwutafQ+4xkomJNqr6PaEDky1wbdv9eTLvSF
	 ++vXGQEpdaohqmbusPJpvLAAcWaiGGmt/c4oa+QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 159/781] arm64: dts: renesas: r9a09g047e57-smarc: Remove duplicate SW_LCD_EN
Date: Tue, 24 Feb 2026 17:14:28 -0800
Message-ID: <20260225012403.555179462@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



