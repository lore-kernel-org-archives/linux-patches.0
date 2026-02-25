Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABD1242D9B;
	Wed, 25 Feb 2026 01:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983000; cv=none; b=DPpJek5QHqZJHD3XyaD9+IvsNl8pVvKIAp0Dt3s0lLEltwNPzFWfKlF9pCJw4NLoDT1LyXIXldAP0tbVYtvzRYEmSQ9YhKpweJDtfFHwEs3nFfWkBDbjhBmEncSg4nvfAC/LCZFcDiFCxPHXCKMWcH+mni3alKYbDMinV2fzrYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983000; c=relaxed/simple;
	bh=s9Nwu5H+Pmz4jYkLccVlucrcNyoycx3DDneLXu/y7PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnbETXIaYAX5bY74JrXf1qPU4k/Xo6/V+E6n1cD8Wa6Ugf/H98szqyG2B7G84qqYkiC3ZLaqALS4tHm/UDpNh1BZ9wcq73PYrtNW1kMVzaCbDCNNJivxE8WB0dpsSQLf3smzr5TAD9Bn5khgLMgHOwLuawMqLll9O3+YjJw7/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQDH/jWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQDH/jWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BB3C116D0;
	Wed, 25 Feb 2026 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983000;
	bh=s9Nwu5H+Pmz4jYkLccVlucrcNyoycx3DDneLXu/y7PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQDH/jWxozmccH9lhAI9L7VGf8APre3Iju/s3D+xu/XunZ0QRzGtIvpFqvivjW+AE
	 jQRE0R+Jefd+LCC5UDflu9V6oxzR8vn3jj/UkfHQ9SvmSpT0/jfBm2Bc0JukKfnP8q
	 4UXRabv0qEPtvpfpPnlGMst7Yo03KQCDiU48lMTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhash Kumar Jha <a-kumar2@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 171/781] arm64: dts: ti: k3-j784s4-main.dtsi: Move c71_3 node to appropriate order
Date: Tue, 24 Feb 2026 17:14:40 -0800
Message-ID: <20260225012403.843667878@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhash Kumar Jha <a-kumar2@ti.com>

[ Upstream commit 24c9d5fb8bbf5e8c9e6fc2beffeb80ac2da83de4 ]

The device tree nodes should be ordered by unit addresses in ascending
order.

Correct the order by moving the c71_3 DSP node at the end as it has a
higher unit address.

Signed-off-by: Abhash Kumar Jha <a-kumar2@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260112085113.3476193-2-a-kumar2@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 61acc4428a7f ("arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog instances for j784s4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
index 0160fe0da9838..5b7830a3c0975 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
@@ -6,19 +6,6 @@
  */
 
 &cbass_main {
-	c71_3: dsp@67800000 {
-		compatible = "ti,j721s2-c71-dsp";
-		reg = <0x00 0x67800000 0x00 0x00080000>,
-		      <0x00 0x67e00000 0x00 0x0000c000>;
-		reg-names = "l2sram", "l1dram";
-		resets = <&k3_reset 40 1>;
-		firmware-name = "j784s4-c71_3-fw";
-		ti,sci = <&sms>;
-		ti,sci-dev-id = <40>;
-		ti,sci-proc-ids = <0x33 0xff>;
-		status = "disabled";
-	};
-
 	pcie2_rc: pcie@2920000 {
 		compatible = "ti,j784s4-pcie-host";
 		reg = <0x00 0x02920000 0x00 0x1000>,
@@ -113,6 +100,19 @@ serdes2: serdes@5020000 {
 			status = "disabled";
 		};
 	};
+
+	c71_3: dsp@67800000 {
+		compatible = "ti,j721s2-c71-dsp";
+		reg = <0x00 0x67800000 0x00 0x00080000>,
+		      <0x00 0x67e00000 0x00 0x0000c000>;
+		reg-names = "l2sram", "l1dram";
+		resets = <&k3_reset 40 1>;
+		firmware-name = "j784s4-c71_3-fw";
+		ti,sci = <&sms>;
+		ti,sci-dev-id = <40>;
+		ti,sci-proc-ids = <0x33 0xff>;
+		status = "disabled";
+	};
 };
 
 &scm_conf {
-- 
2.51.0



