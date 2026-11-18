Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030504;
	b=ipGv4jpvPNjl+mbZWCG6VLJvY5t0L9tC5qotrJAbttv6R1wQ7kpBUiktlQZPjoN1C+ls
	 brCfwA3w4DUtzSKNQYAYHUR6RMZHpt61l8LQMotuD4zwtgJuFtgR/uiTwoTNMCdKvIFP3
	 SA+dJxrp+Xf+iGaDhX7uQQbaN4+ije5bu4yNf/jdZL+Qtu/6OwXITnGfwjX5igajgeUba
	 JmiLd8lJGOLezCJXjXVZKQr5pM46SXYLZ12gBk0Nn9xsdZMtRb4EMjKtQvWC9uOL052i/
	 n+BCD8zusPEPbwoUf6vUo+GmyyY0IWgFUU10mxYslMn54r7BOgMEtd5SHEnbMKYjXrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qcGDSPJgVCJQbDWMxk9RfxmTX41119+LA6tH3LB/9t4=;
	b=Uu5muAs88hm6gdRk0kAXa6IovxnUzrYTtquMaFertmCjfrhBLWSW9qeAPKFoOjJ7SOVu
	 1Db26TFNRDHnRNQ57o4lXZBspEBAn25Wl5rzihnpUm5+4dRMyepqQBM+7ew9J1QH4cavZ
	 kj5pFK/klMplUSJ57TM5DWAlEBAzX2SxykpZijna5+xnRj6oqwtONc2fiMgg8K+DHJSzb
	 PC7jGHdc22ICCwvXghxNfJjjZL/pVQ7E+UP0PW2c3aA/lcc2ruEET+q9/X2Haxg2Hopf6
	 4zcV59/dIsb3NfhZWlxsIF/hU9+LLoRlTF2eLAydYtcleQUSTV5iMjBoZ6zhl8jExZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asymJCUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4B606A325;
	Wed, 18 Nov 2026 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asymJCUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF5F1F000C4;
	Wed, 18 Nov 2026 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030503;
	bh=qcGDSPJgVCJQbDWMxk9RfxmTX41119+LA6tH3LB/9t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asymJCUyLjpTC0ixaVIcxiMqDix1lJm69qgfjHFzmACzjMY2hfdhkKTy6KQdgiGPE
	 T/GvqS0hG7fG6KfvQJOwS495vrWmL5kRRTHm1oOyYNFMqzZUUrOzxElifeS0eyLarH
	 Lrd1Gvxzfxfw56UWA1K094JnICbyfUJfcdebRwTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0727/1756] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:47:34 +0100
Message-ID: <20261118150038.622882087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 286036abf4ca4..c01f142305d22 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1482,7 +1482,7 @@ bool dev_pm_opp_of_has_required_opp(struct device *dev)
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



