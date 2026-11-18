Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060346;
	b=tR3ggb7iw6RtiWtQ+ILOt02Ian/zDVw/HeJl/LXmlVWdWCl97uUn/wq44+yVFUXeY3wR
	 Omgr8NwJ7NY+t8iHpXy8SzMkLTp9aqoXdva9HGfNgg4ch8gWCK60VilYzeD9klX3wmsaj
	 DajR7bs6nzlAlLqk+ZZbGKGS+VzDRMxRJf8kcbHGHhSrCX8Fp1JWI4lwZeGT5YvqIp8+V
	 xP3KGXwbJvYdFwHc0nkLYMpR+EeYAYVwXvBmsebtgmY6QPVWv7ajTvJA53GlIU/A47dzm
	 u/+MFoNV8JBdt28xN1SmxL3uWz/ROMtXibuxtQxBgqzhy4nRenJYuDuYKNktyx6QlaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=esYl2w9uwvJAW5weFeO21rjqb1o9EEMP0MKgrKR1348=;
	b=xPBxL+aBf8nIL0x1eQcqT3074K/UVeiuTobSR2bBD3qCRMhstZgMDa+bkKVP3WBHzAqZ
	 2JjJ7vBWwLIjCtGfq907Kwi4u2qHfaUGPGsxC3xBWbzb2Qn3ZzMpGvbT5kStdKcLl8Wmi
	 SKrrWPRfj0m8QDoI09Xby0qNOeziKu4ebn5Hs0n/Wxb5OJbdf1msk8MJej0BtME1mUTGO
	 85PFLqppxPJgLoVvqHyd9cwKbSH03I2w35q0uFjVUe61T/SiJDQ/Qk+khA6io+R9q/sur
	 6uax8KAihObu6COS+Op648tRFqzXhY47z5MEyp4YMeRkV+Vp4V3pp3KfCoXSIjyWl9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjkWO2ca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BE606A320;
	Thu, 19 Nov 2026 03:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjkWO2ca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F931F000C4;
	Thu, 19 Nov 2026 03:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060346;
	bh=esYl2w9uwvJAW5weFeO21rjqb1o9EEMP0MKgrKR1348=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjkWO2caFxNJ9tQKLehNtdslIuQ1idPMeDaILOw/pKDgJeFp1FA+gYgBqcS/YttVG
	 ZQNYkgPKVw1CRxTPbSNfYWASB+/0+PXgCBzKRXH9+y77NgsPEN0jGeJENd0TxBXID6
	 Q7WOGUvjzzl5DjhvLG0RlT9TxulKibFIunHEC+uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1167/1848] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:53:25 +0100
Message-ID: <20261118150008.504073592@linuxfoundation.org>
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



