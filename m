Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B08247287;
	Tue, 12 Aug 2025 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024684; cv=none; b=a2Ltaocobng5H4yEpx3UWqcsz1/oc4GhCCbrQKOT0/eWjKcpNVOA2j6Vspe0xh8MWnjQeLksl7BHf1Rwvf2dUVeA2iFxWEJaKHlMvrO/Ut9QcEn3CoZC0F/0ZT00b7/wJSDPQ1HVNbm2eXxVVPsVR6T0AecaAFq3kgC5JctBp5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024684; c=relaxed/simple;
	bh=vlCm6ZJHRSrN5AJ6NAPpx+Y2Ky41+pHPRDJqFZGSCf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+65WlgxOWbvREI9gVMb93nGhKP4YiLqD3wQ+5R6VeIrOkyddo1GMeFQdziWYbtUEJQZJ9g7XxDXP/6uCN0R2vg6FBsFHeHRqaSrx+9V0ZIiUEkHyT+DrE0EgKVft/UfEqcKFCz64GewZYGEzzZOonDsrsWw/kwodS6F3SIRc6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+earmzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+earmzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA1CC4CEF0;
	Tue, 12 Aug 2025 18:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024684;
	bh=vlCm6ZJHRSrN5AJ6NAPpx+Y2Ky41+pHPRDJqFZGSCf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+earmzqXV6HDAdKHWwHN6JCiIXrfCG0VA2VI4ztD1ukLQdoG63HteMyGPiv04Ztj
	 QNibV/EUuNGTvSiAsZFr6uPf+GXu32/JNTkA1TqxSrYklEztJia9qGLAHAlw67YoeT
	 QqY5v46QQt/veYQI+Fhi7/p+liUrJ3eIX4FA+ZDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shree Ramamoorthy <s-ramamoorthy@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 419/627] mfd: tps65219: Update TPS65214 MFD cells GPIO compatible string
Date: Tue, 12 Aug 2025 19:31:54 +0200
Message-ID: <20250812173435.219637819@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shree Ramamoorthy <s-ramamoorthy@ti.com>

[ Upstream commit 6f27d26e363a41fc651be852094823ce47a43243 ]

This patch reflects the change made to move TPS65215 from 1 GPO and 1 GPIO
to 2 GPOs and 1 GPIO. TPS65215 and TPS65219 both have 2 GPOs and 1 GPIO.
TPS65214 has 1 GPO and 1 GPIO. TPS65215 will reuse the TPS65219 GPIO
compatible string.

TPS65214 TRM: https://www.ti.com/lit/pdf/slvud30
TPS65215 TRM: https://www.ti.com/lit/pdf/slvucw5/

Fixes: 7947219ab1a2 ("mfd: tps65219: Add support for TI TPS65214 PMIC")
Signed-off-by: Shree Ramamoorthy <s-ramamoorthy@ti.com>
Link: https://lore.kernel.org/r/20250527190455.169772-2-s-ramamoorthy@ti.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65219.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index fd390600fbf0..297511025dd4 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -190,7 +190,7 @@ static const struct resource tps65219_regulator_resources[] = {
 
 static const struct mfd_cell tps65214_cells[] = {
 	MFD_CELL_RES("tps65214-regulator", tps65214_regulator_resources),
-	MFD_CELL_NAME("tps65215-gpio"),
+	MFD_CELL_NAME("tps65214-gpio"),
 };
 
 static const struct mfd_cell tps65215_cells[] = {
-- 
2.39.5



