Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590891;
	b=FqABry0AbPfI5pTdgATNTfPlQT8qeAUVFybK8NFu8Xlrza6hnA4fTrskz3jXUV44Uye2
	 irMz/CcjBR1PMXX/mIcDGwviaCuH5jI5Lc5l7ccW4uHBeMQu41XCsxoSpRMnKIxRm62iV
	 vXyT3uVXCO04MxGFT6QzLdWg8v3wJAzyHJxLXqt57fKmDTbSwzYb4dcoMB/o53Bm5YpY6
	 3GynMUAT0fMMPsZIIPZIMiFar3nCQ+g3hLGmzZS6NtocQzWPR+tuuyk5glUj+2vLd+tMz
	 YsZRsz77U2haISu5rfTB/T5IvUFU68gMk313Z/Ved8+3B5barV23g1jZ/vKCVgJk1ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cJ9LIB9X47DZkQgLLUJEmKgUSYzwRBCxy5ST5OoLFvU=;
	b=d7WYEYiv8E50WJyft00thVDbhPGVBXzFyadX9q5uE7WimJ+2jJMbh3FkRFHNINA2GANA
	 qLfwTrFYk5kEldTOrvG9V8vHR0HZG44dSdQz0+V88PjrJYzSXJAl35Civgl6yzAyvb7bh
	 4Q8cxYH/Q2CtWnRDbgeHDRHWqjJnD9Fhs/ZTaqwWmD49AJl/d10OAnxhPPm4mfF8Om8OM
	 uT6f/jSEi6jwmWMFsJzT46QixjlJNHxLsHHCAJ8EluHYvUGc4tW4hBov7lmHZLCk/iVyX
	 85pBE3a8eiYMAQe2w+QOJ06vN6BBIu3/d37UBVWGkumEJK8ERJ70p4wMB+GmhTp8dnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoYc0dYa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B84606E217;
	Fri, 13 Nov 2026 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoYc0dYa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143DF1F000C4;
	Fri, 13 Nov 2026 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590891;
	bh=cJ9LIB9X47DZkQgLLUJEmKgUSYzwRBCxy5ST5OoLFvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoYc0dYaz0M78/T3ykXa+TNjCKrqGMOwpmVj1YiwRtGqQ8R/N/fTF2h9aXF1wKfZc
	 0OWjpVWVDizbwUkRfuGTC4hsXFzFWjhSCQOvyN9CcAubRjyMHDWgcRGtVy/EvSbN2m
	 7p9l/09ffkOXdsP8e7d8PM+RFEIwn8d+d2z2Zd8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/670] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Fri, 13 Nov 2026 10:44:07 -0500
Message-ID: <20261113153814.681364279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

[ Upstream commit 5695abc4e742b947f586bfb6a080a80ad9957e5d ]

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e64b2959bd01..fc4f9aa0a3620 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1687,6 +1687,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -1715,6 +1735,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damos_set_effective_quota(quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.53.0



