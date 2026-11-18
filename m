Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061190;
	b=naNJjBTlxkoyED/NPHfY5MyhslJSM1B6LKsUbxdX4U0TgGssI2G4MxGT8wgS9xzuawts
	 nXa+JQUZk8/eRNfelL5YI0bxJ3LdwrgNig0mh8t5bgNKNZ4/6GtdzqgtsWWBgVQHba19x
	 GHYD5VV7RWJ4tpi3uRcg64n14F/AAtrNZDL9Y/roXV1kXadQlz+ZNPTzYLbvnvNTFz7ks
	 73EYku3SJMwuds03HqLdAw6aUY7Jfo60Ipd8YRD8eD8FMyBxH8Jy9+te84jbwd8ksqKg8
	 p204yOFoKogPc5jQGVKJk5fM2n8XbFkMPdHVeVTcoYWEaopXvcEE27TK4qS4pND63IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e2Dr6eY711u7WitFLbLp2xWWPHa7bHN+KuYBQtTwHfA=;
	b=v+dzHxvKARX4rXYolylqlpwoeMrIPb1dbxkhnym5BRL9GNoLhSDzXP9BBIOpP06uARh6
	 KO7+gwDIEjI1C2svFMMhraw9TBnL4MZzcY80u+FNKQuOcrEASzNO51xCRUIMbVyse9WLJ
	 0GCNhpJ1bWSVkruWRSBCECUk6Mce04w4f285awLChg9ZTWq2VWjFdCaqNyXzFo3Z6zBNB
	 8nN/pCN6uEwwoaUmjKHc4kDrMyY4f6mb7OcPqnXw45IEEtVpRnA2VFm8FuYXB6XHD05XW
	 ZKMlgDwHbBI/kQkT/WdiKgdE3EB+wXzRHocs0bbixw8GUS5dUtkZ6eQ3qRvmLUGgrgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFRPzAr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5229C606A320;
	Thu, 19 Nov 2026 04:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFRPzAr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF281F000C4;
	Thu, 19 Nov 2026 04:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061190;
	bh=e2Dr6eY711u7WitFLbLp2xWWPHa7bHN+KuYBQtTwHfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFRPzAr0RIdPSka6XOCiKP0lsYF1J+kGFgB4fAwUSfdqdHF7wRJJhUp5Jjk8+BX4K
	 CPjHO+5lnEzO2Z/jWkGDwhndksBEzQiWABOId4FtqCJoKvbGKF+j155agnSn5E9m61
	 ipkXevREfcU+aydZXymELNu/i/rFYWtdlMZTTwL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1423/1848] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150019.104516684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f7df2299a57a4..e7faa5c6fd8bb 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1213,7 +1213,7 @@ EXPORT_SYMBOL_GPL(of_get_required_opp_performance_state);
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



