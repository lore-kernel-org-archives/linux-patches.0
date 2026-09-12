Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016AD3C1F46;
	Sat, 12 Sep 2026 09:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204396; cv=none; b=gLT3CI66gW3nApMkEv03L5KScxsiGnpWET916dGCsEZjdnmtNg+fLkTaEkG9zZIpq0XkacKqhBqSvnhv5ZYejnLNiKOscDpIpglEIDSXyzn7yNEpApzaOFJ8eY3K6XWnvZgBvYzBE8GuWVar+oHcSHNXn3N9CvRubNmeA1mao6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204396; c=relaxed/simple;
	bh=YETLdw03DRvcUWYSJIIoW55/DkqVeMIisrV0hmh0Yq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2V3BRmERkUM/DnccmohEiWSFrBdC4nR0TmVn4kWzbprlN/d7WN0kL1qq3ZNv55qTRvSxqtDf5UzhyM39bizTt7uD/Znw8OQkME6/frK+rHux4jecJ5snuzVQkfLsNZlxzz1EAdhbRH18X3MLp8w3yAnDtByQKe2LzuHCmZvQ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtX3LKri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtX3LKri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03111F000FF;
	Sat, 12 Sep 2026 09:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204394;
	bh=g0vQcPcIZphokElmGvmI3CnfFxgA89wgWbX4T4Y/jfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtX3LKria2f1KrANo9Fo5G0/JgrHLy+58HtHuLL0zw+x7EuqobPsLwwiwPa7Z+1il
	 e8yI3aprm67t6yrszdGUPSxACZ+T5ggShhf5aOtcaFb6ZeL2OydoP67HwtZcgFFWwm
	 0TPZJBoy4r+hb4bhxBOtmi7quTwi2FQnO0z3Sv+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1561/1815] drm/xe: tests: fix error message in xe_migrate_sanity_test()
Date: Sat, 12 Sep 2026 08:55:11 +0200
Message-ID: <20260912065725.640048952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3c1be809be82d..f10d9513747b4 100644
--- a/drivers/gpu/drm/xe/tests/xe_migrate.c
+++ b/drivers/gpu/drm/xe/tests/xe_migrate.c
@@ -198,8 +198,7 @@ static void xe_migrate_sanity_test(struct xe_migrate *m, struct kunit *test,
 
 	err = xe_bo_vmap(bo);
 	if (err) {
-		KUNIT_FAIL(test, "Failed to vmap our pagetables: %li\n",
-			   PTR_ERR(bo));
+		KUNIT_FAIL(test, "Failed to vmap our pagetables: %d\n", err);
 		return;
 	}
 
-- 
2.53.0



