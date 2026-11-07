Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064724;
	b=PfCCEtXygmXd7ac+YQ236NWBJxqAxbQRACLoqiIvEPivjE3N33AFM/kjhGPIJ87MW7ly
	 K9Aa6ThYaZGFRle6hY+ec+WNFsRYM2wI0awHYjbuqOu5dWkybLB45X6QcAXoTpy1aQXCH
	 LmaLZQhHYit5REgvgkSW1DCrdy3rXk8tWzggobrf9cKsCZQoAwnWvJAYcGvnO/2EYQHWD
	 bDz+AMdXx0fkRVeFxMdyjIVitOAu/3SDEHjzR9CPpKlnoGJk5rwXKeKMGeP8h5TsKLPsJ
	 aXDWwCxqLBZrC+d8paT7Lj09MoQN7IJSe6eG1EdX24SyXCBPqmKD/KGikUsFebFEGZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aXSMf/ACTfz2z3LirF5/9LjjfKIBxe7ANncoQ3uMEOw=;
	b=z5hMtGaHWR4WGj+b3k3ymaD8njKvehVthepWq6MYWi5jmEvaovuk0PiDW54Ytq0DWO3O
	 DktYMdigi/k7oWD1z0whaeb0w7/tj5cQ0V9G+zilk+QPjXYZg88lOLCQAzC/Co3w+2lxz
	 K2Sd9MiPcL1vWaxAyHJfD21ynsHhyr9vha8YsVBbBqZc4SPmBZrFDOQQfaJZ4AQtF2vun
	 am6li7DBil8LkxJ6LQnoyO++/Q/i7dQ+EuIhOPw/H8FOyWI2PGNslbAr/aEkNMRYjCqEa
	 EtOhzbfj2eo1o/yDc2ZRZaLjqd34kAMhhj5FMBaMoomLYJuUpb2iEGqYLXIdb42ZgWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3F85GIG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACD0606A332;
	Sat,  7 Nov 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3F85GIG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B7E1F008A5;
	Sat,  7 Nov 2026 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064723;
	bh=aXSMf/ACTfz2z3LirF5/9LjjfKIBxe7ANncoQ3uMEOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3F85GIG9Ord7DFHB0+qVd1YA7X++3Ig57tG7bWLQNQKT7tWLmk1Ks7nFhZZJgOZk
	 SKeTWCDaYEqBogaJ2LnHqGQcVo+i3W49vcQZbXyJKv9XgvHiwKOD5f+V/o68IWQlz3
	 83y6HztsmDvVsjNpx+GAP2uYUAps5aLddKYMPbok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0702/1257] clk: qcom: ipq5018: add 24MHz rate for USB UTMI clock
Date: Sat,  7 Nov 2026 08:49:58 -0500
Message-ID: <20261107134958.643235859@linuxfoundation.org>
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
index 46da652956fb0..add6a53d4df55 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1269,6 +1269,7 @@ static struct clk_rcg2 usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



