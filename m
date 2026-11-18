Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015088;
	b=gPj/U/ro54XgUlSD2wgYDCrSsBKXdt+i+6lju+67pcF2/CKaE/l0FXWt+IorNnieKjW6
	 Wg4XivSy8/ccJ2QgMgFM6wZXNTYtZc8UUqplV/TTXr+itIk6YL7CMoE0aBT5Q544tnCXh
	 Z8UkxwnxhfFNtrEq38oWIKhhXtSt7DU/oqf2v/PbdRq5VTw3p4EMmjIgj1KNRyiHViqFs
	 CikfKsK8P5eTiO+t8mEiHLRvGbbM8238BWpR8vvQI5J3gf/iQa2cj1eeGTEwBxLUf/Var
	 3WvWi4+ETO2ZN8n/g7CLDE8L2+WHpjh77valJqWqo9gIrwf0ZP4o0GgfiCO77KbJ7Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5qmZRPvINNmKM0t1b5Io9DrBoiieVARBAvV2VaOJYI=;
	b=zr/1BfyATSV+3C0PUjfK4bDTsaSyMDwUEwdKoweoKlAgDJ+zhkPVJsDRvUYigc+dGa0p
	 tGpSYhDo218orYBKXp3+jyg4st/3SRW5tZsCl0RzBNc9okjXlhZom/XFXHJ4vnpouCRTM
	 C7eSywrlNJLawmSkZN+lwpST3rAo2NoGl/7Pxo/6kizJxUegGpxJLjQpLqgDzwdo3rocS
	 T8HZF1Oq0sXqAE6PmoG8Tc5nVx3Csd6qtemC83FLrba4Vf5Bv1LgP4hNvEMvd7pyqHcnC
	 Zm502aC5ExqgUhCqeCpPB/eiyB0oskm6w9trkDexLgyrAVYjuI4HWDt2Sm9LztxUjJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IE3szT03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C93D606A331;
	Wed, 18 Nov 2026 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IE3szT03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DE01F000C5;
	Wed, 18 Nov 2026 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015088;
	bh=u5qmZRPvINNmKM0t1b5Io9DrBoiieVARBAvV2VaOJYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IE3szT03t8WBTXSF6xokqZh+ngS1DVBWYeJhi6XjE9K/kBYJJG8gIBKvtjR8+cQYg
	 IRIKVZtim4gixszpbFg36Ze1jjjtZQTqBEgA8ESh/0bHTa2I9tzunzEGC3V5WhONPg
	 xTDUEkDzM6UFcKlfqKnUv38ZtgBeM7wrOx3ZYHl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0048/2651] ASoC: qcom: q6apm: clear g_apm on driver removal
Date: Wed, 18 Nov 2026 15:21:28 +0100
Message-ID: <20261118150249.687068849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>

[ Upstream commit be2172758f2b7c801ae80b9c8d1510b31eeffdaa ]

The global g_apm pointer is set during apm_probe() but never cleared
in apm_remove(). After the driver is removed the devm-managed struct
q6apm is freed, leaving g_apm dangling. A subsequent call to
q6apm_is_adsp_ready() dereferences the freed pointer.

Clear g_apm in apm_remove() before the component is unregistered so
that q6apm_is_adsp_ready() returns false instead of triggering a
use-after-free.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Signed-off-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260923-vmid-v4-v6-1-3d61a0319b1c@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 8a756249e5884..dea1dc2a79358 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -917,6 +917,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	g_apm = NULL;
 	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
-- 
2.53.0



