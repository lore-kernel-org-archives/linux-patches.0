Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A941C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DE7C433EF;
	Wed, 28 Dec 2022 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246159;
	bh=+2w6wsYm1BRXB2I+p+whmvk5bYN+HVXCCZCWA0xuGv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kxncbcm+Z+eCqShUuUKHVlDbkKAhDHh2jPy0uj0EYzBtbwMzEmd/KzgWCdkUHeFRc
	 pOttfZMDeZwiujZ+nw7/IUJcmMDbDt7shC3htGid4NsN18+wL811v239PlbQsouNLN
	 3jMKyCaR0ydpVxWWARUE1/4nno1+9+h297r6J+W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1022/1073] Input: iqs7222 - avoid sending empty SYN_REPORT events
Date: Wed, 28 Dec 2022 15:43:30 +0100
Message-Id: <20221228144355.949709076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 514c13b1faed74e9bc19061b6d7c78d53a3402ba ]

Add a check to prevent sending undefined events, which ultimately
map to SYN_REPORT.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220908131548.48120-7-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 8fd665874a24..0b2bf471b3a0 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2314,6 +2314,9 @@ static int iqs7222_report(struct iqs7222_private *iqs7222)
 			int k = 2 + j * (num_chan > 16 ? 2 : 1);
 			u16 state = le16_to_cpu(status[k + i / 16]);
 
+			if (!iqs7222->kp_type[i][j])
+				continue;
+
 			input_event(iqs7222->keypad,
 				    iqs7222->kp_type[i][j],
 				    iqs7222->kp_code[i][j],
-- 
2.35.1



