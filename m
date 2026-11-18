Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017074;
	b=2IQ6FHMJBU88CSFHdXTpD3+yGjFNIhaJWe5Ose4lKvxj5OenTlOm7kNwh2Jt7aIxGT7i
	 oi185eQd5HSpG42fu04N7fLeP1TKP7UrWC4WP/vEsEObuqFhvY7+pPGk10TAH7kFMdomh
	 nq3XBk7UG0sVxtePlvFZA4bqXiqZ/Xsb55AExFhIh3I3waqwnUxxdHwU8ju430HlyatBB
	 efORFQaxXwlKb/0cUcaxJMUC58kM9etrDSBx1WQeIYGy9W8bHrsDzjcEiyJnrUYSvHbFY
	 AxffDrhaoDZQYyfkgDz26+daczYH9rT4rvlKs5Qw8Q7n1fU1qg3mNQDi8klR0tgFBPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/j1cJR7E6A/caM23ZmD3ggp6F4Xjvf1s55IcmV/3KHU=;
	b=KgbLPBME7FDzlcMx3vOr2QJebttjCKKvdE3dVZGEffcV/pFtWBYvxXksZunnZwhEMirK
	 xd+o9Unchk4eNu1Z/X5TDRaRO7JdkrPRUTBmdIEceDyvpJcfYu+ZO2wHRGESgpZoTMxY3
	 uPOpgVia/+zpnUccwSyaaECpsbmh/pjIzMvuu2yQb/tFn3NBu4CfH7+8/15Lf8INYRNyW
	 SxVCGK07vfjEtqo8thgqoscenB2b3GW7gBUJx4Y1n9GO+gLYZPjxrBPclxWANrM96ylfI
	 dTPiOcffWsAiAgZvZPrBvLCATqVAegmM9wOCU20COpWDGI/pCOpqpsE6HqIzFsLiqvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaTPGcPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C936D606A32A;
	Wed, 18 Nov 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaTPGcPu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F8A1F000CA;
	Wed, 18 Nov 2026 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017074;
	bh=/j1cJR7E6A/caM23ZmD3ggp6F4Xjvf1s55IcmV/3KHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaTPGcPuMxrVfHNKHwwTFi0EDLP+qXzjieCMt2R2E0UWbwUAu8gpKglwAUXLPUmK4
	 2GX5UDlvF3M3AVbFYvrmeicdeZYiDeFHL0OWeBGgpnu5w2R/9a0liJVRTklJjHPvu9
	 /Z9xJY+h2tSji75oZaNxhhylZ82KS7LUL4FKFcgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0755/2651] clk: qcom: Fix CLK_GLYMUR_GPUCC default and CLK_GLYMUR_EVACC duplicate
Date: Wed, 18 Nov 2026 15:33:15 +0100
Message-ID: <20261118150315.060820611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>

[ Upstream commit 748f9caa7ab158598295f6c195e8a2bcbbace841 ]

Commit 6b150572bb76 ("clk: qcom: Add defaults for desired arm64 drivers")
missed adding a defaults for CLK_GLYMUR_GPUCC and created a duplicated
for CLK_GLYMUR_EVACC instead. The original patch series did't have this
problem and was introduced during the merge. Fix this by removing the
duplicate and adding a default for CLK_GLYMUR_GPUCC.

Fixes: 6b150572bb76 ("clk: qcom: Add defaults for desired arm64 drivers")
Signed-off-by: Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>
Reviewed-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260821045214.2623299-2-sivansh.gupta@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index d1fc9bf87126b..283cca5aca0e9 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -73,7 +73,6 @@ config CLK_GLYMUR_DISPCC
 config CLK_GLYMUR_EVACC
 	tristate "Glymur EVA Clock Controller"
 	depends on ARM64 || COMPILE_TEST
-	default m if ARCH_QCOM
 	select CLK_GLYMUR_GCC
 	default m if ARCH_QCOM
 	help
@@ -96,6 +95,7 @@ config CLK_GLYMUR_GPUCC
 	tristate "Glymur Graphics Clock Controller"
 	depends on ARM64 || COMPILE_TEST
 	select CLK_GLYMUR_GCC
+	default m if ARCH_QCOM
 	help
 	  Support for the graphics clock controller on Glymur devices.
 	  Say Y if you want to support graphics controller devices and
-- 
2.53.0



