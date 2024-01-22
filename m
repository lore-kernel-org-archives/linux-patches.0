Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2AA3FF4;
	Tue, 23 Jan 2024 01:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974637; cv=none; b=ujB6KpcTIM5a1fFq0o49jsvOt2jZ5SMgvScbfr7AOiYLmQIh41Q/Ism2mGLr3KLCeobzuFTbnISfZcFqLDBUp/TwAqQH1kU78f23Lf79L1n3768Fktu1rHI8RLyVuY+Vw1B/APc/wK8QRr2gfQ25WYmQPv8rZ1sqhnBpt4iZ6I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974637; c=relaxed/simple;
	bh=oNcCq0nlblelPVfc/q45pjrrLxXoDZSlAxV+kXvziW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8dVLcVI8E0Bso7xPbjppTjqvasJMe58TTIZqDT6w/YnKBoTPtNAIvS7if5yNlMIKPVZMkE51QpWTrGVdurusXUSaZShs3JlZQsLsJdP3kGMLorjevy9f05XoxHbGVVrN1LqfaL9hp9phXTddwWNb6QzPRM6Q6+TQMoso6A+q2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApTWqqre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApTWqqre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB90C433F1;
	Tue, 23 Jan 2024 01:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974637;
	bh=oNcCq0nlblelPVfc/q45pjrrLxXoDZSlAxV+kXvziW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApTWqqreIhOSx4UwMFlhvKMZkbMJXhyac2vq3WtNiOnomHKNKqHLwOq5cHaTBVvSb
	 eq3kEgq1mocuc9LxNKk5PEYQI5l+n/3sI8QBLov736q16QVE4A45s1pjVRIKvmydXX
	 GLqEPPatE99AWYd4RcK/8IfyBXj9WY86JMbeciN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/583] arm64: dts: ti: iot2050: Re-add aliases
Date: Mon, 22 Jan 2024 15:52:30 -0800
Message-ID: <20240122235815.210422638@linuxfoundation.org>
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

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit ad8edf4ff37ab157f6547da173aedc9f4e5c4015 ]

Lost while dropping them from the common dtsi.

Fixes: ffc449e016e2 ("arm64: dts: ti: k3-am65: Drop aliases")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: https://lore.kernel.org/r/1edbc1b56ed4ff2256d7afb7db3cab4b3a423692.1699087938.git.jan.kiszka@siemens.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
index ba1c14a54acf..b849648d51f9 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
@@ -14,6 +14,16 @@
 
 / {
 	aliases {
+		serial0 = &wkup_uart0;
+		serial1 = &mcu_uart0;
+		serial2 = &main_uart0;
+		serial3 = &main_uart1;
+		i2c0 = &wkup_i2c0;
+		i2c1 = &mcu_i2c0;
+		i2c2 = &main_i2c0;
+		i2c3 = &main_i2c1;
+		i2c4 = &main_i2c2;
+		i2c5 = &main_i2c3;
 		spi0 = &mcu_spi0;
 		mmc0 = &sdhci1;
 		mmc1 = &sdhci0;
-- 
2.43.0



