Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B08168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9137BC433D2;
	Mon,  8 May 2023 10:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540768;
	bh=cJXSh2oG0AHWA3Sz+HsPAnGVsnWPwY7DHpd4hkI3Z54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbQMmoibI97QDJOdQT3L4PcqeMu6MymY54PxL1/RUXRVLtLlyCgIjuDEbGXZ7hC7p
	 rGLpsyJMC9NYA6SRfBCJ/PNyFWPB6yRP7ZQkQLLGW/oVO6664oAI8w+cyNXBrZmsuP
	 SI0FkRWpCvTvM1pX1xHB7R+T9BVdkByHm32xLAx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 458/611] macintosh/windfarm_smu_sat: Add missing of_node_put()
Date: Mon,  8 May 2023 11:45:00 +0200
Message-Id: <20230508094437.031130924@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit 631cf002826007ab7415258ee647dcaf8845ad5a ]

We call of_node_get() in wf_sat_probe() after sat is created,
so we need the of_node_put() before *kfree(sat)*.

Fixes: ac171c46667c ("[PATCH] powerpc: Thermal control for dual core G5s")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230330033558.2562778-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/windfarm_smu_sat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index be5d4593db93e..98fb31e00e203 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -171,6 +171,7 @@ static void wf_sat_release(struct kref *ref)
 
 	if (sat->nr >= 0)
 		sats[sat->nr] = NULL;
+	of_node_put(sat->node);
 	kfree(sat);
 }
 
-- 
2.39.2



