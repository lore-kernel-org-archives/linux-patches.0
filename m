Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055371;
	b=NHtHLdTyhxYo7e+69RgI5zDmvV5Bxy094t6DU2dXIBQHp5oqRGbVbHZLFjBwX4gOyf7O
	 9ckPtjY2epBRhCHVPfAPaINmIUy6lbzfQI0RTsrJ8MvuwAIYkBox03wz6OVqAsZVwga/I
	 7klKLSqggfchMHXDtuEfWfrwKScwd1jL9RDzbOvzBsWhlvU0ByJzoS/qCClsWr34fEyLb
	 kPx36XNBZdIsedEuKP0y8vwQBSw8KKKlk922XGnC4x4CrNAuyiP0PaM0ecj68Hj6S7Hm5
	 0Abj2fb5Mvg5t++Ffl7tRIBC/dSXgcRkzte7iaVbTdhpb0ji3Q0RwjHEayXkOMt34Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qMq/smmi/DX2ga2/vTDA7sG/jaXfyQWkXdXdJlSdReM=;
	b=Ntin0TJa/mvs7CxL1ngqQJS8oOzVh/reywAmK59je2pH9Ca3ErG35mQxnb1LuCl04q1U
	 IVkvRCHQrXiT7Po9jLSQjLqEsgFXnC4VNS60H5dIYwweH7gQf4vqnWcC11srH9lvzWhGg
	 kQ1G3ILgnBEAowqj6US98evoKmoXp5clvHGCN0hCphL5Pc4L8/FGWExCLKtR+y9ndHb1U
	 zdg285PqRDpDqQw/dKCSw7Gd9Ph2iSYS+ufLcfnpZFKXDQUKPhYpQhD72Mcebmsxep2su
	 NNNnUGwDWpzkzxXePRqcQSpwsXwLF5q3DssRfdRq2BoQEIn1KK/3DUIZkKmGxVbm84A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQr6ahND;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA45606A33D;
	Thu, 19 Nov 2026 02:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQr6ahND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871D61F000C6;
	Thu, 19 Nov 2026 02:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055371;
	bh=qMq/smmi/DX2ga2/vTDA7sG/jaXfyQWkXdXdJlSdReM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQr6ahNDRsJVkAZQXU1EqV/RAQTxsbbU/I7S2Zt3dOHuuXaXWi+gAzMlDUARze6fc
	 r2Y8rDTN1kv7MyEBqls+Qk5VSfXDVinO73NIjKDqlFw25Bh3oOyFsVH1Bwd/9wWSB6
	 +5fJOPphiAEoCuk0Wm1F+0/wFUq6QWHUvbmRXGqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Jiebin Sun <jiebin.sun@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1608/2214] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:54:44 +0100
Message-ID: <20261118150116.266570908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiebin Sun <jiebin.sun@intel.com>

[ Upstream commit b36a6f180baad35a962677ae181681ca60dda35b ]

The default coalesce fields dropped pid in favor of iaddr, but the man
page still documents the old pid,iaddr default. Update it to match the
command.

Fixes: 423701a0c8d754d9 ("perf c2c: Change the default coalesce setup")
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-c2c.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-c2c.txt b/tools/perf/Documentation/perf-c2c.txt
index 3b6a2c84ea027..4db7ed63f06b8 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -269,7 +269,7 @@ output fields set for cacheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



