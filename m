Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE1E244693;
	Tue, 11 Nov 2025 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822882; cv=none; b=JklCx2efr3W28Jl6DzQlDcOkaEKyhMLrEdcm7lnYLi0a5pd5XiRrpE3k5UlKvFZOXKaMMB+bMyc6UEmA3QBUgeJELkmd3OT6Se508v7n6KX13yhX+xFeKc19cYWSdIunbbbwI6Ez+JQIDwVe7Zr3NPtuLTviowixXDDu+jgJbsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822882; c=relaxed/simple;
	bh=dXhv9ZURsnVCP/yj5fPTP1F1x2dZ73q8gvlrrTQp0+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lfz64HgMCzndjhUg1PmNz+Y5oWCwmkFCO2NsMtVdV8tePVrqJuEa+sawoW2ZW7Ki5WE4H1Zk5wIP2VP2ZU6WhDnom67zndQctXQdlH0vqsPIEjAQpJhtwfVzEHGOKg/jes0deW/1DgOhwkwNU4ZgmfXU1QVfgVkJPZ1fK9NBPuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=At4VEnVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="At4VEnVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AA3C116B1;
	Tue, 11 Nov 2025 01:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822882;
	bh=dXhv9ZURsnVCP/yj5fPTP1F1x2dZ73q8gvlrrTQp0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At4VEnVCQcwZKc4Yaony1bYOlHPwPeNwdU3K0TkSgNzA0w7YTySvkUGO+8NjfmKjN
	 bCCJeXGOnc9WgAOwjIvJbb72cLpsn8goYypmutM4KkyWC0T6T18EoFE1Vvv6yjnYMe
	 wvKIozWT1hgq4MKSGxOaWc8loBCUh6ihL3YOZNBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanyang Wang <quanyang.wang@windriver.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/565] arm64: zynqmp: Disable coresight by default
Date: Tue, 11 Nov 2025 09:39:42 +0900
Message-ID: <20251111004529.787960545@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 0e3f9140ad04dca9a6a93dd6a6decdc53fd665ca ]

When secure-boot mode of bootloader is enabled, the registers of
coresight are not permitted to access that's why disable it by default.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/7e308b8efe977c4912079b4d1b1ab3d24908559e.1756799774.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index b1b31dcf6291b..e2ad5fb2cb0a4 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -450,6 +450,7 @@
 			reg = <0x0 0xfec10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu0>;
+			status = "disabled";
 		};
 
 		cpu1_debug: debug@fed10000 {
@@ -457,6 +458,7 @@
 			reg = <0x0 0xfed10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu1>;
+			status = "disabled";
 		};
 
 		cpu2_debug: debug@fee10000 {
@@ -464,6 +466,7 @@
 			reg = <0x0 0xfee10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu2>;
+			status = "disabled";
 		};
 
 		cpu3_debug: debug@fef10000 {
@@ -471,6 +474,7 @@
 			reg = <0x0 0xfef10000 0x0 0x1000>;
 			clock-names = "apb_pclk";
 			cpu = <&cpu3>;
+			status = "disabled";
 		};
 
 		/* GDMA */
-- 
2.51.0



