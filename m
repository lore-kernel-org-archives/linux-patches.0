Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE94341645;
	Tue, 16 Dec 2025 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884124; cv=none; b=oQdFwMuMhB3Qo6xkG9YBlcnV8qa4Co/HTBYhVEtH0QZsNl0eXHTHNkaYMzorqT99Vp5mdUdbjgZiqWi55NeYosd30Fij6U0PV9AydprIkwzLvq2kY2c5nEA0Hlcp7IMGs3tGfziOH7n/zpa989EFZ3mXO1andrz4aftl3lJ1NCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884124; c=relaxed/simple;
	bh=bjhvss62HsBeuoYowWj9Ei6I5iMix6IIrkx1JHaBt4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn0s4l53TIqof7uy00UM2oTuv9MTzO2b2I9g+2TxFrSieS9YVmctFCAGxHF3G8h6koHJlyA2fO/NJsyuHYj043cdDkKWqJxTU5QIsuoxRJjpa2mNpFHwRDODqJBE0+jr65BwbIYLUoI6LjlyvD8jFQE5C9CS7chd3G/vdJvOS24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQHUgkIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQHUgkIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECECC4CEF5;
	Tue, 16 Dec 2025 11:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884124;
	bh=bjhvss62HsBeuoYowWj9Ei6I5iMix6IIrkx1JHaBt4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQHUgkIwmlxi0xc1xuUwFCRq/MdNPS1gXH11uXiqfzGMN9HcywI8BchMbFgedm2E0
	 20EPHJ0Q20gF6PyTc2V/r7/3kNvCTwW4f7w2DbD9SqoGN039g0lS4AKKYYrQSCjyKv
	 I19OmsftrG0ZAKm2rlfMpBPnwFxHTfLTlHJbfmLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/354] interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS
Date: Tue, 16 Dec 2025 12:11:04 +0100
Message-ID: <20251216111324.434965148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 8cf9b43f6b4d90e19a9341edefdd46842d4adb55 ]

>From the initial submission the interconnect driver missed the link from
SNOC_PNOC to the USB 2 configuration space. Add missing link in order to
let the platform configure and utilize this path.

Fixes: 7add937f5222 ("interconnect: qcom: Add MSM8996 interconnect provider driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251002-fix-msm8996-icc-v1-1-a36a05d1f869@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/msm8996.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/msm8996.c b/drivers/interconnect/qcom/msm8996.c
index 788131400cd13..6c8c6e974c811 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -552,6 +552,7 @@ static struct qcom_icc_node mas_venus_vmem = {
 static const u16 mas_snoc_pnoc_links[] = {
 	MSM8996_SLAVE_BLSP_1,
 	MSM8996_SLAVE_BLSP_2,
+	MSM8996_SLAVE_USB_HS,
 	MSM8996_SLAVE_SDCC_1,
 	MSM8996_SLAVE_SDCC_2,
 	MSM8996_SLAVE_SDCC_4,
-- 
2.51.0



