Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB666FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629FCC433D2;
	Mon,  3 Apr 2023 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532377;
	bh=l+4mpfCWzP6k9cRkje+AxQpyYqqxzIFPOPM/y41iRMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u85dMiklt7vWr9td9bfqwIHDHq8EtST8eVQs0uVvSCDNEIHJy/LS/lUgRyvhITnvR
	 ToRD1gZCzKf5hUlJ6QC7zPBfGoB6qAYwtaw07es5jckG/H3trF015Hnd4S/fHeSDnb
	 OSrIZgjdhKoDpcR893EsyVr7N2pWjso9diMt+gZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/99] bnxt_en: Add missing 200G link speed reporting
Date: Mon,  3 Apr 2023 16:09:23 +0200
Message-Id: <20230403140405.676594740@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 581bce7bcb7e7f100908728e7b292e266c76895b ]

bnxt_fw_to_ethtool_speed() is missing the case statement for 200G
link speed reported by firmware.  As a result, ethtool will report
unknown speed when the firmware reports 200G link speed.

Fixes: 532262ba3b84 ("bnxt_en: ethtool: support PAM4 link speeds up to 200G")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e5874c829226e..ae4695fc067d5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1202,6 +1202,7 @@ struct bnxt_link_info {
 #define BNXT_LINK_SPEED_40GB	PORT_PHY_QCFG_RESP_LINK_SPEED_40GB
 #define BNXT_LINK_SPEED_50GB	PORT_PHY_QCFG_RESP_LINK_SPEED_50GB
 #define BNXT_LINK_SPEED_100GB	PORT_PHY_QCFG_RESP_LINK_SPEED_100GB
+#define BNXT_LINK_SPEED_200GB	PORT_PHY_QCFG_RESP_LINK_SPEED_200GB
 	u16			support_speeds;
 	u16			support_pam4_speeds;
 	u16			auto_link_speeds;	/* fw adv setting */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9ac5f63784960..bc9812a0a91c3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1670,6 +1670,8 @@ u32 bnxt_fw_to_ethtool_speed(u16 fw_link_speed)
 		return SPEED_50000;
 	case BNXT_LINK_SPEED_100GB:
 		return SPEED_100000;
+	case BNXT_LINK_SPEED_200GB:
+		return SPEED_200000;
 	default:
 		return SPEED_UNKNOWN;
 	}
-- 
2.39.2



