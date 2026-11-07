Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061087;
	b=I2hPuTjiyEVZe5Hb/1mpoUM8YEpHsPvYLPamB41DbFsPIrdVtVoDMrqfHSZd0dXAd7lv
	 HSqsPJRrBvCfxhmxEeLpSvFdrzwXHLcOZp4wwAStmelTvwnppOXQX4l6VUWoxYQ8HhU7u
	 QT+Ra/OjkRs0q6H2XoSVtKBdG2FGbpZ5O9t+VTC0vcww8M+3NuchR6JkUoJCwNDjhtkh5
	 0T//iJhjQor83KSuuBcZ9vgUL/H+iXwkZTnoTLlsSlIQwKsdLeDJQxutzZJuphSRKKhzw
	 p2XvMRMBV256ltf2Rss/87kVbtzavs43/Li3CT/ME4LYG5TsOaGRdg737Nxzxd/qRcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7jzJWpejuahZjkubuchdT5ws7WlLIqlltHUrltQlEI=;
	b=INCG+A6Pk07DxXtsTB64AsfkLwBesBjJj0wVyfNeQH6V7Sx2FkXJJ2ZoSQTGaiBcnlBE
	 hiiGU76WddSCe0jC2Pcao/M9ZwPfsjT5ue6RdjGmZYDaVYL5rvsvJUsPDywgLTD/l9I0E
	 zRahr+qWkiepQxQL2h+l5RhYacBi2ZEcfBWBkDUNVziQf3slYxv64xwmL8iI570tKkf27
	 ZHWK/ri6LDJHbT0Lo6uoQSE8Od99CqvL1IKn2z7kc3tfhbpKhCPUIHblomvFBv+5EuZIp
	 9//T98qXEz4TdNn6AiYkX4YptpIwcYMUEh329H0szYnkRj9DjhUDbTQ3gYPSgIpgjjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gh+Ust1k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B1C606D833;
	Sat,  7 Nov 2026 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gh+Ust1k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4E51F0089F;
	Sat,  7 Nov 2026 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061087;
	bh=w7jzJWpejuahZjkubuchdT5ws7WlLIqlltHUrltQlEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh+Ust1kuGd8kgsweesTxUTw3ksPR9EWv1Jo1bKbB/64JsqjG0zZZMk+XI7J53MV6
	 oZUJ/NGij/PKc12eTBmaoJrOTev+ArSWEBroy+ab1TjGOu2e+KC48TB1y8vwwLlQ1o
	 l0d1z+D0w/ZsS9yDNsJTXzRAOd/d7Zen+K/1ypKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0373/1536] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:39:49 -0500
Message-ID: <20261107135008.117136806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 402c89d28fecd28652a4bfe997f08f6544836381 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704121734.54941-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-brcmstb-waketimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-brcmstb-waketimer.c b/drivers/rtc/rtc-brcmstb-waketimer.c
index b108e75042eb7..625702fc5eb3c 100644
--- a/drivers/rtc/rtc-brcmstb-waketimer.c
+++ b/drivers/rtc/rtc-brcmstb-waketimer.c
@@ -414,6 +414,7 @@ static const __maybe_unused struct of_device_id brcmstb_waketmr_of_match[] = {
 	{ .compatible = "brcm,brcmstb-waketimer" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, brcmstb_waketmr_of_match);
 
 static struct platform_driver brcmstb_waketmr_driver = {
 	.probe			= brcmstb_waketmr_probe,
-- 
2.53.0



