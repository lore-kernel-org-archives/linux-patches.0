Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED81F1A617E;
	Tue, 30 Jul 2024 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356382; cv=none; b=b80rIa4B4f5+23lpLeWQQE+F619jIzAD1BWJzVRlWQHhB/VYc4uIDVi5sEKArZ31gWV9lVMjAGLPikoZzs5gmetJ+uzWUdR6pK6sAM6TWE6R3GVQMKOogcT0LtyjdJLsNjkYQT2cZlHVp9qUtDkJ3zTQR1DUBRHQ0EbuAWNhbDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356382; c=relaxed/simple;
	bh=8s1sPz5DNIQp8JfCYQEpo2fqBKj+fvRCa9EcBnAqrKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EezqnynI+XnX7sJj8Y2e0FJ7YMF64u4L15Qt1+Ib+lMQmGHtWW3EGhTSIZrRq2mUGrl2yggNq0dCMwyZR/ZzWC/9YVuBiddpMaM5lj0+mamQebV/G9uat7JgG04nlZGDMXjXjvfz4aeKud2ltLrB4K0Wf++VrSVVGn3w39Z767M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHNjQvAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHNjQvAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC69C32782;
	Tue, 30 Jul 2024 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356381;
	bh=8s1sPz5DNIQp8JfCYQEpo2fqBKj+fvRCa9EcBnAqrKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHNjQvAqEQtWrRtdKCiyJU48tDvdiw169TYiVl+V5+eo4aszXcQ5Jw/3wtLV9NbzK
	 +0pFClpHn57XfLpwdMqtB+kHpSve3CLHMi2DtbYc1EndhRaYdYRpuR4BJM0mS2CPQS
	 xEn4JpaTugHF2kHkPXb3l2p51lnQP1NWiKT/kI4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/568] wifi: rtw89: 8852b: fix definition of KIP register number
Date: Tue, 30 Jul 2024 17:44:10 +0200
Message-ID: <20240730151645.467809506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 2f35712ab82683554c660bc2456f05785835efbe ]

An incorrect definition caused DPK to fail to backup and
restore a set of KIP registers. Fixing this will improve
RX throughput from 902 to 997 Mbps.

Fixes: 5b8471ace5b1 ("wifi: rtw89: 8852b: rfk: add DPK")
Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240621123617.6687-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
index 259df67836a0e..a2fa1d339bc21 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
@@ -20,7 +20,7 @@
 #define RTW8852B_RF_REL_VERSION 34
 #define RTW8852B_DPK_VER 0x0d
 #define RTW8852B_DPK_RF_PATH 2
-#define RTW8852B_DPK_KIP_REG_NUM 2
+#define RTW8852B_DPK_KIP_REG_NUM 3
 
 #define _TSSI_DE_MASK GENMASK(21, 12)
 #define ADDC_T_AVG 100
-- 
2.43.0



