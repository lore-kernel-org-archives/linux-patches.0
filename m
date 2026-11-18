Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028743;
	b=dHvvB9KAp0yxDAWfwKWHviBvY+Pq3RVmCdB5eOWwLCBRcvt2EJ3Gq3EAJRGkdCncD6KT
	 VthIeNZUmabh0atPQ6Z8GI3ewLUDzbRaXw57VvzhSJD1cHmHvgEkPDvt68tHEKBCZGeeJ
	 yR5izLBY90icY9kwoPiwpQyu1J1hesRQ2CrQMEYbLL1JVGzPRqHidSy9zomVyyrykoc17
	 HLCSbolGptJS0X6lXtQqgxh+H6qtDgZBv+APm2TlUnASuGxA9r5FMUlGWaIybPzyYyKGl
	 7f+ioyYcR6KT/d5BxsR1rCGYRdirAO067b8xG9eMOogPua8p49j9dF2FmX4q0RBqNxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yvEddjb5K9lu7qQTDo4+No9XAAbO4iaZtfVtbFGw5ao=;
	b=kb34mK57wFw614yXgb0Jpag+JgvGiYa9VeEACJz8h1o1bf9OM0QdLIo2+x+F6A2yymQo
	 nlCkSuvlB6GyTJvAnV5kxvuVSaTZ1KEjrAHsRHtg5K4Y10LxHzebMlYJVfX8GzF2pQRZC
	 ov1xDzuo4VcY184QYArqSWIUMIAZBm+GpYai3Mfx82H78OMe9dmMg6/3X0agBKjlb6o+e
	 Yl8duWZPGaR0EKrl/Zzx3nmmqQIelJWnit/y6xfwmWhfnSqtiE907DdHkMY75tukcSxP5
	 pekY6reyox8XQYyQC5Ej1evAkFoSeg+oV3CRhyAxz0O4nTnjrKHZEZV0m7C5POwOtKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JUXBByip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE877606A32C;
	Wed, 18 Nov 2026 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JUXBByip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F43D1F000C4;
	Wed, 18 Nov 2026 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028743;
	bh=yvEddjb5K9lu7qQTDo4+No9XAAbO4iaZtfVtbFGw5ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUXBByip8rjvciFaT6oyNsGVjOJhlH6D0x4waz3XvZMTsk517Yf1Wy9Ort0EMlzMg
	 8jqXt+TfZtqsbtHDIManSmSUqq7ZAtq+kEQ0GThGa/cGtddNHvjSyqGE2z0aX75rul
	 wyL+0FaIm8q972j0UDiN736EgfHc0yX9BkIzMSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0103/1756] ASoC: qcom: q6apm: clear g_apm on driver removal
Date: Wed, 18 Nov 2026 15:37:10 +0100
Message-ID: <20261118150012.326946345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



