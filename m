Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F4D1BD4E0;
	Tue, 30 Jul 2024 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355216; cv=none; b=PCOyFG9bWKBkJnUlTBXfiP2gGTcygIcjKOURLOID2TnfYDZk6nyb5MdH5s1qK96Rt7W9wdStKQKXYectz4spbD25iXzs369A9iGat+fkgb7re6fpORUCuZlsVQ4ah/cgnCQClxINHAjemhtjdLefoEch0kPR0f+Z4YbEyiKZIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355216; c=relaxed/simple;
	bh=s9PApbZb8URqwGDkcWJvL6i0eZMlrVr9urPM6xOFi7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGKnjBVbNJkATRIdaI5zdiYAn7scEU6sXUiJ80fwsRH386sttZwSCYIFe/SLZPmajzlS7LkkxAKRcq8O1vMcxKlywTixJDzGUHXNBN0wUsKtkgitFPhtspBPneojU2CvfY6i9L/js4mudQTvMJK0ljLXXTL/7NicMonLUuPHBj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEFSJNTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEFSJNTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547F1C32782;
	Tue, 30 Jul 2024 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355215;
	bh=s9PApbZb8URqwGDkcWJvL6i0eZMlrVr9urPM6xOFi7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEFSJNTVii/RR879N/iV0yygjf1uU2mDBEi/x5CEQZJ1JuExgieNpcqlviYrXeuJc
	 A0h8yOJDcnCBoLx+s2UWBYsG8UEYfx3ely5Kzu3+O2gXg4sL83jFfZxZDoxSFzs4c5
	 LF24pS/wbo7USYCfey/vvAdXO+vu/QGGnNE9mfA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/440] arm64: dts: renesas: r8a779g0: Add missing hypervisor virtual timer IRQ
Date: Tue, 30 Jul 2024 17:45:01 +0200
Message-ID: <20240730151618.419095804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6775165fc95052a03acc91e25bc20fcf286910a7 ]

Add the missing fifth interrupt to the device node that represents the
ARM architected timer.  While at it, add an interrupt-names property for
clarity,

Fixes: 987da486d84a5643 ("arm64: dts: renesas: Add Renesas R8A779G0 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/5eeabbeaea1c5fd518a608f2e8013d260b00fd7e.1718890849.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
index 369370c0a61e3..3de3ea0073c3e 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0.dtsi
@@ -564,6 +564,9 @@ timer {
 		interrupts-extended = <&gic GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 				      <&gic GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+				      <&gic GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>,
+				      <&gic GIC_PPI 12 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "sec-phys", "phys", "virt", "hyp-phys",
+				  "hyp-virt";
 	};
 };
-- 
2.43.0



