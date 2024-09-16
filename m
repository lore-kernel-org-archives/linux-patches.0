Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E8A1547FF;
	Mon, 16 Sep 2024 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488721; cv=none; b=hbf6ZrwrVmXKWyKDxSAy1dvJeDv6ktUxJUuu6yWXwcup1pGl/wYytFAik638qKPaDclrWnckob9vg5xuNV7JKunJF7glieB/WmN9L4DhTs7l2Cx2nYKBVLNqAW7RQtliiqoJbXjqu1C0y6puonzE0lCX47BeH6lBdwCfDCJgehE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488721; c=relaxed/simple;
	bh=L/RJCC9TrPjzZkjXH/49/mIiRoGI6G04nx3wia55/jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYxphSH0VK4fzQFG9ifKD1PVlE5cJZH6R2dqb4vhZP2N7orNCun+WNSaugJE2Fqw2yjeElnvqAS4tW1N2iX8vxKv1PHnK9YObfRenn6CzlHk/FPwvPzbx3LjY4+ev0pqeLjzF2THVMVktAfy0d4X1cNXxOhpxKpNuT/VAXKkcLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEPycz4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEPycz4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEE9C4CEC7;
	Mon, 16 Sep 2024 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488721;
	bh=L/RJCC9TrPjzZkjXH/49/mIiRoGI6G04nx3wia55/jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEPycz4yTIwrVp/2Q+pdEHnGuC0sQqWnLGa5Kb5Y5kMLf76z4AAneUMebQFD1UB4k
	 7MKE+2TpQgekpqw6/utCyW4GlLkS5HzRW6jrQahwczLEZjUZaEh5/Onw9G/VSoDdBN
	 nMHiSa6VyUtYPEcva6YppuiEXMIrhaQTFdew3sgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Qiu <william.qiu@starfivetech.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.6 91/91] riscv: dts: starfive: add assigned-clock* to limit frquency
Date: Mon, 16 Sep 2024 13:45:07 +0200
Message-ID: <20240916114227.452304586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: William Qiu <william.qiu@starfivetech.com>

commit af571133f7ae028ec9b5fdab78f483af13bf28d3 upstream.

In JH7110 SoC, we need to go by-pass mode, so we need add the
assigned-clock* properties to limit clock frquency.

Signed-off-by: William Qiu <william.qiu@starfivetech.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -204,6 +204,8 @@
 
 &mmc0 {
 	max-frequency = <100000000>;
+	assigned-clocks = <&syscrg JH7110_SYSCLK_SDIO0_SDCARD>;
+	assigned-clock-rates = <50000000>;
 	bus-width = <8>;
 	cap-mmc-highspeed;
 	mmc-ddr-1_8v;
@@ -220,6 +222,8 @@
 
 &mmc1 {
 	max-frequency = <100000000>;
+	assigned-clocks = <&syscrg JH7110_SYSCLK_SDIO1_SDCARD>;
+	assigned-clock-rates = <50000000>;
 	bus-width = <4>;
 	no-sdio;
 	no-mmc;


