Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049044;
	b=k5wrttPIbSOsR68gNB98rK9VbMrs5UF7A8E174MFnsyDhvC8xluZLdyVB8pSA+gaVT+L
	 5NP83qmQnWkW+6Owkn6k34xXws7Fi0E2MH3Uq8EFNwxXezVuc8jtKqpTxKRNXHQcARnPy
	 T8GsTiSFupf90o3D84IEwLn0zpfyL4wKMJbAGv/iS6QaBgEEhkRi2ZZTflqukikdC6L88
	 K81toV8UwGI/O7HYe6+Gilw/gBwb+OuxdW8HmJZomILAZH9d94TNonzzJ1sMPJNl2xpJv
	 0Qti5ZtgpI7OoT9NrMbjvK87Rbrcll9ihVnJ915xPmUTn1qwmq7+IoDbN3m68ZK7BUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bw6HU6oMdPxousDOZGw6iYpqDYX801bJovaTPEJafl4=;
	b=Tk5lVWDGjbV3vu1UHFzL/wwG70kysEGHL0jpMCH6xcqjJjTHrD3mWcxad/5cKOLgErpI
	 yDb6XFtF3Wzbs1Iqx2zeKwbojyAHQ8JAebwNzJENC8fwSzu44mHNcPvkw0tYyDga4F1A7
	 /jMATXLgIT4Ll026lNaqHNM6hVrDOHicfcPxhV93toJWJyzVHFoM5/o2NdsOOX+v+19V8
	 CGGonPQHU08/39W4O6R8jaPu+OGWhzbkgH6UfgEzgHkLJGh3rOd2d10wZn3MWnZg3G3xA
	 Q2D90CbRj8xoUU3V2pRAiUKIMJZ3SDuJllJBqqq3pbUxE12b+Pp0wUNy2aFgVFGnypg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnlS3x7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72664606A320;
	Thu, 19 Nov 2026 00:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnlS3x7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A751F000C4;
	Thu, 19 Nov 2026 00:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049044;
	bh=bw6HU6oMdPxousDOZGw6iYpqDYX801bJovaTPEJafl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnlS3x7ZgZTNVE5smIKrzihOT6KA8JJgNchN61kYJiZJ9lM1oRLihZEY+49rT+2De
	 Bhnen+Zlh8QVo1rauXiG9kp3U2OU0vkAIy+TKxHQ2jIdryYy/VrxlfuqGo7e/NuAgS
	 3e3qEVVU6fvV1v8v9nm+9zEh7u4Yu/TJvsrLU/hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2211/2857] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150321.029853205@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 1098c619ce7595a77a8c2e366a703e9fc5f29bf7 ]

ab8500_charger_detect_chargers() returns either a charger bitmask or
a negative register-access error. The probe and component-bind paths
use a negative return value as a bitmask, making failed reads appear
as both AC and USB connections.

Propagate detection errors and release the bind-time workqueue on
failure.

Fixes: 84edbeeab67c ("ab8500-charger: AB8500 charger driver")
Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-10-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 5cabedc69d8c2..0b83dea6393a9 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3452,6 +3452,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3740,6 +3744,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	/* Identify the connected charger types during startup */
 	charger_status = ab8500_charger_detect_chargers(di, true);
+	if (charger_status < 0) {
+		ret = charger_status;
+		goto remove_ab8500_bm;
+	}
 	if (charger_status & AC_PW_CONN) {
 		di->ac.charger_connected = 1;
 		di->ac_conn = true;
-- 
2.53.0



