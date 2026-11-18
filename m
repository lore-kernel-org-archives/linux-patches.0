Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020808;
	b=XxntLf4CwozntCsu2dpAMZzD0P5xs8wH/FPGak/eJggBm0jllAWkallBox7xNyKstWOm
	 csBBq7036xaRGX25yDawnKPwtCa2SQl5n7EBcG09mwh/fJW7ONUBjOkHNg1pDWKKczEcE
	 +RkqZw408N/TTps1OQTChZcvgqSV3+LI0GmLLVfSgxLabP4cDjgp2XjNq8G0odEza6hy9
	 NzL1dCc8VdrTf9DzCudyw6xCCIPVHZ3klKYLGq7m+lUaiY1/7TRFElYDLdaoEpkLGFZgc
	 IZDd9q2xmM+2X5UmpP6dXdEsKHRhCEdSxZGr9CTDmfgGHZPml2G1gubT9XyzbsAcCpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pfU86u3GWwCCmBRGUWbOnbyf823jekq33/6/mjqjfpU=;
	b=wo91tUZieLdQSwwEOY5ejmvcsBsaxjGD5jLG4wCnYvLry5gP38HBYvuVgXPWIYH2+Lu+
	 RwqW+DgneGV0rifwQKkP19P5RHXB5srJYy3/jFG4DhWt+wf7t4Ghcfd5VJFfARJRbB9Au
	 W7yayLnAbuhwtpFD3gHEPA4jFl+fXVoxu1tlBzkz4wVCyOrfSnKScQb7O1QnJVZaIS0aU
	 ljo6AbRL0lwIzd8/tXNCLpJClwl4bzLz7sl863MvSEOgC04AVt8bWi7HKUW7/tiiIiEtN
	 u238UF8A8sSNhrJayRDCbeKE8lB1xXc/A12zf1vvqSPGncxz7Qhdkf6y8+F09QYrGsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WrzuYJdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC4A60A263E;
	Wed, 18 Nov 2026 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WrzuYJdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D501F000C6;
	Wed, 18 Nov 2026 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020808;
	bh=pfU86u3GWwCCmBRGUWbOnbyf823jekq33/6/mjqjfpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrzuYJdiEgJTrMb3E7R8d5KSmQ7245J2dqzt1uSNerPcpChBGpQ0MQITvLNx6B8Y6
	 rhmQ7iiciV8moupVW0rnYcTvK3HkR9y7ORwLwIy54vhGKnUzyg3Xqci7TXWbP/BimA
	 npihwMHtMYmMNbmu+q4UKXXaYxS4tUmiGHKqtgzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2082/2651] perf test attr: Relax group checking for ungrouped expectations
Date: Wed, 18 Nov 2026 15:55:22 +0100
Message-ID: <20261118150400.980478784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ac416cf3eff650ad4b6dabc3407c7174e1826db9 ]

When matching the recorded events back against the expectations,
attr.py requires every event opened in a group to match an expectation
that declares the same group.  The perf stat default metrics open the
events of each metric in groups, but the test expectations only verify
the event attributes, so test-stat-default fails with:

  FAILED '.../test-stat-default' - group failure

Only enforce the group of a recorded event when the expectation it
matches declares one.  Expectations that ask for a group are still
verified in both directions.

Fixes: c7adeb0974f18da4 ("perf jevents: Add set of common metrics based on default ones")
Fixes: 2dfc0cab3da4a205 ("perf stat: Add detail -d,-dd,-ddd metrics")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/lib/attr.py | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/shell/lib/attr.py b/tools/perf/tests/shell/lib/attr.py
index bfccc727d9b25..54635082d6308 100644
--- a/tools/perf/tests/shell/lib/attr.py
+++ b/tools/perf/tests/shell/lib/attr.py
@@ -307,7 +307,7 @@ class Test(object):
             else:
                 raise Unsup(self)
 
-    def compare(self, expect, result):
+    def compare(self, expect, result, strict_groups=True):
         match = {}
 
         log.debug("  compare");
@@ -341,8 +341,9 @@ class Test(object):
 
             match[exp_name] = exp_list
 
-        # For each defined group in the expected events
-        # check we match the same group in the result.
+        # Check that each expected group is matched in the result; an event
+        # opened in a group may match an expectation that doesn't declare
+        # one, as those only verify the event attributes.
         for exp_name, exp_event in expect.items():
             group = exp_event.group
 
@@ -351,6 +352,8 @@ class Test(object):
 
             for res_name in match[exp_name]:
                 res_group = result[res_name].group
+                if res_group == '' and not strict_groups:
+                    continue
                 if res_group not in match[group]:
                     raise Fail(self, 'group failure')
 
@@ -389,7 +392,7 @@ class Test(object):
 
             # do the expectation - results matching - both ways
             self.compare(self.expect, self.result)
-            self.compare(self.result, self.expect)
+            self.compare(self.result, self.expect, strict_groups=False)
 
         finally:
             # cleanup
-- 
2.53.0



