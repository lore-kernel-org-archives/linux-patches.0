Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC64626B2AA;
	Tue, 25 Mar 2025 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906256; cv=none; b=aFrdac6KHyPUTAq6T0gLn7QTO7K6d3wE1Wu9WGUhRkK4xFrO0Hxx1zlCCUcURXR1qvZ7B/FxBLRPNMor+a4wPW+aysZdDmA4yQNBgkuUaaz1DrQHy7JL2eQsRaQEcv2h+/elLFtQaCzabT/qS/mbgS5uEZbv90umoflJtocUyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906256; c=relaxed/simple;
	bh=dGmMt2Z17UOsjS5SzzW6G9nvk23Yec1WlZ+nszF7C7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chKRo4WzgRNG0II3XxKrU1bwi/oWnk4fZFjBvw4dKwtLsuodocmGhusfqIHzWVku8gxw4g086RAh4q0Isq0R3wiV0Jq+W61LeX06kV5uRAfVfevXf4LvakVYl/DMvMRKyB9DrleZ2WCY6ypsKxplXGM/lf7ezcuO57BM80zrp78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2RMrvMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2RMrvMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEEEC4CEE4;
	Tue, 25 Mar 2025 12:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906256;
	bh=dGmMt2Z17UOsjS5SzzW6G9nvk23Yec1WlZ+nszF7C7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2RMrvMpALp1jXEIbpSyqCbFgkDI+3KLf4ev1jHfpU+b2oGKyC43TDEaECUI7wkJQ
	 LuUCb7r6Bfm1WsL8MulLJU8RKsyJXoZ6RiVoq2sE6xWNM+DS6FbYOiRCtWhno4P7kz
	 th/CuERFeQ6wjFjJJYpZ+JrcQpnACms2ctNVUIIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Brautaset <tbrautaset@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/116] ARM: dts: BCM5301X: Fix switch port labels of ASUS RT-AC5300
Date: Tue, 25 Mar 2025 08:21:47 -0400
Message-ID: <20250325122149.736526367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chester A. Unal <chester.a.unal@arinc9.com>

[ Upstream commit 56e12d0c8d395b6e48f128858d4f725c1ded6c95 ]

After using the device for a while, Tom reports that he initially described
the switch port labels incorrectly. Correct them.

Reported-by: Tom Brautaset <tbrautaset@gmail.com>
Fixes: 961dedc6b4e4 ("ARM: dts: BCM5301X: Add DT for ASUS RT-AC5300")
Signed-off-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://lore.kernel.org/r/20250303-for-broadcom-fix-rt-ac5300-switch-ports-v1-1-e058856ef4d3@arinc9.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts b/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts
index 6c666dc7ad23e..01ec8c03686a6 100644
--- a/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts
@@ -126,11 +126,11 @@ &srab {
 
 	ports {
 		port@0 {
-			label = "lan4";
+			label = "wan";
 		};
 
 		port@1 {
-			label = "lan3";
+			label = "lan1";
 		};
 
 		port@2 {
@@ -138,11 +138,11 @@ port@2 {
 		};
 
 		port@3 {
-			label = "lan1";
+			label = "lan3";
 		};
 
 		port@4 {
-			label = "wan";
+			label = "lan4";
 		};
 	};
 };
-- 
2.39.5



