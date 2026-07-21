Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EEF46D0B8;
	Tue, 21 Jul 2026 17:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656362; cv=none; b=ksozg4CXDXOo3S34IAzDzALaQ6vRiQRn2iZyObDqxJ5dW30TRMJKAM4wEj5T0wTRBV+DnNshNC7f2csDmBAzBD+d9gixCFZbZzvwT37xLPBX85eP9pmf+mLxOBwBofcJ33IB9PhuG4kgL8rz9MPKE3DWlZM0m4qbu7MQs+LGw0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656362; c=relaxed/simple;
	bh=P52DVYgNk3JOcZy8VMnWfcCAUT30j5MZJdyjH6/BHj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V08CMO08VYgaFv6EScRCP8AOaqTVL50htH2gEtnmZsiKN3cIKylGy8hLzyf2PUue2oqJNXGP57Vgl/T565nLj5T0TqnBS8XMqlppTUXlJDtA29hWqBTKunIfQl+kbyks8V5362LQo7E6z+dkqEX/Vv2PUQa4IZRnWSe2Ucch5Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZnfmCZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZnfmCZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19CC1F00A3F;
	Tue, 21 Jul 2026 17:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656360;
	bh=hOxjT5DC3A9dl5AIL8RU4sF3qX97Vd3ltkqew8c/WFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZnfmCZzDMHIdosOOx7nZSxz20SPeFQF3uRN3NC6RySjZL+CxThhaU2cqhROnykdB
	 SU7epP8tRMySxNewvjyagmCVA3rgP5wAJJFdTGDNXL3aoDKbCkrTPq1P8Y8xeTePOA
	 USXwqFB77C2TXWigPYjjWkvTUqpyb8cCWoLeF2Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0357/1611] arm64: dts: lx2162a-clearfog: use rev2 SoC dtsi
Date: Tue, 21 Jul 2026 17:07:53 +0200
Message-ID: <20260721152523.172828871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 13a37b30e464503515625ba891018aec0264c7d2 ]

LX2160A and LX2162A are different packages of the same silicon. While
LX2160A had two revisions, LX2162A was released later based on LX2160A
revision 2.

Commit a8fe6c8dfc40 ("arm64: dts: fsl-lx2160a: add rev2 support") has added
a new soc dtsi for revision 2.

Update LX2162A Clearfog description to use revision 2 dtsi.

Fixes: 5093b190f9ce ("arm64: dts: freescale: Add support for LX2162 SoM & Clearfog Board") # no-stable
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts b/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
index 8920326a067351..5563c9c47163bc 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2162a-clearfog.dts
@@ -6,7 +6,7 @@
 
 /dts-v1/;
 
-#include "fsl-lx2160a.dtsi"
+#include "fsl-lx2160a-rev2.dtsi"
 #include "fsl-lx2162a-sr-som.dtsi"
 
 / {
-- 
2.53.0



