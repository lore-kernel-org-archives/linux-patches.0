Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018032;
	b=2l+ve554RJiyURl37mz9unEzdGNxCifPeEHnyOeOwoGeeywQ/IRe4gpu5oMQYVhK529g
	 3INChJ+m54NbO2cKhOLnBQCyh5L298n90Gc7ytkEA4fjKGw5JHx50lDn29o/9ndVqbb0W
	 FrUCBliPhkLdZvdJsRL76pt7kqcxdooUwo6xwD45ElaLxfjG3f5I/gs0pqHVN3AXbugFl
	 rUyKBr/23nAnUzHEzKmiXWzP7RJ97IGaUb8QW/ONRNyIzqo+Z+/+0VYtdjj0daXzWuttK
	 ipq3vRjoYYmQvJCgRW06O+Bqc0XHjVt3cER5hLuH0hYcpmlzkE1MgO84PResTaB/RJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnXe2IuW2Pmg/ES7BH8JREKK9/5Xd6i1XxmW7e3aYSc=;
	b=0llGSF5194vXvjFcihw+iRs4w+fT8TiY8Q8HU6exOBY2yYyaRxEAngzB/v0A1YQYy9on
	 KoO0KxF7KjhVfkqMpBBttQ3RNdflP98d4sQSOEPa+cjZS2n3wVb0ZJCdB7gUFYMdqLKAc
	 XqJOiadqkztjxZNxulO1EphvO6lBM6iUNMQOP11MY5W2qX64YgjpWU1Sk935phumB09AH
	 vaFe7c+Una7cVOStQ2pr2b7eocYLJHtVWK2sKyK1pVKd/X/6hoSOggvzl7PQfsZx0mpcO
	 2ksr0qk6yQVrG5ODknVnTyAiD2uukaWi+CN5LqRLidVFQvFsDfQ9mMMNJi3Y0Gjno3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YwzCsDT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC76606A320;
	Wed, 18 Nov 2026 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YwzCsDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669A91F000C6;
	Wed, 18 Nov 2026 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018031;
	bh=SnXe2IuW2Pmg/ES7BH8JREKK9/5Xd6i1XxmW7e3aYSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YwzCsDTAOfuiVEW1Jt0OYZKEEGkwUkN+RORn350gyVewr5qXO/f0aXznJLIbJK59
	 gVNl67jxTBJPJi1CZjTxizues3DqafvP+MrKo6QgPXN8+fnGwt5196nAJulj1u1t/l
	 9I/6tX+g33X8Fy3QW+APniM23IRiPXtmSRwOEapI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1097/2651] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:38:57 +0100
Message-ID: <20261118150327.491427708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2f3bbde9a9e17..ea93800795783 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1409,7 +1409,7 @@ bool dev_pm_opp_of_has_required_opp(struct device *dev)
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



