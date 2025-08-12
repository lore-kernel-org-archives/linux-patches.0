Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAD9260583;
	Tue, 12 Aug 2025 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025503; cv=none; b=LnfGaLcOBRxQ/iNsEg47OxCsG2q5IMWvlhRG6ep44ex0fWPC2tZzc1gHqm/O57tY90tB30fVOZNJCmvLOpA0pBAO+yOYhfOAdYWxIb2C0KE8qPB8RlZUnHJcWm5azhvewX48LKOUAsNT8qF7yWhPBjJY4AT/RwIUbru4JURwefk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025503; c=relaxed/simple;
	bh=rSBvEJE4kHCLBF9jsWxMm+4gtPJyjkN/13575wSzzak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLQSU1Acxw4079fDp5NesFrRogVzY8JwgxKejzvTu6YOKHdAWPeTD2I3WI69vMnZEfDDLvk4byIvpU4A1peSCy24SeuHMzuGUbHs5HyjnZp24SP/7ofk6agbf127llChk/wf0ZtMwbmw/0DCTTOKDxfTV2uQSwxCbhIx88gHOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIiO3d09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIiO3d09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4BFC4CEF0;
	Tue, 12 Aug 2025 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025503;
	bh=rSBvEJE4kHCLBF9jsWxMm+4gtPJyjkN/13575wSzzak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIiO3d092I23sNU3UhSqpHSM5rygLekOUM7KGRjZ6cDDXxxMc72PWHcOZiRoNcOm7
	 vnTmgrKqn9w6fSG/6uiADR1d8eMw9qkYLhTyefTWoC2JRUtX+lU83+1Iyqk56Rt47Z
	 a40a5/xJKS2+yrdYLylAWJ6c64App3FxqlhLg99k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 060/480] power: sequencing: qcom-wcn: fix bluetooth-wifi copypasta for WCN6855
Date: Tue, 12 Aug 2025 19:44:28 +0200
Message-ID: <20250812174359.894622045@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 07d59dec6795428983a840de85aa02febaf7e01b ]

Prevent a name conflict (which is surprisingly not caught by the
framework).

Fixes: bd4c8bafcf50 ("power: sequencing: qcom-wcn: improve support for wcn6855")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250625-topic-wcn6855_pwrseq-v1-1-cfb96d599ff8@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/sequencing/pwrseq-qcom-wcn.c b/drivers/power/sequencing/pwrseq-qcom-wcn.c
index e8f5030f2639..7d8d6b340749 100644
--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -155,7 +155,7 @@ static const struct pwrseq_unit_data pwrseq_qcom_wcn_bt_unit_data = {
 };
 
 static const struct pwrseq_unit_data pwrseq_qcom_wcn6855_bt_unit_data = {
-	.name = "wlan-enable",
+	.name = "bluetooth-enable",
 	.deps = pwrseq_qcom_wcn6855_unit_deps,
 	.enable = pwrseq_qcom_wcn_bt_enable,
 	.disable = pwrseq_qcom_wcn_bt_disable,
-- 
2.39.5



