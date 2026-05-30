Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2339B192D97;
	Sat, 30 May 2026 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159792; cv=none; b=qg+emUytwo1mN0Cswa4hwpabGQqvrq5RUE5NhlNfrb8TWMtidbTczHn3Av1YcxqMShqwsvVM6X1jqLhxPdJ9BwXgWi8DUBkDPoGPt+GpkJ8j0hBxAX7aEu/ddDFkfsxprOFKmcC90LAElxvLisiCqbCHSsn7ymenlTjnHcYBm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159792; c=relaxed/simple;
	bh=ofgWrxuzg1ci1BIWVorf9ZLSE0l5tHUVYNObtXW2Tt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hC/oSHZOjdi75yEHfDp1f2TG1JKcMx68b0qcnfFuKJSubV2djRIfFsbVQTe/2RxHzA27K8GZTDtksNTbfIIeZ341XQOORu4Wk0IW4ACA/ddrJ32+Ce36ItPBI2nkKfR90SRyeIIYvmvXMGC5h45BwIWGRMyNwOVag9z8JiDChJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/l/CNNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/l/CNNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174BB1F00893;
	Sat, 30 May 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159791;
	bh=k8R2pSHMRWmB2JwYbWKOcr+aEYhN8J/H8k+HrcIHe1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/l/CNNwWChla/0CY4dIJinFASH0mRkJVlY/2qRDGeM7sfDjmtoG6hHLKqSVEXnCR
	 HQCShJESRCMJGv1mJLMk6FdbFYR7GuYEONX+6Nnpr8IuH7ExYwQ9JkQCds4wZ9bFol
	 lJYRdCf7+ulCjdmNnpraZkhcO96PStRs3cjBRhQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <set_pte_at@outlook.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/969] soc: qcom: apr: make remove callback of apr driver void returned
Date: Sat, 30 May 2026 17:54:16 +0200
Message-ID: <20260530160304.213651030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit 33ae3d0955943ac5bacfcb6911cf7cb74822bf8c ]

Since commit fc7a6209d571 ("bus: Make remove callback return void")
forces bus_type::remove be void-returned, it doesn't make much sense
for any bus based driver implementing remove callbalk to return
non-void to its caller.

As such, change the remove function for apr bus based drivers to
return void.

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/TYCP286MB23232B7968D34DB8323B0F16CAFB9@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
Stable-dep-of: 6ec1235fc941 ("ASoC: qcom: q6apm: move component registration to unmanaged version")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/soc/qcom/apr.h  |    2 +-
 sound/soc/qcom/qdsp6/q6core.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/soc/qcom/apr.h
+++ b/include/linux/soc/qcom/apr.h
@@ -153,7 +153,7 @@ typedef struct apr_device gpr_device_t;
 
 struct apr_driver {
 	int	(*probe)(struct apr_device *sl);
-	int	(*remove)(struct apr_device *sl);
+	void	(*remove)(struct apr_device *sl);
 	int	(*callback)(struct apr_device *a,
 			    struct apr_resp_pkt *d);
 	int	(*gpr_callback)(struct gpr_resp_pkt *d, void *data, int op);
--- a/sound/soc/qcom/qdsp6/q6core.c
+++ b/sound/soc/qcom/qdsp6/q6core.c
@@ -339,7 +339,7 @@ static int q6core_probe(struct apr_devic
 	return 0;
 }
 
-static int q6core_exit(struct apr_device *adev)
+static void q6core_exit(struct apr_device *adev)
 {
 	struct q6core *core = dev_get_drvdata(&adev->dev);
 
@@ -350,8 +350,6 @@ static int q6core_exit(struct apr_device
 
 	g_core = NULL;
 	kfree(core);
-
-	return 0;
 }
 
 #ifdef CONFIG_OF


