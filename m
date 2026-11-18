Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039033;
	b=qtAa0q87GfU0JLRuURzynlqxUbhzSqF4NUHbvQt/gB07ztM/ddaCwJYQB+vlXTbijGO4
	 R/83uoM8V/yNZAoObXQ8jxeWmFHdmDHMK9zZzpMxWkP54e8v6AdQpUK0agiGtutn9QH+x
	 xft26HmfQtrgjY7DLwZmgWpavaN+2gDLJmxKDMZItzfZ/SIlT2l9axH85YJNFBcY/IoyC
	 8fa9vt4KqML97L6uYBFx3LcoH7qq+NED/F9YYfrLL3FkJcpTWUSDw1XRyep+Hx7wzkyLg
	 JZq345Y17Ctq1g04VxGjDlZAS0kcgBWwwJVAKW/Lu99Rj9DHedC+/QJTcCNKH0/mJQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C25QxPMEgXYv7nfaYGm/TBklXtow+uinAwW5BMVLcQQ=;
	b=WnsetEb1G7muFT0FoP5qvHIDfWaTzBstwms9HJgRQoV3s96LPaCSD+LT9FxpPvY2RB2F
	 4lGxILowrMCy5l3UPgc8+u5/kJvQ0rUj0ac25Oexsx4ey4Miv1y2Lxk33aoWJ4k1Sja5Z
	 j/keVMvQG0f5iV7xnQ3QUhTbQUImnOiRGk3qC3LQM8itE4Slpo7rUMjSsrJBfU2X6gOPR
	 BeBIajPeZWqozlmmRnJZSaNvIXbIskg/WGWSdrnbfY01yh9HnFOBwQlhzyG+Ff0gQLMgG
	 Q1pYtz4mj+TH+RXZb5QlWNbEUzmT7/z7EufpHSBRBMnSdpU7gu+i1Phf3Lxx5pRO9KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/QkHegc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD562606A325;
	Wed, 18 Nov 2026 21:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/QkHegc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3286F1F000C4;
	Wed, 18 Nov 2026 21:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039033;
	bh=C25QxPMEgXYv7nfaYGm/TBklXtow+uinAwW5BMVLcQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/QkHegcpkGCsQ0THJ2gR2SrT11T2ThSmmzuSeBJZxU++IDp153qcHrc6P9bbcfVY
	 H9VeiSuBQoNkl0EyliB5RMkEs8WwJ9LXcVACV+S44cmM5twYVntiXQx4FDqSJlJNaD
	 9EIH+TbJPU2BmOCm8YYqI1oHPasXRvNeeKfhZVCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1954/3318] ASoC: qcom: q6apm: clear g_apm on driver removal
Date: Wed, 18 Nov 2026 15:42:56 +0100
Message-ID: <20261118150420.698556712@linuxfoundation.org>
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
index 1025ddde9e316..8937b3b797e58 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -795,6 +795,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	g_apm = NULL;
 	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
-- 
2.53.0



