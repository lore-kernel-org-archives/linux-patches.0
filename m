Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7658634E;
	Wed,  5 Feb 2025 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765980; cv=none; b=AsM0voSiEaorkDZ1+hDue90KmmtIV/jmFQo0RfG7KI43TB+PYO6D7tgMBEeOZSSkXB/ypAlxBmTQ7oXd0P6gJeUHfUwRZtZybk5Q6MUZesipi+2fanqQtVXg/UwtCzOAop5bqgirubP+7YBBhrli7sZil8FeCF3WN6tZQYhdufU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765980; c=relaxed/simple;
	bh=IJPAZNs/6yFg6UhXJKOq2+9Dl3gaiNiDKrnrxSgAHso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAs/suvuc5A6gvnSaJB/UUQrX/UGHW0uG2SSXqkoaAnVv18qd27VrNiQNejWwanCsGa/Vzc4LQppi2/3BvLCByUQpiD7WKjgEPtapHaopb6dTUR4eUILL782qnQCzg1sjDRyvw1THy8IirGwtSilhc5/kE3sOhuDiwbRFEMiwz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saEuWwmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saEuWwmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893D7C4CED1;
	Wed,  5 Feb 2025 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765980;
	bh=IJPAZNs/6yFg6UhXJKOq2+9Dl3gaiNiDKrnrxSgAHso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saEuWwmV1ykX3GgKdGKVxjCkw7OxLrNsM9oc5jN0qUBBg4JxFz+5tHqKIfzQ2J/sp
	 n0KZHEJKJH8UqZcbSZENEQi7Q1G4Yjoyi7MDcX1EeM2gIvLstOOrbxvu71IzuU4Fg9
	 J8jWc5MBpmrF1yk+/q7iiPLLpGMbnTpjbvyVcOBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Tahera Fahimi <fahimitahera@gmail.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 231/623] selftests/landlock: Fix build with non-default pthread linking
Date: Wed,  5 Feb 2025 14:39:33 +0100
Message-ID: <20250205134505.063302935@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 0e4db4f843c2c0115b5981bd6f6b75dea62e7d60 ]

Old toolchains require explicit -lpthread (e.g. on Debian 11).

Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tahera Fahimi <fahimitahera@gmail.com>
Fixes: c8994965013e ("selftests/landlock: Test signal scoping for threads")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20250115145409.312226-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index 348e2dbdb4e0b..480f13e77fcc4 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -13,11 +13,11 @@ TEST_GEN_PROGS := $(src_test:.c=)
 TEST_GEN_PROGS_EXTENDED := true
 
 # Short targets:
-$(TEST_GEN_PROGS): LDLIBS += -lcap
+$(TEST_GEN_PROGS): LDLIBS += -lcap -lpthread
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
 
 include ../lib.mk
 
 # Targets with $(OUTPUT)/ prefix:
-$(TEST_GEN_PROGS): LDLIBS += -lcap
+$(TEST_GEN_PROGS): LDLIBS += -lcap -lpthread
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
-- 
2.39.5



