Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313371E2834;
	Wed, 25 Feb 2026 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984028; cv=none; b=AITjiwdgJdrvQ6J4bBQ+jvJMDqbNnKbspCU77l3icYry0QH7GIsqPTUblxj/5TY4MAMfArJ35h+oWavSBo31H7bYuuXq2rfrNoXW5p/zMnI6z4rsqPRxIbJavOGXksCmJ0wqf+8xhffBIX43Ke4dlaXa8wQncbeT45drLMFpfE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984028; c=relaxed/simple;
	bh=dAc9vW2w6/1XhEeA0d35nLcPf4rS+frMGQl18pO7sac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNbUyLBdro2mt+Q2LnCHRo/azDlMzjP3dZWPVeqKXF2xRv3T/dLtZMT9ebBCIPWYF8f9+Tgx+siCS4ppC1ZHUrmy744dKtPBbuakFWKIajnmZlnZ7naPVQeFivtBaYHbxUV83lVlHXowK9ftL0+GIL8Dgbm1UesJczvBDDZmlTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBO+nveI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBO+nveI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F59C116D0;
	Wed, 25 Feb 2026 01:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984028;
	bh=dAc9vW2w6/1XhEeA0d35nLcPf4rS+frMGQl18pO7sac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBO+nveI+ILzPidg8qxJMZZeL9pl5m4sUjwBMKu9TOIUVTLzYj1LHlL/iZQO2fQeK
	 FNyZKETqjvG+SnI9ivH3aJ2w/rqSE2zgAzcczh7bSrrdE4pPSf4kjuDDF1ZGpUrdsh
	 4f1s8sYgclvWExSh/3G1F6g3BWKooiRPFvh/wnP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/641] xdrgen: Remove inclusion of nlm4.h header
Date: Tue, 24 Feb 2026 17:19:59 -0800
Message-ID: <20260225012355.413480892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit eb1f3b55ac6202a013daf14ed508066947cdafa8 ]

The client-side source code template mistakenly includes the
nlm4.h header file, which is specific to the NLM protocol and
should not be present in the generic template that generates
client stubs for all XDR-based protocols.

Fixes: 903a7d37d9ea ("xdrgen: Update the files included in client-side source code")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/sunrpc/xdrgen/templates/C/source_top/client.j2 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/net/sunrpc/xdrgen/templates/C/source_top/client.j2 b/tools/net/sunrpc/xdrgen/templates/C/source_top/client.j2
index c5518c519854a..df3598c38b2c2 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/source_top/client.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/source_top/client.j2
@@ -8,6 +8,5 @@
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/xdrgen/_defs.h>
 #include <linux/sunrpc/xdrgen/_builtins.h>
-#include <linux/sunrpc/xdrgen/nlm4.h>
 
 #include <linux/sunrpc/clnt.h>
-- 
2.51.0



