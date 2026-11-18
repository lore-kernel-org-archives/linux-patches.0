Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048955;
	b=reIlZy+cWafI38IPMyNwgVWjO5mAHk6n7mj6pflKnwTkqs45ujAlIWf8HhQTr+COhgDS
	 Ff9s2Y5BX9TkJ5DfPCVnbAEPhs4SQOi37m+JMkXs0cY3XrJ1uHRVesvptnfbwkk3q7mnx
	 AhiK0MpX5U3T3ezN/MkM5w69oDC5ckFWucq7sTX7WOoYr70iJO8SxqvQzjROY0aaU6QjH
	 RaDw5OHKgb1/LyQ11NA3I4d6hPan68poM0Lno9qhYLVF17mWVeeyzKuhkpyW5aSXtgT+x
	 +atx9aMqjPH9Co9ux4jJ8BXqD9toz0bYUgPCkme3Bmg9uKYtVDEsbMO+62orPhBfQ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hVaveDjrMr6Gd4oc1E1vpn/Hqb0Ry4AfHznGJZsCFCY=;
	b=km5ADfV+Nvj4h5cs3OVyv7uLEJOwnx2ThJi4BiNlj8YD35y6LhwgTi4JnXxWHDT/8EsD
	 OoRPW11PA4yS9Q+fV8KuUjDoY5sMnKtPp8ydWk/f8ke7zIGKnxgQSjK6/U1M/KslKZa9j
	 UdekdQ7vOJly0tI/hXXCiBT0Bz3PhaYwV9wb6dIft2kmJG37YzVwVUYBgM3MBEsO4OrO4
	 6cXHldH6MN/FEWgqqpn3aICkwBPrX9z5tk63c3+Qyn4Y2m9//frj56vaDXf5TtAqPo+Mw
	 7U8kmtLRkiv/7RzXqnn8L4Nc5EStKsTkxZ8sId9csXb/R+yEdOhoop+BRAIcxNmkzBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O0H2A/zC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AD7606A320;
	Thu, 19 Nov 2026 00:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0H2A/zC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93671F000C4;
	Thu, 19 Nov 2026 00:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048955;
	bh=hVaveDjrMr6Gd4oc1E1vpn/Hqb0Ry4AfHznGJZsCFCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0H2A/zCgKpZlI9+Ok/FsK6lj7zSxJY8Da9HlFQGAGrK9CFyZ1F0P9LW4R+P8t/g7
	 P02FOt4aFlaLnQzPG7cwJdZLFw4tvtwn28ttcEI7iltB/qSEQI8BvSzRtAgYSKKcCC
	 arzVWzCrWSByY1sV7RmbCfdHmBu7ZQtEpJ7w2wYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2180/2857] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:53:34 +0100
Message-ID: <20261118150319.897697219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 8f30b035a6676e292ee8e54334711d9905dd0495 ]

Return -ENOMEM if of_iomap() fails, before reading or configuring
the timer register block.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 9d2aa8c7961a ("ARM/clocksource: use automatic DT probing for ux500 PRCMU")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260911060917.94310-1-bolin.liu@seu.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 2fc93e46cea38..1af223b0e8963 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -52,6 +52,8 @@ static struct clocksource clocksource_dbx500_prcmu = {
 static int __init clksrc_dbx500_prcmu_init(struct device_node *node)
 {
 	clksrc_dbx500_timer_base = of_iomap(node, 0);
+	if (!clksrc_dbx500_timer_base)
+		return -ENOMEM;
 
 	/*
 	 * The A9 sub system expects the timer to be configured as
-- 
2.53.0



