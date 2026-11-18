Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054751;
	b=PanL5jWMCdk5MCBZ+gyKbFsxXOEgrVKthRm0pWky0F1JL8HkBMTBi0LpoT+FvdzCNZtm
	 04EJI92NzacW+oLjOoxelYpOYHIYs7nbKquTrrDwJcqY2geEsgLI238TclEFizwR+Sm68
	 DNlITlqpqZa+TdP9ZOsNs6seiXJxhMCCciKx2TVJxlQDGqNgvz/4TjAWl9xe6+w9+B6zr
	 vXjDq/K/yxkGcb23asQiRKL1gTXkGv8SljC+uTbM1OiqoxMvYKCdEjBuKwVo0ocETlLK+
	 GyUO8uV6BD76lsBWSgr7qm5RFcpxFwFR5xGv1c9O4gsg/viV6IYJmtUG5U5eJt5LmpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UBwztPxvvWoQJuwAFEzVrU+Q5PoB9GTGHXtpQVGnCto=;
	b=bhuIscy77CCzAz4gHH9hoDIaQE7NUOcAaJHlC8e+zxglL9m7T7jqYhDFyn0wXA5TTKwL
	 MWn1PtVXKdiUyZ5t4gap/7KhazvEjTjE7ugBlALA5nD0aYm55gizpFXB6eDbi2Qe9JOmH
	 CJB+cNgchIDvQil1phXOB40N0Oo9fvygQ19Ojz4iV/S8kbPxMf6wRg0TyVFQ8tcnIFLTB
	 sj4C1xc515x2D7VODGY5+Le8ZMJaXLJ0OD6F7D1+e+ez6QqEdWHIItPexUGHDFx8wALQn
	 j4RPVzpZwiaAhua4fFDRF+KFCVN584L8EwZLNd3VFrB7MG4TX87ZrCFIwMvjou9E20g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+tEibNV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CD3606A320;
	Thu, 19 Nov 2026 02:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+tEibNV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D712A1F000C4;
	Thu, 19 Nov 2026 02:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054751;
	bh=UBwztPxvvWoQJuwAFEzVrU+Q5PoB9GTGHXtpQVGnCto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+tEibNVSoryUBFGXl9aXT2MXIcrPkIPvIgjZXYj6PrkIRH9lomLBfaGzXBGqqTQK
	 N581SYcKzd2eD2m3ggmLO0+2yk1qsZndeKkH8uCglhyglBd5Dvm30hu6ZuxwShS0Wc
	 A4qdG8+E6A4aOqO/EV66JXjNHxWXnXdgiuH81EDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1387/2214] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:51:03 +0100
Message-ID: <20261118150106.830551701@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 24fa0eadc2e3c7e9397924197dca7777ec08b8d7 ]

The MP886X vsel is 7bits, fix the vsel_mask.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260901043123.5401-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index 8ad4722eca4b3..7910896df51a5 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -267,7 +267,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->min_uV = 600000;
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
-	rdesc->vsel_mask = 0x3f;
+	rdesc->vsel_mask = 0x7f;
 	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
 	rdesc->ramp_mask = MP886X_SLEW_MASK;
 	rdesc->ramp_delay_table = di->ci->slew_rates;
-- 
2.53.0



