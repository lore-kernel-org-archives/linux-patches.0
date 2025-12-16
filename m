Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1687F2459D7;
	Tue, 16 Dec 2025 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884056; cv=none; b=NTCFtpP/UF60kTufiWQoXt+ebHV/m0AR/g4DIYsdFY+UusaelgQl/6lzY/V1HPLTJD/+X4Vmp80mdiv+V9SUO/Bfn0S5NmL3iNp+4m4Y1UN+UbyujlqLQO4RHdTJ/WHqU9eYQuUbZoVlO/qwZ2HNkgat6086md2XpV9Ca/csECA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884056; c=relaxed/simple;
	bh=D/yNskerJnjcVFNGKyz59wu/UcnJEG2HKWLSRCuVymc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+Zeb3p9BOxQc75qCGrKPrlYQhVsAsg6896sRl3+fKW2p/92qOwrxOsvdozAJm0qsvPwr3xM7O1RlpqCX1B6paTtueRlE7HjKT0wqSZr63ZGFhPZ2exNS43oW+KawMFFFXc0om8v7BXcKnyOyUyCEDihY0FDyRV5vkG4Iih52lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChTQkL3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChTQkL3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A5DC4CEF1;
	Tue, 16 Dec 2025 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884056;
	bh=D/yNskerJnjcVFNGKyz59wu/UcnJEG2HKWLSRCuVymc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChTQkL3ZTYk+qBaJV2yMvYIwWjIQRuKqiHpvlB/3PBgNPidLQc0bwADU8W1ZBP3vY
	 e192fEjQ3LCCWaxOsPk1CY9D3EMCrbLgCSLLg690A+wKtXRkQeoHsjQlvX1XBw5+Aj
	 la8OJ3iSmOgEYj7+MSu3ChwV0IYzekaMXEUwYjns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/354] ARM: dts: renesas: gose: Remove superfluous port property
Date: Tue, 16 Dec 2025 12:10:47 +0100
Message-ID: <20251216111323.822788736@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 00df14f34615630f92f97c9d6790bd9d25c4242d ]

'bus-width' is defined for the corresponding vin input port already.
No need to declare it in the output port again. Fixes:

    arch/arm/boot/dts/renesas/r8a7793-gose.dtb: composite-in@20 (adi,adv7180cp): ports:port@3:endpoint: Unevaluated properties are not allowed ('bus-width' was unexpected)
    from schema $id: http://devicetree.org/schemas/media/i2c/adi,adv7180.yaml#

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250929093616.17679-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r8a7793-gose.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/renesas/r8a7793-gose.dts b/arch/arm/boot/dts/renesas/r8a7793-gose.dts
index 1ea6c757893bc..1a4e44c3c5af6 100644
--- a/arch/arm/boot/dts/renesas/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/renesas/r8a7793-gose.dts
@@ -373,7 +373,6 @@ adv7180_in: endpoint {
 				port@3 {
 					reg = <3>;
 					adv7180_out: endpoint {
-						bus-width = <8>;
 						remote-endpoint = <&vin1ep>;
 					};
 				};
-- 
2.51.0



