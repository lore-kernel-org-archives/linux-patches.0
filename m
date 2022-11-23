Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0991C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79971C433C1;
	Wed, 23 Nov 2022 09:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196857;
	bh=r5ny8RYTNd0a7LdNCJJ/gy6kbq18AjXM1dEl0OjjLiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyR6KDqoxhzDr9eMYLrWctICvTuZ+xm5tr/2IVM6RvFGyey/hV9ioobXRoFXVog0Z
	 qge7sNz9MmWkedxpKyWZqbsWyHgHlw1WQL7WizNItNe3/4MHjBGcw0xBrsMaX1Ov0D
	 wqVfjUVLjxxp3/bHHJgRCJdIGrKGyG6ppkXOteUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 136/314] arm64: dts: imx93-pinfunc: drop execution permission
Date: Wed, 23 Nov 2022 09:49:41 +0100
Message-Id: <20221123084631.703263834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 2db1fdb25d209a88112fd82eb493976d66057d10 ]

Drop the header file execution permission

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: ec8b5b5058ea ("arm64: dts: freescale: Add i.MX93 dtsi support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-pinfunc.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/arm64/boot/dts/freescale/imx93-pinfunc.h

diff --git a/arch/arm64/boot/dts/freescale/imx93-pinfunc.h b/arch/arm64/boot/dts/freescale/imx93-pinfunc.h
old mode 100755
new mode 100644
-- 
2.35.1



