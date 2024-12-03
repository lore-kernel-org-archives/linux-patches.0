Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A8E1F706C;
	Tue,  3 Dec 2024 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238105; cv=none; b=epWtlP0392Aik1T9DAcJHU4PmFbCW618KzoeRNvl/ca6z9I/WnXpEsBw/5lmR97zBidwkPCTYAOgVZfataf2IMTTnEzJM74T4Mg8ko8KeHf+JwTglQ/HsOJmA9ho86ZeC3qo514W0m/nS0/I9QwC/Zo8qwm3JWDUdc2TFQkCWLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238105; c=relaxed/simple;
	bh=PVLaqf1VR8y9SPbo7m0i+XeMCFhdmc+FUvfVEEBeG3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oetwcqFFrJ9+PqQqfA65koaxc7QMjbv98sYxsVsD7AGAM08YydbwOG9nu4wlTIHdr4w2KL+VNpNMt56mglG4VZWgjgvhaUfHN7Y2D1BjwhPnniKvEDw9WSodCpveYOUyxvbmNuUihgq6kynGPIUhRM0l/lc9esW/oQibWLgiq+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSrA0UCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSrA0UCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D063C4CECF;
	Tue,  3 Dec 2024 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238105;
	bh=PVLaqf1VR8y9SPbo7m0i+XeMCFhdmc+FUvfVEEBeG3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSrA0UCa6/aqekZvONx9VxdFyTs5y5syVNBN/aIExKeLdT3SuyHa8nYnvtTyzkqcZ
	 wfAxalnEshmn1j8picaHMYV8xXTmH6hvCS1Bhwrzmcf1Atk4hdW2hUIPfv+FKbK9xr
	 Fd3qhFSDKbWiBXhxR8UOaI4ajJXcof36Ad8Y7V8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 163/817] media: i2c: ds90ub960: Fix missing return check on ub960_rxport_read call
Date: Tue,  3 Dec 2024 15:35:35 +0100
Message-ID: <20241203144002.091207122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 24ad2d1f773a11f69eecec3ec37ea3d76f2e9e7d ]

The function ub960_rxport_read is being called and afterwards ret is
being checked for any failures, however ret is not being assigned to
the return of the function call. Fix this by assigning ret to the
return of the call which appears to be missing.

Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ds90ub960.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ds90ub960.c b/drivers/media/i2c/ds90ub960.c
index ffe5f25f86476..58424d8f72af0 100644
--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -1286,7 +1286,7 @@ static int ub960_rxport_get_strobe_pos(struct ub960_data *priv,
 
 	clk_delay += v & UB960_IR_RX_ANA_STROBE_SET_CLK_DELAY_MASK;
 
-	ub960_rxport_read(priv, nport, UB960_RR_SFILTER_STS_1, &v);
+	ret = ub960_rxport_read(priv, nport, UB960_RR_SFILTER_STS_1, &v);
 	if (ret)
 		return ret;
 
-- 
2.43.0



