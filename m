Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F7B200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232D1C433C7;
	Fri, 21 Jul 2023 19:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966318;
	bh=ds2pkiK9ioYtLMnF1E+bHeq+zdya3OIjPr/fc76HNNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rtf5lr/YGXD6hT/TdlzM6WgxL7yZb/jYdIyQM9LJzxUzlhVG46vnbADmlQch4vBK6
	 NOKfK6L1UedD7ZrtHSB/STioSK7GAeThEiSuatDA+MjvtDi8rab3ZyNmY+0qrxyYFA
	 qygSDrAW2PF7vgAVfRE/fhSCno9hyT3MNzc4eHD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/532] mfd: stmfx: Fix error path in stmfx_chip_init
Date: Fri, 21 Jul 2023 18:03:26 +0200
Message-ID: <20230721160630.777884375@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit f592cf624531286f8b52e40dcfc157a5a7fb115c ]

In error path, disable vdd regulator if it exists, but don't overload ret.
Because if regulator_disable() is successful, stmfx_chip_init will exit
successfully while chip init failed.

Fixes: 06252ade9156 ("mfd: Add ST Multi-Function eXpander (STMFX) core driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20230609092804.793100-1-amelie.delaunay@foss.st.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmfx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmfx.c b/drivers/mfd/stmfx.c
index e095a39301423..6e1629beb8094 100644
--- a/drivers/mfd/stmfx.c
+++ b/drivers/mfd/stmfx.c
@@ -387,7 +387,7 @@ static int stmfx_chip_init(struct i2c_client *client)
 
 err:
 	if (stmfx->vdd)
-		return regulator_disable(stmfx->vdd);
+		regulator_disable(stmfx->vdd);
 
 	return ret;
 }
-- 
2.39.2



