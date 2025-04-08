Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B2819AD5C;
	Tue,  8 Apr 2025 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112505; cv=none; b=MDr/lyUQ0Slg3SmgxjIm1czYUfGS8GPdfhheBs8dDlECL8rNAfTGtv7TrkHMjF9kmGz0g1Lo2Y//7QARjEHPgQFRrXKWg0YkzeC1mkO3vZMKELLa1xvwhhpso58/0aWbp4LmRqI8RX1I2jA+X+LUXiWDrUflt+PUYL1Ddai7kqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112505; c=relaxed/simple;
	bh=W2n4uBh2hPBQxWPFIe/0WlBMpYGKaPV50mhuGfD5HtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daq0uxIWCL9g6Fwf0srk71V6GlUpL+4OE0jmKpAxjbEoRN+H5RZH/LfUQM3Zn1m8EupFjX0b/NXkq54tTNDNhiiFkGtY1rxTLbanorbeDuKjPySl6N2rFm24nAiRAcukAOZKzYPidSGCzHT8o/1wRNjTmrBtDG18a+1LG0TxCSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgcJ38Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgcJ38Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305ADC4CEE5;
	Tue,  8 Apr 2025 11:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112505;
	bh=W2n4uBh2hPBQxWPFIe/0WlBMpYGKaPV50mhuGfD5HtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgcJ38QiIWK/aW7VziEPXJ/5kXBJdxocVpp66hZkjXpLruAMaGlabHTV7g57s3Jx1
	 1H83rLDce3O1FfzKktS5iEP+JtU+4iu4YNG1LKyDm67KAxAazyItr1XQMgSLu6zZ7W
	 H/SQLjvnAfvMY+FXA569LEV/fJeBA2RDM1i72OUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/279] net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES
Date: Tue,  8 Apr 2025 12:47:57 +0200
Message-ID: <20250408104828.892706791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 90a7138619a0c55e2aefaad27b12ffc2ddbeed78 ]

Previous commit 8b5c171bb3dc ("neigh: new unresolved queue limits")
introduces new netlink attribute NDTPA_QUEUE_LENBYTES to represent
approximative value for deprecated QUEUE_LEN. However, it forgot to add
the associated nla_policy in nl_ntbl_parm_policy array. Fix it with one
simple NLA_U32 type policy.

Fixes: 8b5c171bb3dc ("neigh: new unresolved queue limits")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://patch.msgid.link/20250315165113.37600-1-linma@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9549738b81842..b83878b5bf788 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2173,6 +2173,7 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
+	[NDTPA_QUEUE_LENBYTES]		= { .type = NLA_U32 },
 	[NDTPA_PROXY_QLEN]		= { .type = NLA_U32 },
 	[NDTPA_APP_PROBES]		= { .type = NLA_U32 },
 	[NDTPA_UCAST_PROBES]		= { .type = NLA_U32 },
-- 
2.39.5



