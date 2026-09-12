Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D938655A;
	Sat, 12 Sep 2026 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218666; cv=none; b=HG3VblbZj/0k6KLIpXLPho7iEP2oI9mxy8OUaAS7K9Y+mP5dlZZveSA6CSDurkh2tQQBoArIWBGKpY3MELBguKpq3mPcuf+1AEv7rnzsFIAA6/EL3/2vOZIiDjI6VlsFQWSdbvDxVJ6Eklc7fbQxhOsBPoNVrx/tYvXALZA97mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218666; c=relaxed/simple;
	bh=O4JIXVwoOvCDqOji1/boDWxkDe2sM67t3ZaiFHDsCTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOvOVt183ol0FMwoXwnMl+vn6au7pVZyxzQ+dKJTyNdbEf9SyAOPqvhMoGe1gqYkHIviDfp/t1Fq2hT5cxKI2ZqiRzbtWOTMVo7TWUyxKflhURVthnWrGzHDCaLDrSdnFCvi88obVHcYHvF4azOelEXmJMLwWPP6/v4iXECuyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLkp0nJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLkp0nJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89571F000FF;
	Sat, 12 Sep 2026 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218665;
	bh=zIOUUxqbZ/F5kExVkWFZ7TR2lIW/cHLJ7aPi63U+9Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLkp0nJCEJ3XpuDoZGOfHbnVLiUjOjj4ybJyPHuJh/72edcV4I6YvPi6oqUb3rpF5
	 6Jki6ZIwjbyQUni8B0bfsOcwI15VBkmXyLD6jDD4lcON9Yx8qRkmMEg2SKq6Ivj1Qj
	 lj52w5avf/4NwrYzgL6Sx7zABGcValkBoGOSza/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1190/1376] drm/xe: tests: fix error message in xe_migrate_sanity_test()
Date: Sat, 12 Sep 2026 09:00:16 +0200
Message-ID: <20260912065634.073995230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3bbdb362d6f0d..40007f0ddc0d8 100644
--- a/drivers/gpu/drm/xe/tests/xe_migrate.c
+++ b/drivers/gpu/drm/xe/tests/xe_migrate.c
@@ -194,8 +194,7 @@ static void xe_migrate_sanity_test(struct xe_migrate *m, struct kunit *test)
 
 	err = xe_bo_vmap(bo);
 	if (err) {
-		KUNIT_FAIL(test, "Failed to vmap our pagetables: %li\n",
-			   PTR_ERR(bo));
+		KUNIT_FAIL(test, "Failed to vmap our pagetables: %d\n", err);
 		return;
 	}
 
-- 
2.53.0



