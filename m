Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1BE3B1B4;
	Mon, 17 Aug 2026 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976843; cv=none; b=Fc01CEaQ6f3IhdxytBwfH9lOZfypNC25YJxIIvJ9T6r0TL1Bzf5zOygG9fr2ps18v4nv6qGAMx43MBTC8LvzvQH5OezoKx+GDNjZMlKmae+z2pvxqylPVk0ZAuJkM0UUbv5Xv0mPb0oBo7XvMIFUwc8D3wE1eTU43+Ge2CvmF4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976843; c=relaxed/simple;
	bh=DiW5ecsMbpS2YfU+qLDU0kBxWw/YW5NVea5weeGQMzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY8yySyH8IKfSVGSiGsKea66LAMqlkyqu2W5pMVZillaHzJgfZrGwp2yJinXI7Auv+wtoG3+lMkFPoDKunrilj1sjTIwdV+B0soBDHcGzkSn/GxEk4tMqMQ8T0jqxTkuJTWl0VsqEaShLae3BSOlDle6uHRTJwKf0V8HwfO/3Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wb9jNFY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wb9jNFY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F761F000E9;
	Mon, 17 Aug 2026 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976842;
	bh=/43aJTXKxxVnes/FqhgDv7r+qR788hb/sS0qsbbxyaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wb9jNFY+3+iqHcbyxAZ/VuPGbxagGgfMYAETo8yGNgwdK+c8jTo1ZO7ZLYZvmUn4I
	 6Sc1BR4iezCsNDemRBBq1jfHc1Is0zYr/wFfoi0hqBRjZhlyVAIYWimpoVM78mtdw6
	 SoPXxzE8HoZ0YlT8uX95L5br0UefYqczar9Hfk7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/456] net: stmmac: reset residual action in L3L4 filters on delete
Date: Mon, 17 Aug 2026 15:28:33 +0200
Message-ID: <20260817132544.902589016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>

[ Upstream commit a448f821289934b961dd9d8d0beb006cc8937ba2 ]

When deleting an L3/L4 flower filter entry, the action field is not
reset. If a filter was previously configured with a drop action, that
action may persist and affect subsequent filter configurations
unintentionally.

Clear the action field when the filter entry is deleted.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Signed-off-by: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260714023716.29865-5-muhammad.nazim.amirul.nazle.asmade@altera.com
Reviewed-by: Jakub Raczynski <j.raczynski@samsung.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6d971a5db00bda..b31d2a86057a55 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -671,6 +671,7 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	entry->in_use = false;
 	entry->cookie = 0;
 	entry->is_l4 = false;
+	entry->action = 0;
 	return ret;
 }
 
-- 
2.53.0



