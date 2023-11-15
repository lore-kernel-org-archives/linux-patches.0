Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9137E3A8F7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnomfarO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF6BC433C7;
	Wed, 15 Nov 2023 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077256;
	bh=PbnD+LvMK4ZUSILm55phXkgjL+sau6F52tWZrpxovRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnomfarOU0DWgrNM47jeKZfnflrXBp+sQZZ8Gb0nyfC/UmsxRjZ6a2r8Zl3XiJvTr
	 mGLaTBsufXZmYX5NKYc7uYoPDwLd6UwJuUjHLIjpmxqs9lrKDvFOF2SLsd9yencjSl
	 8orA4mYqQen9sbFYELnaCasVEh4D48DeNHs4qqAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yujie.liu@intel.com>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/603] clk: qcom: config IPQ_APSS_6018 should depend on QCOM_SMEM
Date: Wed, 15 Nov 2023 14:12:17 -0500
Message-ID: <20231115191626.541137196@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varadarajan Narayanan <quic_varada@quicinc.com>

[ Upstream commit 6a15647d0adc686226045e8046369f34d6ab03ed ]

The config IPQ_APSS_6018 should depend on QCOM_SMEM, to
avoid the following error reported by 'kernel test robot'

	loongarch64-linux-ld: drivers/clk/qcom/apss-ipq6018.o: in function `apss_ipq6018_probe':
	>> apss-ipq6018.c:(.text+0xd0): undefined reference to `qcom_smem_get_soc_id'

Fixes: 5e77b4ef1b19 ("clk: qcom: Add ipq6018 apss clock controller")
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/r/202310181650.g8THtfsm-lkp@intel.com/
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://lore.kernel.org/r/f4c4d65a7cb71e807d6d472c63c7718408c8f5f0.1697781921.git.quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 865db5202e4cf..a79b837583894 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -131,6 +131,7 @@ config IPQ_APSS_6018
 	tristate "IPQ APSS Clock Controller"
 	select IPQ_APSS_PLL
 	depends on QCOM_APCS_IPC || COMPILE_TEST
+	depends on QCOM_SMEM
 	help
 	  Support for APSS clock controller on IPQ platforms. The
 	  APSS clock controller manages the Mux and enable block that feeds the
-- 
2.42.0



