Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034272;
	b=urw41jiaRuRROsbpbvKwtqMBvYdhE8MwUOFaD2dMjrQOBAGlE19BR3ToxzqrmRlNjEB+
	 Ed+neHoV21Wv/EHV5efX/q7JZ6JU8sC/5mPiE4O/HgUvEBG5bNrJ8srK4QMbw71a5k4we
	 2JA4TpguOuztbpzVOyQZCp9K8GJKTG9FYHsdv4aiCRj78x2TgYgTBS4mYZhhRNwQ2xb57
	 WcRG8lp/Be4D/p4aq2EHlEzcEPrnt+hJRXZrL0sy3rTh6rWFvk88gQAfSW/DSHzL9QszT
	 7S+2c8RUXyZ43EcNfBzNZq6044L3M0FZTwXbBwsmSgszOKNu5RF5KXCZxXXavuhHFNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YvwXHbt16EJfHzXUupErdfDtyrrJ7mr2s26THku0XeI=;
	b=yzoW3EPH+XZynTKhI6PcVD/WKVSoUuJHMorJsEmno/CX40vst7y3wZj9scly+1VmGZIG
	 YZS9CpJGTQBqx/WZqIVd3uo9HwS9DL2Iifj1k7vjRrocqM0NCeQJjiaZ+A5OBPSsynzQ6
	 6OmkBeP6QNy58jJqBdbH4VX9uXSncRdtmco2bxXcFhl4alICHuA19byBspx99703fjb/c
	 a0mlLoL/2f5QcJxdbZJmXRNjqwCDKWB261yi7CWtYY8SfOu+QaeYDPUWD+TUHFKgAR8cy
	 jhaxNy7B3Wf1J5oezL5IUHJlOH9ICzsDERT9YwTJFqPTkDiHuhq+uKXIiBHk66pmy6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbbJp06W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85AA606A338;
	Wed, 18 Nov 2026 20:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IbbJp06W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372FE1F000C5;
	Wed, 18 Nov 2026 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034272;
	bh=YvwXHbt16EJfHzXUupErdfDtyrrJ7mr2s26THku0XeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbbJp06WVa8RLzh8l+7vtjAs2E6wyYCpva7vMO930+HY0WRlCxxm3tQnCOc/GafiK
	 B1og5jcHGA07Hs3Xe2dNOg19iwVTgZKK/82976rQPMI0PBpQLpBPzg3PdgoFDv922D
	 DI1rNkSgvaFfKD0K8JgrFsgbLt9tZ4nys8kaFHZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0311/3318] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:15:33 +0100
Message-ID: <20261118150325.130340344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a65a4e0dc003..9741f843ff4ec 100644
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



