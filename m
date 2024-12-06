Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAA149E0E;
	Fri,  6 Dec 2024 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496853; cv=none; b=cMhVhYheoZ8cGHT3na+aSAbqTD7f5wvU87rWbYeKLyQ1ovUljxCCnol1+miVtsCPj81Kl8Av/L+wzttrK8Ga8FxioYi7WiGSwq7cGW7wISI2qHfWN1e62AoQaTphamm/p5xZ2hQG19ZFgBPjwqGpl5Y3CrIF2xh3vvMGnbrbtWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496853; c=relaxed/simple;
	bh=P+s+MSRYrnkk5iD4/Q+me0J9m4+vLjFADBZihV6ydIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8ZJh6dzSR/Bc1ZkL4A8dVr8FBAWKg0GekqoG1kP1+22z6NRGNZ6wUrXrOeyvAYrGWhjwN/mDZrFcBWTGkaUQKcEFeZ1Ky7it+FwMmedn2oumTDMBf2LMdL85T1b/vIqcu9G6ET7fLzfjBHT1XC4vz+/gM0sOc/Xl8SuaOhsZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsD3XMou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsD3XMou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC76C4CED1;
	Fri,  6 Dec 2024 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496852;
	bh=P+s+MSRYrnkk5iD4/Q+me0J9m4+vLjFADBZihV6ydIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsD3XMouzQF5bOrmIk9KStOYHr6GT6FikzWel6gzujGhemYRJAM1mmDZFq33m/nvM
	 PHwQqJbmwzMaZBU4UBUlceyDPK0uAoxbzqC4d3hO1QuAQAIEAlE4gE88+Aee1QGYm0
	 +FzLOSm4Xj9FlrPF8PqSlFKdGi9fYqOQmArJV9fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/676] media: i2c: ds90ub960: Fix missing return check on ub960_rxport_read call
Date: Fri,  6 Dec 2024 15:29:04 +0100
Message-ID: <20241206143658.237256255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8ba5750f5a231..7f30e8923633e 100644
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



