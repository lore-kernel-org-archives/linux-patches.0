Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025740;
	b=f9uTRRpbFKtqlXDF2OvV3MqpPzdUkIhqfiHUh/gB8+uwta4eL6LcU1UxmgMEUBSnS1Zo
	 MOsqivf51WwB71GzrbfpixSdoG4ElP8d/Smxelv05Xg/8krQ2a6S1ac+eshknQpWDo7Lo
	 aURsC/J577vnSQQzCSiVivj5/RlCA8QDR5+mpiiZqWb7XmHVo8VOtdwJUH7vnIx1PzmXw
	 rKdEL37bDAhb+mhcv5IoyjPOfb3VMSx+cMYQA6mKZHFxT8JlkeEWjaDhVKG7ds3BS/EHJ
	 8mqTWWZVC1IgV4XuTyi7y9r55G2BKj5tb5fepIBM9pJ9trkhTViV5uUOhKEmC6nOyiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j58CIgQhw6kfxh2qOaozb4OZJgPuEqn5+M7zBEjfXMg=;
	b=bCZJJvk5bZBkZ2ODEjV3pIOHusKFJtRugoLfYLOrmNx3n6UBgR5q6lcR/LZLzUV49MTD
	 XZmWBH6qyMECUIM2jsLDfSsALigpMVBHlcOwHYjQ29KQ/Xj8IuzSLtiJw3/dpYomKGxPO
	 vhcO/BbehqhURSVqp3JHKoEbWxaBuN2ij/4ozB/TzrGmxImNbqFZEKNLWa2en0itJMXho
	 qHPeoI+E2g/I5mvfHDIis/g23Gfknfk413+P+fgUzkVe/u+LAPby5ftKbZgawFbrP72kf
	 HySy55d12hUNrkH4WbObG1shvWfoi3kG4vEhRN8tQDZ+UtrzN8UY8MLuWYpOsINXSNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPdNGHRA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34613606A32F;
	Wed, 18 Nov 2026 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPdNGHRA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE5C1F000C4;
	Wed, 18 Nov 2026 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025740;
	bh=j58CIgQhw6kfxh2qOaozb4OZJgPuEqn5+M7zBEjfXMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPdNGHRA06B9H5iy2W/dqhMRd2glzF77ETYiZAoyU0POjbCsbuUv2vQdcg9osXyUb
	 y/qHC0KoV68Fsd67luQWW0mjjNtLpdYfI0CbJttzRZXGbIoCaxeXRfG2OrzGFuqWYv
	 C9iZjQGBP+uuWS2VycReu7nX+PlbfWh4O9mHu8sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1185/2151] perf test attr: Propagate the return value from the test to the wrapper
Date: Wed, 18 Nov 2026 15:48:40 +0100
Message-ID: <20261118150205.362801532@linuxfoundation.org>
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

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit f8596112cbad0072cdc957c0ea06695afda246dc ]

Currently it does not matter what the python script actually returns,
the test always passes, as the $err variable is always 0.

Fix that.

Fixes: 8519e4f44c2af722 ("perf test: Add a shell wrapper for "Setup struct perf_event_attr"")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/attr.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/shell/attr.sh b/tools/perf/tests/shell/attr.sh
index 5a4e43b2471de..307e1535795a3 100755
--- a/tools/perf/tests/shell/attr.sh
+++ b/tools/perf/tests/shell/attr.sh
@@ -18,5 +18,6 @@ trap trap_cleanup EXIT TERM INT
 shelldir=$(dirname "$0")
 perf_path=$(which perf)
 python "${shelldir}"/lib/attr.py -d "${shelldir}"/attr -v -p "$perf_path"
+err=$?
 cleanup
 exit $err
-- 
2.53.0



