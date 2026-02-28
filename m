Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5B4340A51;
	Sat, 28 Feb 2026 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301282; cv=none; b=tqfNoDtS/0VvP0103SJJRw6Akw33dbEXzA2dGKYbZkXx+3ZJqlZqlTQbe4U3Ki9PGH3WZHrn44BJU44joWGA2Kt1ycJcnMHchVkoS+QD8HRbk+Oui3riKfEokBJkaZMr36q5mss7lnSb6JrfLByKLhBwmxMTTkAHarCPpgmDbhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301282; c=relaxed/simple;
	bh=zyf+gpSoNDKeLFptf7hUU0gxUFJbg75B1a0fm/er4Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUr+I7Zy1BztQFHI+zdUaAgMw1PAF2Al/OmhOuj6QJ1OUMEWvbRyq1kPLEB4Nh8TuQjhWLrTw57RezvQTR4f3KneQjhM/yYwWgPA3Qdo+K3fDoVeC4VE5d0+D0aChmbJeOw7ERzJUdc7Xs1GgpuzlC0vB7yf0oQb3apY5B1BPlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BebEBhlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BebEBhlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0850C116D0;
	Sat, 28 Feb 2026 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301282;
	bh=zyf+gpSoNDKeLFptf7hUU0gxUFJbg75B1a0fm/er4Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BebEBhlR8tEY/wx70W2yquRwuf/d+N8t1IJACOzkleeE64ITs5Is8iLLIVMhA9wa7
	 mLAgXdVwLliSb06YHtGem5ilKVy4ZKd4klMq5muOzTcf3plGNcakvOCg3TzolNdUja
	 73fO9B+bIVYNPTnvuI2+VJfKd/fsc1IxiJuoSsjwo7EivBU4fvGji4U4xkGHInzgx+
	 x/JNIPW3ixxJyaj9nOdqnrFELwKnFxRLFcNLT8hrCrhRkJMGkAnYaRoSUL6U8SRpsw
	 xvaL9ivlCeVuS0hr+zXmifBUCvNqUAsRUlAcobUBdBiy/q648kwIZ8h/masPuejZqq
	 WlupLo5Y0iOFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 466/752] drm/tests: shmem: Swap names of export tests
Date: Sat, 28 Feb 2026 12:42:57 -0500
Message-ID: <20260228174750.1542406-466-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 89f23d42006630dd94c01a8c916f8c648141ad8e ]

GEM SHMEM has 2 helpers for exporting S/G tables. Swap the names of
the rsp. tests, so that each matches the helper it tests.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 93032ae634d4 ("drm/test: add a test suite for GEM objects backed by shmem")
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251212160317.287409-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_gem_shmem_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_gem_shmem_test.c b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
index 68f2c31623547..872881ec9c30d 100644
--- a/drivers/gpu/drm/tests/drm_gem_shmem_test.c
+++ b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
@@ -194,7 +194,7 @@ static void drm_gem_shmem_test_vmap(struct kunit *test)
  * scatter/gather table large enough to accommodate the backing memory
  * is successfully exported.
  */
-static void drm_gem_shmem_test_get_pages_sgt(struct kunit *test)
+static void drm_gem_shmem_test_get_sg_table(struct kunit *test)
 {
 	struct drm_device *drm_dev = test->priv;
 	struct drm_gem_shmem_object *shmem;
@@ -236,7 +236,7 @@ static void drm_gem_shmem_test_get_pages_sgt(struct kunit *test)
  * backing pages are pinned and a scatter/gather table large enough to
  * accommodate the backing memory is successfully exported.
  */
-static void drm_gem_shmem_test_get_sg_table(struct kunit *test)
+static void drm_gem_shmem_test_get_pages_sgt(struct kunit *test)
 {
 	struct drm_device *drm_dev = test->priv;
 	struct drm_gem_shmem_object *shmem;
@@ -366,8 +366,8 @@ static struct kunit_case drm_gem_shmem_test_cases[] = {
 	KUNIT_CASE(drm_gem_shmem_test_obj_create_private),
 	KUNIT_CASE(drm_gem_shmem_test_pin_pages),
 	KUNIT_CASE(drm_gem_shmem_test_vmap),
-	KUNIT_CASE(drm_gem_shmem_test_get_pages_sgt),
 	KUNIT_CASE(drm_gem_shmem_test_get_sg_table),
+	KUNIT_CASE(drm_gem_shmem_test_get_pages_sgt),
 	KUNIT_CASE(drm_gem_shmem_test_madvise),
 	KUNIT_CASE(drm_gem_shmem_test_purge),
 	{}
-- 
2.51.0

