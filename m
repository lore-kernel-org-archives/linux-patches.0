Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049801;
	b=omLxjVUx3u7IHknCrrjCfEGMmW0zOIndhP193dQR40O8DTuRHzsvE8RrerxoNpt9MRt4
	 4WDLEw7gN3rWo6IjrQng0vK5sj3AjacXCPDoSc5/npUNEeyy7eviL/9I1AX4jqTX2Bz0q
	 UY/y3MfinVCAPoEU64glRY2/5BD5WEobQP7sxQBLJCFcfLkxeVfDQ5oRU4cLExNKh6A5m
	 JvqdlKrWdPCrn/qLexL6LG1v9AdmvJISzSiwogtObrd6waRDB735J7MDUpse30r28KAT4
	 fcmjHreDMnn+cS82MPEtSa89iGHQMtF0IUxS8Lw2mEWs51oy4MJaYxvR7EPsxZ0j1NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n0NcqpnFc25+HIXHYg0E5Ta0V2srnG6zUEFbVnMvyf0=;
	b=2FCnS/PEpz91PkHdlFJ4tANcRtDqlyyBwGEafUD+bMEffr+lOtIcOGlQXy4bQ+Mtf/ZK
	 GxJL22vcKxV9eIsZaaHcd59AKv4owFQOqpXEOgFYWlDNzUSLar+M/nAlsZsj3UW+w7Fw7
	 M4prjG9mlrw80hIck/1cYRV/y6bDlJilv3aGR07GjTB3H8K4MQPUjF6ItfmPr1B9/DZ94
	 CFlC9w+Vxc6i4t+LOh7FDdjhDOSWWnUgBsaLLyWpPdtehG/M0PjuLQR7+LJMLKW4xIifa
	 Zsj4+KaxtPmYJNxAu4L1hyBTyTG3xYpBYlzpn7aKfNJbHmDEgnfBEgFQhs2po0gYiLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhbC9nyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AC2606A325;
	Thu, 19 Nov 2026 00:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhbC9nyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E61F000C4;
	Thu, 19 Nov 2026 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049801;
	bh=n0NcqpnFc25+HIXHYg0E5Ta0V2srnG6zUEFbVnMvyf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhbC9nyO5qHcd4csxoefPLMtgNZ/brgfkIq5Hmy1Sbxv9z3LBFF1pt7q6DnsT1imO
	 KSXbl23FrfTG9dsfbh3nWejFI0nnuTGXiZlsDqOT/16bhgMtswU3jOPvBcgJPJwHDw
	 1m8PBw74cZpNH6lam862/yRJESJRa2n+5+DqvKDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2480/2857] rpmsg: mtk: release channel OF node on device teardown
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150330.854970496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 00e100cfbf7bc159e462df16832cddeaf2cab770 ]

mtk_rpmsg_match_device_subnode() returns a referenced OF child
node, which is stored in rpdev->dev.of_node.

mtk_rpmsg_release_device() later frees the containing allocation
without dropping that ref.

Release the OF node when the RPMsg device is destroyed.

Fixes: 7017996951fd ("rpmsg: add rpmsg support for mt8183 SCP.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://lore.kernel.org/r/20261013074744.942560-1-thnkslprpt@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/mtk_rpmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/mtk_rpmsg.c b/drivers/rpmsg/mtk_rpmsg.c
index d1213c33da204..d4eb1968cefd7 100644
--- a/drivers/rpmsg/mtk_rpmsg.c
+++ b/drivers/rpmsg/mtk_rpmsg.c
@@ -168,6 +168,7 @@ static void mtk_rpmsg_release_device(struct device *dev)
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct mtk_rpmsg_device *mdev = to_mtk_rpmsg_device(rpdev);
 
+	of_node_put(dev->of_node);
 	kfree(mdev);
 }
 
-- 
2.53.0



