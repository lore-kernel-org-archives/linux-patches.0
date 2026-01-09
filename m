Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E62433A712;
	Fri,  9 Jan 2026 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959556; cv=none; b=jiOUvSOg1yBQN6CAmPK3qlgyI5GNE8SYI/iheK4E0/UVIIAjx90o2oVC5ndttevdM+wBTPiuHBprPwVQf05CmaxE+uqEp1kgzV/Lmss1FYmxINOw9MjouGU45/mzq87AEXnUyjwOevFk+khLb61aRJIX/rVp9VrYL+ZPJo8Zg/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959556; c=relaxed/simple;
	bh=VVwopGst74QgaKEh4r9nDwbnkKcegu6S2rtAhVwAo/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR4GKga+DgwuDyhyNyfiqJvJkoS6HA9Jv9zEDikN6N1Ff2Rtf3Du2bHxUbvkRp1nurAqGSOHW5NH65qAylDxuD5Z73cip13QsRip7DJDXeJHsJij5gz9GjcsR06iMCJiEg1f/+gHHUski3GAf+Pwa4OWclBwPNVWCSzHidxVKHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiuAkHmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiuAkHmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC4AC4CEF1;
	Fri,  9 Jan 2026 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959556;
	bh=VVwopGst74QgaKEh4r9nDwbnkKcegu6S2rtAhVwAo/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiuAkHmHybwT+Zmo07RFlZfjKWvH2KN8KWIszul4UIlq+w37krK56zSOT66iPvOyV
	 lo9C9d/b7xUM3JHmYpXsMUlz0rDRkodpNlu7QGeyUA2Yti4zJFyW16yw85lDaMZKsU
	 UIrv9iS1UDEwZgTgy6c0VAPb8VTdeLw/KJ00O+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/737] ARM: dts: renesas: gose: Remove superfluous port property
Date: Fri,  9 Jan 2026 12:33:52 +0100
Message-ID: <20260109112137.497647649@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9358fc7d0e9f6..e92de3ab33b5a 100644
--- a/arch/arm/boot/dts/renesas/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/renesas/r8a7793-gose.dts
@@ -355,7 +355,6 @@ adv7180_in: endpoint {
 				port@3 {
 					reg = <3>;
 					adv7180_out: endpoint {
-						bus-width = <8>;
 						remote-endpoint = <&vin1ep>;
 					};
 				};
-- 
2.51.0



