Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039285;
	b=VCZjfWHbRqi3kzTIASKlHfTO0LvagHjhmBCxMYMKR6JuyDZKoTxAqvDdO2GBM+Bgbbqu
	 q8inM4cuK/cfkZv2/RPDBrwkUlqNLsZTRt9Uzn6rFHFSFG06gWQvnMdHlWGKvdWy1K+td
	 Axgm8up+dqAXDgsUVBG7cOt/DGR7nmAUvBUZHsonqejFrVrL1BSH6oCMO2K7F1ULGXryc
	 t6fp6qP8Aqx2iAop5lydT1GeKp27KvVjFNt8LR/dOgBEdnMhP1tehLc5uTnzvpKizeX2M
	 iPvyiwII+MHOeOKcjZsX5yHtmnLHncaW7kDY1lgBg7k6FZ8L0rGkF394ocXpDPsY2aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2P8kKqQq2Vw3xi3/U7Dqgvxh9kLN248/fe/HOutE2Kk=;
	b=umJr5aiUqV4Ucsb66fgVeVEYkhRRi16dd3u7gR7OvxLD5Kk/zpOFmhTxak1wLKJJQ6J6
	 EDoh5oTvorhrHM01r37ymQbXuomh8Aaa8CXKEklleEB05QG9N9Fc1sd8LU8OtXCHxZz7j
	 Ly3djUTNYI5VGVKmgLigLgVqRTKlsdkd1PM5hAak/txze9ffgs7yrOaWfhkUMdmzE3ssb
	 FsQMv4kfoXcsUjW3U/EW/Hp5iS9e28PYxYmGZx0eHZhIn1WupjT6OoW/38MP94ilmL4Pj
	 SWi0NzL/pyRC/siJAOfUtrK0klzhVOSwIAOm59f2PfJ72l8rjC1i2rgOfbpniICySTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgwoJzS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9593606A320;
	Wed, 18 Nov 2026 22:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgwoJzS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3320A1F000CB;
	Wed, 18 Nov 2026 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039285;
	bh=2P8kKqQq2Vw3xi3/U7Dqgvxh9kLN248/fe/HOutE2Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgwoJzS42x669oYIFIuR8LuaVbZgLyAywNr8c6pJj8MZ141+pC0Iz/TA5TNOSRVpH
	 C/5ZzYj5JMdFA0UxT/iPtn2rqlSUMDlMdz00IdBifCuO7niIjtAr/TQHOjP3atyS/G
	 B0c+FjDU5e0tGe87ckmYMQfugolksmtEpVUi4g48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrishikesh Suresh <hrishikesh123s@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2009/3318] perf: replace strcpy() with strncpy() in util/jitdump.c
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118150422.317739832@linuxfoundation.org>
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

From: Hrishikesh Suresh <hrishikesh123s@gmail.com>

[ Upstream commit 9bef5cead63d5d8fad3ba7ebaf26f3f4ee172c82 ]

Usage of strcpy() can lead to buffer overflows. Therefore, it has been
replaced with strncpy(). The output file path is provided as a parameter
and might be restricted by command-line by default. But this defensive
patch will prevent any potential overflow, making the code more robust
against future changes in input handling.

Testing:
- ran perf test from tools/perf and did not observe any regression with
  the earlier code

Signed-off-by: Hrishikesh Suresh <hrishikesh123s@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 4eddf7d9e341 ("perf jitdump: Use dirname() return value in jit_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index f35b68d796bab..1b5fc048af8b6 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -238,7 +238,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	/*
 	 * keep dirname for generating files and mmap records
 	 */
-	strcpy(jd->dir, name);
+	strncpy(jd->dir, name, PATH_MAX);
+	jd->dir[PATH_MAX - 1] = '\0';
 	dirname(jd->dir);
 	free(buf);
 
-- 
2.53.0



