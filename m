Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062334;
	b=PHJ/qtEQNtdaPrtkieyyge+CR7asJdOgBwf0aNoQ9+bPD4Q/2MGIYG2WXFQXTTohjZPB
	 5zMYHbMm/AH+dD3xjtTc5qjrA2OjuwEqsLOpOWwqkz5qm5zMd23K5MBwPn32I2o6lDnGO
	 0DrAE3PErX6T/T91TEOmKVUzD8bZO25OfB1aUxaVhXleNOSCzO3QfiCAfy2rlToPM+9Ib
	 We3eYwQVD+K4ipEWCsKvorN09KLAQW8zE0JIuRh2mfZyEWQWY5jjWwgkMPWNiYzJrh7E7
	 HdyxQn4wU3UhyGAdhfCWAgsCzdILAVjOQe7/wquBRtQmzBRdg/2zCoqqe/hHFroCDyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5RcFG4za7dOeBRQx2Kpd/PqfveMNmx4c9LArE/myL5k=;
	b=X52U5PGs5yIyI1Dq0C4bbqVUtc255S8D1GDa3Gk98vwh2Lr80uFoCl1aBqcwE1/6t27e
	 b2riAjpj9s3X55Y/UxSfnU+jaDTiMIH8hEA1GvJayVirKqVtdvNwWWzMLB8XJC72OZYyl
	 eFpIoT2A2xDHNH+4wZS8Ebu9pS3twuRSPbww+dDa3ouXlgedrBwCD7zuAyQOYb2hpp3sg
	 UHvKx+Dhp8My8v3eySbPkMr7j64x0seohOsOOOzocEDBx8WU1awqYlSQqDPQ0xOlMZWIB
	 FWc7YqN+YRiQbWzas5XU4W0uYb2fMySEpmLBrIItgcS+2TdV0YEWytNiCt7JERWv+ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2f7sPcp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8101606A32F;
	Sat,  7 Nov 2026 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2f7sPcp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5337F1F0089F;
	Sat,  7 Nov 2026 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062333;
	bh=5RcFG4za7dOeBRQx2Kpd/PqfveMNmx4c9LArE/myL5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2f7sPcp2EQBf/HiO7oUUr+9j3fF6L9BlHhj5KjwbUo+JyaBopcptIgWeYmVKQbEJ
	 /dmpjBziNLDiFMwe74W1gToQ0d1uacJKIf7T8GRCe/kY9/hX0NcgmCW3D2776l6060
	 o2t3qqEAlP7tcNpnI6p2r8u0WRLbfoBEZmzHHq74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1264/1536] clk: qcom: ipq5332: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:54:40 -0500
Message-ID: <20261107135033.274431925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9536b2b7d07c2..bf77959ca84d7 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -1039,6 +1039,7 @@ static struct clk_rcg2 gcc_usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4_OUT_AUX, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



