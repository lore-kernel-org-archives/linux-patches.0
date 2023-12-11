Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6432F51C38;
	Mon, 11 Dec 2023 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYhRCYWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1E5C433C8;
	Mon, 11 Dec 2023 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320787;
	bh=RmeJpaPvcu6qokkk2kq1AyLYZmcMjVqnxM04gopnJhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYhRCYWK32sk8Re1D1i6wRHegHrMNneqDcM1bodiQ2/Zwc1PqlBNb4kRKru7Ed370
	 hxZ8URs97TR6CdB/Hky4ypKY6xZGEUGxbYigv8q5zhxjupRTy6CwpktUQuMw87JOOv
	 lWr8wPwm0XGvP/LXZwaR83oxTGgzzju2kV1hbmX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Nam Cao <namcao@linutronix.de>
Subject: [PATCH 6.1 190/194] riscv: Kconfig: Add select ARM_AMBA to SOC_STARFIVE
Date: Mon, 11 Dec 2023 19:23:00 +0100
Message-ID: <20231211182045.183518920@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

commit 78a03b9f8e6b317f7c65738a3fc60e1e85106a64 upstream.

Selects ARM_AMBA platform support for StarFive SoCs required by spi and
crypto dma engine.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[ resolve conflict due to removal of "select SIFIVE_PLIC" ]
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig.socs |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -23,6 +23,7 @@ config SOC_STARFIVE
 	select PINCTRL
 	select RESET_CONTROLLER
 	select SIFIVE_PLIC
+	select ARM_AMBA
 	help
 	  This enables support for StarFive SoC platform hardware.
 


