Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045728;
	b=U6a1P4AIgX+l3U1G0p8xgfIcOKd3j+1fs62FixewTYjE3kYlNKZxkhjFFWoTPSPFpxXQ
	 QpZMnmCNu/ZCn+EHimP4/6NlIaawHgrgQIly6PE319xi3xd/XPOtMB8AAN6f3j6WGhH4o
	 sB47lIpfYCuVx2iFwMnpoPrcVaiN807FuFL1WUhUNhwoOKJuSJjGOE42KzFzpgkC1FzAL
	 zzKi5Iv4hbTU5g2rGuzWLrkV9Zv5JfMfdjDee0IvIgDW+TZ9ItCRbtggbSpfTlREpENvl
	 oIwv8iEqwdKNKzEIuDXpBSumDEp1xeF+ZG1ON0H+UoTBW+w9fMOFNWCu3qyqeNIAhYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zY+MpspgZdeFt+EHik/1acJV+WeZJCDnMhxhVYxRJE0=;
	b=sHgyMsqg9hgPsXoPjJh8mIxGRI/4Z7oJtfvDr/5zedM4mmC0jNZ3OsLdjgRxvXLvSNii
	 O7776ojnsbTyETPSv73SGcIediiKx/6d5ROlbfZXlK4BJiaeb1GuQkBvcVE6BAuNwtInD
	 +Y7KC1BwJuA3FPNLeNBBmbDrqErUMCy+SAfcCNWcr5kFQTTrnkTpDBJi63wdVtfPIaKtz
	 nsBxed5fjNUIySg8RJEhtxo26ntw8/KHeyjZcOUEaPnKfGHYXxlz8JV+wjgYJvtBPVz4B
	 DGo0LdsigZHtmyIBWL6FWiggAkYIPN8OznFGSBRUSsXaiysYG9M+2vgnAKm16jwY7MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Aq/6Yf8O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50466606A31C;
	Wed, 18 Nov 2026 23:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aq/6Yf8O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497001F000C4;
	Wed, 18 Nov 2026 23:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045727;
	bh=zY+MpspgZdeFt+EHik/1acJV+WeZJCDnMhxhVYxRJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aq/6Yf8Om6IC5PdN1HnszZVwkwRN7tziA5VWqmal5L+9r8E0zGO6NhYRWvVW0HRx5
	 44bGIBUdCB3Bth32PoAu+whcjmaPgIx1joFqnwG7QYe3nnkheTF0NI1CkEX4yUwKjk
	 FsTi6jadM1bmYtAvTefal+QvtPeNFBkdDCFQ3/mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1025/2857] tpm: tpm_nsc: fix NULL pointer dereference on init failure
Date: Wed, 18 Nov 2026 15:34:19 +0100
Message-ID: <20261118150238.505391634@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 1900449684cf71427a51e0bb1d7914c0c8b39152 ]

tpm_nsc_remove() is used as the release callback of the hand-created
platform device and dereferences the chip drvdata unconditionally.
If init fails before tpmm_chip_alloc() (e.g. request_region() cannot
claim the ports), the error path drops the last device reference and
the release callback runs with chip == NULL, crashing module init.

Return early when the chip has not been created yet.

Cc: stable@vger.kernel.org
Fixes: afb5abc262e9 ("tpm: two-phase chip management functions")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/d5f0b38d6d6c17c01519c879d26448dbae388b0e.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_nsc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 038701d483513..bec0b1fcad27a 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -258,7 +258,12 @@ static struct platform_device *pdev = NULL;
 static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_nsc_priv *priv;
+
+	if (!chip)
+		return;
+
+	priv = dev_get_drvdata(&chip->dev);
 
 	tpm_chip_unregister(chip);
 	release_region(priv->base, 2);
-- 
2.53.0



