Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025025;
	b=BBnym4xCHyxS54PG/XOCyqtqX7wl6LpDRzdnTUMlrNRy9j2yMJKjzMoeAQCGv2322PO5
	 H7yVKFDHp4gmijhaUxnRy4BFibsuuwTEDZybKEZafvCE7xW3bFTT2271M2M171CtVkbk6
	 IICVyLqTvvdm5q8fSQ7fFSkJFU7j4AmoEQlF8Mo2+Ju5sFBaj8QKu9mirr2x/PUupZVRs
	 f+qFyFxj0H5Bq6k1/zaqiAnFFKk+KB7586iA+leQMaFSBnNzQx4tlD7RwZt7qFuxi665h
	 kJKBpzax6uCwi/rP7mWmIWKsX6g8KV94JqIPVojz+6YcMltYGE5aGob1q2Z8EHTAidQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcDtVMDg/fz9AZnZY6G1fajeyMJ1jSg0+uwzx+9Xs9c=;
	b=v3DJw7TrOwuE1ZTC6Hkrkp4P7eQZh5RXY7MMY39vHivyomT2IAaSzL4K7sdCMWNiK3eo
	 K8IbQo6iNSckFfZG7JCPXDvHMS+JFq8VGYj9iuZZkI3rPL5OYzdI5rN8v8xaQ58zN7yQH
	 ndKey/Lp7l3K41NBeskwnYHxFtOJQz+gxRd9djlqftNJ5Wtulkg+tbHHA2BTSfQM9hILS
	 UZgQ806xsa9XAmBXCINYIP+YLcMUVuASEKFUW0y8OutfAU/MRmByZZBe1a/fHzRxztHhu
	 kxXHzcDLMLQa7f4P8GYIFARmMOUCB2dkA5PH0Ms49zV9UezHGuE42o2e2q/QiQCJqQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0DMdws7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A82606A31C;
	Wed, 18 Nov 2026 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0DMdws7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585781F000C4;
	Wed, 18 Nov 2026 18:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025024;
	bh=fcDtVMDg/fz9AZnZY6G1fajeyMJ1jSg0+uwzx+9Xs9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0DMdws7S1WdERs+7SG9AfTOrInHBzn/Zho95bGfx78f3+1S3szxjZs5A0BepgNn7
	 DKzOeAPXwDsnAiwZyEO8BDVMgKNBbG2A1ZhrWt1tOVedGirulAiJSMALhT0T+YcaCA
	 ON0uBAIPDRNi+4UaI4BjHu7ea8dOTRCaWV+jmwGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0918/2151] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:44:13 +0100
Message-ID: <20261118150155.860465292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e2f4d89bfad33..b1300b4d78a63 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1399,7 +1399,7 @@ bool dev_pm_opp_of_has_required_opp(struct device *dev)
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



