Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC15E30F921;
	Mon, 13 Oct 2025 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368884; cv=none; b=e6J95nSeqLm7wxQTcnAnReb3fPGDosguLzavnOlqZ4q2qaJ+K9Qg3hOgDqoLS1HVvAICswx6BUnSvawhEzckkA1H4sysAua+QgCN0E3iylOW1HZijCZ4ABtC9Huh3esFfNK+eVkFMw/DmoSyS23WI1vvTAQaokrZJmbUdyfCNQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368884; c=relaxed/simple;
	bh=S4oqsQrLNpzi0BKw1vDQLiTmN0aJotZ+QAOPRtH7V98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRyrM9LCgdT7fmfDfe0puK7dPwKQxUC5sMORzcT7GDgkSHhw8E+yzFHQ7fdVc0ALQouQbPxcJbCRgT6tKNbdPXQrpOOyp4ORMu+grcc0JIX4/aKIPpooJMwU6oR7ixteWau8nCMRErPeH33IBDU7kqR7zBIr9TpNTNv9xor6vPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU0EiU3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU0EiU3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECEEC4CEE7;
	Mon, 13 Oct 2025 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368884;
	bh=S4oqsQrLNpzi0BKw1vDQLiTmN0aJotZ+QAOPRtH7V98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU0EiU3Mtk6oHv1QfSMuGjn4AR/02oWCusqE2ja8cugc0pFNLTPoqPr3mBlaRwkZp
	 HCCVjDaEqCXD/3MytJEBnSmlHF2vfXq7P92f8uOhbmofUhZF0SLK98amaLqZx+Xt1h
	 7KmuGATrmmxsSWaZl9oaHVUROpqsNNfE0IebvI/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 051/563] ARM: dts: renesas: porter: Fix CAN pin group
Date: Mon, 13 Oct 2025 16:38:32 +0200
Message-ID: <20251013144413.141711892@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f518eadd8b9cd..81b3c5d74e9b3 100644
--- a/arch/arm/boot/dts/renesas/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/renesas/r8a7791-porter.dts
@@ -289,7 +289,7 @@ vin0_pins: vin0 {
 	};
 
 	can0_pins: can0 {
-		groups = "can0_data";
+		groups = "can0_data_b";
 		function = "can0";
 	};
 
-- 
2.51.0



