Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017333;
	b=SCiwNF/4jgsODQSM7OvzLqGBxQ94CF5wgDB+qf2fn2Q0xSW+W/Q0c82Gg7+47FVPT5zu
	 sUoJncJ0h2mgHLrU7WYNDMHNR+DbdLNWZQTjgG4YVJgeMW/SX9yHl0wXYo69Jp5fyR07i
	 Ws557DfNN8nyLX+4rBCsYjNGiKxs489UuFnIOttvLra/KVLGMiX45wHjOj3eiYAThwR+Z
	 wM0lu7tVGRZZ62GpIUW7NHh8zM8s/ZxVWs9LCBr1klD/ksjoG9ohCO8Bx5nc0x3aFlKIW
	 8RVFLL9iSNVfRXISI/MkrpWZivbKt4te71Imqfdyxb/0KC076iYLz0T8G8heE9ZawgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i8RFgxBq72INMNSu8a90p05sEWxdXlbLbOIxGWuF3qE=;
	b=h0olmolWs+MF+Wzh6/Zc9FSUcGpeBxnWmwuc+YT5afQhemb2DpP8QOxGPz+QbxI8Ix6B
	 ksRgwokIFnLbnqzxy62hACAIRvb2VKGDGD2s4qO3Gb35GYSMrTQZINUwA+YjVVZVwf0Uw
	 87iERHxcCa2sKVSSWPx7Dq6b74aT8+zNeQIOsGmIhe/f17TcVtO4TbA6QIbGvBvNwCmj8
	 +1+Qz1TllaxbFEvsA/Gbypliscf7E1UwQe7/ZwIqNnUHtzOpyUs0sSMJmQb9TjSBh6RWX
	 FY4XXnJktPTGewFOaORyrfqnYj+Gxg7rje9TuQ1lNLBx8awe1WbrxH9z1pKsBQEpYlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PYlvF+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85886606A32A;
	Wed, 18 Nov 2026 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PYlvF+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A0D1F000C4;
	Wed, 18 Nov 2026 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017333;
	bh=i8RFgxBq72INMNSu8a90p05sEWxdXlbLbOIxGWuF3qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PYlvF+OKMN+IN3aP1MUP3Nr/akq/VN/6bvKQp+zilq7cd2OlixhKegyn9jzPLEBe
	 e+Mc7VOeE9OdbH4IE9LGxziq+euregleDeWoeHFKKlA0n96zRBTBKYTCz9tC7FCUQy
	 dafpVOEaLptei1jpbrmu6mfDKQLuUjUjy2ulcVEQ=
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
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0847/2651] perf tests c2c: Report skip when the workload fails
Date: Wed, 18 Nov 2026 15:34:47 +0100
Message-ID: <20261118150318.372011878@linuxfoundation.org>
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

From: Jiebin Sun <jiebin.sun@intel.com>

[ Upstream commit f4a58c7164957e73df36ed24c42b0b9b713a43b3 ]

The workload path leaves err at 0 and returns, so the test exits 0 and is
reported as a pass even though nothing was recorded and neither report
invocation ran. The check_c2c_support() path above it already sets err=2.

Set err=2 there as well so a failing workload is reported as a skip.

Fixes: ac881007c4bf7be4 ("perf tests c2c: Add a basic c2c")
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/c2c.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/shell/c2c.sh b/tools/perf/tests/shell/c2c.sh
index 2471d44595c35..f5f223cbf9cc7 100755
--- a/tools/perf/tests/shell/c2c.sh
+++ b/tools/perf/tests/shell/c2c.sh
@@ -39,6 +39,7 @@ test_c2c_record_report() {
 	# Run a workload that does some memory operations.
 	if ! perf c2c record -o "${perfdata}" -- perf test -w datasym 1 > /dev/null 2>&1 ; then
 		echo "c2c record and report test [Skipped: perf c2c record failed during workload]"
+		err=2
 		return
 	fi
 
-- 
2.53.0



