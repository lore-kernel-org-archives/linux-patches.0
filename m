Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1022FA628;
	Tue, 17 Jun 2025 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178906; cv=none; b=LJ8H8z4ifdoxAqdBQBi5nudUkct+E33Zl5U7HnTzNtikok0balTnZMKSEWWCEloD9i7qiPWEss8H7KRnp3BYrviprYvMcY6MoOHldtTN8ASk05DkRQW0dmFpU3TTxLfpKn54lz5/4Zs6xlUK5DRqpl1OfGzSirN+fn2v3cJCuoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178906; c=relaxed/simple;
	bh=IdGteU1X7UpU50hCSjOGlse9yRdWojaZ5TUXk2lT0GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXhvo1dA6xw9AXP+0fQ8DGN/bBapPCVQc1n7JdWQeiMhRGUK14HQPRbYE78r0HlscCpUqT566JGJOidz9jt0Qd5SR8a5xhLfMBHg6H5fITEMkaXlsEuCj0PXRp+ax98BVnCj+dE4pr7apSO/Q7CL2MYiRBjggcVQ3kWjkoJ5DNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBfXjbCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBfXjbCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF5AC4CEE3;
	Tue, 17 Jun 2025 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178906;
	bh=IdGteU1X7UpU50hCSjOGlse9yRdWojaZ5TUXk2lT0GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBfXjbCjSqAF0uwN+O0gfSgDY9JxqdNWXNZz1vXURJ2BRg8uEWOGTc5r3QQa+ceB2
	 h2rdNKmtBbRaq2bHC7rSdsFN1qYt63aNBngeranoCYNK/zUSM6VZAr0DuL3hsM8oXh
	 cRp+AgLrDbVzDRE9ew4EIE+g6ZHjl9DrnTDIy6NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 589/780] selftests: net: build net/lib dependency in all target
Date: Tue, 17 Jun 2025 17:24:57 +0200
Message-ID: <20250617152515.462402219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit d3f2a9587ebe68f5067f9ff624f9a83dfb911f60 ]

We have the logic to include net/lib automatically for net related
selftests. However, currently, this logic is only in install target
which means only `make install` will have net/lib included. This commit
adds the logic to all target so that all `make`, `make run_tests` and
`make install` will have net/lib included in net related selftests.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://patch.msgid.link/20250601142914.13379-1-minhquangbui99@gmail.com
Fixes: b86761ff6374 ("selftests: net: add scaffolding for Netlink tests in Python")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 80fb84fa3cfcb..9c477321a5b47 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -202,7 +202,7 @@ export KHDR_INCLUDES
 
 all:
 	@ret=1;							\
-	for TARGET in $(TARGETS); do				\
+	for TARGET in $(TARGETS) $(INSTALL_DEP_TARGETS); do	\
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
 		mkdir $$BUILD_TARGET  -p;			\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
-- 
2.39.5



