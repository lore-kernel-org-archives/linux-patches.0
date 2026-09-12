Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF9635E549;
	Sat, 12 Sep 2026 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211572; cv=none; b=rWvemYr8eq6mToKOmnMl+8aaKClJRbhdE8lOU51Sj8vKrN8ziqQkbetilNww2XmYCWTIakgCVOEeK1eQjANVoc20l/Tgl1jlNxH+PfD/VdQi52NF0ZCPYGrk2L2VZcFgLwN/PuIQpWgJMXojZMDb/ac0HKBnOlZ2tfAMKr+kiQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211572; c=relaxed/simple;
	bh=FM+AGEA29SFI85xHyIzQqCG1wCkbYvFUkeuFjo/kcCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1Pf7hao2KuLfStjrHIjdijHk2E5NbgIiifXoMGW1IyGOYClswK1roU/ic9/caobLIwwkDKd4oBB3BWY3Zw8qkf17+DirjhSnKP4G45oqL8dyYyIvzUwP3KuE0H7Qf2sEkcgPGgM0iFMA5/ksWbINJF7KTDJNi57WWiKyV25wtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osCjUT4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osCjUT4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE391F000FF;
	Sat, 12 Sep 2026 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211570;
	bh=ys7vFXuQIscISgnW+ONEp/Rb5xP83xLZYjKyFPb/ZQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osCjUT4lh7m86t1PGBaD1TNjc9Q8kQbVLsgHW0wTWy0KRhpOku7LOdtbDcVXkHeEo
	 t23eGfcyHXF7bUtqLrdhSW6EEfIortouD5T5IctyyXl3li4bzllIiX9RDcRNSpceRr
	 xkitiTIhA2RW7OG5/uQC52z8uJrfDVNouEBZLmDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1258/1518] drm/xe: tests: fix error message in xe_migrate_sanity_test()
Date: Sat, 12 Sep 2026 08:57:07 +0200
Message-ID: <20260912065651.970183335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 3d318fe4e99a627aa3c2980699e2e9f13ad18516 ]

This is supposed to print the error code but there is a copy and
paste bug so it prints "bo" instead of "err".

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/an1tu0z3T-qX1ogn@stanley.mountain
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 28a4198c52a1468fc1b620a9837557ea1dc1766d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_migrate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_migrate.c b/drivers/gpu/drm/xe/tests/xe_migrate.c
index 5904d658d1f29..e056fac1a86b9 100644
--- a/drivers/gpu/drm/xe/tests/xe_migrate.c
+++ b/drivers/gpu/drm/xe/tests/xe_migrate.c
@@ -197,8 +197,7 @@ static void xe_migrate_sanity_test(struct xe_migrate *m, struct kunit *test,
 
 	err = xe_bo_vmap(bo);
 	if (err) {
-		KUNIT_FAIL(test, "Failed to vmap our pagetables: %li\n",
-			   PTR_ERR(bo));
+		KUNIT_FAIL(test, "Failed to vmap our pagetables: %d\n", err);
 		return;
 	}
 
-- 
2.53.0



