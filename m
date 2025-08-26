Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB11A7260F;
	Tue, 26 Aug 2025 12:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212842; cv=none; b=t7NbtkpZxW7w2i9TcqyBQuJcnRXKCBn70H0RfTkOokrINu7HF4whWXwADYVTRbeMAGkpGQMTUKygV8BsDoRB9DW9wZLqzGmzGPg6mXyhPpqxFJlA9Wbrjwq1iD90A+u7xfmkCDK33sqB45PL1wqg+cPJd3v5KD3LfDPlBccJch4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212842; c=relaxed/simple;
	bh=GK34UdY/iArNBjSSNrM0LyHbmT5dnDeucLrq8yGI+Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNMlCZTA0r2ApJ6jZtx3LAFBmH09ge0zjflf/jiRpbAPUSQ9Zzl7ePeOppLK+aBbNo0VmNVLO0A+0Gm23e7UJ+HXetaWxqF4EUchqTACQf+5uNQWT8zGBjYq4fZqwSMotph3QQXRREhT7mkZToRxOrhG7Ph4aR3rRTEXiEmZbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aztzSpqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aztzSpqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D98C4CEF1;
	Tue, 26 Aug 2025 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212841;
	bh=GK34UdY/iArNBjSSNrM0LyHbmT5dnDeucLrq8yGI+Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aztzSpqAFF5YOxollKx7ad2RdVLvpebZ9NHaX6zAmc8wp0rwtS9elaosDH2JatkBr
	 s0FP4GDYr+xsYhq1AqgdMKaRL8qr8MO1XGIgPTdY88MtNu1EuehbJG7dnv8pRVDGdF
	 pcGpjTYmHtyL3XsBUS5Wi1KcBBjnGfqlyUBgOxfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/587] soc: qcom: rpmh-rsc: Add RSC version 4 support
Date: Tue, 26 Aug 2025 13:04:00 +0200
Message-ID: <20250826110955.250590548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 84684c57c9cd47b86c883a7170dd68222d97ef13 ]

Register offsets for v3 and v4 versions are backward compatible. Assign v3
offsets for v4 and all higher versions to avoid end up using v2 offsets.

Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250623-rsc_v4-v1-1-275b27bc5e3c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index dfc2d4e38fa9..163a58eb02e0 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -1075,7 +1075,7 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 	drv->ver.minor = rsc_id & (MINOR_VER_MASK << MINOR_VER_SHIFT);
 	drv->ver.minor >>= MINOR_VER_SHIFT;
 
-	if (drv->ver.major == 3)
+	if (drv->ver.major >= 3)
 		drv->regs = rpmh_rsc_reg_offset_ver_3_0;
 	else
 		drv->regs = rpmh_rsc_reg_offset_ver_2_7;
-- 
2.39.5



