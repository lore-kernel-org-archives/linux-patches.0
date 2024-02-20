Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F07014F9C8;
	Tue, 20 Feb 2024 21:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462842; cv=none; b=KNh+Jb0l0FbadbyMwf/jzlt2BsXhvkC0veSZa0AKtWBaPCEAyzhm0zozQYa4f0U9CrrMH5YqDRM8zyU9PCvPv5x6aSGBFW3hsXvLGse9yHH1mLUEZ4a/fIF2PhCzyZTB7eYyRw7LNZvNj6gHgFUMrJK+UWjXrV8FlQ8PyuZTsaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462842; c=relaxed/simple;
	bh=dyoW/6rRe78tG7Fi0oZses4HMWf58q6g6ABOJQKKjUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgDPwqQOPH3geCIn+1rRomzzXaqZKV8PnYuFSIFi8faGqc+C3m+HIdbt3aMLyEe/Cl4NGURVyHpk1JFbm8KpYBFEbyjZI29CH6dU4g3S7sTZ35+k6hR4YEaz2i5NTgwa79erTAQE5ntH9QTQZQIXvxCrtHjvEqj3df0cnazDlJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trGRxEbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trGRxEbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF7AC433F1;
	Tue, 20 Feb 2024 21:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462841;
	bh=dyoW/6rRe78tG7Fi0oZses4HMWf58q6g6ABOJQKKjUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trGRxEbB+7todVOubSo0tRndQyyw4MDdfge129xvBAwJobssKdRhcHL+UIcyy/0tT
	 pfUQQJFmRA0K+uxisms/dKuyRRRvMIAHKW/o7BPMnvxIrm0rWgRj7N0PMkPUB9JsSS
	 ILNnA1aUJfwlpsBYanX5GSB1tzhJCz3+wogAmNs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/197] interconnect: qcom: sc8180x: Mark CO0 BCM keepalive
Date: Tue, 20 Feb 2024 21:50:13 +0100
Message-ID: <20240220204842.696446042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 85e985a4f46e462a37f1875cb74ed380e7c0c2e0 ]

The CO0 BCM needs to be up at all times, otherwise some hardware (like
the UFS controller) loses its connection to the rest of the SoC,
resulting in a hang of the platform, accompanied by a spectacular
logspam.

Mark it as keepalive to prevent such cases.

Fixes: 9c8c6bac1ae8 ("interconnect: qcom: Add SC8180x providers")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231214-topic-sc8180_fixes-v1-1-421904863006@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8180x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8180x.c b/drivers/interconnect/qcom/sc8180x.c
index 83461e31774e..d9ee193fb18b 100644
--- a/drivers/interconnect/qcom/sc8180x.c
+++ b/drivers/interconnect/qcom/sc8180x.c
@@ -1387,6 +1387,7 @@ static struct qcom_icc_bcm bcm_mm0 = {
 
 static struct qcom_icc_bcm bcm_co0 = {
 	.name = "CO0",
+	.keepalive = true,
 	.num_nodes = 1,
 	.nodes = { &slv_qns_cdsp_mem_noc }
 };
-- 
2.43.0



