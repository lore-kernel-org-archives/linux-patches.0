Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07212EBEA;
	Tue, 25 Jun 2024 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308583; cv=none; b=YRcF38CMKji6Me8jI0zouFIOh2gl3DaMOwMYh6EgrjcLp9zpsJcaQ2at3u4c8AsvXJz41NW9mtS8VRhKkfyBAwEWM+fdx5P4ko12n1NQ6Yvf+jx9pTfnatOhbBZGoUd3LnOufzhf/0rxc4Dfh506zo49xTAlfArI7Izpd1o+2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308583; c=relaxed/simple;
	bh=79Kk8rma4sugEBPZkYT7xy+ZmQ4I4tD3ODF+U16sQBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ0tmZsnmwe1Qzcw3YiDuSIQ9eP6YBvK9q5zc8QIvm4HNVZtszqzzBoZY/8W5KvAll9hzxMge9olurgxNuGcRRIjRUQRwn+qtpdsTKatTAHNquZ9XaapXWF5sWyjlyf8YxOK9+QzAJ1fO8Z7DYQUCYoCaGKOoBTRdFwW2MmrRCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxIq9rrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxIq9rrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8965DC32781;
	Tue, 25 Jun 2024 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308582;
	bh=79Kk8rma4sugEBPZkYT7xy+ZmQ4I4tD3ODF+U16sQBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxIq9rrlWRu7LQJWAqMe1hJrN/kVSsfs3WtwZU6SJzEKxc5FkN5cLp1FR/+Xi036v
	 rO/in6qyvd5T2uok6ECHUV0GDQsHc5KB7dWrlDkYkdNmHRJPGzJ7Hj9WQgdB41FY9A
	 eGCEzwzcQKGmGyVMGRnofyM6jB0Cfl1Noxt29BiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 163/250] arm64: dts: imx93-11x11-evk: Remove the no-sdio property
Date: Tue, 25 Jun 2024 11:32:01 +0200
Message-ID: <20240625085554.315503471@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit a5d400b6439ac734a5c0dbb641e26a38736abc17 ]

The usdhc2 port is connected to the microSD slot. The presence of the
'no-sdio' property prevents Wifi SDIO cards, such as CMP9010-X-EVB [1]
to be detected.

Remove the 'no-sdio' property so that SDIO cards could also work.

[1] https://www.nxp.com/products/wireless-connectivity/wi-fi-plus-bluetooth-plus-802-15-4/cmp9010-x-evb-iw416-usd-interface-evaluation-board:CMP9010-X-EVB

Fixes: e37907bd8294 ("arm64: dts: freescale: add i.MX93 11x11 EVK basic support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
index 9921ea13ab489..a7cb571d74023 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
@@ -175,7 +175,6 @@
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	status = "okay";
-	no-sdio;
 	no-mmc;
 };
 
-- 
2.43.0



