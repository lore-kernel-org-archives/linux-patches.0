Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061696;
	b=Meja/3Um3BqCFFoAYeIfwvycm3GF4ufGIlWGMfFxP6H2AU+sgrO7rHKRW4GY9DAPHGGv
	 WivmxCCz6BsiySXC1NH+qom2XqxoCGdsEfLo+zF2szTuEVjCAHW1ph3rQAazVpT6tnWRU
	 6LcqXOJFFBLZtHwR3DhmRATXfy0ySpY91b5ECvxCSjn10jY15m8Pqf21UwUoMLqF8Gc56
	 AqOcZsGw2cHkDHGjdPepjqVg+C1/VWvtBkqR/qQdWZISQ1UmfP7QzzqV8qONc8XlQ1f2s
	 x3HEMnvOWVnmT/woXTYyaIucHPmYoejX11YUiYANY7dv2iX2Guj5a2IIWFlBJMFXegA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQORLvgTroaGi6ztYdQqn1j5PLYGXuGVwCTOPWqfnKo=;
	b=QDD7NTLTZTld/kTfgN9qwgXM5fUSrUzrRZiUueUNVWoBD3LEANlah+FSu59BZl6uxBrI
	 RRBxSuCH+eazWG0p4jihP/PJjs8ocWt2BcobsS/p/UGmEwrVjtcMBXZMStu/hOv4DVWhD
	 aioOTKDI1ByKyOb6OT4hky759yR8EM/dexII748TTC3d3r7mTsFqLaaw/kkrq/h+34MTf
	 hilv8vpCNp0uyF0Lnfn4hWDRXLSPKIEiULs04r+H7gwvUkRAwfU73dduZ1XFmdpz50eiE
	 7g0wVImDsG+d2rmleA0IYr2OjtkObcENKFlsrqMtn+ka+oAj3IZMIh0EeiUPJ1NQ/iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G7maNqE/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BF2606A320;
	Thu, 19 Nov 2026 04:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7maNqE/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE3B1F000C4;
	Thu, 19 Nov 2026 04:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061695;
	bh=ZQORLvgTroaGi6ztYdQqn1j5PLYGXuGVwCTOPWqfnKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7maNqE/AQqy+JtkNNgQPcO5p7c0KtIj0YpxoSGj+C0jbYxFQYc76jSBiMBt2p8S9
	 utSdfHGYyK4HeVStgSNdVnF0UmK80PV80RbFOTbGNjhKhPMqMLDi6LUgLGbHqGpT8f
	 wJ+lU/I5znIZ2GRDXZTzMvoY0sA3RX8HozvR093Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1604/1848] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 16:00:42 +0100
Message-ID: <20261118150026.711160386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 8c0f93e10fa9e34009817bd37bb75c1b5a691fa2 ]

clk_rcg2_is_enabled() returns either a hardware status or a negative
regmap error. The force-enable polling loop treats every nonzero return as
an enabled clock, so a failed status read is incorrectly reported as
success and clock reconfiguration can continue with unknown hardware
state.

Check for negative returns before testing the enabled status and propagate
the read error to the caller.

Fixes: 7ef6f11887bd ("clk: qcom: Configure the RCGs to a safe source as needed")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-2-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index eb4fd803bae0d..fa86832b3f825 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -828,7 +828,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
 	/* wait for RCG to turn ON */
 	for (count = 500; count > 0; count--) {
-		if (clk_rcg2_is_enabled(hw))
+		ret = clk_rcg2_is_enabled(hw);
+		if (ret < 0)
+			return ret;
+		if (ret)
 			return 0;
 
 		udelay(1);
-- 
2.53.0



