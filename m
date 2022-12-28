Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5EC1C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C81C433D2;
	Wed, 28 Dec 2022 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246185;
	bh=6gnQhmIdBmF6JNfN99H/3Ivsv7fp+DBKABhVpVZqLSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O88LKliQDLDo5gtArI7W4VSiQnV6/IfkHWkcwTCrkX6JS23wuTUGgvwZ4wiPrJKdu
	 eAFK0WZUJdasu46s5RP9wcFedQzM+M/GCtVs04ei95yvNF9VzG27y8KXaJFThDogu0
	 0o55lHRQiKFpiyhkwov1teSa1LV6T3Xca2j/U/6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1026/1073] Input: iqs7222 - trim force communication command
Date: Wed, 28 Dec 2022 15:43:34 +0100
Message-Id: <20221228144356.059597201@linuxfoundation.org>
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

[ Upstream commit 10e629d31aacb2348a1e9110c31a29e98b31ce38 ]

According to the datasheets, writing only 0xFF is sufficient to
elicit a communication window. Remove the superfluous 0x00 from
the force communication command.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220908131548.48120-6-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 0b2bf471b3a0..6af25dfd1d2a 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -1077,7 +1077,7 @@ static int iqs7222_hard_reset(struct iqs7222_private *iqs7222)
 
 static int iqs7222_force_comms(struct iqs7222_private *iqs7222)
 {
-	u8 msg_buf[] = { 0xFF, 0x00, };
+	u8 msg_buf[] = { 0xFF, };
 	int ret;
 
 	/*
-- 
2.35.1



