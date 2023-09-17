Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE5D6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9A6C433C7;
	Sun, 17 Sep 2023 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978541;
	bh=TDk+9EUg8oiRJcmpitO3eBZv1qnb2ZaB1mB/jCmxInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDw1lCZ7TEleIVID5zcCVBKERehL3d970VAegr7VnSzqnfU8Acb9KILxalGvLHYVU
	 pEIZgW5zy9Ew9ubd9jqn2HBac8jGccHssy+S3eh09qPDwJU+59uLYT4zkMKlXiBOOp
	 5kIXOyCW6MAYmcnvAwEy4fOH1+f88vOf20+f/r+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/406] wifi: mt76: testmode: add nla_policy for MT76_TM_ATTR_TX_LENGTH
Date: Sun, 17 Sep 2023 21:09:03 +0200
Message-ID: <20230917191103.480691328@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 883f59c7a7e4a..7ab99efb7f9b0 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/testmode.c
@@ -6,6 +6,7 @@ static const struct nla_policy mt76_tm_policy[NUM_MT76_TM_ATTRS] = {
 	[MT76_TM_ATTR_RESET] = { .type = NLA_FLAG },
 	[MT76_TM_ATTR_STATE] = { .type = NLA_U8 },
 	[MT76_TM_ATTR_TX_COUNT] = { .type = NLA_U32 },
+	[MT76_TM_ATTR_TX_LENGTH] = { .type = NLA_U32 },
 	[MT76_TM_ATTR_TX_RATE_MODE] = { .type = NLA_U8 },
 	[MT76_TM_ATTR_TX_RATE_NSS] = { .type = NLA_U8 },
 	[MT76_TM_ATTR_TX_RATE_IDX] = { .type = NLA_U8 },
-- 
2.40.1



