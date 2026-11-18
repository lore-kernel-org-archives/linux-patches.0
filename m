Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036467;
	b=m9/KyutEDIlyVHsDZvEDyvPTg41VwmF/vOMqpjlSIOo9Oc6cZZfvSzjcoxY0LYM1FvQN
	 WnWkkCXQpU+1pTv+LHH8kixiz8vQuZcfKZ8cFxGBuzYmFB7/9QEIAk1ETuW6TtQfGSAK4
	 fMVDvopYc4gh6sYyTTYNHsMaL+6VCZT0DLupLwHwRfNa/SafZ66dhw2qKvU0e0k8K1x1h
	 7Pc7fb3bIv9AIaQffjaYQpn84NRKhmvNhAJbn8PRseRwqcZDnpYwZyG34lThHjPvU2M8c
	 lmCgMvwGUlrC5l5sV73OO10ozSyIakYNJvOfR5YsHMHvHG4cWcRvAxbVXBhWQSgJ1LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wk5nBSBcEckcZr6snJAjZLUs7IJ+PbheVZfG/6tNWoA=;
	b=n8DyCXCEvRpmjYVhgFrFWdi5XHhgnDkGassH2rxWABaDz2/rcYysblt4FqCQbjaVEzyD
	 ZAgOe3UQs3DyXaazQ336S3a/iN61R2x60y9u9Ou/9qiaplzyB/AkTGjRAaT/83dsCXRzi
	 2l1gEPc2eJjnyl6ZImRz12tpSTPKmGKPlB5UIJe9UfPVkFdCod7OcGiYIuZPzWQPMRL5u
	 Dh6ceEMZhz9rNwaa74ogVb/sizssKJQsgt7IGih+FY9AwbKguV6AxGNO+X5Mu+jGFdN9a
	 uTnmeNgI8l6VQhE/V0/fwXa7ft1N7C98YJTvFR+z1N7VKXGY0jVODrTSv3V/4x+L1Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oythxdcx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA35606A33B;
	Wed, 18 Nov 2026 21:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oythxdcx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720931F000C4;
	Wed, 18 Nov 2026 21:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036467;
	bh=wk5nBSBcEckcZr6snJAjZLUs7IJ+PbheVZfG/6tNWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oythxdcxaQg+EH34b6Nn/9qkKuinUQ4E9z1FzAWH6pyJT9SNzlTEJ7rH7aDkmN9Qz
	 h7FplXxMSQLKLXucnZ1heafrc66+XdBG1K0IzxPRBfObX1e31F2a6f+U4QisqaAcCh
	 THGU90X7yiNe4Dqsqov1Twkbka3MT/rV0u+BrE1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1071/3318] mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
Date: Wed, 18 Nov 2026 15:28:13 +0100
Message-ID: <20261118150352.097007137@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 60e58be27d5e16d35e0728298f994dcae9f208a5 ]

Patch series "mm/damon: move damos filter range arguments validation to
core".

DAMOS filter range arguments are being validated in the DAMON sysfs
interface.  Some of those have minor time-of-check to time-of-use (TOCTOU)
bugs.  In future, other callers might have duplicated validations with
similar bugs.

Fix the bugs and further refactor the code to move the validation to the
core layer.  Also add kunit test cases for the validations.

Patches 1 and 2 fix the existing TOCTOU bugs.  Patches 3 and 4 adds the
validation in the core layer.  Patch 5 drops the replicated validation in
DAMON sysfs interface.  Patch 6 further cleanup the code.  Patches 7 and 8
extends kunit tests to test the validation.

This patch (of 8):

DAMON sysfs interface reads the user-provided address range arguments for
addr type DAMOS filter twice.  Once for validation, and once again for
assignments to the variable that will be passed to the core layer.  If the
user updates the argument in parallel, an invalid address range could be
passed to the core layer.  Avoid it by doing the assignments first, and
then validating the assigned variables before passing those to the core
layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid address range is not really invalid.  It just
works as having a weird address range.  No critical issues such as a crash
or a leak could happen.  And sane users ain't do such parallel arguments
update anyway.  If they do, such racy behavior is arguably somewhat
expected and deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-1-sj@kernel.org
Link: https://lore.kernel.org/20260914142327.92510-2-sj@kernel.org
Fixes: 2f1abcfccd86 ("mm/damon/sysfs-schemes: support address range type DAMOS filter")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 546decf6b7776..f67a5cdc3ac3b 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1578,12 +1578,12 @@ static int damon_sysfs_set_scheme_filters(struct damos *scheme,
 				return err;
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
-			if (sysfs_filter->addr_range.end <
-					sysfs_filter->addr_range.start) {
+			filter->addr_range = sysfs_filter->addr_range;
+			if (filter->addr_range.end <
+					filter->addr_range.start) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->addr_range = sysfs_filter->addr_range;
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		}
-- 
2.53.0



