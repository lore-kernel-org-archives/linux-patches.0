Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150A26A1BD;
	Tue, 25 Mar 2025 12:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906170; cv=none; b=gjb/hjU0BpcXXpwukNzsxTFzRa1fSbBcdmxiU84oq4gbKjtjcDY6YWGyRAG2CJskBab7r9oALCF7nbbRlsZ3q87Rmh6qblhku3Z34bG18jU4tMim5f5UjDKrCxOD8/91vLzrY3Y5Axs8vvAtSVtgxWvH/RYBc6I39e1eDgRjlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906170; c=relaxed/simple;
	bh=poUxc/VHItdPEWuVfB4W1Or3rfdWdq7kWPoSVRr0SbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOiDvKQqMszzDXSj+3Q4iGAnOeZnH6wxc6EPPqIf2D4RlrqrqtWu1FeVxnN0Eb44yAnTbRvEyU4RdkEWRcMxemMeQkPl2NHipYgnTIlKmRIQdEZD5lgUKv5GQYgSsYLJw698kBzZwgW629gAWTZ+07XYW4fKrlt6BbSmvrwa4ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0ewMFPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0ewMFPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D0AC4CEE9;
	Tue, 25 Mar 2025 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906170;
	bh=poUxc/VHItdPEWuVfB4W1Or3rfdWdq7kWPoSVRr0SbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0ewMFPLia/KLa+ZPvh+CxI9Uz/bIOe7KjX9P/DQJisoKiy2qxWLnC1cQGZHALh91
	 u4ncpEZU7cTOJtcFqvIZ483qgDQpHv40LEfHmrBlWt2qEzkDYa3ZpMZMN1cua/yaNV
	 AyOvJHiK8g+3amqUF+N4t3/8vau2qIdVUMdJQWx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	E Shattow <e@freeshell.de>,
	Hal Feng <hal.feng@starfivetech.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.6 35/77] riscv: dts: starfive: Fix a typo in StarFive JH7110 pin function definitions
Date: Tue, 25 Mar 2025 08:22:30 -0400
Message-ID: <20250325122145.272993153@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: E Shattow <e@freeshell.de>

commit 1b133129ad6b28186214259af3bd5fc651a85509 upstream.

Fix a typo in StarFive JH7110 pin function definitions for GPOUT_SYS_SDIO1_DATA4

Fixes: e22f09e598d12 ("riscv: dts: starfive: Add StarFive JH7110 pin function definitions")
Signed-off-by: E Shattow <e@freeshell.de>
Acked-by: Hal Feng <hal.feng@starfivetech.com>
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7110-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-pinfunc.h b/arch/riscv/boot/dts/starfive/jh7110-pinfunc.h
index 256de17f5261..ae49c908e7fb 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-pinfunc.h
+++ b/arch/riscv/boot/dts/starfive/jh7110-pinfunc.h
@@ -89,7 +89,7 @@
 #define GPOUT_SYS_SDIO1_DATA1			59
 #define GPOUT_SYS_SDIO1_DATA2			60
 #define GPOUT_SYS_SDIO1_DATA3			61
-#define GPOUT_SYS_SDIO1_DATA4			63
+#define GPOUT_SYS_SDIO1_DATA4			62
 #define GPOUT_SYS_SDIO1_DATA5			63
 #define GPOUT_SYS_SDIO1_DATA6			64
 #define GPOUT_SYS_SDIO1_DATA7			65
-- 
2.49.0



