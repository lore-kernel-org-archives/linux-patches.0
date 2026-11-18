Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048952;
	b=A+eeyN6DsUCL6OakYmk0tx81YZy5e4aHaaOvXA9mULbCI7ebBIkXpSOJNyo3OUcddMOw
	 tXqcn9syAMEWpdSDFyom2ASi4q/24QrfnDBS7onzT/5CmTJGNEdzT15gfGegBLmml+Ya2
	 7aSjqm/uG3DxFFqkt0EMIBSV/iGqPd5o7OREqMSyO23r2Q9L8X7C38UfJT7ehzK+YfCO+
	 T4dBfXu+VxdDo0F5T487iKagS9H7aUZjo1+2wm1isYE5GjLHBumKXBcKFJs3c6kW4TJhz
	 0jzHwDcHGTUb+M0Ig8wvoh1cMSUU8eqa7VIt2lOYbCR5q7fSyj3CL9JmgAaKyGGyyTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxpPQ3L3HhCe3VmME4UnHWa4GuCvTAw7d4YQEws78aw=;
	b=dY75S8yjjgcbYtNyMPeIDztTMXYyr1ZHxoFd8cOLHym9TccshVAt/DCH0rC85QoN2WR3
	 Y01G8ib+wnO2kVBG3eCqSxW+H8jwyZE55z7Bh3RzZARncikl93BKg750dE5VgkMd8dN51
	 WJ66Sbg0g450i5L4WZpwfqCs9XeSUmDZI40C3Piary9hePJ4V8W/qBn3zpPDOQXQOUI9m
	 pvKnKt/DjKTmqM1RyvYL1NieWa9meBersDSyngKvQPKjvNeNsMbjsujJ4F/uJlpmVFIFW
	 mQQ62+sTtDQSw7YrS/dE/L++7yrBcE46wF4OqNjvsfEJQwQIaNwjB1so31uf2xXokWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHv2EtNu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077F606A31C;
	Thu, 19 Nov 2026 00:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHv2EtNu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F110B1F000C4;
	Thu, 19 Nov 2026 00:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048952;
	bh=LxpPQ3L3HhCe3VmME4UnHWa4GuCvTAw7d4YQEws78aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHv2EtNupTHNrqHed2Ir5EyeOjKGu2YYp2r+B4lKviuq5XrH4GGoOFLxV1Co/olrX
	 nMIp5py1Pvyy7FRYkdbgj5XD87otWEnSaj9M6nI2+J0LiJUlcFG9A/seobKDy21+oq
	 q7J48tTemo7VoUHhUWS8G9t8H7h+urcsrpVwpT/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2179/2857] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150319.860659075@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 4c3ca7c8c152278332590bfd3df1b0f086364759 ]

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 94f7116e96682..789a5c709ba87 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.53.0



