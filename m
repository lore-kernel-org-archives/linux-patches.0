Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE1E11184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F91FC433C9;
	Mon, 11 Sep 2023 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440861;
	bh=LEtcJZDUs+ZZFPpT3/7tYltmCkdJEWyC0QEduPwILck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS7k/YG96k/3OR3O/gKeepi7+eWb5ZH7g6YjXQKAhMExolvjLegry98UJ+LHBHpRy
	 Ir8yAr0/QU5WvJiNcqHLRM19RNiwRcAKZrXD2Z2bjY1WEIyTwRn5UlxLb8DheeoqvO
	 P903Impu28NvYwyewKeW7JchVb08m3ZoeXh1GXlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 212/739] arm64: defconfig: enable Qualcomm MSM8996 Global Clock Controller as built-in
Date: Mon, 11 Sep 2023 15:40:11 +0200
Message-ID: <20230911134657.112687957@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit dc015a3a6d6986c41a7bd12fb205a282f685e328 ]

The commit 8f680c287445 ("arm64: defconfig: Switch msm8996 clk drivers
to module") switched CONFIG_MSM_MMCC_8996 to module, which also resulted
in CONFIG_MSM_GCC_8996 being switched to module. This breaks useful
bootflow for Qualcomm MSM8996 / APQ8096 platforms, because the serial is
not enabled anymore until the GCC module is loaded.

Reported-by: Rob Clark <robdclark@gmail.com>
Fixes: 8f680c287445 ("arm64: defconfig: Switch msm8996 clk drivers to module")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230619125404.562137-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index a25d783dfb955..28714382ce3f5 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1182,6 +1182,7 @@ CONFIG_IPQ_GCC_8074=y
 CONFIG_IPQ_GCC_9574=y
 CONFIG_MSM_GCC_8916=y
 CONFIG_MSM_GCC_8994=y
+CONFIG_MSM_GCC_8996=y
 CONFIG_MSM_MMCC_8994=m
 CONFIG_MSM_MMCC_8996=m
 CONFIG_MSM_MMCC_8998=m
-- 
2.40.1



