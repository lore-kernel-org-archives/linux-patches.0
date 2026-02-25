Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFDE1E2834;
	Wed, 25 Feb 2026 01:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983213; cv=none; b=TtQmuJ/SRA4hMwHopHlJgmm/UtvnWyeHhhycYeduxbu/bxR/m52WOHpOWW5P9zUr+QQA80FpkG4GjeVCU4lOfN3VnAwKer+Ev3xVBbfKJlz7mihKS5fFU3latrXEQl459W1CvLdzyTtnwQdCDFeWwWdsVhR5YAsLe1zPbB24Trw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983213; c=relaxed/simple;
	bh=74jKZP3E7wmi6X8ihOlBxq4UF1V44IpS6ZW+Wr46b8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpjeB9AqXsBlCrhitTXKeU8xA7BheMhvKcYSWIl8QZ7kJmbn5oRGSZVmO+qhL+rWmdP1x7YdAgbLeO3KyixKcmtrCCmLxc/XAG9WwF9/I0LaCL5CdzPe1B/xnfrj2/XpcsUlRvRqU5qH2U9EoR/PE3EDpD7yW4xaoOPsj/JN8QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xdlk1vkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xdlk1vkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79038C116D0;
	Wed, 25 Feb 2026 01:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983213;
	bh=74jKZP3E7wmi6X8ihOlBxq4UF1V44IpS6ZW+Wr46b8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdlk1vkkGuqyZa+i0njptDfM9Cs0x1lUJzfk3rug/6ALc3yTGHZSNcsysIksE+sLo
	 xZ1JYWmYIkF7i/TyFgZ/x1yzUV/jaJL/lvOY4BHtnZAzE1FoJOt+ezsJ32hyKhPU3z
	 shCNSqLam2cfUMDw5oSOqUmV1qikLV3UjZZifDdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 362/781] xdrgen: Remove inclusion of nlm4.h header
Date: Tue, 24 Feb 2026 17:17:51 -0800
Message-ID: <20260225012408.560952979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



