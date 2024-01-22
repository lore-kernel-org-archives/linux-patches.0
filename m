Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2788D61673;
	Tue, 23 Jan 2024 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974949; cv=none; b=i7ETXvvb1uaMvPDUxEdJybdFtd/eJZxr0V3W3t3xNO+IGYAZUo0R9x4ebxEoo4PdoFVJaaUZaoFZqddW/pjCG+OiRwyov7dP3plAoQ5EdQSZyfkPA9TWQ+MlCOjciIh9WGBFhFYLU88AJ/4hVTe4fN82BQYh4NNwGfnecOjuXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974949; c=relaxed/simple;
	bh=zAgzVDtNQACi70vH/sA+fi7pZFgXpbI+g2653CjfWTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/2kINUhlKfmtPNZeaxNydHrY/KpKE3gC8Ch/QiDo6+mu5aYD+FZnaaUFJPI4FzOGS8h0c81MSMBMCcjgO/ybXUsCqHpjivb7gYl5iOUEjPzFv7cjNDDuT2VbbYmdKBNb3rAi1KNOpxkuW1fmlInvgKy5vaWUe3I8obKPQiFfmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbpnBQrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbpnBQrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE7FC433F1;
	Tue, 23 Jan 2024 01:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974949;
	bh=zAgzVDtNQACi70vH/sA+fi7pZFgXpbI+g2653CjfWTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbpnBQrkMJzcJyfRNElbq5uoO3R/qDY05OuntW3EKqTdM8OO1BTJCjAEkro5yubYW
	 T4t6+zn/aP5y1Jg72s2IpRe8/Pddas+Ibn3xxRbh1AFOWOH0mkUVFB4Slntg50O2SI
	 PhO2RREAZzP2a5HJutsRNPfvfYnqTsTT06VxXtM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/583] ARM: dts: stm32: dont mix SCMI and non-SCMI board compatibles
Date: Mon, 22 Jan 2024 15:53:35 -0800
Message-ID: <20240122235817.059440068@linuxfoundation.org>
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit bfc3c6743de0ecb169026c36cbdbc0d12d22a528 ]

The binding erroneously decreed that the SCMI variants of the ST
evaluation kits are compatible with the non-SCMI variants.

This is not correct, as a kernel or bootloader compatible with the non-SCMI
variant is not necessarily able to function, when direct access
to resources is replaced by having to talk SCMI to the secure monitor.

The binding has been adjusted to reflect thus, so synchronize the device
trees now.

Fixes: 5b7e58313a77 ("ARM: dts: stm32: Add SCMI version of STM32 boards (DK1/DK2/ED1/EV1)")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp157a-dk1-scmi.dts | 2 +-
 arch/arm/boot/dts/st/stm32mp157c-dk2-scmi.dts | 2 +-
 arch/arm/boot/dts/st/stm32mp157c-ed1-scmi.dts | 2 +-
 arch/arm/boot/dts/st/stm32mp157c-ev1-scmi.dts | 3 +--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp157a-dk1-scmi.dts b/arch/arm/boot/dts/st/stm32mp157a-dk1-scmi.dts
index afcd6285890c..c27963898b5e 100644
--- a/arch/arm/boot/dts/st/stm32mp157a-dk1-scmi.dts
+++ b/arch/arm/boot/dts/st/stm32mp157a-dk1-scmi.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157A-DK1 SCMI Discovery Board";
-	compatible = "st,stm32mp157a-dk1-scmi", "st,stm32mp157a-dk1", "st,stm32mp157";
+	compatible = "st,stm32mp157a-dk1-scmi", "st,stm32mp157";
 
 	reserved-memory {
 		optee@de000000 {
diff --git a/arch/arm/boot/dts/st/stm32mp157c-dk2-scmi.dts b/arch/arm/boot/dts/st/stm32mp157c-dk2-scmi.dts
index 39358d902000..622618943134 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-dk2-scmi.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-dk2-scmi.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157C-DK2 SCMI Discovery Board";
-	compatible = "st,stm32mp157c-dk2-scmi", "st,stm32mp157c-dk2", "st,stm32mp157";
+	compatible = "st,stm32mp157c-dk2-scmi", "st,stm32mp157";
 
 	reserved-memory {
 		optee@de000000 {
diff --git a/arch/arm/boot/dts/st/stm32mp157c-ed1-scmi.dts b/arch/arm/boot/dts/st/stm32mp157c-ed1-scmi.dts
index 07ea765a4553..c7c4d7e89d61 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-ed1-scmi.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-ed1-scmi.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157C-ED1 SCMI eval daughter";
-	compatible = "st,stm32mp157c-ed1-scmi", "st,stm32mp157c-ed1", "st,stm32mp157";
+	compatible = "st,stm32mp157c-ed1-scmi", "st,stm32mp157";
 
 	reserved-memory {
 		optee@fe000000 {
diff --git a/arch/arm/boot/dts/st/stm32mp157c-ev1-scmi.dts b/arch/arm/boot/dts/st/stm32mp157c-ev1-scmi.dts
index 813086ec2489..2ab77e64f1bb 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-ev1-scmi.dts
+++ b/arch/arm/boot/dts/st/stm32mp157c-ev1-scmi.dts
@@ -11,8 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157C-EV1 SCMI eval daughter on eval mother";
-	compatible = "st,stm32mp157c-ev1-scmi", "st,stm32mp157c-ev1", "st,stm32mp157c-ed1",
-		     "st,stm32mp157";
+	compatible = "st,stm32mp157c-ev1-scmi", "st,stm32mp157c-ed1", "st,stm32mp157";
 
 	reserved-memory {
 		optee@fe000000 {
-- 
2.43.0



