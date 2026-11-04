Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829511;
	b=GQerwnTrQ9NkkR0BTABbYHr9XD/HjVnbs8dL4bYTZU3At9224hgpLgzSRWV26gIrZj19
	 vHi/T2UKAeWKgCcKnZMO8MNv6bheAW5BbM8BgzZYQpBrDfD0IesRM/oL1am+HubGvZv/q
	 WXRSeJ/h19V8UDdGhNUrzFjta6Q5IQqqsx3iN98st6K4M5hx9nBSFt2M9QFEQGu3Xj87y
	 Y3CtLfYk0fAA4oU9+8f9fJjCgLHT4U1DeVBFpfLsz5hcXY5N2EdP4bJuu17Zf/JZCeB56
	 1nMgsSHUdBse+PDSeCFuQfxfZ/XiMSxF7Sh0bhnpa9sYjghoTkJp0zNVZvGbJiTOHMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axu9fWYlGi/f2qjdAdmTyg2XtI8sphY0NxoWNOB4bAk=;
	b=nb1ZsvMR1Ady9L9OBQmXW7BJer1C+OWR9UxuUbceQurGMQZijpe9bBohTUnF82ERJrcq
	 OMdBPwkyLx2+ViozAzknwgSREE6f6RxQhkM1/N6YoPv5SvsEcerR0YwO24DjMVGyDpF4Z
	 n6wNcIErj3ujGjKk5x3gN+TZMGHaj46U4oXseaRjWyKKi+hYy2E/6irLoccwwrTsIaga8
	 GEvb3ofj/wSGtAxGR0d1o9ClYriU2anMaLkp3Rt2PwLTWeLKxBCnKV+nCpIMQnng+36l9
	 fp7eGM+8FP/tYSAfOkHlZSBqGheUYR6EOXiQUuvfLwBrAlfncOfqdHMHD2XwMd6MsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nyzZ/qL7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AAB606A87C;
	Wed,  4 Nov 2026 21:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyzZ/qL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FFE1F000C1;
	Wed,  4 Nov 2026 21:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829510;
	bh=axu9fWYlGi/f2qjdAdmTyg2XtI8sphY0NxoWNOB4bAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyzZ/qL7SuBhThGdnhnYZ/uGfajBFgJ8HyUGjfLj+0iUskPghP/YuxhobLpRQ0fNN
	 x8lgkaTvZsj5q+rGR509QK2j3Og4npmHIIZSPhy3NwZxT5mr4bRxSFE9hw8n4TwAIM
	 vRIXTqbIfgdWaY2VW5S/8a1eLAWYHDFC4XgynNbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0170/1005] media: cec: tegra_cec: dont break off msg on NACK
Date: Wed,  4 Nov 2026 15:58:23 -0500
Message-ID: <20261104211048.533146488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit be627f257ce283c95fd2988080dc0db3a20d0d2a ]

The Tegra CEC hardware has a bug where, if the first attempt
to transmit a message is NACKed so the transmit is aborted,
then the second attempt can contain corrupt data.

Ensure that the full message is always transmitted to avoid hitting
this bug.

I suspect some internal state is not reset in the case of aborting
a message due to a NACK.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index fe66336e734f8..f8ffaeb78118d 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -243,7 +243,18 @@ static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
 		  TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED);
 
-	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
+	/*
+	 * TX_NAK_MODE ensures that the whole message is transmitted even
+	 * if each byte is NACKed. Without this flag the retransmit of the
+	 * messages after a NACK can be corrupt. This is a bug in the hardware.
+	 *
+	 * While less efficient, in practice you rarely transmit messages
+	 * that can be NACKed, with the exception of POLL messages which
+	 * are just one byte anyway.
+	 */
+	cec_write(cec, TEGRA_CEC_HW_CONTROL,
+		  TEGRA_CEC_HWCTRL_TX_RX_MODE |
+		  TEGRA_CEC_HWCTRL_TX_NAK_MODE);
 	return 0;
 }
 
-- 
2.53.0



