Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E995328382
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvnECDXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A70AC433CA;
	Wed, 15 Nov 2023 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076386;
	bh=iFueHND0gZtKQaojLDRBaTHokDjRwHY06gplllbd7Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvnECDXEfge51lFgVJAqN2b7WXrjKorB7aWI8IOMUYayv28ro4rFnU6W1m6JCB202
	 JVHT3ZWKv+hmhcirfZlQg5+DswhEThlehBwI8E5Lxs+NfRXw7vXcEJTZCSsPa2U6Vm
	 enyv7hfNFHYoIjL2qsoxiwCJJfLezM50IYogTnrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 260/550] ARM: dts: renesas: blanche: Fix typo in GP_11_2 pin name
Date: Wed, 15 Nov 2023 14:14:04 -0500
Message-ID: <20231115191618.735109642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit edc6ef026fe69154bb6b70dd6e7f278cfd7d6919 ]

On blanche, the GPIO keyboard fails to probe with:

    sh-pfc e6060000.pinctrl: could not map pin config for "GP_11_02"

Fix this by correcting the name for this pin to "GP_11_2".

Fixes: 1f27fedead91eb60 ("ARM: dts: blanche: Configure pull-up for SOFT_SW and SW25 GPIO keys")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/203128eca2261ffc33b83637818dd39c488f42b0.1693408326.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r8a7792-blanche.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/renesas/r8a7792-blanche.dts b/arch/arm/boot/dts/renesas/r8a7792-blanche.dts
index c66de9dd12dfc..6a83923aa4612 100644
--- a/arch/arm/boot/dts/renesas/r8a7792-blanche.dts
+++ b/arch/arm/boot/dts/renesas/r8a7792-blanche.dts
@@ -239,7 +239,7 @@ du1_pins: du1 {
 	};
 
 	keyboard_pins: keyboard {
-		pins = "GP_3_10", "GP_3_11", "GP_3_12", "GP_3_15", "GP_11_02";
+		pins = "GP_3_10", "GP_3_11", "GP_3_12", "GP_3_15", "GP_11_2";
 		bias-pull-up;
 	};
 
-- 
2.42.0



