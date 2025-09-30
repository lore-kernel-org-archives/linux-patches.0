Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C840302163;
	Tue, 30 Sep 2025 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244319; cv=none; b=DVZ5Et/gy5dGcUUrNUHzvYllRO7C2I+6telQ3EdU2GuKU/2iXnjnVEtZAa1+Rc6DXTCWdGNg7umUH/T+9/6PR1i7X+eEw68zH+Gem3LJRD0S8MKGXafALDifCTzGsPmKfy8c2fzAqa7aQ5YDXP1KImRCcZhadYLRwmIJIsHroSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244319; c=relaxed/simple;
	bh=EhCNkDWmzIh5c75FiXueiS2d+j3sRXK6ccGYstEy41Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh0EOSfq7xDsJcFAiiWhDeqVlvfnrUxHxdiYkwMWTlsZt0s2fTRrqxiLgZD1HuwKkp5BYxdUmGYqGOCplOamzRJvWkfjruSnkjFqsfQUw2h/J9io1LDseXP2GozwmdULRt8hcOmO4JSkbuQq+4TMmT74TTjN+9fGTYypnPlJYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ef4ppuqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ef4ppuqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF908C113D0;
	Tue, 30 Sep 2025 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244319;
	bh=EhCNkDWmzIh5c75FiXueiS2d+j3sRXK6ccGYstEy41Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ef4ppuqmZNxG5cX06mkdxCJIh7iricZ+LaeVhcfGUbTaPXCE0weDugPQxzQ5d1tel
	 +Q/8ZtzUs21FwgEciNyXJ3eZ0S5nDTGyavaLkUkr3P0lVeimGaYMjuD8qNJpTGpnfs
	 2AZ+xt7wr8+Un4VEA8Q9hsdFa0xxHP99LAFIf2fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/122] arm64: dts: imx8mp: Correct thermal sensor index
Date: Tue, 30 Sep 2025 16:47:05 +0200
Message-ID: <20250930143826.841348791@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit a50342f976d25aace73ff551845ce89406f48f35 ]

The TMU has two temperature measurement sites located on the chip. The
probe 0 is located inside of the ANAMIX, while the probe 1 is located near
the ARM core. This has been confirmed by checking with HW design team and
checking RTL code.

So correct the {cpu,soc}-thermal sensor index.

Fixes: 30cdd62dce6b ("arm64: dts: imx8mp: Add thermal zones support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 0186b3992b95f..8b02ead72a88c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -142,7 +142,7 @@
 		cpu-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 0>;
+			thermal-sensors = <&tmu 1>;
 			trips {
 				cpu_alert0: trip0 {
 					temperature = <85000>;
@@ -172,7 +172,7 @@
 		soc-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <2000>;
-			thermal-sensors = <&tmu 1>;
+			thermal-sensors = <&tmu 0>;
 			trips {
 				soc_alert0: trip0 {
 					temperature = <85000>;
-- 
2.51.0



