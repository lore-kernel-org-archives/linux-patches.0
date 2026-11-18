Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036525;
	b=W/TmDVbMiLMRNz4Uh7g3GCjVU8s12l6zU03t+7IiX4xt7Xv1qZqbI/gsnTvA+YlZRoh+
	 NuGmrjR9ggBZe9m/XWO2W5fmKP1wDJ8dqE/RAsC3MxdjO4zHR0xXteVInQXVyxcLxq7/X
	 C2S9Vu7JzvgnsU9NPUP05fme+sNXALiZkdc/QHbrVq2BsWw7UIv23Y7MdcvT78F36/FTb
	 WDFUZdVkkNEv4EHgUvpLiqTQ1J/mOCR/Eq2sZpAeZlLMU3yL3YeZ8CeGk38w7y20P9a3L
	 ZMG4UJbVwEaxIB1PPsK+ZIrK2xErzFERSHBLhDLzIzEe6LFVKqgkNgpNfmnHPo5u01Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUcVJaoKaEfAqciy5Qzlwf/hPjoddEMkliaQY+eE5t0=;
	b=x+whV54LDGbSFxAKls4oFvS1I4eDq5kbBeXy0RT0YwGy8I3ATgLgmFy3BEfYoUX8jODZ
	 AfeXRx+jEVjNRnztgNgQBiqk3c/9Oscq0mNjMmhkpF0WifkP55GSwgJEhL51oXxNxepUJ
	 gLyUWDgoXonmYW5kO+3w2UKoSq/UyIMylWNoGRH3+xmsDqQ6poLRFOafSRrozFketcPmf
	 GKVDFN0Z9b5QAFyO/7OrYhTHi5+7AnzD7TrymwnhLziBT1HFD/XphG5TiKKv82BTWjl34
	 ZRL4sZ2sDNq9gS3KE/hHGWzBKDOm4aCJpS4zdmTqRLTRcTn6t4mUz451pIaOwY1i7pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhmcoqGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415560A2603;
	Wed, 18 Nov 2026 21:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhmcoqGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F0D1F000C7;
	Wed, 18 Nov 2026 21:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036525;
	bh=LUcVJaoKaEfAqciy5Qzlwf/hPjoddEMkliaQY+eE5t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhmcoqGDIs53EW0ugtVPozeSR7pWJWRdwAYectcGV8Pb2gLDOnC6KnVIGHiFk5a+K
	 vK/Bz4E/mApnxOSheQawE43gkGuRREst/plZ9V+MYS9SmE8DXx/S73BQsSuUV/mugE
	 oODPiu7aH0pKPiJMUn/aaw5/HVJkB6NlJIEraFrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1090/3318] clk: qcom: ipq5332: add 24MHz rate for USB UTMI clock
Date: Wed, 18 Nov 2026 15:28:32 +0100
Message-ID: <20261118150352.677098670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6a4877d888294..289b9152a85c1 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -1048,6 +1048,7 @@ static struct clk_rcg2 gcc_usb0_master_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_usb0_mock_utmi_clk_src[] = {
+	F(24000000, P_XO, 1, 0, 0),
 	F(60000000, P_GPLL4_OUT_AUX, 10, 1, 2),
 	{ }
 };
-- 
2.53.0



