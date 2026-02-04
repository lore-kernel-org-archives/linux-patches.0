Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20E34218A0;
	Wed,  4 Feb 2026 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217855; cv=none; b=smsf8T0kZuytX4Dy+qg0otIumHaJDyK61moIeTdGpIi1lEf+/YW5ejAN0nYKedSwWUZ3q8W0KFvhfEH+2+lxCoHk/fB3U4FxSC4vVTKC03RDj3uCmcHGLspcpAFFa7hvP2Rp006uD2zF57ieDIM7E+a5MXy88TCbsicTsPJac3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217855; c=relaxed/simple;
	bh=+KOEUkanwSW0gfoMak+z5SnyI0udYqrH+cDKa5+KPn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO0h05RyVr1Em4WsildE3UagicZwRYkVXyjfACGUZlMnvK6diiAmsJAc7ixrGB8DP0mDEMTaVT1f/doEmCnRnwVTeO0cP0GUuDsQ8SaDQ4vUv08/ga6rhpo1BaOP1az6/3URvOcNAFw7QxDPEl59XUrZUrWBbfUhKW1j5l956qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyjQqBB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyjQqBB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC96C4CEF7;
	Wed,  4 Feb 2026 15:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217855;
	bh=+KOEUkanwSW0gfoMak+z5SnyI0udYqrH+cDKa5+KPn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyjQqBB1PS63Vz9ZDWlDKAOtiYhKFM/1hAzLk1iRJQNTOstV+ADOXYEPZEpFuSF+j
	 Gku7qKXAEXUqfD76NvOmnCFde5Irog519kDfS5woKv3srN7INiyAS5OlSp+05NNipX
	 wCfEP7bSa/FzXms4VeOmFCEMYZUnv2CW5Y18s7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/280] net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M
Date: Wed,  4 Feb 2026 15:38:34 +0100
Message-ID: <20260204143914.674559765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit d57c67c956a1bad15115eba6e59d77a6dfeba01d ]

HCLGE_FD_AD_COUNTER_NUM_M should be at GENMASK(19, 13),
rather than at GENMASK(20, 13), because bit 20 is
HCLGE_FD_AD_NXT_STEP_B.

This patch corrects the wrong definition.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260119132840.410513-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 43cada51d8cb3..0b9d3fc749b95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -731,7 +731,7 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
-#define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(20, 13)
+#define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(19, 13)
 #define HCLGE_FD_AD_NXT_STEP_B		20
 #define HCLGE_FD_AD_NXT_KEY_S		21
 #define HCLGE_FD_AD_NXT_KEY_M		GENMASK(25, 21)
-- 
2.51.0



