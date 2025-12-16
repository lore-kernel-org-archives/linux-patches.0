Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A14D35771A;
	Tue, 16 Dec 2025 12:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887255; cv=none; b=uMfqEVmSvwh4up/Chz8EntnBj6WJz6/JtMu3dJVzWQ+ZOsZkzuwI2ugcK1XMgAfSz7CD094fqiJIzBDwwrzbWdGwkP9DplRp6mCrGLGX/dF3E9woM4/8cNkxEdetskSNayT6b5CIsXz4URxaf8X2rYfX8X5GIO9285+iI1MbfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887255; c=relaxed/simple;
	bh=ZOyuIJ1xZCRkjyMq6AVA09XPRV+xMMxzvOc7N8TtTts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ins4+0ohL7p0pVxzNLgVffat2r7hFm4B8N/Ymh/IaQm0j2sh705eJU9LVKkriaHJIhfJob14u0lNnERYlkorNiDPYeJ1cLy4O6JAkpqhLEZ628ch4N7lSZaXkmSTSzvP4QPJR4AY1swny7FBdoMuqarfGWsnbwnk1Y+0YzTLRmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP74uH6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP74uH6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1913C4CEF1;
	Tue, 16 Dec 2025 12:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887255;
	bh=ZOyuIJ1xZCRkjyMq6AVA09XPRV+xMMxzvOc7N8TtTts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP74uH6YQqpeXjcZVzFmRaf26onJvsPmrS+gi90q7YDG40DiKItik3pFjuVOA4MiY
	 ghrCT6d6Cy415n1BfWDAqibY0NQ9JcyPdLko0OYMFjeme9PoQnH/+AL/0/+YRnG9kC
	 c+KVHo2dzUDe6J/z1dFvF00RFyNFtlqsbgvA8cCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/614] ARM: dts: renesas: gose: Remove superfluous port property
Date: Tue, 16 Dec 2025 12:08:18 +0100
Message-ID: <20251216111406.082202380@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 45b267ec26794..5c6928c941aca 100644
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



