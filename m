Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040527;
	b=M0HxFqSyZLqJ95f9c8zRA+SGdpbaP15yTZg8u8e8sKpGytQ6G/3KbX5wzaF36EFOf3Tc
	 azDgnlRw8X1mji2a+YTomgRrmeasI1/6cVqrUXdqDYQCbBJ55gGvcXmW0Ub9Y+cjQlWua
	 0NdixxHyld4mcNODrb3Xx2/M/gJGILQMjHhW5NZM7u5KoBlOCqer0xGjWs0yHBXFFuD+l
	 lTHKoFAhf9TKevdDcDQPCGSzsTNDJKs8q85XU1gtoj4K1m0emYOgO6O7IFTYFobR0LVr6
	 NmGOYe9PkQiaHFUYZaaAdW4VB3VCKOKTdDgCuVhzEIsQONQBX0yTTLuimPJAB5Wr+rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ihwvMHTj0S67slqnon1CXo4asjl+J81vmaT6/pfUmTg=;
	b=Cp5gCWwWfqJXXLRYOe5YoEdmNlLaKfR/sgp8pF1naLTc13KjHiClnG+Ty6NmKBRvDQw3
	 9YTbBrAp2+Q3oeqKuyhNpjRPuN9W7xam4hygT3PiLssg8uvkdu7qVCOE1StX3d5KDoZj8
	 XcWkFXph4g4UdAPxRsOJePjklt+qLUHGbwvHfAI48DmLqKFnnO3SvYgTDlg4nJM7fxSAp
	 ubsTkIzVgGFRFWnz3G9Qg9EIQ0MCDEyKC9gNdijvWhU3VXlgbd5lWpnoarMCJhWLVotyp
	 AZQ32yKQq3aug6tTT9FNoSP67p3WA9LQ4LPbN+zZHPai7/d7EjQ21IE8IWjNtB1V3Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cO4pZzC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83003606A325;
	Wed, 18 Nov 2026 22:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cO4pZzC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98191F000C4;
	Wed, 18 Nov 2026 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040527;
	bh=ihwvMHTj0S67slqnon1CXo4asjl+J81vmaT6/pfUmTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cO4pZzC6AvuVZP3X1LUdiTnUllFOjMZJ/Odf/7JPPph1fCRqYSFIPBB4AEvLAY3mc
	 HKcewX426dBWCasslM7xGHKvDjDZsC71OU3l7FHZDfLjilQrsACh5jStTtcR3nI2WX
	 IxyvGfEEDRkdrfMnAygGyFATP91e0+l0N7a6AKJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2487/3318] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:51:49 +0100
Message-ID: <20261118150436.005725056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 706081c6b9327dd611dd72b20130a77f0f059b6e ]

dev_pm_opp_get_of_node() returns NULL when the OPP is invalid, but its
kernel-doc says "else 0 on success", which was never true. Say NULL.

Fixes: e2f4b5f8dc59 ("PM / OPP: Implement dev_pm_opp_get_of_node()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 56aa753f7b0d9..9af17ff6206e4 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1413,7 +1413,7 @@ EXPORT_SYMBOL_GPL(of_get_required_opp_performance_state);
  * dev_pm_opp_get_of_node() - Gets the DT node corresponding to an opp
  * @opp:	opp for which DT node has to be returned for
  *
- * Return: DT node corresponding to the opp, else 0 on success.
+ * Return: DT node corresponding to the opp, else NULL.
  *
  * The caller needs to put the node with of_node_put() after using it.
  */
-- 
2.53.0



