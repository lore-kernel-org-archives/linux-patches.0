Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0869527456;
	Tue, 23 Jan 2024 00:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970940; cv=none; b=XMf+T0Ni8T2zntQrpAAhYf9cm2FwOL6sZNJaiNi8RaMhvt2m8Ilj7wJ6NoCY9OsH9FijkMcl2vwPK43oO1e+D2laJm8G7VbP7HJ4XdYugkXrjLCFYhA3YCLkDdt3Ez8LfxkcjUDUoxa2Q70Jg4INCELeWcp22dllBqFMyHqOAIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970940; c=relaxed/simple;
	bh=kDm11rET1fT4c/QP1nHEm3oBT+dqRyEwwj27dmxbuM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g94foDsoPeiaS82BK0gXhL9RmJePx/Pfg9471BZSk93Vle1zQAcIFjcHKSxP2LdyO8SlLHLmuCRREMP8auT9zcv6g1UQBLYWofg8dBzas9bBsh/IThkyNVq6cr8S10bSIIrMF9FufzASJW5r0mRIIyDgyfnfNX2oOqNA3EGmQ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjBYLv1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjBYLv1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C459C433C7;
	Tue, 23 Jan 2024 00:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970939;
	bh=kDm11rET1fT4c/QP1nHEm3oBT+dqRyEwwj27dmxbuM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjBYLv1x/0Uy00APLh0NcnZKlIP2mJwmpbi4bZnsg6bqA+WE4GLZfnQdtyqnVsICR
	 OaeLsY04c84ZA3qaXfzv4NFx4FJXYhKZPG39ztJc/wc3nYQ8CCzeqUiXasqNTzI+k1
	 SGr05LvHKg+pAGp6JPOJUPKawJzZxx4EcljdnSYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/417] ARM: dts: stm32: dont mix SCMI and non-SCMI board compatibles
Date: Mon, 22 Jan 2024 15:54:47 -0800
Message-ID: <20240122235755.908402624@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
 arch/arm/boot/dts/stm32mp157a-dk1-scmi.dts | 2 +-
 arch/arm/boot/dts/stm32mp157c-dk2-scmi.dts | 2 +-
 arch/arm/boot/dts/stm32mp157c-ed1-scmi.dts | 2 +-
 arch/arm/boot/dts/stm32mp157c-ev1-scmi.dts | 3 +--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157a-dk1-scmi.dts b/arch/arm/boot/dts/stm32mp157a-dk1-scmi.dts
index e539cc80bef8..942a6ca38d97 100644
--- a/arch/arm/boot/dts/stm32mp157a-dk1-scmi.dts
+++ b/arch/arm/boot/dts/stm32mp157a-dk1-scmi.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157A-DK1 SCMI Discovery Board";
-	compatible = "st,stm32mp157a-dk1-scmi", "st,stm32mp157a-dk1", "st,stm32mp157";
+	compatible = "st,stm32mp157a-dk1-scmi", "st,stm32mp157";
 
 	reserved-memory {
 		optee@de000000 {
diff --git a/arch/arm/boot/dts/stm32mp157c-dk2-scmi.dts b/arch/arm/boot/dts/stm32mp157c-dk2-scmi.dts
index 97e4f94b0a24..99c4ff1f5c21 100644
--- a/arch/arm/boot/dts/stm32mp157c-dk2-scmi.dts
+++ b/arch/arm/boot/dts/stm32mp157c-dk2-scmi.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157C-DK2 SCMI Discovery Board";
-	compatible = "st,stm32mp157c-dk2-scmi", "st,stm32mp157c-dk2", "st,stm32mp157";
+	compatible = "st,stm32mp157c-dk2-scmi", "st,stm32mp157";
 
 	reserved-memory {
 		optee@de000000 {
diff --git a/arch/arm/boot/dts/stm32mp157c-ed1-scmi.dts b/arch/arm/boot/dts/stm32mp157c-ed1-scmi.dts
index 9cf0a44d2f47..21010458b36f 100644
--- a/arch/arm/boot/dts/stm32mp157c-ed1-scmi.dts
+++ b/arch/arm/boot/dts/stm32mp157c-ed1-scmi.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "STMicroelectronics STM32MP157C-ED1 SCMI eval daughter";
-	compatible = "st,stm32mp157c-ed1-scmi", "st,stm32mp157c-ed1", "st,stm32mp157";
+	compatible = "st,stm32mp157c-ed1-scmi", "st,stm32mp157";
 
 	reserved-memory {
 		optee@fe000000 {
diff --git a/arch/arm/boot/dts/stm32mp157c-ev1-scmi.dts b/arch/arm/boot/dts/stm32mp157c-ev1-scmi.dts
index 3b9dd6f4ccc9..d37637149919 100644
--- a/arch/arm/boot/dts/stm32mp157c-ev1-scmi.dts
+++ b/arch/arm/boot/dts/stm32mp157c-ev1-scmi.dts
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



