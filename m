Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F73330B1E;
	Fri, 17 Oct 2025 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716028; cv=none; b=MXu/XyfJ78IcJdmNRNtG/Gf/YIZRx5oUH4VCP6iby+XnuOLEk8S+JJ+LnlVJTMblg6UOJeSdguDECcuVAPUA3hDuzbQjYlRpI5OgGkRSciV4NQq4fE2S0mkz93Gi3kMCTjZr7OLnSEm0ew79aT7A4zV3qYN2wc3reYsO4NH6tBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716028; c=relaxed/simple;
	bh=f9jpA9tmR5Fk1DoQhtXdGkrWMLhUJkDHm3hrDxawWtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPkbeH6eZEgZmEX5RHn3b27aUxOZGgGdnTYhLMdmXVuD9GAVbmGWMDpFcd8wWNo+qeZLgjEx3m5jCylNdCFghayVtHkAqOaE+qk27IFjeseex0VbJPNy1VRRRxmcz2fcaJlZcahxSuw7FY2B3Q43ab5ZFdawGpLIPKY+jUDCU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGiukmTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGiukmTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59896C113D0;
	Fri, 17 Oct 2025 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716028;
	bh=f9jpA9tmR5Fk1DoQhtXdGkrWMLhUJkDHm3hrDxawWtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGiukmTm7pypepWkQbVdYEyGIbKmBy8M7nKSRevdRH0pWN8F3Ky9FdSjiGBX0Hmp2
	 bSfLZQOK+tbBnngEiQRelqd4aKePyLEIeE0D8ENjEK3GB4UZCvexjefvXBTmHCYinN
	 y5rZxeNdXPuUqF9lzeSZbN1xdx8Ou6BxJLsLsD1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/276] thermal/drivers/qcom: Make LMH select QCOM_SCM
Date: Fri, 17 Oct 2025 16:52:22 +0200
Message-ID: <20251017145144.280184911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 57eda47bd14b0c2876f2db42e757c57b7a671965 ]

The QCOM_SCM symbol is not user-visible, so it makes little sense to
depend on it. Make LMH driver select QCOM_SCM as all other drivers do
and, as the dependecy is now correctly handled, enable || COMPILE_TEST
in order to include the driver into broader set of build tests.

Fixes: 9e5a4fb84230 ("thermal/drivers/qcom/lmh: make QCOM_LMH depends on QCOM_SCM")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20250728-lmh-scm-v2-1-33bc58388ca5@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/Kconfig b/drivers/thermal/qcom/Kconfig
index bfd889422dd32..22cd3d5384910 100644
--- a/drivers/thermal/qcom/Kconfig
+++ b/drivers/thermal/qcom/Kconfig
@@ -34,7 +34,8 @@ config QCOM_SPMI_TEMP_ALARM
 
 config QCOM_LMH
 	tristate "Qualcomm Limits Management Hardware"
-	depends on ARCH_QCOM && QCOM_SCM
+	depends on ARCH_QCOM || COMPILE_TEST
+	select QCOM_SCM
 	help
 	  This enables initialization of Qualcomm limits management
 	  hardware(LMh). LMh allows for hardware-enforced mitigation for cpus based on
-- 
2.51.0



