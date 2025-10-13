Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B72248A5;
	Mon, 13 Oct 2025 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367566; cv=none; b=cWbmip9tcUPgiCZ43sfmYvfXJ61QAqZ6BLTEjhg3VKwiavX2lP96cHdxq3s1xqQ/YDloaSb5iyP6bjWt3HcYtCqgTFGROEXkPH8VgYVldA76RVWR2wi0DuuPfBhG/5VIKyQkgBrwVGWYCTD7jREwtuWkHBJTGZiCTcZpLDDDIFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367566; c=relaxed/simple;
	bh=1UTQFgpw2MrrYKzUHdIZid8TNIAQZIhakzYqtn53Wvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFRq/uqjjT6Z8JhoBPCRYgOpyt4cw8WSGezj9TV1Fsv7i6Qb5YZjxIwZqYz44OBw1luI2PXBg/GNBpNhIAz5CMJ5XIgyoFjOxAiwKGLOQC3u/4JQiBtkMZDyKCiOssltojXVJMAHYxkX3NIPVN2eQpHfNsKdpruh4XbqHdvuzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJT5B1BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJT5B1BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED107C4CEFE;
	Mon, 13 Oct 2025 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367566;
	bh=1UTQFgpw2MrrYKzUHdIZid8TNIAQZIhakzYqtn53Wvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJT5B1BNbTfeLZR7uMgA+3DClR1fjtPE9F3gUHUUjmofQAk8iwZXFsec2D+s/GWE5
	 4XmUhYJxRJbYb/3pEAUCew5Pt40C4oMQ3N7cPb0PxTzKjm/oRoGLPIYpkhvPRqNgKW
	 PCtdFJQcoQtX+N2KXluykaOw6Yq2Fv+T3uR/H3Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/196] thermal/drivers/qcom: Make LMH select QCOM_SCM
Date: Mon, 13 Oct 2025 16:44:07 +0200
Message-ID: <20251013144317.225078801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c7f3f9a26ebb..a6bb01082ec69 100644
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



