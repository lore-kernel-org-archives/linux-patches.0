Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B716D3ACEFE;
	Mon, 23 Mar 2026 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274773; cv=none; b=uL3JUiC3G4ye5ocY9nzY/QDUNK+kQ+qAS3GYkMZdV9rjWLISnsmD3cHGSiYzR4gO/JPvC9rHsimkth9ZkLiGD8Lw3MSII7uSld1lVWqgSR2Wqg8sFocdq8jsklCJqv1HJsmm2IUR3fzXhg33S6Acl0u+riELStDKCR0FGre0AQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274773; c=relaxed/simple;
	bh=j3uEo1fB2tx0U5Ni7NfgqSOMGxOUsV++ZwNVgWNtSbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1OKePZNpO3Bc+Z6v7QZqHWEOcdYl/PxUvLRS241D/XYH4DO25Cpxa2DUeuetwLzrfVDDe7AEpv7RQYTSjG2/6DK+Qxxg5nNzfKubWZQqbN0W8D2sUOALbfCd4fh/JuZQpVHTrI0SxicEiXwBanvLHlQs+HXkFnBwHOJSiNNofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYn8CQU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYn8CQU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A858C4CEF7;
	Mon, 23 Mar 2026 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274773;
	bh=j3uEo1fB2tx0U5Ni7NfgqSOMGxOUsV++ZwNVgWNtSbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYn8CQU3lgGZ5Q7/TjPg1JN9v93UiIFrwZJN0nPg0R2YyJNC6BXQQPjYysEAihW+Y
	 n8DcL2AuQI7CmyPtTfdoP8DD1KQksINpC9OxZfVf4J8WpZxq+HRWjP4DNp0+fo3ABS
	 6xFF5g2lSPQeODPJORJurGd24nsy3UkrLtiWkSMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/212] soc: rockchip: grf: Add missing of_node_put() when returning
Date: Mon, 23 Mar 2026 14:45:25 +0100
Message-ID: <20260323134507.067741812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 24ed11ee5bacf9a9aca18fc6b47667c7f38d578b ]

Fix the smatch checking:
drivers/soc/rockchip/grf.c:249 rockchip_grf_init()
warn: inconsistent refcounting 'np->kobj.kref.refcount.refs.counter':

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 75fb63ae0312 ("soc: rockchip: grf: Support multiple grf to be handled")
Closes: https://lore.kernel.org/all/aYXvgTcUJWQL2can@stanley.mountain/
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/1770814957-17762-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/grf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index db407fa279850..1f070e0becb52 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -216,6 +216,7 @@ static int __init rockchip_grf_init(void)
 		grf = syscon_node_to_regmap(np);
 		if (IS_ERR(grf)) {
 			pr_err("%s: could not get grf syscon\n", __func__);
+			of_node_put(np);
 			return PTR_ERR(grf);
 		}
 
-- 
2.51.0



