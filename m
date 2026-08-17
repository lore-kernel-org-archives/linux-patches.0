Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF30C2D5A01;
	Mon, 17 Aug 2026 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975625; cv=none; b=lnYbLjBQNNQ/XMGsrk24jNSIOVfXgLgH+zMlCEhCZySEelnCy3arDqWwXxNyeUk8qD0bhip914Mu7JiOVb5IVG8a2wM0FIuHDMqH2kYMGH/LB55pomJtx6Sj64mHdN+tbyrazc6L73Qd5zIseYg0ntB+xe2ny11H/HZvLvZllBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975625; c=relaxed/simple;
	bh=M4JuEIadrNYIcDKGOJ48wBhuR9saRsbVY2YiON1CtVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+T7cPBKSpXuc5E+9xqYaE5XFLvqf4KFTgzyB92lHxe0sAwDDxIdh8TJmwUP7+3IAwnqYNznZ3JrDOBh4vNSnuZyhAwuLSMtWQzVEEiey9PZXvyw2Z7hzY4pm3XZMymMjUvPTjygCJcJmbMhjkoxqmlVRBJuxFJKopqWHDc53cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES6II+it; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES6II+it"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABF11F000E9;
	Mon, 17 Aug 2026 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975624;
	bh=IoKBhMFCDDP9s0agMdXbUs/g6RRzY+4mURHu8vNz72w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ES6II+iteowbaf6ZvliVp0XTkXtBGreo/K1pdhsOxnT/o+6VhYCnqi6iwmDnNlFcr
	 0nKgPxijKYQKEaWAqzu7G/PxraIiCo69kgv+YY/HREv7ZOic8SkEpqDYpzz8s89z+9
	 FHDG1MlePKU5XDHDhZSoW0iJODgujidD17o2IqnQ=
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
Subject: [PATCH 5.10 092/389] net: stmmac: reset residual action in L3L4 filters on delete
Date: Mon, 17 Aug 2026 15:28:51 +0200
Message-ID: <20260817132542.699078110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3539c1542eb8c6..f5977539129cfd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -603,6 +603,7 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	entry->in_use = false;
 	entry->cookie = 0;
 	entry->is_l4 = false;
+	entry->action = 0;
 	return ret;
 }
 
-- 
2.53.0



