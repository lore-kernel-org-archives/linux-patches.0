Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3379923815B;
	Mon, 23 Mar 2026 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277254; cv=none; b=pJbhqArkzi2qEeC6+sAmiSIQ5N3di6T4ex8K0+1y1c+f8Vrimj0C6XyYCXXePFnuMiSY6fdZZMEa+qbJ9z909eHhb+IdBzxaBOU6eVem4u9+7Zq7WDEwKFMow6dmrjdqHg+hHhz/Obdq/UXJ54ouyyhL4TfQlXsAM9HSEtw6vvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277254; c=relaxed/simple;
	bh=NN6TkM1QFZzFyIryCFSauukSji8uwuNkqYb0qD5Yvsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUCl0RvWom/1ZVEeFpUyX+Z22aETGfkF6CX+ahNa7q/POmDx7jxWiuGKvhmy7SjoCllnNAjEwesXLABRF3cOn4YW5ARNsx5oxhgNIv3J2rXjWxddZypHq/BydIUm50pIQtufeV2RYGp2SNVw/vbUynAXcFzvG5yL1hRSEtxJpOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBsQkLf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBsQkLf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8570C4CEF7;
	Mon, 23 Mar 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277254;
	bh=NN6TkM1QFZzFyIryCFSauukSji8uwuNkqYb0qD5Yvsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBsQkLf98vo6sTp6OQ/4rT4Wyo8VYPchgGYZKtEJpk+Tg0OU2WxSyEHEtNGaWmmIV
	 RdK8tIM/hLsTNuZAM2+rySjrKoVKUMnhZu2XAKmfBToyiNUdWGfDZOFhPus1ZlO9y0
	 ujKOl3TF68vXGmIT5r3uhL9qBip6ZBfSYWg7S7PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/460] soc: rockchip: grf: Add missing of_node_put() when returning
Date: Mon, 23 Mar 2026 14:46:07 +0100
Message-ID: <20260323134535.680284672@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dddfe349b3da3..6fd02220abf1d 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -217,6 +217,7 @@ static int __init rockchip_grf_init(void)
 		grf = syscon_node_to_regmap(np);
 		if (IS_ERR(grf)) {
 			pr_err("%s: could not get grf syscon\n", __func__);
+			of_node_put(np);
 			return PTR_ERR(grf);
 		}
 
-- 
2.51.0



