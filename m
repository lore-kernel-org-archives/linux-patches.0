Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773931;
	b=0B530bPl7e5nxXzq22vD6+F7jMP8QPaNrDiPNfXuYq23oGTRVSX3VtTmADMqt8q6u1Hz
	 pcnIZ99F5FJUqXPJT75fms7bMtlh07z6QapImEir3ceSp2LDhpSZFiVbpKPw7Q5UsPY58
	 Ac0I96S1DOfFVtKYyyopK0Ts78y+6/6t8Exk9bvaAvV/lR/hQvAsGVfvhfpRdQ7/nRi9Y
	 B6/t42txoILd1XBg1EDTLcm+u3K953uzKijlfiPzjNljObFkNQuy6zrvyj/HZi2tQiQr+
	 9GrR3SE2X8DcqPf67/aFdQ0S3a805n9MfTz/8Fuz3D5w8pvI66vSOKNHSYxcqV5gFhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnwbGuh73aGFyy83tdyV0ZjW1BA7feePzF3mjEEuRcI=;
	b=g8Cj9JiPKRkRQNxwMMNupq/I/1eoMJCa345As+sujAQ8fHbzCiRqe9yE+L1wtZd5AnUx
	 N+I4PO36uoN5PrYfSNMgWEpRGriYey9fEpnaNtkTo3mcaJvaqfF6p9LMbke7JE5akUH31
	 HYGFGOzCxbC0f/91QInAy5kjx5IQUcPSJZshERkg4dTwh0OkAN5AsmH9jvx05M1p2PtZc
	 TLpwu/85lMzkyaP39/kp94JmagCm4f4x+HW+xjTYfz46W+EOPXPOHe+yQmFYuI2zDM8ME
	 RQbDVV6CPEbonoTFdjbruSkpBsLQ2C5SlbgeyFV98L6rLEC+sNTsbUqvzGTWN7e23oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wwma1SYn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5F9606A31A;
	Fri, 23 Oct 2026 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wwma1SYn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692AE1F01825;
	Fri, 23 Oct 2026 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773931;
	bh=BnwbGuh73aGFyy83tdyV0ZjW1BA7feePzF3mjEEuRcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wwma1SYn5mBJslF4GMYxDTYl/JmsnUwyrJ0PEYHBmoRluSbpdjnerZH1cxHeS6KZP
	 vlYkpQX3SWsOhKye/RjMcrsIYF+RuUnds46OUQ6C5L/7YjRHqS6GyHMCFAdFT/5w5J
	 6guH8SaIoViaDRAw/ns+OmvVei7y5yupE1x5sqoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/193] gpio: mxc: use BIT() macro
Date: Fri, 23 Oct 2026 18:35:42 +0200
Message-ID: <20261023163715.742733090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 9de94681ee48770ec7e2062451a572b557bf9298 ]

Replace the open-code with the BIT() macro.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260526063504.25916-2-alexander.stein@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Stable-dep-of: 170aeff46fb5 ("gpio: mxc: fix wakeup_pads bit operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index b71f4b4b6bc2a..7e17d7668980d 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -331,13 +331,13 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 			ret = enable_irq_wake(port->irq_high);
 		else
 			ret = enable_irq_wake(port->irq);
-		port->wakeup_pads |= (1 << gpio_idx);
+		port->wakeup_pads |= BIT(gpio_idx);
 	} else {
 		if (port->irq_high && (gpio_idx >= 16))
 			ret = disable_irq_wake(port->irq_high);
 		else
 			ret = disable_irq_wake(port->irq);
-		port->wakeup_pads &= ~(1 << gpio_idx);
+		port->wakeup_pads &= ~BIT(gpio_idx);
 	}
 
 	return ret;
-- 
2.53.0



