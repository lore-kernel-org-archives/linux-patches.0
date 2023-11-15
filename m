Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1C145BF1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUUbuwzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56E4C433C8;
	Wed, 15 Nov 2023 22:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085775;
	bh=+B0JCxyw199jJ+ny5A+7O4Gudhe9D/Xbk16QYwRHcg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUUbuwzdW212JSDqKXEc3IwVqnpTJz8XD7rLFaYbtzHXbTi0/n5JOjCbwMZuBdk5w
	 IBvCsCPob+Hhobm4E0QR0J3PZJCBCWzfNb0jyKOphaEK3JB5KDwrRj06EykmBeByP8
	 QLEoafFBQie1rjJiAJaP7o79BJu0dkWTxpmIoANY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Gautam <vivek.gautam@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/119] soc: qcom: Rename llcc-slice to llcc-qcom
Date: Wed, 15 Nov 2023 17:00:36 -0500
Message-ID: <20231115220134.055999771@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Gautam <vivek.gautam@codeaurora.org>

[ Upstream commit a0e72a5ba48ae9c6449a32130d74506a854b79d2 ]

The cleaning up was done without changing the driver file name
to ensure a cleaner bisect. Change the file name now to facilitate
making the driver generic in subsequent patch.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: f1a1bc8775b2 ("soc: qcom: llcc: Handle a second device without data corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/Makefile                      | 2 +-
 drivers/soc/qcom/{llcc-slice.c => llcc-qcom.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/soc/qcom/{llcc-slice.c => llcc-qcom.c} (100%)

diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 28d45b2e87e88..2559fe948ce00 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -21,6 +21,6 @@ obj-$(CONFIG_QCOM_SMSM)	+= smsm.o
 obj-$(CONFIG_QCOM_SOCINFO)	+= socinfo.o
 obj-$(CONFIG_QCOM_WCNSS_CTRL) += wcnss_ctrl.o
 obj-$(CONFIG_QCOM_APR) += apr.o
-obj-$(CONFIG_QCOM_LLCC) += llcc-slice.o
+obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
 obj-$(CONFIG_QCOM_RPMHPD) += rpmhpd.o
 obj-$(CONFIG_QCOM_RPMPD) += rpmpd.o
diff --git a/drivers/soc/qcom/llcc-slice.c b/drivers/soc/qcom/llcc-qcom.c
similarity index 100%
rename from drivers/soc/qcom/llcc-slice.c
rename to drivers/soc/qcom/llcc-qcom.c
-- 
2.42.0



