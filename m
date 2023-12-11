Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D682351C53;
	Mon, 11 Dec 2023 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5e1Wyej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D266C433C8;
	Mon, 11 Dec 2023 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319828;
	bh=WLC6oy7pu499G9BR4ZMFSMb5S+vkSxu9uRl+Uxc5wcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5e1WyejOB0LUCdYBAc/g4XZC+/60hPAb4xWnHuNxzxXK5MHzl0CUST3Thcuee/HV
	 hqg6u2JPiB2KTUzJNO9bC63J/nRG0HnIomdFys8mqSiCt6YqHSdEBSu2rB/GhY34Pj
	 ciGSBr6j7mi9iK6TqfjwjxsxbbkpdQQ2QHc0NMJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Nam Cao <namcao@linutronix.de>
Subject: [PATCH 6.6 241/244] riscv: Kconfig: Add select ARM_AMBA to SOC_STARFIVE
Date: Mon, 11 Dec 2023 19:22:14 +0100
Message-ID: <20231211182056.821816763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

commit 78a03b9f8e6b317f7c65738a3fc60e1e85106a64 upstream.

Selects ARM_AMBA platform support for StarFive SoCs required by spi and
crypto dma engine.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Cc: Nam Cao <namcao@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig.socs |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -29,6 +29,7 @@ config SOC_STARFIVE
 	bool "StarFive SoCs"
 	select PINCTRL
 	select RESET_CONTROLLER
+	select ARM_AMBA
 	help
 	  This enables support for StarFive SoC platform hardware.
 


