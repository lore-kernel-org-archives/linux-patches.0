Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34AC1F890F;
	Tue,  3 Dec 2024 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240382; cv=none; b=n+1MDWPshR0+TdaA9AGL0xfsNyhJ4J9VlCmBoFhotP2HsAXIB8SNcHnMTb21TJmDJ6cCEHYilPYwuvTkObtDF9lRiqrOCxqELIgfn8nfC2N8pvPcty8xvC+7cAQlpjzOO2oHTnLLOvMIifsSaoJxmrropT4NT7nDyHt/TMCfvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240382; c=relaxed/simple;
	bh=xFMUJJ1MT/TXIsJZqWJPJPJnHHRLFeonZq9OEQ9ss+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTVFJWm8d3eVeKcd9uuFtL4pQV3WXoZMYRQE+PRPwc+LV6zilhAw4Jvduh/6p5F70GdPkSNnMTJHMgy2uPP+36gsQ3g5LqgIJKB5bOoKzTvmGSS4V3OS28BsipzTS3Kp5SkhWwlPkSk2PhT1BGcsUJJFKXfCYYrJ89ymvFqmsOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdAByqR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdAByqR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE4EC4CECF;
	Tue,  3 Dec 2024 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240381;
	bh=xFMUJJ1MT/TXIsJZqWJPJPJnHHRLFeonZq9OEQ9ss+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdAByqR+fM7wpzPgqf0qTzBPbtnrLZD8/FEWKRr8i9t6EVb8sFE/gl5miqt4gK+oD
	 0//1WOSYhSuDr/oiotLAk0lJGrPSprzCqvLLmI/ye+L2/N0FkFrlU+95FBH5c8C7FK
	 RBuX/9psjUUvTSRArF0FwfYszlulQlhO4EvNPeYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/826] ARM: dts: renesas: genmai: Fix partition size for QSPI NOR Flash
Date: Tue,  3 Dec 2024 15:37:09 +0100
Message-ID: <20241203144747.712537520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



