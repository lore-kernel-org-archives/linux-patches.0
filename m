Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65B033FE;
	Tue,  3 Dec 2024 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238141; cv=none; b=YDwTPXrvwV0lzsx6PIdmWH/ymsphdt4/njUTJEFXD8wptYe8ftV8LS2D9xdehez0aKZ7ELEhljrXcVI8IgWZBV2eCDw41t0lMZrXgD/yi6QRzDlALdAOWxKas7BduXNuJBvJ8gexEcMw/IlPeIBJ4KP+BImbF/g7JlxMhrdXmk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238141; c=relaxed/simple;
	bh=9pDLS6NzoRt4DRxLfIXChlb5msUlud5+91TRQgVu2RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yg00FDZ3499y1buhpvz4qTJwdVOzwmHRFqFwg2wvz4wF0YSt8c1wWrDCXoLvKATAZDTFfWYc/XT1wGih8IQ8SKMGsJha4V4DZ98QdL8XkST2hXR0hhsD60uc0uMgPaLtICSqwCPj0Cw0UGxecLeu5hKES5aqKc4gjn69l3FM2Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIcnptIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIcnptIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CA2C4CECF;
	Tue,  3 Dec 2024 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238137;
	bh=9pDLS6NzoRt4DRxLfIXChlb5msUlud5+91TRQgVu2RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIcnptIMSlaQ74aaF66LyseN9aBFugjf0l/5NUmmb0+w54474HVwmobdKL+hNSAjM
	 99u07ECGue9gQwZAp/B8VYGmbbvI7xvA9lAKKqLomEbJv+tF6YjIHsotcObQfu7yni
	 iVmwb1/3mk0FWd4fgbXHcVn5cQBaLmmas+hSbgEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 143/817] ARM: dts: renesas: genmai: Fix partition size for QSPI NOR Flash
Date: Tue,  3 Dec 2024 15:35:15 +0100
Message-ID: <20241203144001.307606267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 48e17816c3effa3545e21cd4f7d5a00c55c17a18 ]

Second partition was too large, looks like two digits got mixed up.
Fixes:

mtd: partition "user1" extends beyond the end of device "18000000.flash" -- size truncated to 0x4000000

Fixes: 30e0a8cf886c ("ARM: dts: renesas: genmai: Add FLASH nodes")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20240914182948.94031-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r7s72100-genmai.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/renesas/r7s72100-genmai.dts b/arch/arm/boot/dts/renesas/r7s72100-genmai.dts
index 29ba098f5dd5e..28e703e0f152b 100644
--- a/arch/arm/boot/dts/renesas/r7s72100-genmai.dts
+++ b/arch/arm/boot/dts/renesas/r7s72100-genmai.dts
@@ -53,7 +53,7 @@ partition@0 {
 
 			partition@4000000 {
 				label = "user1";
-				reg = <0x04000000 0x40000000>;
+				reg = <0x04000000 0x04000000>;
 			};
 		};
 	};
-- 
2.43.0



