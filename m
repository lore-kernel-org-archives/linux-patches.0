Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041554;
	b=3ldbU0V65T2CVFbh0L0JQzNWynAH1/RAauv21HcrFN4+MKb3z6GtVqyXQYwhlbIOpRT0
	 jiNU4gk5bcC9hUmd/PYLc1VUWH5FAzXRVfXVZMP5jgv11Ix3f2n118UENQnAv95zJb/X1
	 BAQd6WAaUsyUGteGXhsBOtQsmn1z1ntU5F9LVyWSEwDkPngf6dIc6ZRS+HVvRqeTZG1fI
	 bvIbFRJDIbDcSZnkqjKJ/g6F3CGupxpTKjW00zSAjfk3KXi9ifgK/I3x5x2UUI7/2Qnaw
	 WDRgklSEw3uHKyR+djoYuJCVOiMkeWZNc7x6FdkgTxKoUKSNsbvk2gyD80s8BN1UQbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kl/bVUbljygwywAcsbodZXcHR1s7fGhSlV5/7S+yCDA=;
	b=d2ZHGZrXAPwjgSO3avzhzmqjjCbko/IjoURCfiIdlJhq0Xgqeb5U+F9jqlUdeLfJWYBY
	 azJi4vyNcXR+m0JvcfJS55n3rvA6dGN+Ee/aWj+FOcc5XFBskBpsrLWfZUPFZXSZn0zpe
	 HR75yoN9hg62wreu6su832VcEhxB9v8QGAdfUvE6ZfwxxJrQJAi1vm+DQKQS0O86mQtC7
	 IHt3vqRQY9SREEk9qrtVASbJp3syfDwR5Y52OURWBkekz3RnVAu9iN+R8eRfj82JAegjd
	 uPXrEqwQc9/rP+5e8lFocJCEjh1hkISjE9yh1dlHLBeOEbduiOVvUrqYrrNlg9oLrzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+9n599X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACF7606B60B;
	Wed, 18 Nov 2026 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+9n599X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D341F000C4;
	Wed, 18 Nov 2026 22:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041554;
	bh=kl/bVUbljygwywAcsbodZXcHR1s7fGhSlV5/7S+yCDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+9n599XqeWQywWXBfmdM8VRow5Ab+GTnvR7A5+e3673eSN4IH+svFRio6GuXKTIp
	 foaeJzIsQMpSyu1/cAc1C505rEPfD0Wj17/O49yBk2+Kklt95jdArLz2n+TSjw8Mt0
	 qX+NCqy5rXu7c2nULIIFUX/8htXyaYrYFFaDORCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2856/3318] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:57:58 +0100
Message-ID: <20261118150446.276554097@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 75e0b607e3456c9eb15dfb783984f814a89cbcaf ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87b3bfa7711b61d89c21044d02fb3242dd934385.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index ee47de27ad6b7..bc06cfe0a41df 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -112,7 +112,7 @@ SOC_SINGLE_TLV("LOMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER5,
 SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
 	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
 SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
-	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
+	WM8990_LLBLOVOL_SHIFT, WM8990_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 /* ROMIX */
 SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER4,
-- 
2.53.0



