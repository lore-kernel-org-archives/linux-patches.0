Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024483;
	b=gb7X2rNE0wtHtP+3NmCIJxavQpfrLea1gWdFIzni6a8X0/4VHV5Aag0ZkomGkFBEPd4v
	 M2V0KzydkaGvok7awVBm+LkF9yhWtyVEV+l7rX/QI5dGsKhqzu/L8T64WQsp6uPxxY06E
	 1cYtDSN5m8DibPCof+kHYfdT/Fbx1ilWB/s7YLvxviLGlFLOIZ5xdjEt5XHsVYW7IVH8Z
	 2hfgZkTm1wI9WQbkyVnN2xp5c7td0hAYDdwNRIb6vXEvOw2PkWrVki3FLjNuDZ4vdI26D
	 JDEhbsBrDzi9l/r3wCoqua3ZAIkix6uJWe8LEa4HoXvSqYr0aDCTIjA7PzS3LoE/JGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtyYDVWAL6gWzrsaG2r1YQlWhV1gU9Uf+560d3pN15A=;
	b=vorbk9LS0jFAaWrngvThS0UUML5Z5sg4JWdzcDFm7HaWJMypMYEgr4le0aLsQX4QqQzG
	 hUwbg3W1FF5NvcnyO0QXuwRPbIc25qicCaDSKOa1t2bIvAoZYlJuTp5ZddArzFLrbGG3U
	 HXdKI4/4dTS/NDCV6b3OsJx+zxeA8/SgSPi9djh/YuXNSlRPwdeFnZ8KecMGS4A/xsgNH
	 3x1yDYi7rGcKMKP0sNXX1umXdMeaoAqoQP8gjsvVHjnIzw50bV+7ZwIzUNJRrVODyZ+l1
	 gJ+rNTdMR2KUG8PtNcY5wTG1dRRXhPshGzMXCeBZNG25rmjG9z5FzcFLgMV1BR7yb0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjQEzvdB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768F3606A330;
	Wed, 18 Nov 2026 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fjQEzvdB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D83C1F000C4;
	Wed, 18 Nov 2026 17:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024483;
	bh=GtyYDVWAL6gWzrsaG2r1YQlWhV1gU9Uf+560d3pN15A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjQEzvdBwqfmO0hVHbLC8xUxH7SXkljzO8MdLVx9WhSH+IuC96adF9AAKw7fIBCaA
	 SwR8kxiEe0gd1GwpHHIHgukQe0wGqbwQU5RnX1r3xktDu/qvvr3zY3yzsZIq7iiE/J
	 4tHabIcU836Ek6rbhEQ3/lDMsjgfIyKWT3qtY5hs=
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
Subject: [PATCH 6.18 0734/2151] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:41:09 +0100
Message-ID: <20261118150148.766585367@linuxfoundation.org>
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
index f4af2dd6ab318..246598bc48bde 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -311,7 +311,7 @@ output fields set for cacheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



