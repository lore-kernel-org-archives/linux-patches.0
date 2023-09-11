Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3911715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECC1C433CD;
	Mon, 11 Sep 2023 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444903;
	bh=HnzCwk8zmP35daZztYxiZo5c//NRi067XQvL7WcH1A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yYmTh8b+XJREPPE+bYP8hGX4cG4g1yhiZ27OVjqfEB5euIJNxWYaR1jSrJHWWeum
	 CTIue4JAa9UmcglqORtjhWTB0w9xMf7j5clXZcK2g6PooJ0gGb8QPKjluPmZ3gXc8I
	 n0ZiES9qYUsNR6rj3DMLy9A9swVw+Gf94Y5/0x28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/600] wifi: mt76: testmode: add nla_policy for MT76_TM_ATTR_TX_LENGTH
Date: Mon, 11 Sep 2023 15:43:09 +0200
Message-ID: <20230911134638.215901120@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 74f12d511625e603fac8c0c2b6872e687e56dd61 ]

It seems that the nla_policy in mt76_tm_policy is missed for attribute
MT76_TM_ATTR_TX_LENGTH. This patch adds the correct description to make
sure the

  u32 val = nla_get_u32(tb[MT76_TM_ATTR_TX_LENGTH]);

in function mt76_testmode_cmd() is safe and will not result in
out-of-attribute read.

Fixes: f0efa8621550 ("mt76: add API for testmode support")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/testmode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/testmode.c b/drivers/net/wireless/mediatek/mt76/testmode.c
index 0accc71a91c9a..4644dace9bb34 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/testmode.c
@@ -8,6 +8,7 @@ const struct nla_policy mt76_tm_policy[NUM_MT76_TM_ATTRS] = {
 	[MT76_TM_ATTR_RESET] = { .type = NLA_FLAG },
 	[MT76_TM_ATTR_STATE] = { .type = NLA_U8 },
 	[MT76_TM_ATTR_TX_COUNT] = { .type = NLA_U32 },
+	[MT76_TM_ATTR_TX_LENGTH] = { .type = NLA_U32 },
 	[MT76_TM_ATTR_TX_RATE_MODE] = { .type = NLA_U8 },
 	[MT76_TM_ATTR_TX_RATE_NSS] = { .type = NLA_U8 },
 	[MT76_TM_ATTR_TX_RATE_IDX] = { .type = NLA_U8 },
-- 
2.40.1



