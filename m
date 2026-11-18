Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047598;
	b=lpuDEc+7JV06xVSB23yZg+o3uBs3CMWxPBAZjBdEs3BWRcqYxfHpOP6PpwQrfMdiMlYx
	 bivfHhujlmO+3/bGSM0zWO+yPLTBpAkVjEvjHFGQXflT4BAXDRs5fduj0rOhzuUNXpZE7
	 fcaFZPnpitLf+fN8m4UdY20/T2JEQ+nKN6er1wR0Dlk+DxJapObYAv5J68YGVv6gpGVjl
	 NTzXk85dKlrlkq85aN9t5/iuSMimjWY0oj+a5taScVNSVd0C1BfCtGZgIYgVhrYe+jZ9X
	 dRcqlobWy+tIHPXOfKjgv8O/0GUKEJcTiukQC6b3jo5j1DOiP5LOhiA5nP1XEhfsAeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sW0DT7FZQ6cavrqsd88t7kTCNsJRJqPCckyVlg49hHQ=;
	b=4bz7nZL/+XLPOCE6gd+gCYx3nWNHqml22DbfpYFsF8A3boaY/xZsjEM1nzP0+BX6PX7A
	 DWs3JWR7xw31pgM48GHZUFZhz7ZY70nps2cB31O2RObXzrbRPB4P0r4adefGxnMZjd69V
	 D+zckM7NWuJ79O7pzQsYozfmD1uMXLwn2n8CJS7YcvpGnZzO1MytEVPk9il19cJ+xjGdd
	 7E4gpZzeOisCxCFaE1b/uXUQxfAVIjCb1UHg1TIHFxMXPupig8LAa2Pt4z6fwffjGihbL
	 pubPh5mPrGThYSbEn/1Syv0elHf6dVKQywVHHVMMzwVT7h1nZ7ltIBfzNWvauTpgDHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F53qRzt9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B098606A31C;
	Thu, 19 Nov 2026 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F53qRzt9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08781F000C4;
	Thu, 19 Nov 2026 00:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047598;
	bh=sW0DT7FZQ6cavrqsd88t7kTCNsJRJqPCckyVlg49hHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F53qRzt93tv/6GP8eqjtHn0ktn6074DLohqLzJWwK1PdMXlp4AB6+XSKw5uNKFwQp
	 do1ym+WIIDBG+YtsHidbLuT8Iexk5Ohw7Q3PHzyzttm/aXoJN/4dvHWzOyfvnUJeJH
	 hS5PQmfxrv75A7IbITX3GPHykDyOT38K0X1C2vWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1697/2857] ASoC: qcom: q6apm: clear g_apm on driver removal
Date: Wed, 18 Nov 2026 15:45:31 +0100
Message-ID: <20261118150302.433805867@linuxfoundation.org>
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
index 79bf618a90166..788de3e5624f3 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -790,6 +790,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	g_apm = NULL;
 	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
-- 
2.53.0



