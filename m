Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C6E1A76A5;
	Tue, 30 Jul 2024 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360508; cv=none; b=XPeA/QQbvKC2bBU3/nJRoFxxIecIJZe+Kz6BYSbw/+GE4t8bJ8yNVO9JZfVohPCeAFZnHywWzkQxmaLH+/kPBZXS2PPHoDD4Dg3yk2ZDqBS4UZH6wvvH5PAcg5m5W3QlRBvIwd0JDzNBqd/A3cbQJsVPjwIAIXQrmVnqUiYUy5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360508; c=relaxed/simple;
	bh=GyuEhMLgBNNrNAXMPm8Oe9RrsuZdIrVfqJB1s0NsaWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv5F4XVEoEcFj5JTl6U/RYNM0SzQKnheccSmGws/4pzVQJQSCkbGdEriYwj5ImunKn1TuhuGs8pa3GL8l+k6TjHtuTfNg0OOQE6ErWJ6CSdbJUwssLM3fTxg3+wAGBwrgJN5Sp1V7wmy3wUvvn7ZVXen9e6ZnwVa1sMF+2xbLJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6BFhpDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6BFhpDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFB5C32782;
	Tue, 30 Jul 2024 17:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360508;
	bh=GyuEhMLgBNNrNAXMPm8Oe9RrsuZdIrVfqJB1s0NsaWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6BFhpDjcZ0FoXUWZBvlvgzkJD38fmreL5H6fpWt0n/KQ2Nh7fMDtYNetO9OGMeXX
	 d2PLTyI+a+sHxc866t9yDQN48/nX0dGGCREEgOzw0CPGAUP1qbrqNLdBX4vzSvHclV
	 ZsOj335Jlgdmaig36gFlalTxDdSbyhhYcXlkIkR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.10 720/809] remoteproc: imx_rproc: Skip over memory region when node value is NULL
Date: Tue, 30 Jul 2024 17:49:56 +0200
Message-ID: <20240730151753.377302167@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

commit 2fa26ca8b786888673689ccc9da6094150939982 upstream.

In imx_rproc_addr_init() "nph = of_count_phandle_with_args()" just counts
number of phandles. But phandles may be empty. So of_parse_phandle() in
the parsing loop (0 < a < nph) may return NULL which is later dereferenced.
Adjust this issue by adding NULL-return check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a0ff4aa6f010 ("remoteproc: imx_rproc: add a NXP/Freescale imx_rproc driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240606075204.12354-1-amishin@t-argos.ru
[Fixed title to fit within the prescribed 70-75 charcters]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -726,6 +726,8 @@ static int imx_rproc_addr_init(struct im
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		if (!node)
+			continue;
 		/* Not map vdevbuffer, vdevring region */
 		if (!strncmp(node->name, "vdev", strlen("vdev"))) {
 			of_node_put(node);


