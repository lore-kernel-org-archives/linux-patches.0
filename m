Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B957569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F96C433EF;
	Sun, 28 May 2023 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302082;
	bh=1CIL6RBnOq5tntTeeM/NFFFXukTpZtqo4uw+ny1yCVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA9cETdjPmVR0V1rSWO2Q/fTsj+okkQ5xt0HPk5z4ZOrFCz9N6H3j9PRAYtRKrUe1
	 H8IFZofDnBERZZAXwdnBj+csIIThYO7PpK5m2oilEAKn7aKenglA3SRPyPzXnOf9fh
	 4rFpuXo55y9EbpYzAMQ5K60+xJRxCPCJc01F3qMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 153/161] power: supply: sbs-charger: Fix INHIBITED bit for Status reg
Date: Sun, 28 May 2023 20:11:17 +0100
Message-Id: <20230528190841.723266797@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
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
@@ -25,7 +25,7 @@
 #define SBS_CHARGER_REG_STATUS			0x13
 #define SBS_CHARGER_REG_ALARM_WARNING		0x16
 
-#define SBS_CHARGER_STATUS_CHARGE_INHIBITED	BIT(1)
+#define SBS_CHARGER_STATUS_CHARGE_INHIBITED	BIT(0)
 #define SBS_CHARGER_STATUS_RES_COLD		BIT(9)
 #define SBS_CHARGER_STATUS_RES_HOT		BIT(10)
 #define SBS_CHARGER_STATUS_BATTERY_PRESENT	BIT(14)


