Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314B3304BC2;
	Wed,  3 Dec 2025 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776216; cv=none; b=khRqpvDNdFUu5P5bit/8vKl99rMjE5j9LDNFhqxDQxA6HkF4X0EaObU1P9E9Hc7xRPi/TZjRrNMVGCeqrx9fjxUI0RIsKDCqBiQcQw9+BxH2MyCJnYrFts3UTAJQpK3t1QO0t/Q2rBIkujja4HcgCYGs+WPQVw7I31eUeRioVpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776216; c=relaxed/simple;
	bh=8G8GIbq+2Eg8clqYlkRM9rRXiAx62DhgsOIpn6kNIAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLs7zThwGl5W07zd+MQOO/i8gqIj0kyA1MbNTF+adM/4wI8jJveT3uDFD/P8aCte2nZvSQI8yhAyqnMP+aohOhMxi9wMNPL+0oXNNwGldzW32M0CYq2ZdmVUPiN28bK71FqVCHZFhyvD9P3lXlICHwERy2nvPj0vFf7BfSQWm4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+iuTCsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+iuTCsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A01C4CEF5;
	Wed,  3 Dec 2025 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776216;
	bh=8G8GIbq+2Eg8clqYlkRM9rRXiAx62DhgsOIpn6kNIAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+iuTCsTskoPHsq6Yc3rwB/1CeiiBR5WfUVPsOPEUl12hacsbSRophB3Lj6NWz+JO
	 dflbTK+GpY4/ugAfNFWQ97yn5vqidqGZsMSInCsZp6lAhNQ5dNf9xU1qzEkLaGWtEc
	 6mkHTjJ6m8u7McTI4hcNP5nKBOerboGfazLe8Ekk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/300] mips: lantiq: xway: sysctrl: rename stp clock
Date: Wed,  3 Dec 2025 16:25:02 +0100
Message-ID: <20251203152404.254563590@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit b0d04fe6a633ada2c7bc1b5ddd011cbd85961868 ]

Bindig requires a node name matching ‘^gpio@[0-9a-f]+$’. This patch
changes the clock name from “stp” to “gpio”.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/sysctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index 084f6caba5f23..96a62b42e2971 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -463,7 +463,7 @@ void __init ltq_soc_init(void)
 	/* add our generic xway clocks */
 	clkdev_add_pmu("10000000.fpi", NULL, 0, 0, PMU_FPI);
 	clkdev_add_pmu("1e100a00.gptu", NULL, 1, 0, PMU_GPT);
-	clkdev_add_pmu("1e100bb0.stp", NULL, 1, 0, PMU_STP);
+	clkdev_add_pmu("1e100bb0.gpio", NULL, 1, 0, PMU_STP);
 	clkdev_add_pmu("1e100c00.serial", NULL, 0, 0, PMU_ASC1);
 	clkdev_add_pmu("1e104100.dma", NULL, 1, 0, PMU_DMA);
 	clkdev_add_pmu("1e100800.spi", NULL, 1, 0, PMU_SPI);
-- 
2.51.0



