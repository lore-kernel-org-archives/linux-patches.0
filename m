Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048605;
	b=DLthGunt2y2DKptMVRpt+Pt02DSGSs6ZMUy0n8Y6Cibc6BEdEKNaayb3v/2vzgmCK/GT
	 B0W5bZKhTKDjvUgYDG0wumyZOXAHEjGhJem5OAZUMLiss8IG3/2CQuw339aLdze5QksfR
	 fV12oH+pAPOnxY7bW+JkBfVjwFjppK44ZAuphlrpB8itg/LwlOuXd/iH9GjtKrEn8YjIl
	 Zs9dLQZ5LTFMfs07R/3YRPil7bwvHEBgbDFIoU/SBjt8DNyT1E+HmwTUGJRjAp/+3lI/1
	 ZyClhOJANDOiFuXDzYZCdDL1qMMzkE7PzacnzfGyMzP7m2e1pnLVfk+hI6us3ywfFYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S5aNKrowON3it8/hY/FZ99mpAEEFdkc0J4NTrD8dJ3U=;
	b=E4o+T5dxSw4eUh3gTxmcDifof8vF8Jw9ZIRckM7uhSs1cWSVEubgVqrLnkVyLLlIHGSM
	 rF51Evh5IhKIXUy30ZRCAGDbH0pm4v6ATXcpakarCGNKkZ1DA4GIot+oJyOEJR3Jb+JN+
	 pJwHKhHf37Sx/jkFx88U0dZxmmolhl6Wr92u0yEIMRk3NAV59HlINskvr2EFYjFfX0ZrI
	 oTp8j3DlsiWGV3soKNu49/Jr0jtvQnVhLwGkJHPzzQ4lMZXgrarnnrsfJsorhj7rKtb5/
	 KWadjb7sjMB2/YAE/EzSz3MTl7JXeUVZtag80gae5sk16pUx5c0DFODqtNskkoVS+7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08xvPKgD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DE3606A31C;
	Thu, 19 Nov 2026 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08xvPKgD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63B21F000C4;
	Thu, 19 Nov 2026 00:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048605;
	bh=S5aNKrowON3it8/hY/FZ99mpAEEFdkc0J4NTrD8dJ3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08xvPKgDblqsl78cJVG7UDq1rmg/xgJp/7TQlVm7Psn2mQDyeapgAldAF1zmT1o3d
	 ubZB3PVxR69pWVYqA0aruv/6tibCGXSXeqPnSLmfVuK3qbJRRMySabukixXIhNEauf
	 KvBv3x1Usmvubg1Te8BuMQl0d2+4PW+jy8KteQBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2054/2857] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:28 +0100
Message-ID: <20261118150315.374145834@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9f2933d9a437302d5ae32eb9022efef049d8ab22 ]

rt5665_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-15-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index 76ff097518c88..7c52cf7887456 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4491,9 +4491,7 @@ static int rt5665_resume(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5665->regmap, false);
-	regcache_sync(rt5665->regmap);
-
-	return 0;
+	return regcache_sync(rt5665->regmap);
 }
 #else
 #define rt5665_suspend NULL
-- 
2.53.0



