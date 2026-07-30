Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A82138E5DC;
	Thu, 30 Jul 2026 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427955; cv=none; b=ZNUTE7d5Caqz9Y48cTfns9AsrbPtcu4nZB53dtcVwUI90BInZgVZ8DBIRl+MUkXn4k5goaSYLLycazLErOnlE8fN09vgOQHPjtuzXzDRpzlANlDZfS/aNrkalZ4bjldkReZJY1BUy3k2AlgIwFcXTV+Nnp4U3MKivx5WRHqtEfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427955; c=relaxed/simple;
	bh=O1S7YQMrPJdCw9/9vhg2vz4bx0+Izp2CnbyOjIVgBl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVpEn3IRKtqUF0txQ/9+so6UMTFVoH/2bxaSDqa7wYjwLvgG7F2vJyskECltmZMh3kAt6SFUJuHA6xdS8qsGdBuOgG6xuu8Xh7d1ZsUfc4FkguiPmjsJigWE3bhN8YV/kc+5oOIP62CnYTSScY0Gd/h3YkZaEwMrh4sibS3yR2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4z1Snmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4z1Snmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AC81F000E9;
	Thu, 30 Jul 2026 16:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427954;
	bh=vZnEL/M9/rBNbonzMmvmZ3pXTinpptSdrpkJwx+EshA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4z1SnmflnjODGNVyWeqvkfRlZ8cireKuQ2gFTCB/Kup5m+mo2giUE8rTQWzlTmnj
	 zfQvv6Mt5cbEldB8OifoUG6+VQyUjjhjGU09TcaA6O1ppNqUxMWV2Y5j+lbIPC0kTf
	 +NBCLkT0JmcJMDV/r/jGq3w5InNG6JxvMZuAC0mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/484] net: qrtr: ns: Raise node count limit to 512
Date: Thu, 30 Jul 2026 16:14:08 +0200
Message-ID: <20260730141431.102233044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

commit ff194cffd586cbd4cc49eccb002c65f2a902a277 upstream.

The current node limit of 64 breaks the functionality for a number of AI200
deployments that have up to 384 nodes. Raise the limit to 512.

Fixes: 27d5e84e810b ("net: qrtr: ns: Limit the total number of nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713145901.212396-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index ecf49172307f1b..90244ce7e95e7a 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -85,9 +85,9 @@ struct qrtr_node {
 /* Max nodes limit is chosen based on the current platform requirements.
  * If the requirement changes in the future, this value can be increased.
  */
-#define QRTR_NS_MAX_NODES   64
+#define QRTR_NS_MAX_NODES   512
 
-static u8 node_count;
+static u16 node_count;
 
 static struct qrtr_node *node_get(unsigned int node_id)
 {
-- 
2.53.0



