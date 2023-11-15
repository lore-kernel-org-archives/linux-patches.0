Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE73BB48
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYu09U5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C385C433C8;
	Wed, 15 Nov 2023 19:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078140;
	bh=qq+pQWndxCbzLlHkOtEBqm1nwkr5IyBnqrzwIF2OXVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYu09U5tcwbYKWSVwq72MW0ZLRgDiGm7NnckoIkqI0mODPjEhg4NH820EEZ245nrM
	 jtbaxDAvTENp/mqONZ5EstVyFgZ627UKS02RGt7eI2jBdKjWa6891JBakoVy0FfXoF
	 rAP42TTmYF3aTGnmHcIXFGiYz0M1mjoxG9By4xPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Maxim Schwalm <maxim.schwalm@gmail.com>
Subject: [PATCH 6.1 134/379] drm/bridge: tc358768: Fix tc358768_ns_to_cnt()
Date: Wed, 15 Nov 2023 14:23:29 -0500
Message-ID: <20231115192653.057214581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f1dabbe645065d20ca863c8d446c74c59ca1ca9d ]

The tc358768_ns_to_cnt() is, most likely, supposed to do a div-round-up
operation, but it misses subtracting one from the dividend.

Fix this by just using DIV_ROUND_UP().

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> # Asus TF700T
Tested-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230906-tc358768-v4-11-31725f008a50@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index 5fd89596c9a20..8429b6518b502 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -631,7 +631,7 @@ static int tc358768_setup_pll(struct tc358768_priv *priv,
 
 static u32 tc358768_ns_to_cnt(u32 ns, u32 period_ps)
 {
-	return (ns * 1000 + period_ps) / period_ps;
+	return DIV_ROUND_UP(ns * 1000, period_ps);
 }
 
 static u32 tc358768_ps_to_ns(u32 ps)
-- 
2.42.0



