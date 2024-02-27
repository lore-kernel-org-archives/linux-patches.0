Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2BF13B7A2;
	Tue, 27 Feb 2024 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041504; cv=none; b=hgQopjcM3fpW++aovBtwvsGCdet2o+rK4n1wJaXZFsBUv3N5WGbB+ySDpIAGKe+SdPRO0AQtvOD7Mb+aWRmLm5BQIMzPGAL/YvE/I4Di5mvvh6YuTWliD4vWTMU0gz4YeNAY2JSEAOtb43vrY69wYdtgpDQU9XbJb7PG8LtUIO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041504; c=relaxed/simple;
	bh=roFazU2GadqBttgLJp4chUpCCTLPTHfOIwWiht/1y4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ym+ns25OUldNXWLYPaZB0aAV98oCzqafmwADaXi4IFIdELszki3gnxpIoTmKdT/001NlZwh7qZY5cVybKqVuSgH8ykA5Oj5LUMh9JmAj1oM7I/agUcl978Z4f2rVNejFb1RwBXo/bQHNav1DTLSVVkZx30wpLcOJrDSVb6fUMXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxvAjJb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxvAjJb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE90C433C7;
	Tue, 27 Feb 2024 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041504;
	bh=roFazU2GadqBttgLJp4chUpCCTLPTHfOIwWiht/1y4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxvAjJb+4xrzlL20nBVyvpTtRyCGMgDG0Nlf2cZqALyHgr+DNibSJxzvdtFtQ7KiG
	 vIJy5K6+/v0/m2F+HbPbJ1xnI8OqYxgpZ/1xTJ3QoDa6VePDLqJ5hUqC/PXwjHM/8+
	 SbI2jB//8s69Jq4Hj8DMyRJSNVulBwEY7Vh7PPUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/52] pmdomain: renesas: r8a77980-sysc: CR7 must be always on
Date: Tue, 27 Feb 2024 14:26:13 +0100
Message-ID: <20240227131549.391116066@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f0e4a1356466ec1858ae8e5c70bea2ce5e55008b ]

The power domain containing the Cortex-R7 CPU core on the R-Car V3H SoC
must always be in power-on state, unlike on other SoCs in the R-Car Gen3
family.  See Table 9.4 "Power domains" in the R-Car Series, 3rd
Generation Hardware User’s Manual Rev.1.00 and later.

Fix this by marking the domain as a CPU domain without control
registers, so the driver will not touch it.

Fixes: 41d6d8bd8ae9 ("soc: renesas: rcar-sysc: add R8A77980 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/fdad9a86132d53ecddf72b734dac406915c4edc0.1705076735.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a77980-sysc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/renesas/r8a77980-sysc.c b/drivers/soc/renesas/r8a77980-sysc.c
index a8dbe55e8ba82..3d1ea245681b0 100644
--- a/drivers/soc/renesas/r8a77980-sysc.c
+++ b/drivers/soc/renesas/r8a77980-sysc.c
@@ -25,7 +25,8 @@ static const struct rcar_sysc_area r8a77980_areas[] __initconst = {
 	  PD_CPU_NOCR },
 	{ "ca53-cpu3",	0x200, 3, R8A77980_PD_CA53_CPU3, R8A77980_PD_CA53_SCU,
 	  PD_CPU_NOCR },
-	{ "cr7",	0x240, 0, R8A77980_PD_CR7,	R8A77980_PD_ALWAYS_ON },
+	{ "cr7",	0x240, 0, R8A77980_PD_CR7,	R8A77980_PD_ALWAYS_ON,
+	  PD_CPU_NOCR },
 	{ "a3ir",	0x180, 0, R8A77980_PD_A3IR,	R8A77980_PD_ALWAYS_ON },
 	{ "a2ir0",	0x400, 0, R8A77980_PD_A2IR0,	R8A77980_PD_A3IR },
 	{ "a2ir1",	0x400, 1, R8A77980_PD_A2IR1,	R8A77980_PD_A3IR },
-- 
2.43.0



