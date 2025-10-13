Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01353081BE;
	Mon, 13 Oct 2025 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367449; cv=none; b=he0MmDDia37R8VZtCUIBJEwMYJAdlCpQBABQN8ifXWN5h9KaokJuvrwg0vodqRo/CwI5g0Q4DxzR1Ps5UqYKXpCiVE+7Lt/zgJITIaoRPXeTr3rlOK3dH4YAjzgQqbZ5FGrWk28RmD9u8yKf6LnrnI/bPFkiVmu4gFftVS2L2mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367449; c=relaxed/simple;
	bh=8s0w+i6rUoTGGdHzLxE8E4e4WHfZzKDOc/r7U+AMJ7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbU7NeT/WXIXHcS1uTH8iiflCbwTTOTdI0Ux21mxI49pYj2jl74+Q1G5aRvk5LObf0xVNEwdg6JoCrObvxAbZDbBGWJnzrN7yJXQ8aNBXekbiMCXZQxZrxnSwodMOsfRX+3zOpZH66oNJJ+k6OkSmXOopJFjkzaPYLkxZNRaqVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+u6dULI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+u6dULI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5BBC4CEE7;
	Mon, 13 Oct 2025 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367448;
	bh=8s0w+i6rUoTGGdHzLxE8E4e4WHfZzKDOc/r7U+AMJ7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+u6dULIaH++l3YQedNdrKscuPBHXi4Ev6LF9prZBKmx7HE6xzNAdO/EQCuaK3WlC
	 I2JsOo3/ZIlVtDGRX7tCHx1OKKn7+iy/xZUywcDIbUO7OcpnI1NfaN0l698y7SvCSo
	 ctM/TxKuTyEkcQI6wpyEaPbFT+iDVrjTbyUQAVcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/196] ARM: dts: renesas: porter: Fix CAN pin group
Date: Mon, 13 Oct 2025 16:43:27 +0200
Message-ID: <20251013144315.783884763@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 287066b295051729fb08c3cff12ae17c6fe66133 ]

According to the schematics, the CAN transceiver is connected to pins
GP7_3 and GP7_4, which correspond to CAN0 data group B.

Fixes: 0768fbad7fba1d27 ("ARM: shmobile: porter: add CAN0 DT support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/70ad9bc44d6cea92197c42eedcad6b3d0641d26a.1751032025.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r8a7791-porter.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/renesas/r8a7791-porter.dts b/arch/arm/boot/dts/renesas/r8a7791-porter.dts
index fcc9a2313e1df..0cd08f7b8d8e0 100644
--- a/arch/arm/boot/dts/renesas/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/renesas/r8a7791-porter.dts
@@ -266,7 +266,7 @@ vin0_pins: vin0 {
 	};
 
 	can0_pins: can0 {
-		groups = "can0_data";
+		groups = "can0_data_b";
 		function = "can0";
 	};
 
-- 
2.51.0



