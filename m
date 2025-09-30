Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC0320E334;
	Tue, 30 Sep 2025 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245816; cv=none; b=kJxQSSMzv84n9Q+JDW5VUUxdm360CQeHSCVcrmzvbS9TcatSQ4lSzDTUgPDnPl4rlh4MrcXu+YqHv67OAqJRIkBYd9ol7gBpC+RUwbSqMKavhtL4l6IN5eI1jW9kqinTsm98Npk6sorwkCfFBKYgctiaHUBNV0VPQvNgqWxVWg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245816; c=relaxed/simple;
	bh=6Qni5WkzTCvVsqq4hLQtDQpgjfxlULmxB85Jh1yBhvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ur+Q56mvg6jRGrmqVHQ9vp/TYqDl+8GiDK2ppCLxsVXaeSh7EwwXayeRAUxwDLqu3pJAvrOVu95H8plCXi157W7mnu819Nab8lw7b8nIB8zYK2cM/jUIG9mYjXz3S/te181gECzEebngeExj1nihWgGGffWS8DI2zajJ2F6nbLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1alCqjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1alCqjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0216CC4CEF0;
	Tue, 30 Sep 2025 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245816;
	bh=6Qni5WkzTCvVsqq4hLQtDQpgjfxlULmxB85Jh1yBhvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1alCqjzYT+4gaej5we6ie32IU+64S6nCla/rs72quyOeCVmsHnEDRk82hjHtt5FX
	 gsBuTYq73QG8ikUc6ogJracnZgWTo7x6clBEV9B/B7xz5s6epyPH8HBAjaU7j1ocY7
	 pfirYpTgeo8nrGIsGssHZx7ltmJiw+D7TQtPfIR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/91] arm64: dts: imx8mp: Correct thermal sensor index
Date: Tue, 30 Sep 2025 16:47:26 +0200
Message-ID: <20250930143822.271256124@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit a50342f976d25aace73ff551845ce89406f48f35 ]

The TMU has two temperature measurement sites located on the chip. The
probe 0 is located inside of the ANAMIX, while the probe 1 is located near
the ARM core. This has been confirmed by checking with HW design team and
checking RTL code.

So correct the {cpu,soc}-thermal sensor index.

Fixes: 30cdd62dce6b ("arm64: dts: imx8mp: Add thermal zones support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 69b213ed7a594..7f7bd8477efde 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -228,7 +228,7 @@
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 0>;
+			thermal-sensors = <&tmu 1>;
 			trips {
 				cpu_alert0: trip0 {
 					temperature = <85000>;
@@ -258,7 +258,7 @@
 		soc-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 1>;
+			thermal-sensors = <&tmu 0>;
 			trips {
 				soc_alert0: trip0 {
 					temperature = <85000>;
-- 
2.51.0



