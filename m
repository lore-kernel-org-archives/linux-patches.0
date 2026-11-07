Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064727;
	b=DOxemOp1CKhaKylLRXyvDnozLbpv0O63esBIjBV6Gp3WTnMpJotpp2+Magop6fsWg37e
	 tibNqWc4mRltoOo5jfX4ETLLjvQPYLaWGdTmm+gC/UnZex2Wj1s6nUiBh0ov7Z8iLLZkW
	 ugXXJ1NgrU3LG035zD7DS/3E5pusJv3OtRVr7LGydGNpXzumApKtLkphO1tJRnuVEAo0O
	 8+3PleFdLnPX2KpqebP1AJVCLf8KEfAnGdXkJL8/eLuHj65yXEIchDvlSKMlRSNZLIqwf
	 QT8fVJ7JdMJCuGz0BdRogdFi4FYOkXXMcc3an4/rTQ3PA4vkD8oOzVEHJOn0U7HSoBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yYyIYrPtSXdaAo0VE2FAsiS4o7waYIfziHultBkzJL0=;
	b=u2cA73FhbXJp+EQ1J7ftHOfSHPCwCZMNI3PT1nsylBtzPvaa3+wRXLQFWhho638RkZcE
	 ej7VPoaH2xwkh9I9UrAyXSH5bSY+l776nEf5c7vCgAMOxhKM8xo0UT9OVo56BUDJ71Q4E
	 V0y/pdoa2IhsZuMPz6RoZcDiSadaGupWCPI2fHMT9t7Cg5JEmi+lh9YxYAWAtlEpIklMp
	 UiEds/uAqjG8zLW5M3QyNOZ1ztOS9lOMPL2f2ZJ0NrovG5dnCxL4Ae9kUDBTimGh0cZdm
	 2SELmmHt6kV7L/f2o8ASkb/biWsylTxbR1Ds5MDwwkIoHhZMMj+x//uZ+1z0xnh+vNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5YkKiXw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F9D606A332;
	Sat,  7 Nov 2026 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5YkKiXw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F961F008A1;
	Sat,  7 Nov 2026 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064726;
	bh=yYyIYrPtSXdaAo0VE2FAsiS4o7waYIfziHultBkzJL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5YkKiXwqJGrhARzZaVBbD1pQCl+UeVGzFWY67PaqfYIEiiNJGjIY/9Fb6q7pn2sK
	 Ba9MEJ165BehLEAlut9cI8ug9fkm6uoEEfAg36EP0fEF2pgcblP69KKSGyeYroQPtV
	 byIjTta5xMf23JJU5vzNIaCsmjITH1xOvEH/Hnus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0704/1257] clk: qcom: ipq5210: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:50:00 -0500
Message-ID: <20261107134958.697854820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 4d61492b5fa910ed59c4cbc699d2e5a03a5777d3 ]

The USB UTMI reference clock must operate at 24 MHz, as recommended
by the hardware team, for reliable USB operation.

Validation showed that USB 3.2 hub enumeration with USB 2.0 devices
fails when the UTMI reference clock is not configured to the required
24 MHz rate. Configuring the UTMI reference clock to 24 MHz to resolve
the enumeration failure and ensure successful device detection.

Cc: stable@vger.kernel.org
Fixes: 844be6e24afd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5210 SoC")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-3-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5210.c b/drivers/clk/qcom/gcc-ipq5210.c
index 3a786a21bdff5..76adfa8bf2ad9 100644
--- a/drivers/clk/qcom/gcc-ipq5210.c
+++ b/drivers/clk/qcom/gcc-ipq5210.c
@@ -716,6 +716,7 @@ static struct clk_rcg2 gcc_usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4_OUT_AUX, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



