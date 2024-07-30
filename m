Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D3A1A76CB;
	Tue, 30 Jul 2024 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360522; cv=none; b=ZhRCESzY4dYjXhO8joxrpm01FQY8XBP4GZ+swMmWRUE6BxM+MP44eIhLOPPcZIfWU1yTCvcNgTYrbSQHW+gAsPIp2QRgRBKkQz6LR7535eVfh8Kl108yH8+q6r8Ow67AJAUosKanBKaZXCjNO05CugGDDA079Lg1WKeENEIvPlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360522; c=relaxed/simple;
	bh=1Q5oEZ8LUsyBCt+FAGxWH517DMQtTHY6TyItGN25xYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDm+IFw9LxI+ycawHWmj8MZIm26QW6oILDCPemtoullMRtDw+mcC1Kp3Rp17M8CZA9qa8jyQxtQh3a+/zx/oeVpSIMCgpo/GpcJTxQPacbyugEaSi55VBJumaGU7ZFh8Yz5Ob4DQIpTuS9pRzI8EegwyeqHM6FLNWmCsvIPp5ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRs1pu69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRs1pu69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0CAC32782;
	Tue, 30 Jul 2024 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360521;
	bh=1Q5oEZ8LUsyBCt+FAGxWH517DMQtTHY6TyItGN25xYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRs1pu69u3wVWk/OIduYUd8xnsDCoY9P34Jy2aLYf4l8yK9u6oQDWsWyukvPSs8YR
	 wfa9E9W5hBm0suCNOIzwVysW+5VxEdFhS7kyiwzYKXF3A7d9uWMPIZDy+W/x9vEkPW
	 fRNE4iEXSLERRouwFEkxFeW+hDtcW5DshxUIFfLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.10 723/809] MIPS: ip30: ip30-console: Add missing include
Date: Tue, 30 Jul 2024 17:49:59 +0200
Message-ID: <20240730151753.493776129@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 8de4ed75bd14ed197119ac509c6902a8561e0c1c upstream.

Include linux/processor.h to fix build error:

arch/mips/sgi-ip30/ip30-console.c: In function ‘prom_putchar’:
arch/mips/sgi-ip30/ip30-console.c:21:17: error: implicit declaration of function ‘cpu_relax’ [-Werror=implicit-function-declaration]
   21 |                 cpu_relax();

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip30/ip30-console.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/sgi-ip30/ip30-console.c
+++ b/arch/mips/sgi-ip30/ip30-console.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/io.h>
+#include <linux/processor.h>
 
 #include <asm/sn/ioc3.h>
 #include <asm/setup.h>


