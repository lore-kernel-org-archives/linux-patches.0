Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6E23F417;
	Fri,  9 Jan 2026 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961612; cv=none; b=jzr95FQUh7KVxJ9ijGpKHAIfukTRLVAl3g5gyqqo/SmDpxP5s8rbeNFGTYkOvqdr8ywEQGqDPmCfze7Hr3xzIHBesIuHPhaua5A2CT7qkI5BN/nAqcOzlrrM1As1uhxgu1dtywNy4LGOHkS9vJJDzK8QdBhVLwuRlFzTQcVos78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961612; c=relaxed/simple;
	bh=zI+ZZy6kKvYPAObYhXkGldmoCguEYNHPg7eOo7iQv0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrjcpkznDKSxG3vLOvQJX4P3QA48+mtNvNwA4nzq+rGEorGzlJh/sOS/yO+QyFerjAsC8WBEvLw+Dni2f3LivD8dNurbdjUGg8MnRlTcT8fbkvMjRcXmOLlxW47NnA75Pcn77d1MIz+i3P3brmjqFn8XUayntqFyxT3geD+92zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyKX/Dzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyKX/Dzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBCDC4CEF1;
	Fri,  9 Jan 2026 12:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961612;
	bh=zI+ZZy6kKvYPAObYhXkGldmoCguEYNHPg7eOo7iQv0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyKX/DztJv7IW8pqdt1IxHMclll5/StSTlYFhgcAwETtPWvecyNHhz9JOgrwLGJj3
	 hkKBWmQ3Xak4EPtvCj+6vrgBCNzvdil3jh3iVwHDIElJLDvZmU/jKaVRQwIK/zdsoj
	 U4dem2cq3z1FoLiNj0kx3zT7DM13cyLsSm8solC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/634] interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS
Date: Fri,  9 Jan 2026 12:35:54 +0100
Message-ID: <20260109112120.301228449@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 14efd2761b7ab..680d7e56d6a7f 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -557,6 +557,7 @@ static struct qcom_icc_node mas_venus_vmem = {
 static const u16 mas_snoc_pnoc_links[] = {
 	MSM8996_SLAVE_BLSP_1,
 	MSM8996_SLAVE_BLSP_2,
+	MSM8996_SLAVE_USB_HS,
 	MSM8996_SLAVE_SDCC_1,
 	MSM8996_SLAVE_SDCC_2,
 	MSM8996_SLAVE_SDCC_4,
-- 
2.51.0



