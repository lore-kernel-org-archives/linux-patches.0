Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB411A9B5A;
	Wed, 20 Nov 2024 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107548; cv=none; b=Vqtzhjs52n51Wobd01iB1Br5aEoEcJpyCCAefyLCWjIvMD0awttGL+w9Bt5DnSTtmg/tNZxG8FL+GFXs/UzqmLv3I248DmQPTu9bmZtia0o1Oo6x/8fWRPNq9cFhuEp3zb9A0fkxrq1BA37128xZob4bBEwl6KdJp0VtK9YWwP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107548; c=relaxed/simple;
	bh=p6tgGSMsTkr79QyczEF27tdKyWbd8KJGGrkiHb5V08s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reu61PqJ0/TGCYcY94i2b+D5UtRYTdBsKKrIdJRBkbvNsgldeYzz4vtQzXFpveFTO5rD4H8C72OzPMZ9lo3yJOk/HGGqYL2lqHqn9nUDXkWbFA48SjBq1bRXtK9WcfR+xzLNm9lsGpvkds+J/vf55ybAP5G/JcSvHMtP0lLtuwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzWHoeOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzWHoeOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187F6C4CED6;
	Wed, 20 Nov 2024 12:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107548;
	bh=p6tgGSMsTkr79QyczEF27tdKyWbd8KJGGrkiHb5V08s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzWHoeOzFx4TyWAPT6sOlwflslQNfcZZZR1zRGtDnkTe6iqx2hsacMX5F/TUd8MJi
	 o1y4SGFZwY833qxCd0+kty8WuLvlmHvv0uhlJGh47uq0zevOxCal7RDk7oesHkY8jY
	 VrHSw4yLnuciy1EoXRCgR3vNjQTd7zEdkpedRsv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sibi Sankar <quic_sibis@quicinc.com>
Subject: [PATCH 6.11 087/107] pmdomain: arm: Use FLAG_DEV_NAME_FW to ensure unique names
Date: Wed, 20 Nov 2024 13:57:02 +0100
Message-ID: <20241120125631.665728688@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

commit 0bf020344204a2c1067b7562b6a247e6c689e28b upstream.

The domain attributes returned by the perf protocol can end up reporting
identical names across domains, resulting in debugfs node creation failure.
Use the GENPD_FLAG_DEV_NAME_FW to ensure the genpd providers end up with an
unique name.

Logs: [X1E reports 'NCC' for all its scmi perf domains]
debugfs: Directory 'NCC' with parent 'pm_genpd' already present!
debugfs: Directory 'NCC' with parent 'pm_genpd' already present!

Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/lkml/ZoQjAWse2YxwyRJv@hovoldconsulting.com/
Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Cc: stable@vger.kernel.org
Message-ID: <20241030125512.2884761-6-quic_sibis@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/arm/scmi_perf_domain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/arm/scmi_perf_domain.c
+++ b/drivers/pmdomain/arm/scmi_perf_domain.c
@@ -125,7 +125,8 @@ static int scmi_perf_domain_probe(struct
 		scmi_pd->ph = ph;
 		scmi_pd->genpd.name = scmi_pd->info->name;
 		scmi_pd->genpd.flags = GENPD_FLAG_ALWAYS_ON |
-				       GENPD_FLAG_OPP_TABLE_FW;
+				       GENPD_FLAG_OPP_TABLE_FW |
+				       GENPD_FLAG_DEV_NAME_FW;
 		scmi_pd->genpd.set_performance_state = scmi_pd_set_perf_state;
 		scmi_pd->genpd.attach_dev = scmi_pd_attach_dev;
 		scmi_pd->genpd.detach_dev = scmi_pd_detach_dev;


