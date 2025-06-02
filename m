Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7B51A01C6;
	Mon,  2 Jun 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872609; cv=none; b=LzGkoQbFERiMb5+qhp8czFReIFDU+rtDeIEBzozm24yBfeK3lpGCdX5wCMVILemC0Du5KlwZEY861A8KTZMQtF7fPHChHq2UNtmlnvdepCcRPC6K1TAS8UXfUFu99C+sLB4jCR2rqAwXgrxtYqUQO2rYg6HqUkc09CKWPFuwo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872609; c=relaxed/simple;
	bh=x1alF1XZJH5Z7h83y9rLnKQUJJsI+y+KQfkyoygREYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLk08O7hilNA6GO9Nou+yLhQq/0pFHTBjVpzDYWVRzebiv5/5ggDkzueAvajDP35nLn5Kvf9TYFRtblhTSa/RYeOeysiKVJEQBDVpKv6O3fvZUnS5xxrIMgzVN4XfjFuLpPWHbJv2Dei7/e21U/z8jRjyQ4lVyCNsd6CbATWO2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRhpnVTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRhpnVTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB057C4CEEB;
	Mon,  2 Jun 2025 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872608;
	bh=x1alF1XZJH5Z7h83y9rLnKQUJJsI+y+KQfkyoygREYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRhpnVTGMlyh2OAf0yPZdotSlhSxK+0Zj20aviNw4MCTMVJa7K+UK2vLtVHqvRId1
	 x0JuviX+tLgE2MjHaPqqByVJMeElDnT4PP5BAeaTPNxp3guZ3uB+jUOjvIbmMLJvLi
	 cnlxF+8FZaXsg+OxKcyE5vCZUVnTBX2pUSuOsiAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 16/73] arm64: dts: qcom: x1e80100-hp-omnibook-x14: Enable SMB2360 0 and 1
Date: Mon,  2 Jun 2025 15:47:02 +0200
Message-ID: <20250602134242.339872832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juerg Haefliger <juerg.haefliger@canonical.com>

commit 48274b40a3719a950b1062f8125c972a2df5c083 upstream.

Commit d37e2646c8a5 ("arm64: dts: qcom: x1e80100-pmics: Enable all SMB2360
separately") disables all SMB2360s and let the board DTS explicitly enable
them. The HP OmniBook DTS is from before this change and is missing the
explicit enabling. Add that to get all USB root ports.

Fixes: 6f18b8d4142c ("arm64: dts: qcom: x1e80100-hp-x14: dt for HP Omnibook X Laptop 14")
Cc: stable@vger.kernel.org      # 6.14
Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250319160509.1812805-1-juerg.haefliger@canonical.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts
@@ -1352,18 +1352,22 @@
 	status = "okay";
 };
 
+&smb2360_0 {
+	status = "okay";
+};
+
 &smb2360_0_eusb2_repeater {
 	vdd18-supply = <&vreg_l3d_1p8>;
 	vdd3-supply = <&vreg_l2b_3p0>;
+};
 
+&smb2360_1 {
 	status = "okay";
 };
 
 &smb2360_1_eusb2_repeater {
 	vdd18-supply = <&vreg_l3d_1p8>;
 	vdd3-supply = <&vreg_l14b_3p0>;
-
-	status = "okay";
 };
 
 &swr0 {


