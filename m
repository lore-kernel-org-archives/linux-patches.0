Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064725;
	b=miIgnTrO6Rvk0PV9vZKW1qkemObsOqeg3aN+HTdnTiVvWdLxuOmSLs1/0aDjWQPCTnbd
	 JTpE0O+WKBAX9vgSthIGA3uVw4gCndziDCXxK9JuL/FbVVL6v8FHZ8pOawPLaurBp+PvO
	 NVU9idlURxfIVn3hnjMrB7VcBmhBTJ28vj8fp4XszPNSRnOEWoNJ+BDSaMDMRj1RNI1Lo
	 z+aGkW50elGGj2sdZbxVubNWDAnLkgs35av6m9e+M04eB3xOlnoayV1MrU2DhACc+ZOD+
	 vP09gboTnukXxYy2j9Y7V9iXHT3OPMQjX6Vpl2vW8nLm7IK2gCSjt72GC/IkY8+OodQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zetE11E99G1URMtav6G0egA8SUo4zE+AQwNrDXhTuLk=;
	b=1/DoXKMG8jOhn/gtFZqm2QZe7UnDqP3pfyXhjA/vftxieL3oorKjRbZUxhapF12FOhWg
	 5ILtBDMqxX23IZLsVbraE9/LBAWsjXxoCeeZNhyyK9VUPzqisIBB/UybCvwXp403lIU5g
	 C4IrQU8xuCwvP7qLgpDPr6k2/Bn/pdT5exGLwvBh6NUVi8gwQutN4hitwnhaiJNcM5KRF
	 /isn67ZP/J9k/b/ebNjjXFGXG1NFNGwg51nSDjaWxbNi+RE5BrZs7kRQ/HtvtFuxaOUvG
	 suuTT+LWpfqhkFLwuPxKSwFtBFP7NprtaBiH0z5ciXKlJJjqux9ttixVY5NUpAxAG7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0O3ixCY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4E606A332;
	Sat,  7 Nov 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0O3ixCY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB53C1F008A5;
	Sat,  7 Nov 2026 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064725;
	bh=zetE11E99G1URMtav6G0egA8SUo4zE+AQwNrDXhTuLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0O3ixCY9oQ7T1mhgOqtIpTtBVCabg5fhPYdTpfEfkE4gS3Hy08LkvvvNucE032Ql
	 HDv1aOZGuH4c21btafMyEEDhYuKOkyYbLmUJ6MgsTn9Fd/2zjlOwvlBK8pwZq1KGV0
	 KDSkZKeZIv4qmDhxhpyXVzM09Ik34QKsB4H7tlQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0703/1257] clk: qcom: ipq5332: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:49:59 -0500
Message-ID: <20261107134958.671658495@linuxfoundation.org>
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

[ Upstream commit 19b62f31e15ef70dc927aab91b1576ea6c37f992 ]

The USB UTMI reference clock must operate at 24 MHz, as recommended
by the hardware team, for reliable USB operation.

Validation showed that USB 3.2 hub enumeration with USB 2.0 devices
fails when the UTMI reference clock is not configured to the required
24 MHz rate. Configuring the UTMI reference clock to 24 MHz to resolve
the enumeration failure and ensure successful device detection.

Cc: stable@vger.kernel.org
Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-2-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index ecd9ebeed7549..4625b447c2351 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -1038,6 +1038,7 @@ static struct clk_rcg2 gcc_usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4_OUT_AUX, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



