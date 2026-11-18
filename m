Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050876;
	b=mYrkU9HweCSgY8aUmUa3g9B/85mV9iQtYe6275TCfoLbyCki/w2atOHhTUrFy4MNs9oh
	 M/urBOJUfeIBa8/huRRdDVP3JLQ/Qrp+qUFV85ONmWRSlv8/tWN/nABBY9oQ0gF3RQJOZ
	 NJxmBMCjor7YjoZh3eZZye0CEIZI5GlUdU6DVDtrtS6unjxstJG65BxjZkg26yHQi7l/J
	 7JA13A+nyjANbCwTMTtqOb3Bff6R7yj334GqUOJNr2Jx2MnvaSOhlkZLN2bXIzSUCYbiq
	 93WjfNG+VMjxNYPJ7RlzZQt/GDmAKxaF0diSLzeepSu1qxrng+4afsWPdICexF7MHHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qY25DY0qU+L1iitL97YqO1vNh3S7Bmi3/gPkzIvwdAc=;
	b=XEQG6l10rc02+8nMOUjFulIM6/iXqh2/Pq6jgjL0TgVF7kwAG9Na9xgZ6kz7d7szUvgX
	 lz/Sm9MiH7IfUdjwJ4lI2L51QuODW4a5PcjgWlbGo7gZFWIgDkTPmiqPPQR5uMZM2XOwv
	 adKgulq0VS39DAlL+PJnZ3NJdAWJJIWpILwKeqz88oVAfQQd0+vDe4/8WVb6jKwY922qB
	 wlCo4Ei2RkaMZUTyR/Nb3K1ShxKYF5jhRZBbHwb4fndIUCt3VZ8oDsOMP8gDc1Mo2kHv1
	 KUjZ6qTQ34pnUAYztbItaeg3xP1IJSlcSDMGWAJs9WR7xTVfzayZ4vcUa76o1u4UMEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qxy2gCDA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529FF606A31C;
	Thu, 19 Nov 2026 01:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qxy2gCDA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7CE1F000C4;
	Thu, 19 Nov 2026 01:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050876;
	bh=qY25DY0qU+L1iitL97YqO1vNh3S7Bmi3/gPkzIvwdAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qxy2gCDAURrcZV3JLrMXvgV/6B2meNXSqwYYHeKTo3aO+t5ycRaCAO21jRDryTzJW
	 nShk1s/HJ1gyDN5EfiZgIubKnr9c5zSu3ySxkz53ABTM6Vf09qy1iRTesst0WeWUP8
	 bkJIjeA7OdZ/c9sHbGmtncDoWU+o4y7vBPAWLONA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 2849/2857] drm/msm/dpu: initialise clk_rate to 0 in _dpu_core_perf_get_core_clk_rate
Date: Wed, 18 Nov 2026 16:04:43 +0100
Message-ID: <20261118150344.167292161@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 34202be9523718838c620fdadf2e985890286883 upstream.

When removing the core perf tune overrides, I also occasionaly removed the
initialisation of the clk_rate variable. Initialise it to 0 to let max()
correctly calculate the maximum of requested clock rates.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 6a4bc73915af ("drm/msm/dpu: drop separate dpu_core_perf_tune overrides")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/551321/
Link: https://lore.kernel.org/r/20230804094804.36053-1-dmitry.baryshkov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -287,6 +287,7 @@ static u64 _dpu_core_perf_get_core_clk_r
 	if (kms->perf.perf_tune.mode == DPU_PERF_MODE_MINIMUM)
 		return kms->perf.max_core_clk_rate;
 
+	clk_rate = 0;
 	drm_for_each_crtc(crtc, kms->dev) {
 		if (crtc->enabled) {
 			dpu_cstate = to_dpu_crtc_state(crtc->state);


