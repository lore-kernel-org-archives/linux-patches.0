Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B325F18991E;
	Tue, 30 Jul 2024 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356272; cv=none; b=Gl57NEEa6waYCgd/aOa8EOfWHhtZUWnpF0nPEbyoMD53ilyEpntZ7ac6o3Mb74BJ9fNzu36ndITmPbmpsTJucQ0j/wbogadE+s++RjnW81e7nGqCAoFVQl04I00SZPp1kDcHPAQmbKuAMp9aVdRPqLuUrWMFtgsiacXc4YCQYtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356272; c=relaxed/simple;
	bh=qmr1I/hZkWfVN14X/3jE9GRjYQgfoOKqhiX/xvQXyFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB+W0Jo9FRFscvcvJ8j6MsPIaDDt3hdI5j3m5JV4n7wXIwX1ELFrGzFRqYWbM3D6rRszho+fTXrrF/RoIuIkQHr8et9/JPGfvZOzVRCzgoqZTRud7TfUeXksqrjLOKhameA9UiWaFR31HTVe5vtJBBh0uLV1KdbWj7rVT3S90G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhYcwyU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhYcwyU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A75C32782;
	Tue, 30 Jul 2024 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356272;
	bh=qmr1I/hZkWfVN14X/3jE9GRjYQgfoOKqhiX/xvQXyFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhYcwyU5Vc1hbx6ybfj0eWnaDSZL9D+tHo1smF15NaIymb1Oo+Q5o9HEfqaSwpsS6
	 ge4JsJLn7yyaDB5zjcVNqdgfVwKHPXqiJFwBOLuhyIsVyqc8sXT6XsrcwLE2R11LPd
	 Citndqn+NYIJNbJUd9QtcCtMQl11S6zPfjgVSelY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 135/809] arm64: dts: rockchip: disable display subsystem for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:40:11 +0200
Message-ID: <20240730151729.946642632@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 2bf5d445df2ec89689d15ea259a916260c936959 ]

The R66S and R68S boards do not have HDMI output, so disable
the display subsystem.

Fixes: c79dab407afd ("arm64: dts: rockchip: Add Lunzn Fastrhino R66S")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20240701143028.1203997-3-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
index e08c9eab6f170..25c49bdbadbcb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
@@ -115,6 +115,10 @@ &cpu3 {
 	cpu-supply = <&vdd_cpu>;
 };
 
+&display_subsystem {
+	status = "disabled";
+};
+
 &gpu {
 	mali-supply = <&vdd_gpu>;
 	status = "okay";
-- 
2.43.0



