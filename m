Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA81F669E;
	Tue,  3 Dec 2024 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238738; cv=none; b=DjvEM0oHpxqlZFevK/gQm3tnqxMVcZhII0yUcPihhGUYhnNwpK4ndbIYha89X5tdDkEw3WZbbgl/nqAQnOSeEsCJ1IckN9+Hu3bW78FVH+5CzOeMnf3V1lDozjPMBAt0og9CheFfT1sfetE4pBDxZ6nShkFw9ilVj+W7SNfF9Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238738; c=relaxed/simple;
	bh=xCmccjG4DaLL0jjJ1gTv4idj0ueHFRSW4aJi+7qotMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imO+FLZd9Xk8pWYHoIbJgdJvBds462h++8ZH20xu/4j3olHMsd2sAxSAK9S5ybiQMmiGtIQeWEI08CpPj3wpU6bb/OKI/QU4uefDDMU3b7rWLBWxrxjF9ba83JSGV3TiFA8NcjIeQrWu2vxyz91GocnudZXbNVCGvJgjjx8n1s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsXkSbi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsXkSbi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9C6C4CED6;
	Tue,  3 Dec 2024 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238736;
	bh=xCmccjG4DaLL0jjJ1gTv4idj0ueHFRSW4aJi+7qotMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsXkSbi8ZVtCbvgST41LmnzVX2Z1QHKxZMrDw5vbKgD8FHP0/EPhWglZdW6bzMleF
	 IPw8Vd5p31THVguUGhYSeDmNjXru/4S0BiRlIiQ2zBE7GTPyAm6iBI4LwezkWj8RdG
	 K74caiLOCDJY2pmY0NYBi0NEkE2/+EOEqXTaF0xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 381/817] pinctrl: renesas: Select PINCTRL_RZG2L for RZ/V2H(P) SoC
Date: Tue,  3 Dec 2024 15:39:13 +0100
Message-ID: <20241203144010.715495501@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 5dcde519a067ac5c85c273e550dde1873e2199bf ]

Add explicit selection of the PINCTRL_RZG2L config option for the
RZ/V2H(P) (R9A09G057) SoC, ensuring pin control driver is enabled
for this SoC.

Fixes: 9bd95ac86e70 ("pinctrl: renesas: rzg2l: Add support for RZ/V2H SoC")
Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241010132726.702658-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/renesas/Kconfig b/drivers/pinctrl/renesas/Kconfig
index 14bd55d647319..7f3f41c7fe54c 100644
--- a/drivers/pinctrl/renesas/Kconfig
+++ b/drivers/pinctrl/renesas/Kconfig
@@ -41,6 +41,7 @@ config PINCTRL_RENESAS
 	select PINCTRL_PFC_R8A779H0 if ARCH_R8A779H0
 	select PINCTRL_RZG2L if ARCH_RZG2L
 	select PINCTRL_RZV2M if ARCH_R9A09G011
+	select PINCTRL_RZG2L if ARCH_R9A09G057
 	select PINCTRL_PFC_SH7203 if CPU_SUBTYPE_SH7203
 	select PINCTRL_PFC_SH7264 if CPU_SUBTYPE_SH7264
 	select PINCTRL_PFC_SH7269 if CPU_SUBTYPE_SH7269
-- 
2.43.0



