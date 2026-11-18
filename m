Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025380;
	b=zhRQctiUcCz6Q2SE2FeIGJjqnaxL0aS2pyVgh2K2GzO0GP2HybHYRPeN4nZtJVD/w5A+
	 GJSQT62SfS3Jvl9CudgTUF1RT1tjnyIWTMD7Mbb31HfKDM7tiUoPeSehYiJ3alBfJn6k2
	 s8wiNvODqnUfoicShQjyWyf5nGNqC/UjVKABBZyAA8xzUb6t5L7l7rswKVatcbvd+6haw
	 idor/ZlpZxKDgwzGCjPZn1IcUdJaGl8Z1nvgnsKfWm2XTMP0fNp8kRc3Iz650e1RBrxwZ
	 ZxcCK+fTcE6VLgkKYyA789qVGEnpvpo26UcOe9FWC5neOppqlkxIblBn0Z08PkE5xCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pDvNnWTn8eytYqVIXheLvTtiqF7oLfwtLc5w+pI6+dQ=;
	b=AkkvTy1x/E81mubba/YKo6HzB5S97cZDp6aQuBnA77pqVkc3VFpkem1i0lXGaGLzt6nD
	 XGnosF1wgoBB011Cr+ahPVKE44w2AupfttAzCcLIMiQIwzQoeqj4qLz02CL/Mgzrcf0o6
	 8zMMUINwSc9LCHslmu2cFLCcyqkgPNOmNGqJeu/t4ydCFILXB9CcoYA6O8bZjYpioGVoW
	 dq5a0LPpQTUKpXif7Tjlu3Qf0U+Y+3Wx3zMh3UBi/qwSYAWaHnBEMYECWQfbUEIaQvUEB
	 RN+rWIncDYyeN57DCZJjIAqGaliyuHnTEwtBY2zi9anyqGlqtzGQS9fLW1j7irNAqhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvaM5KY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D2A606A31C;
	Wed, 18 Nov 2026 18:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvaM5KY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0131F000C5;
	Wed, 18 Nov 2026 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025379;
	bh=pDvNnWTn8eytYqVIXheLvTtiqF7oLfwtLc5w+pI6+dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvaM5KY4vz9vd7pdjRPufvGgVSAnWKf5TntoT5tbofI4pAIpejIj32YFIP/oUBJQa
	 u7OIeNWbhoQStQFEirAPu9tar3JjB6V8uIP6icdfVmED+RsYkpZ16EiFRfEYL78Zzn
	 UT0q4WvRt/eh3N0MGEI83VSQCfUDgzBJOJpGtQf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1057/2151] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:46:32 +0100
Message-ID: <20261118150200.813179165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index b0aca9441ed51..8358f8c8d3612 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3462,6 +3462,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3750,6 +3754,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
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



