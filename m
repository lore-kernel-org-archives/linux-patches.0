Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057275;
	b=H38y4tbm0ZqiVrhN5ls51EXxHZLF40tb6mrxvBnQMyywVPzgFrKdKuDp+ZLtFjvwSW2C
	 4aOVNLnpM76wI+vSo0BtUHW8bjVPYkWir4Y39tQU7iMmxyM1+lsqSZq5Sp5CDHR+GvkJs
	 QNBK0E7FqwO1nAeYuZfMkghhtIpem2/eFaiGCx0evjblqyOBE/1SXH14qyMnLTMT2eV1b
	 TMH3Q3bGLAdqKcBnBk7aQcnAcZplmGkqkChIxBFefp23igajLeTQR2nbOeyz75VoOnOjH
	 b8WYuUMr5+PRh8FNzTV51vQ5hby8x7dZIkPmm2nWP5lT6ou59cAXisnM7Odiyu4an2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yzT/eA/W048T5OrkIHMcZaPbOQ7acfSfcFuU4QDU6b0=;
	b=4hjGG3UUhSeU9U6BwEThP2Qoue3esrEtw7c0KjMeUYUvBuIXvfM/fOIrHaIluZKhI/11
	 WZ8mIH8DlgYHWB8vQX+lwwoNZSflvmJ2FVgyvnPS4c/uXXckryGrx/qn2WZZ9P/+MTZUM
	 rmm2GQSHUURXmLz4t5Z7VoX7mF9X6it79UVeaWXTbqRtbt0tA74qytoMi5ECBOK8/gJvB
	 yHzvuhfulSnRmounXlV1ZkQpDpAH/R252wUb5peqNNAwPm3f6Qi7WPnaeMa3Wc7l9zBzF
	 uG9+TSemkQshdG7asqxg6AiANosKKBHIKKnK90+ZbUO7crP9PLMdN5xhy0x+QKW+Gjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUtzaDDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B529960A2620;
	Thu, 19 Nov 2026 03:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUtzaDDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181F51F000C9;
	Thu, 19 Nov 2026 03:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057275;
	bh=yzT/eA/W048T5OrkIHMcZaPbOQ7acfSfcFuU4QDU6b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUtzaDDEPqKcwxA1BcIZmoN4uW4wn/T7Xnt3HpPfDkqU1EI4f4P+iJwFYOhaIHeki
	 DYio7p4M1e6dUJH1MQYNL7WRaGq8STfBGGg/6LdFVoRQoWLqyLpi6y8gl+Jg6r0NgF
	 5nfA5eXbNtUq0Dr/4CDKc2M21PWlOyaEmrYP0KQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0073/1848] gpu: host1x: Wait for timeout worker completion on channel free
Date: Wed, 18 Nov 2026 15:35:11 +0100
Message-ID: <20261118145914.218363452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 7a39b9856acccc8e9b05845ca2bf62494fcd3dfa ]

cdma_timeout_destroy() used cancel_delayed_work() to cancel pending
timeout work when destroying the CDMA. Usually this is fine, but
there is a narrow race condition where the timeout handler has started
execution but has not taken cdma->lock; the channel is freed causing
cdma_stop to take cdma->lock and flush the channel; host1x_cdma_deinit
then proceeds with deinitializing cdma while the handler is waiting to
take cdma->lock.

Therefore change cdma_timeout_destroy to use cancel_delayed_work_sync
instead to ensure any pending timeout work completes before proceeding.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-1-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/cdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 2f3bf94cf3658..58444defe1b0f 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -309,7 +309,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma, unsigned int syncpt)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0



