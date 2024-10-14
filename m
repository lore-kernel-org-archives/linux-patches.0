Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E031A28C;
	Mon, 14 Oct 2024 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916469; cv=none; b=PDUKeR1i1XQm24/BmSYXHt9HXCjCY+lhbOjLxygIZIuKewI2a/Hw2tpmP2mQVTLubCKLqwT+TpYA006No8V6pYMPCrBBZDCWKfIv5A2Dzl3/DBsG22QQDzhbAGtH407WQIvUAapKsWmk2uQraTdB9v3f7jHYZ69qqhWcLDUHj/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916469; c=relaxed/simple;
	bh=Pbl7lH4I1+hTOSnDkwJMJ3Pndg10Ca7Wk54MKSCeKJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us4S/abgHasLkHfoAb4Q1SL2wRlefslMXW+aWRpTF1FnCZXQPmhrw/j+2Em0i89PPdZxin7NZUUIXGyRuaZwgv4gyVFbSb9X5vVly2taa3p2OY3y/QYA1UUVnEVU7aBpYK14359G1uHbWEJ9AkMiWP5ZUE4mcggouCRiMzddjOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm9w+i43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm9w+i43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8ABC4CEC3;
	Mon, 14 Oct 2024 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916469;
	bh=Pbl7lH4I1+hTOSnDkwJMJ3Pndg10Ca7Wk54MKSCeKJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm9w+i43/kNzXR/7fkNWARDOyMGcChWdlYG1c1OWGAVEZLutYNW++1eCJuZPC0SMe
	 epB204BZjQKmRdDwFI0QkIS6kLEEivBAk4qyblpeDzYw7K/nqxbbkNf6QFE5nmgjqz
	 KFqMGm65hzV+dIb1RgwewJKymw1TwwB3/GXHmYQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 191/214] OPP: fix error code in dev_pm_opp_set_config()
Date: Mon, 14 Oct 2024 16:20:54 +0200
Message-ID: <20241014141052.432419740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit eb8333673e1ebc2418980b664a84c91b4e98afc4 upstream.

This is an error path so set the error code.  Smatch complains about the
current code:

    drivers/opp/core.c:2660 dev_pm_opp_set_config()
    error: uninitialized symbol 'ret'.

Fixes: e37440e7e2c2 ("OPP: Call dev_pm_opp_set_opp() for required OPPs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3f3660af-4ea0-4a89-b3b7-58de7b16d7a5@stanley.mountain
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 494f8860220d..3aa18737470f 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2630,8 +2630,10 @@ int dev_pm_opp_set_config(struct device *dev, struct dev_pm_opp_config *config)
 
 	/* Attach genpds */
 	if (config->genpd_names) {
-		if (config->required_devs)
+		if (config->required_devs) {
+			ret = -EINVAL;
 			goto err;
+		}
 
 		ret = _opp_attach_genpd(opp_table, dev, config->genpd_names,
 					config->virt_devs);
-- 
2.47.0



