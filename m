Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063329;
	b=w6wWrm5ZgDgNn99RUxvabJwvRk71jjVlvflklYROBuxgzEU/6SQ/RHxyibx/QSlmgEGJ
	 AcbNIS93LxlzlNmOm7A2ispw46owe2bA/95HtR/QRezND3A70iZwPlA93H3hImkAWThSV
	 Uu37kHx/rjN7XB9Y/0giMXBlCytpYrZB+P6cOQpTn0uLKMetLRLKtsOHINVlsMvT1DKQJ
	 wFB9f58Udu057cnB6YG27HMAZlCJ1VjI48Y2lKKvRkrVBpKNBKsPWRKTwnMKDn52dVaVe
	 TY+y2x+V90quVnGLWOkP1jCZtMmNvTUZHOdaiJfzMrDPgdD29+CSlGlUIgmfT66Ps4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zbwnI6XoJHF+S4cPSGeHyWlDJdbF7wX3vQdmsikr3qQ=;
	b=dG1iFm9mOB4TyXGUc8M2acQX5/GOOxl0v8lpqVm7vp6Iovg7bFmjQcZZJ6bPr7faIUex
	 ca8tHUxXGO9Q0UreEPwX+J/O58q/QYFRvMmDLUntNpDwz7vHLcITg/bQEBUEzCRFFnX53
	 kwQoy1PFyd1gpP2fonM2bZL84aoV3/8GHbyXa912rOaiprJDczJNSgB2/h1kSFwjxl9uv
	 /45fW6aO9BWxE9PIFyGwKMr9Z5i8VrqSozkIKccUNojhe7J6KaxnIrRBdXmyPI2nyQAwx
	 +JIL0U6O94/Up8UIOarClr0JnA9HISNQEBWGEMqABI45d7IzCEUXKqRqE9BOmvwm12Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXjnFMG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82E6082BCB;
	Sat,  7 Nov 2026 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXjnFMG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D65F1F008A2;
	Sat,  7 Nov 2026 14:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063328;
	bh=zbwnI6XoJHF+S4cPSGeHyWlDJdbF7wX3vQdmsikr3qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXjnFMG6JnDOad/oypp/r21s46EEXPJ6VXB2RBdivREyYJy9xXxuG7gcHjoiUeirV
	 rxSH6zVQwRrFY05vw6MoGtQnkKFa6lEuZzWqdW41aRgUYWW1cz9WrnLDNhXl0gDHNM
	 YPwO03N8uu8FiN/LgXkUoN0u1B5EWmP+gC1d3yP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/869] clk: qcom: ipq5018: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:53:14 -0500
Message-ID: <20261107134910.928235780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 75e893169fc5c9ec28d5f9dffde40ce29b59a5de ]

The USB UTMI reference clock must operate at 24 MHz, as recommended
by the hardware team, for reliable USB operation.

Validation showed that USB 3.2 hub enumeration with USB 2.0 devices
fails when the UTMI reference clock is not configured to the required
24 MHz rate. Configuring the UTMI reference clock to 24 MHz to resolve
the enumeration failure and ensure successful device detection.

Cc: stable@vger.kernel.org
Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-1-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index e2d01cdc39c96..78ccd70199fc9 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1270,6 +1270,7 @@ static struct clk_rcg2 usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



