Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055412;
	b=SrD0iFk8OLO2MucM+10DL5hjNAPBCd/SBoQ5IM2HJHwKmGuYAV8GdcZFd3VyjFjzNCsL
	 5iCp+nKJR0QQJvon2z7KHt/idbnnxoYdV1xvICNrtgEjGZ3//RneF32o9pNu1h6yu5kcD
	 cXUfcL/bId9NSr2ZDi1lkkp4EBjBty+zSulSDeajTQi7xJRKekh38Fo7rtzwn7Q6SjeQL
	 v7r/iDL49RwJSK+AMvAUucKAu+Qt6dZXPo+jgI7I9Y9xN24W7p91cykJ40f/AZ4O39b9U
	 8GONyWgc2bAPzTRBc2NQNfVU02eMThdJjYYkyfoPK+NS+CgJ0Pnl2sDQ4MTljGXpiBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=netChb1/CF5FiUlhC/nJavmfTIg8OiD2EXbsJ7hgul0=;
	b=aDxcJeUOuFJpXFKNTLvgLtAUMGLsDEqRtce13lKdCOL+lr22rRyMpjgV9YLDsK91vi4m
	 3hmULGG3aTYBsaKPfkDHjzXmNR8EM6ptT76nbnvjaqsHkpkCbZ9sYhV+OHrW/m3sHkMqd
	 ST1YmCER9jBskj14Ghw2pP3P3X7WCZobEcpr80WmXcfFyYzbRb3Kengw8rOeRAHIAxAtl
	 20bgFP4Xv0N+KHZ5IbXkmJQehCWt0/I2yNue8reH7QLaD4WPg0i0E0ASo1jqPzH4oDSCJ
	 LwdkIbm0mHg+6hYAPtr8lCCr0g2wzBqi37CWEBDAszxtlyH5O+Cf1dLgcTpZlPmimWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPNhsw4L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924CA606A32C;
	Thu, 19 Nov 2026 02:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPNhsw4L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39DF1F000C5;
	Thu, 19 Nov 2026 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055412;
	bh=netChb1/CF5FiUlhC/nJavmfTIg8OiD2EXbsJ7hgul0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPNhsw4L2+E1j2WoHVY6LGYsUNEAQha8RjRBNODcx4owIHHeV7D5RfcF2Y8P7yW1W
	 LyNV8tNQ1e2fjcAnCFldmSFrjjmeDwI+kCI44i+Jy2P7LOSFDmj0z3KYd9gyRDUl02
	 aMOvOPQFNRiWCJS7olD477JWHV5PddJ6btoZrEys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1595/2214] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:31 +0100
Message-ID: <20261118150115.781345630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8ca84987c11d11e0ba60f202e3199b3b80c87721 ]

adau17x1_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The optional switch-mode callback remains ordered before the cache
replay.

The issue was found by a tool we developed.

Fixes: 4101866c743a ("ASoC: Add ADAU1X61 and ADAU1X81 CODECs common code")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-2-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau17x1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/adau17x1.c b/sound/soc/codecs/adau17x1.c
index 8aae7ab74091f..ba85fedcd50f8 100644
--- a/sound/soc/codecs/adau17x1.c
+++ b/sound/soc/codecs/adau17x1.c
@@ -978,9 +978,7 @@ int adau17x1_resume(struct snd_soc_component *component)
 	if (adau->switch_mode)
 		adau->switch_mode(component->dev);
 
-	regcache_sync(adau->regmap);
-
-	return 0;
+	return regcache_sync(adau->regmap);
 }
 EXPORT_SYMBOL_GPL(adau17x1_resume);
 
-- 
2.53.0



