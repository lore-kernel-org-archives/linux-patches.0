Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF0CBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C727AC433EF;
	Tue,  7 Mar 2023 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209701;
	bh=OZdwRaIXCowRIk33gj614RkTEgt+m/8idpbUsFriHok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YO7a94jsHtcYtHA9DukVLnfOGoSldbZvl7//HaG3xrLG2v31Zp+rLHRVlmD7h0GuX
	 /7IKFskCdIgEEuQ1VTRZjap1LPsL4gBxLJu30YzMlLTst25aKdNoDJm5C7xvKdWHTK
	 oETVzFzzppw+0fMdmpqwIiLvLkr3CydwQUY4YnhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0304/1001] tools/lib/thermal: Fix thermal_sampling_exit()
Date: Tue,  7 Mar 2023 17:51:16 +0100
Message-Id: <20230307170034.760724162@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit a29cbd76aaf63f5493e962aa2fbaadcdc4615143 ]

thermal_sampling_init() suscribes to THERMAL_GENL_SAMPLING_GROUP_NAME group
so thermal_sampling_exit() should unsubscribe from the same group.

Fixes: 47c4b0de080a ("tools/lib/thermal: Add a thermal library")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230202102812.453357-1-vincent.guittot@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/sampling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/thermal/sampling.c b/tools/lib/thermal/sampling.c
index ee818f4e9654d..70577423a9f0c 100644
--- a/tools/lib/thermal/sampling.c
+++ b/tools/lib/thermal/sampling.c
@@ -54,7 +54,7 @@ int thermal_sampling_fd(struct thermal_handler *th)
 thermal_error_t thermal_sampling_exit(struct thermal_handler *th)
 {
 	if (nl_unsubscribe_thermal(th->sk_sampling, th->cb_sampling,
-				   THERMAL_GENL_EVENT_GROUP_NAME))
+				   THERMAL_GENL_SAMPLING_GROUP_NAME))
 		return THERMAL_ERROR;
 
 	nl_thermal_disconnect(th->sk_sampling, th->cb_sampling);
-- 
2.39.2



