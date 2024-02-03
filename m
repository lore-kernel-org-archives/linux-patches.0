Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A5D171A4;
	Sat,  3 Feb 2024 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933903; cv=none; b=Oq0bnusAdn7djELbqgnt/z10YtJ8lFOpv9TSJ3W1IAElJESCCUlEF1IXxLfQ70lDpFaO1fd5G3y4igf9d4Ns5O0MbErpWxh1cCpg9ofVI4yHgHDsyg0EuDnSOEax73uyo3q/aHE/Lg/J1rLjZkytFCeUiwvy3FJXF+WfosaP1jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933903; c=relaxed/simple;
	bh=g9lWkjE4t+2X5brtia5P4AknTEcblOsQIHw0Y3BHsWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdT8eiu80h1nHme4ivp450DCwqKwkm/KppI1q+u0/khtoCcyBoIJJHIx9SMamc462K2FwPKXCxsbfJV4M6yuDknZpsj0F9XI9IDq9JzaQpnBY5k7+C1NxpYhyXqyLgo5sb2h+ilzi98KkSmGAdEqaMYTwEUJm0xg1jiIUOm2dtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANVWai02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANVWai02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0098C433F1;
	Sat,  3 Feb 2024 04:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933903;
	bh=g9lWkjE4t+2X5brtia5P4AknTEcblOsQIHw0Y3BHsWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANVWai02Q+bVMb02E2G5A+Zd8P2+rACPc1ms0JwX7Jxbn60MrJsKppKpqw8xGM6n8
	 zlLPnCw5DIhhWih21CPX2BwNS4VcSJmH+MffYQbxYJQconK/jBjQn3NCgtyU+0PamB
	 2RJvIgfx1H3MIxtbkIaHSVwkXGTm24/MI8sJ3W+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Leo Yan <leo.yan@linaro.org>,
	John Garry <john.g.garry@oracle.com>,
	Mike Leach <mike.leach@linaro.org>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 252/353] perf cs-etm: Bump minimum OpenCSD version to ensure a bugfix is present
Date: Fri,  2 Feb 2024 20:06:10 -0800
Message-ID: <20240203035411.706914415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 2dbba30fd69b604802a9535b74bddb5bcca23793 ]

Since commit d927ef5004ef ("perf cs-etm: Add exception level consistency
check"), the exception that was added to Perf will be triggered unless
the following bugfix from OpenCSD is present:

 - _Version 1.2.1_:
  - __Bugfix__:
    ETM4x / ETE - output of context elements to client can in some
    circumstances be delayed until after subsequent atoms have been
    processed leading to incorrect memory decode access via the client
    callbacks. Fixed to flush context elements immediately they are
    committed.

Rather than remove the assert and silently fail, just increase the
minimum version requirement to avoid hard to debug issues and
regressions.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20230901133716.677499-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/test-libopencsd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/build/feature/test-libopencsd.c b/tools/build/feature/test-libopencsd.c
index eb6303ff446e..4cfcef9da3e4 100644
--- a/tools/build/feature/test-libopencsd.c
+++ b/tools/build/feature/test-libopencsd.c
@@ -4,9 +4,9 @@
 /*
  * Check OpenCSD library version is sufficient to provide required features
  */
-#define OCSD_MIN_VER ((1 << 16) | (1 << 8) | (1))
+#define OCSD_MIN_VER ((1 << 16) | (2 << 8) | (1))
 #if !defined(OCSD_VER_NUM) || (OCSD_VER_NUM < OCSD_MIN_VER)
-#error "OpenCSD >= 1.1.1 is required"
+#error "OpenCSD >= 1.2.1 is required"
 #endif
 
 int main(void)
-- 
2.43.0



