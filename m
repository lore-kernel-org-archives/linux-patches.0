Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043119;
	b=Yo3exGyGxoxMSmUEuUdbNQGMOFS23Ez6PhJtviS8SiUZXFw4itYTsp8VJL4I6FGYg2+u
	 1PkqRp/7rQL38FF5p1tzV1Lvk+wraodp+LixS0zrxaUyxPH9sdyqELHofCgWfotZPkw3G
	 dnFEfj3dWJWrlIFex23UNrBeb+PZ24QGAsxfgS8MaVGWBAlWltZfkPWXbTIYXmlqKiEei
	 yIufV1GmuEViuGtOdNfEpenekO0p5cZF3OOeDkkOps/moxflHNNx/csPKy5xo11VeYsl8
	 /vRq8dlm1SprdEcIczxxKTWB6703bs3IH5mY/O4e/N92dUEstl0OteKtaopjLmHaQOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8h96XSRFMP7BQw+AsWdhO6vWJ/2oup8jEy0l1X7dI0=;
	b=fqmVh6vvfM+axv2PxKXVwKegVPzahAqZmJ3vDGElwIZ/Nn5e2MTu8WseMtA7XXIdUlnT
	 H9C3kKK/ZO0ZOn6a6C0vQSrR09mduOPFAuZ3umnB2l+X3Jfli5NqliZoFXLv9aF4yP504
	 /RdCO4E5S69NRPTJoAi/CecAmiMFV1vxrUEdZT4Itz4t5WImJCiTot53udDKs/Eu3jNmq
	 duHKzkd8NhbMXHZWVD6UuDDrESTHtVCAuero7AsmQ8XOzYqtleZbuN8oer12dg0QUuqj0
	 UnxUWZT2oqHx96Oqk+442CaNTFV8w3k/3J3Qqk5QjGeooklxQ6yLGDwHa9x7e7qztEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R+BMVvos;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC19606A31C;
	Wed, 18 Nov 2026 23:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R+BMVvos
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F056C1F000C4;
	Wed, 18 Nov 2026 23:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043119;
	bh=n8h96XSRFMP7BQw+AsWdhO6vWJ/2oup8jEy0l1X7dI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+BMVvosO8VYYGNHERpmg4ai+HiQAxnCFoybf0+51FunW+4yJniE2Nr9pRpgqP11X
	 NXZsvUPAHoMSEAWY2a6xw2OMTmPJw6+D2F9+97Xd9v1w0wXbx3SRfe6VNrBOswDUdT
	 gatqwhihdWDSS+nXzIHFdXE29lzUwJ1pzEzjvoAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0096/2857] gpu: host1x: Wait for timeout worker completion on channel free
Date: Wed, 18 Nov 2026 15:18:50 +0100
Message-ID: <20261118150204.722035778@linuxfoundation.org>
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
index 1b65a10b9dfcf..9607330000f24 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -343,7 +343,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0



