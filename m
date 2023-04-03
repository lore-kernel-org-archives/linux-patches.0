Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170736FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903C0C433EF;
	Mon,  3 Apr 2023 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532578;
	bh=vuW0vUuDsrbF6EdZBmyISlMkpcKD10t+InuXT0eDUMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbjqjpEAoKeaa1NHBf+8DoSLqM/YutoDe6bkxwdk2a8e0gXgzE6QKfqfnSwXsyDz6
	 nn92ihK99L4Bcagji7dkBKxoyz+D22YkPu5re38xsIKUVcoivnXoIBHAGotEgz1SUK
	 AcPV4UgM4VnLEhPaAeRnfUaDo8PGH1wQn3hX11ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Nick Terrell <terrelln@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/181] zstd: Fix definition of assert()
Date: Mon,  3 Apr 2023 16:07:52 +0200
Message-Id: <20230403140416.370578318@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit 6906598f1ce93761716d780b6e3f171e13f0f4ce ]

assert(x) should emit a warning if x is false. WARN_ON(x) emits a
warning if x is true. Thus, assert(x) should be defined as WARN_ON(!x)
rather than WARN_ON(x).

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Nick Terrell <terrelln@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zstd/common/zstd_deps.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/zstd/common/zstd_deps.h b/lib/zstd/common/zstd_deps.h
index 7a5bf44839c9c..f06df065dec01 100644
--- a/lib/zstd/common/zstd_deps.h
+++ b/lib/zstd/common/zstd_deps.h
@@ -84,7 +84,7 @@ static uint64_t ZSTD_div64(uint64_t dividend, uint32_t divisor) {
 
 #include <linux/kernel.h>
 
-#define assert(x) WARN_ON((x))
+#define assert(x) WARN_ON(!(x))
 
 #endif /* ZSTD_DEPS_ASSERT */
 #endif /* ZSTD_DEPS_NEED_ASSERT */
-- 
2.39.2



