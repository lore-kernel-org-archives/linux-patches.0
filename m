Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040293;
	b=3NJUFKlpjLXwCuUX0qCByKW2Cp/+jm+k3sJLXVcFy50/eKWEXdjLhqPUZe7H4VwbH61n
	 VJW47VgvEK6GEXRtApDKsIbOPbIbskc79TaYw9kmtMVIsP/MDhqbs1ZE2AslKi2Xm2Wsl
	 rW5JtJY57rmXSk5rfuuMmlFN6/iLP9Md+lEBvcRcoHTZ8AiSLtGuX4D5RZFu1En8NUuIV
	 GAsSDFQo2vj3O540UqK6P5dEGYojKjPAwaLBVAeMPTsya3JPhv/EWf9TPaBWI7T8nVZcz
	 0zTGqK25f/Rc+3R7VR+kq3uglJmRKb5xf4c2+gMf9NVQCetKjUlh2LPffmlBDVbfKRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q0hObCNqddS9tly31ghAim/C/JGUjo6SPK7cg7G8HAo=;
	b=Hp9o5XmlO9TBuaJPz4K5PtUG0BU9Ur/cpz64X0QUWb7+LX/OfPuWuda3JNurAJOQb/DH
	 t67l4mZV+yjoZzip0eeCfKd87i25Xp87AvJ1dw3XgwOz3qmJrEOMCnkQOOs23BzwsBlbX
	 hDlpU1E3ti3GCjTYiRQNEkbP/62GQely9gudE/1XKYdEXNIj3uhWHtziM410Gm4BQXiHx
	 CMkumEQkNZooYqIE/02ZAa2xYRlt/8TUpbBFn0D1aUZiHW7yU0xxUnqQsHDJSDzHGo2gf
	 KuBCrOwoYjwDTxM93BkMt7Q070rlrdmFEN1/yZUAStNrq9a7MEuYQT2ESfiYB5qPj+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBK9zmTu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E0606A320;
	Wed, 18 Nov 2026 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBK9zmTu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3F61F000C4;
	Wed, 18 Nov 2026 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040293;
	bh=q0hObCNqddS9tly31ghAim/C/JGUjo6SPK7cg7G8HAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBK9zmTulk6Dv3qE1wwMYs45RjDB2V5EP36CfSGLH7MlMCKq45Z/ANx2gGycb8pK7
	 H71AwKtcdRaImsxE5yiKi8Wf1aHLQeGDxuHeTUwcToaCKOafkn63Foat4UXCME2Jxg
	 uFEDAV8NO6qw8tUSLmBXE0kweWVX5aTg97bd0od0=
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
Subject: [PATCH 6.6 2365/3318] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:49:47 +0100
Message-ID: <20261118150432.526449723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 856f0dfb8e5a3..d744b43769a0b 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -304,7 +304,7 @@ output fields set for cacheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



