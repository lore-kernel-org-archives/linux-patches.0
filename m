Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46D7199941;
	Tue, 10 Sep 2024 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964302; cv=none; b=q0+kxeZ5y0Oz5PIPDnIlqjR3JTeha1O9VQQyQUsbrfkUuK+Y2FpbNJ4ceoRapP0zjhFHkGq8eRqKSUnn5yrSvOmsUawUL8TExELnn8maoDHEAIekhfXM8DohJDOprlRRuhAP+3N4JSE480pSf0cNU26V+lhb8C5BZ9NGjoG6l44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964302; c=relaxed/simple;
	bh=wiqtrK2Cl+C2szB4N3LNkgGZ0RJyP2e+cM8L0E13wEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izMz9bY1Mmjf5aoeHj4/DZBXvOMXjNv+Ke9QA+hpLj2qZZmA/YWfw7yOI9INoxW4EkwaDkhjexZYZ8DcBvBEnsy5Purv2cDeNv/aPoxwtMEBIjMCu7ixsDTlD4cJZGbLGjVa4xjflv/1/5CFWnvmyBVxcixMGmzWaMLGAcy3Ql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIQvBkSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIQvBkSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5913BC4CEC3;
	Tue, 10 Sep 2024 10:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964302;
	bh=wiqtrK2Cl+C2szB4N3LNkgGZ0RJyP2e+cM8L0E13wEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIQvBkSqR2qWq4VaB62BXpSuwyrzVyii7OTCr95SKYQrbh55BsTXrA2A+VQonfOAU
	 G2leykEsyiAJf2b0Jw5GJXo1v4HagwFymAURuZsXTG0l982Upy51w31AqF/blYT8qm
	 5b94tHXK7PNfLZeNivDOlbIxhjPjFxrJFnpb7MM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/269] selftests: net: enable bind tests
Date: Tue, 10 Sep 2024 11:32:03 +0200
Message-ID: <20240910092613.054719061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

[ Upstream commit e4af74a53b7aa865e7fcc104630ebb7a9129b71f ]

bind_wildcard is compiled but not run, bind_timewait is not compiled.

These two tests complete in a very short time, use the test harness
properly, and seem reasonable to enable.

The author of the tests confirmed via email that these were
intended to be run.

Enable these two tests.

Fixes: 13715acf8ab5 ("selftest: Add test for bind() conflicts.")
Fixes: 2c042e8e54ef ("tcp: Add selftest for bind() and TIME_WAIT.")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/5a009b26cf5fb1ad1512d89c61b37e2fac702323.1725430322.git.jamie.bainbridge@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index d417de105123..91a48efb140b 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -85,7 +85,8 @@ TEST_GEN_FILES += csum
 TEST_GEN_FILES += nat6to4.o
 TEST_GEN_FILES += xdp_dummy.o
 TEST_GEN_FILES += ip_local_port_range
-TEST_GEN_FILES += bind_wildcard
+TEST_GEN_PROGS += bind_wildcard
+TEST_GEN_PROGS += bind_timewait
 TEST_PROGS += test_vxlan_mdb.sh
 TEST_PROGS += test_bridge_neigh_suppress.sh
 TEST_PROGS += test_vxlan_nolocalbypass.sh
-- 
2.43.0



