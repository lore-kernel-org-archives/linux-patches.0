Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5F2123F3;
	Tue, 12 Nov 2024 10:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407999; cv=none; b=ks1uUn6u220l2gsNX3LW1Vz/HRsxr6/mpIIggScg2tgjQ7lyjIttb+AGFtuDvZs+15S+yXdkr9YLqyao6IAn3gfYN1hCqmM8nVzTVgSOM4flpobmLQUWQCOZq07/8+ie0Tg0YWo/YaT0YBKRsrRWxiKVeQUQ1unN41P5TfeiD+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407999; c=relaxed/simple;
	bh=IQoWrY7WfLv2TQtT2aR8Z7Ya/fCj8Z5AA7DXqd3gyvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0KpPnfkV70DGlQKDNMm68vhm+3/iJ3Pec1P+1CVjASXB0KFVvwFUk+WjCd0HsFPzier/HAujorTV/lHvHVbHJZ+71zqx5bmScC4wEJ6WJ//nnoBffyMRTv/BPwoBULyXYrRIF2Jtze01IoQDqX53xHirYeYRAc4NZeeFoLqPgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWnMie1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWnMie1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8365C4CECD;
	Tue, 12 Nov 2024 10:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407999;
	bh=IQoWrY7WfLv2TQtT2aR8Z7Ya/fCj8Z5AA7DXqd3gyvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWnMie1OyW6f9Q6Cd6rpMB5Zi1q10z+aGqlUxbmNTgaOq/nVh6hhbp9QV1lUP+m6y
	 Kw2fcGbVuV8fsyDmmB61gELUNHmgWgaqQw/oss01qV7FqXUL9njP+eQ2rmpDzR12OW
	 0l7E8+OLGwmOhpFnFkDccNuCxu4UKT0srTzgLHLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudraksha Gupta <guptarud@gmail.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Kuldeep Singh <quic_kuldsing@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 006/184] firmware: qcom: scm: fix a NULL-pointer dereference
Date: Tue, 12 Nov 2024 11:19:24 +0100
Message-ID: <20241112101901.115325013@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ca61d6836e6f4442a77762e1074d2706a2a6e578 ]

Some SCM calls can be invoked with __scm being NULL (the driver may not
have been and will not be probed as there's no SCM entry in device-tree).
Make sure we don't dereference a NULL pointer.

Fixes: 449d0d84bcd8 ("firmware: qcom: scm: smc: switch to using the SCM allocator")
Reported-by: Rudraksha Gupta <guptarud@gmail.com>
Closes: https://lore.kernel.org/lkml/692cfe9a-8c05-4ce4-813e-82b3f310019a@gmail.com/
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Tested-by: Rudraksha Gupta <guptarud@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Kuldeep Singh <quic_kuldsing@quicinc.com>
Link: https://lore.kernel.org/r/20240930083328.17904-1-brgl@bgdev.pl
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 0f5ac346bda43..a50d8e8d0f1b8 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -207,7 +207,7 @@ static DEFINE_SPINLOCK(scm_query_lock);
 
 struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(void)
 {
-	return __scm->mempool;
+	return __scm ? __scm->mempool : NULL;
 }
 
 static enum qcom_scm_convention __get_convention(void)
-- 
2.43.0



