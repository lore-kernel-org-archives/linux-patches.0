Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062321;
	b=rELxzFkMPOTrthmu9uzjfv6NRvt9yHX2EuY04Djq9cSPUH2NieW8/3hU1uKKcmNRQj/+
	 9Jx6jHDfFodfuiW/umtpSN/jIlImMcQx9gwt9YdlFG2SD7kVDM7I3CVvnp2OccxNbvxIn
	 4vtDooswDaMOyTWxA6+hQkukPL3EzG5azk+1btRctrdjge2QZkN948Ax/vthSI5Nak4UT
	 VhOg3JgCNdX6yBBUDH3Wo/VBtJc7pe4LfY8EcjnkZumbIRxG2BGT1yP9aO9uORuOfJTTh
	 xPi09R1Zy+9JwOpkBnHioTkr0wFdvtZe6M9mWHsLDv9dYDwa+WVL42a1V0hFuMgT5LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQ91zRmEJplON09ZhOAEQJQYweJJgmQ5KQzwz12gd7w=;
	b=D1gChEalS3v9+9c5wOzp/KWcLx7yfR9kzMSLf86hKBzlmzpVf8tiPjgF2c84fO9bDDF7
	 zyd90ntARyCteh/mdnYub/bR5ZP5hnDWO+TWDJ9g4yhhq1sW3XAzLzdHbvnaIszGnaR+E
	 BrRsm+MJDsZeVaSb1oGeZM322GGJBx3P3AbPH2nHyhP1v0lCC61Y/Rc+VxH6Ac2MbXdO9
	 14+3hG1rYNxcUEkDNqQfOrVcRxO0zz7LP2bqRZX+RP6k2W5Fw38WXr26L0/KCbOrbz18W
	 Z8R2RNOmAypEtaIPaA59t+zJkVjJ8Br+5c2DgCn1vQJfOZceuXvSc/+wpIfEi7GeAlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5WxxOer;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A9E606A660;
	Sat,  7 Nov 2026 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5WxxOer
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C0A1F008A2;
	Sat,  7 Nov 2026 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062321;
	bh=SQ91zRmEJplON09ZhOAEQJQYweJJgmQ5KQzwz12gd7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5WxxOerXlxUBtRRvxK/t5c4kxa77DRUHz2GM/k3A1NL1olFZCVgQzTCS3vyX1saX
	 A/IhXp8m6kuiphCkXvP90EBvGGIhiNFKZFTQa8mRZae1Y+h75OfrvmlgQR/nHOc4Qq
	 ArP9EIfNSdmjM6oXxUnWHnZBfJGU3uvUjh00ZWGE=
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
Subject: [PATCH 6.12 1237/1536] mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
Date: Sat,  7 Nov 2026 08:54:13 -0500
Message-ID: <20261107135032.500233142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5fc797359ae..e2f474a0eb577 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1950,12 +1950,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
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



