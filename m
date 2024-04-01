Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A6A38DD8;
	Mon,  1 Apr 2024 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989374; cv=none; b=n60tMu3ktTt544pPtm+jpfMi3AbWTwhLCso0jDYQCx1T0fjCEZFJHRM7D1Pb9zWHER7J7HAj6wBNIicSkGy7bpPJXtNsCMPWTt9x/llR70PQxEQPQD5Igx0Czqfva+yodl+16/M5u846QvzQiu2A+gtjnhhzhiWK513l8SB4tCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989374; c=relaxed/simple;
	bh=1hr843oa/TUiYhYY6aywuZ9kVCBbJ9Pi+ah4wyRs3/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUWjeOqoX6f7k3SLi4vWzVOJbtV0L6QypTyVD56CnbVchqVV7AHA5IF9JdAwarBQPwZ3hzjUVs0qYgNndlE1UguLLICjTRttD+UbAgrsap2vXakm5ZM7mDQVCooIsuJxMPz0eqKA4ZvytNUJIHuDuVED7+WYbyG3OtrRWhzaWIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpQzKKKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpQzKKKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD844C433C7;
	Mon,  1 Apr 2024 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989374;
	bh=1hr843oa/TUiYhYY6aywuZ9kVCBbJ9Pi+ah4wyRs3/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpQzKKKhiFPaGpKq5AOVUy3zb3bU9BwktN/eR3LSsmOKWs5T6LGKpyXIfjT2eeOMD
	 bXnrW4qtI9loGG5NCWA3GPMtBq1Iac7TtHu/7LDOp907v650xWbott03mpnW/nkWjg
	 QvxErBBd+Riq785l0/YymNi3yZBGNCeamNoRlq5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/396] clk: qcom: gcc-sdm845: Add soft dependency on rpmhpd
Date: Mon,  1 Apr 2024 17:40:58 +0200
Message-ID: <20240401152548.160510041@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Amit Pundir <amit.pundir@linaro.org>

[ Upstream commit 1d9054e3a4fd36e2949e616f7360bdb81bcc1921 ]

With the addition of RPMh power domain to the GCC node in
device tree, we noticed a significant delay in getting the
UFS driver probed on AOSP which futher led to mount failures
because Android do not support rootwait. So adding a soft
dependency on RPMh power domain which informs modprobe to
load rpmhpd module before gcc-sdm845.

Cc: stable@vger.kernel.org # v5.4+
Fixes: 4b6ea15c0a11 ("arm64: dts: qcom: sdm845: Add missing RPMh power domain to GCC")
Suggested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240123062814.2555649-1-amit.pundir@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdm845.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sdm845.c b/drivers/clk/qcom/gcc-sdm845.c
index 725cd52d2398e..ea4c3bf4fb9bf 100644
--- a/drivers/clk/qcom/gcc-sdm845.c
+++ b/drivers/clk/qcom/gcc-sdm845.c
@@ -4037,3 +4037,4 @@ module_exit(gcc_sdm845_exit);
 MODULE_DESCRIPTION("QTI GCC SDM845 Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:gcc-sdm845");
+MODULE_SOFTDEP("pre: rpmhpd");
-- 
2.43.0



