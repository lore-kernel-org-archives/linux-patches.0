Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4332326D44;
	Tue, 21 Jul 2026 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655690; cv=none; b=NaTOCPpxP5p5nMOA21q2dl/75wenUQY1OJp1DdpU+SOhi20Ntv2TI1cKxwpS73wXYO/ofwZfDO5Eb4JtJiuWI+2AVl/YRLLhMrb6xr338m/ZP0XbTP83WGH2fr2xjM+sldoRK4qrd2DYq0JtjfdDApYjSe0KUSt/nnyqfAchKto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655690; c=relaxed/simple;
	bh=ofxMryBcFpjnvKDE2XGOQ9bb4Kn6NWbJSeHmf5OTdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DG3q5N+xTy/U81yhxtYOwg5m0q5n6OeRIeRDCp3qmbUw/zVkKTTqfGmQvKWAThsq1bkv+EelhET0bJx21NHx8pBufXdySvPZaA/0bSrPnrQv/4LZTwILscaUJ7cJd7Fy+4zp8+2QsJJ2TkYNhXlvjP/uLx1CvfkWnjs4+IdvifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ8ecUw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ8ecUw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DA91F000E9;
	Tue, 21 Jul 2026 17:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655688;
	bh=kAzdO52Wq1ZHUy1xhh2aUUC5eS1rHEAPc0pWTC4+ldU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQ8ecUw8MgPHMPpD/jzZIsYxApjKquYeOmMPNf7QLo2C+pdX9wAj/oQF5S9UVoD81
	 ZzK4Ii0bUc+4DTIPr7QHYfUX379/l08FhI26BTT9CPNau0dy3B1ApM04TaRmlSilXp
	 XpibajIBB/StJjCmIJx0l3DmfIHTqYdqmG+dd48A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0105/1611] dts: spacemit: set console baud rate on bpif3
Date: Tue, 21 Jul 2026 17:03:41 +0200
Message-ID: <20260721152517.209171838@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 24c12ca43b12c104389d9a159207d0b25779d0af ]

Because the default console's baud rate is not set, defconfig kernels do
not have any serial output on this platform. Set the baud rate to
115200, matching what is used by U-Boot etc on this platform.

Suggested-by: Vivian Wang <wangruikang@iscas.ac.cn>
Fixes: d60d57ab6b2a8 ("riscv: dts: spacemit: add Banana Pi BPI-F3 board device tree")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://lore.kernel.org/r/20260430-reword-overstep-3be08b7eab25@spud
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
index 2aaaff77831e16..a58192ba67b2c3 100644
--- a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
@@ -17,7 +17,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
-- 
2.53.0



