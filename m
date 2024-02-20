Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A779D151CC8;
	Tue, 20 Feb 2024 21:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463627; cv=none; b=OJpNtz3WJ64EGtFOtHn6jLe6eyjWKOwtB6YeEQvCVMG1AuQaXtTWPxxtIogt/WdC867gjCEqbg4f3F8NDF+V7/A2NFIN7RUffPmxZzL3gRuwTwkVnJlefesAjuojlTKMyfkYqb/HXfXXSfiltKnouBc5jOrCqEKrnNMBIkTSVmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463627; c=relaxed/simple;
	bh=XY6LEUV7518S8UrPaSML6/xpM7LMPGlGwHdLKRR7sEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TduUOAW2Kg4Viy1EiD6hGoPryPGiOHPYol9RyBEx9jk4EmQE05Dm2k9/acZnqBrtv8goseGyZmwDvUxMxroNQdKrB0ru+qRvfVNWig8eNnq8neNALSYb9fmi2IVTwiPc/789ijVzaEjTluzRHKF3gqKLDZ9rfOy8m6ee4GyNy38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNRtjaJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNRtjaJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B632C433F1;
	Tue, 20 Feb 2024 21:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463627;
	bh=XY6LEUV7518S8UrPaSML6/xpM7LMPGlGwHdLKRR7sEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNRtjaJ3hBLKfa+yxYwW7wLoSpgHeP9VEUKYtj13Cwkzg54zHW4HWmLGctUMAfWT5
	 z3EFg43WVRfzr4mugRZIZLSTTZQivKMvXYm0p9ICaj6m1W0UNmC0cDRV3Eptn4LcYh
	 jdMuBF9ICLGy9Cc4fLBfTm5hDzBo5WPCU4eZDDQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/331] interconnect: qcom: sc8180x: Mark CO0 BCM keepalive
Date: Tue, 20 Feb 2024 21:53:21 +0100
Message-ID: <20240220205640.261431801@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
index bdd3471d4ac8..a741badaa966 100644
--- a/drivers/interconnect/qcom/sc8180x.c
+++ b/drivers/interconnect/qcom/sc8180x.c
@@ -1372,6 +1372,7 @@ static struct qcom_icc_bcm bcm_mm0 = {
 
 static struct qcom_icc_bcm bcm_co0 = {
 	.name = "CO0",
+	.keepalive = true,
 	.num_nodes = 1,
 	.nodes = { &slv_qns_cdsp_mem_noc }
 };
-- 
2.43.0



