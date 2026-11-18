Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047893;
	b=vRmfNI/k39eD5KNWtCj7BYXeiYMG6RAd9zicgIyEINwWdhc5yjYXVtSKA4WCGCLkjB6j
	 ucw74SUGPFG6WZht+55wx5wRnb2LsG2CdfyuA87dY+WQl6VSF2Lhv5UdiCXPGQg/y18ty
	 Jdot9wC18MSp0gFcbjTDvGoh9NWt8AkdcWTMhwBXfLDjU1ccnDl16v/9CJFdkfQL8xSfR
	 Da38YqypiNYDFNN67JV0LEQtyqjsYp27ziee+pyFqb0qutpjfzPuBcfZ+7TmeQoY7fTHy
	 1LznTG5d/pfeZ7UMzSN0VI+L+J0M9bqBhFIMyDhkgb0CxEy0re0hE6UJ6gE/Rvwmk/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4u409ILpcH08ACuchZ6CN2zYfB0wo0p8ldWcy8KQWDs=;
	b=jtXJe2YMLaODAqLGitNvV6c5jUDKlyZmagaacIlC7g4ULSWQpI0JHyeA7U9LBj8mzBp4
	 nc6X/7HERKb06b/Dbt7M3kEYpXXSwPG+fEJhekoSu91LsinKD4n3hu48okz3b84zPPSP2
	 UvZYBprDYSWYE8dFOVBqNjW43+BYOQRyp5hvMmq7OS6JabQ/qDTk/zxLcKaf0RWsPi8qy
	 1oqhXKldl1mk8Iv6PYeG5nMQyToi4Z4q+k3FsaZIgxC7qdTjaB1D+sHvRRpmcuvQnjma4
	 l405R8ySY+CPuKiJ6OQEwb9suqjOa0VLmvKZkASsubvIJP6g/zaLDFEU83WrkxJvmGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncASZZQN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC09606A31C;
	Thu, 19 Nov 2026 00:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncASZZQN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9311F000C4;
	Thu, 19 Nov 2026 00:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047893;
	bh=4u409ILpcH08ACuchZ6CN2zYfB0wo0p8ldWcy8KQWDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncASZZQNeKZuw0xvb4jD+I0KEgJjKnTasWAM7UC3ngkK4RYmt8QkAjrFcbJ/474sw
	 JMccgCkdpg0V4WEeaev9HiTzCl+0YN1xL3cJ9tYdhTRNOg9R4LXKOI65aHlaYyDe0d
	 Qx6DSSo4blRJLvPZYjq6iSnvKKl9P3kjj7R4ipUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1800/2857] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:47:14 +0100
Message-ID: <20261118150306.065638608@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 24fa0eadc2e3c7e9397924197dca7777ec08b8d7 ]

The MP886X vsel is 7bits, fix the vsel_mask.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260901043123.5401-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index 8ad4722eca4b3..7910896df51a5 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -267,7 +267,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->min_uV = 600000;
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
-	rdesc->vsel_mask = 0x3f;
+	rdesc->vsel_mask = 0x7f;
 	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
 	rdesc->ramp_mask = MP886X_SLEW_MASK;
 	rdesc->ramp_delay_table = di->ci->slew_rates;
-- 
2.53.0



