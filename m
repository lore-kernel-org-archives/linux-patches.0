Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCEC61674;
	Tue, 23 Jan 2024 01:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974936; cv=none; b=TFOGqoiY1XAGsYclWX+OxkF1W5tN42h8kLO7hsW91fv5vODxXMz1BRzeyjgUCBdpLyHfjOmmd0hjDBC6BBn402j1Xp2NRYtYEo87Af6OwIBzp9esk7OWIrywnucrclNLeXCd//Pc/GTmy+4NRuExj4+sLlNTMPyECu61+8d74sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974936; c=relaxed/simple;
	bh=ctEYgXlZoauO3JU3e8u1o6ZsHeXoF7iUcT6eGbLLzNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbBjZGN3nZ2QH7Hvu/R5kHebcd0sJjis9oIsyP9SOE3ZvBBHH3GCa2tdWimW96xw+Cmld/yrsbvcy0ujlu5NKncJEfol/WZXiOV3a7BcP6crQFKysRDHs126C1ValGRqJJpSwhizvuhuqz8+RHc08nbTFwThSOwrcm2BK7rodh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjnx4lQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjnx4lQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951B8C433F1;
	Tue, 23 Jan 2024 01:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974935;
	bh=ctEYgXlZoauO3JU3e8u1o6ZsHeXoF7iUcT6eGbLLzNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjnx4lQvVJXzQdSc654GZ2q5e+Um/QsIjG3prmTVDp1pVKKuorRfDHYJa99MdE2xB
	 2Yk1i4nngGRpPY1Dbaa1EuIRt1QIoj5wdY+QxjDJP4c+gDJbYO/gIZdOoyzmv9Uf6S
	 /yL9GP9v+Qgykc9VKB1j5mM6BVGCl0YqWOvHXTx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/583] arm64: dts: renesas: white-hawk-cpu: Fix missing serial console pin control
Date: Mon, 22 Jan 2024 15:53:27 -0800
Message-ID: <20240122235816.825490977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit fc67495680f60e88bb8ca43421c1dd628928d581 ]

The pin control description for the serial console was added, but not
enabled, due to missing pinctrl properties in the serial port device
node.

Fixes: 7a8d590de8132853 ("arm64: dts: renesas: white-hawk-cpu: Add serial port pin control")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/8a51516581cd71ecbfa174af9c7cebad1fc83c5b.1702459865.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
index bb4a5270f71b..913f70fe6c5c 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
@@ -187,6 +187,9 @@ &extalr_clk {
 };
 
 &hscif0 {
+	pinctrl-0 = <&hscif0_pins>;
+	pinctrl-names = "default";
+
 	status = "okay";
 };
 
-- 
2.43.0



