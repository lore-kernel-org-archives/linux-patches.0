Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6A8611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E4C433EF;
	Sun, 28 May 2023 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301680;
	bh=J2LPz9DRRovs+mSnt/Zr/PIg1UYidc4u/Q0GZgj6oAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKwdimJcWfSiEDl6PJi/kt+DlhRYbYz2YOXjqfCNPrLjzRyhfDDGzjih0ktpuKfUv
	 5CmxhPSCY8cknLxT5338YSQIxYBmTq8Kjv7GqWV1f7705hfB/Ay8iBPB6NphBJ0cA5
	 5gVPagEQzHmi30W/+Mm2ikbP6LfeKil15ClEaV7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 126/132] power: supply: sbs-charger: Fix INHIBITED bit for Status reg
Date: Sun, 28 May 2023 20:11:05 +0100
Message-Id: <20230528190837.719684181@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daisuke Nojiri <dnojiri@chromium.org>

commit b2f2a3c9800208b0db2c2e34b05323757117faa2 upstream.

CHARGE_INHIBITED bit position of the ChargerStatus register is actually
0 not 1. This patch corrects it.

Fixes: feb583e37f8a8 ("power: supply: add sbs-charger driver")
Signed-off-by: Daisuke Nojiri <dnojiri@chromium.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/sbs-charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/sbs-charger.c
+++ b/drivers/power/supply/sbs-charger.c
@@ -29,7 +29,7 @@
 #define SBS_CHARGER_REG_STATUS			0x13
 #define SBS_CHARGER_REG_ALARM_WARNING		0x16
 
-#define SBS_CHARGER_STATUS_CHARGE_INHIBITED	BIT(1)
+#define SBS_CHARGER_STATUS_CHARGE_INHIBITED	BIT(0)
 #define SBS_CHARGER_STATUS_RES_COLD		BIT(9)
 #define SBS_CHARGER_STATUS_RES_HOT		BIT(10)
 #define SBS_CHARGER_STATUS_BATTERY_PRESENT	BIT(14)


