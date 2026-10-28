Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213215;
	b=brMAzBqUWI6EjtCpgKqGUqYwOEsOGWpx/6S0f3uHdvunTnASqz32YzS1SzE/y99mSesO
	 K4IRhk2l/UxkmwcAalIVzoqNVCHAkRj1KvV+CsR/iodUqYj4RKU5PJUWTkrMmWjCPbxq5
	 +3/z5vC6hkvHDRPnWnm3D68PjTqN97uUjayNCiu4M/cNODRQXOntYr6rje3zXOTH8vPpM
	 TCVR7zplJ+V7qJM5k9616A1oQ99pG3609blHUF/qpwrjJ9WEmn61hVCRIUBgOpaz2XhLt
	 xfjXUUHvxxqWUcKL6V8yv7+KD2Aub84DE4EVJYurkmB214Rn13DTs89TvQGtVb/xjJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edFTxKy4e1BqQo0XffgFQmbZNxes0zmMtnEvaufvtzk=;
	b=NeUmfv6uqdK8sGyeuf3KU9/9OEuG4KWuKUTFY9htKxRHmxrALilFrBQGdUEAcuxcm5Cw
	 E04J+0QvK67W/SPEZ2GuK+NZiqAvb/hX7A7aMaGOOqaKO1DE0RlWtwS/I+cjzXrrTHk3d
	 k6NRxNtbYjXEOWpclHgkTIt8Gg6iQ1+QiNaankx7R+37I9yJG793smn4yjwBwz8q8DX7h
	 73R56JP/AIrj073chzeSHLQ5PPVuPIaGF5Etj3odoPcuAiTGqijsojKWOnp5IKwVH6suy
	 VOE0OAbFWGPdzWOuekgD6C63sEWrEfAQmLqz0mHSVoDRVUGFI3Ra9k2jCEWikhgdWRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQPS3qMo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3B606A31D;
	Wed, 28 Oct 2026 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQPS3qMo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7531F01828;
	Wed, 28 Oct 2026 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213214;
	bh=edFTxKy4e1BqQo0XffgFQmbZNxes0zmMtnEvaufvtzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQPS3qMoHAmywT3VUDDcLxPgsgS1/DgRLt55GorjfKtqDptdgjpNh2eN5fT5wZFOG
	 CaWbk0mp4tD5ElFZ32LCSSbfestsEWF8PfjbW0s5GmKzPKUReDL4JHW6MxE1UohAkM
	 JY0KZ+nnOGtxlBAXeIilEcySCpQve9pu13GsmIYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0426/1887] mm/damon/core: fix unconditionally skip last region
Date: Wed, 28 Oct 2026 17:42:02 +0100
Message-ID: <20261028170508.928304096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liew Rui Yan <aethernet65535@gmail.com>

[ Upstream commit b3723b596b548c837a766aae3553c14a7b15af2b ]

Once quota set, the charge_{target,addr}_from unconditionally skips and
resets at the last region of the tracked target, so the last region can be
skipped even when it has not been processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

However, it is important to note that this is a very minor issue.  This is
because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except the
last region were skipped by damos_skip_charged_region().

Fix this by only resetting the charge_{target,addr}_from when last region
is reached, only skipping when it is applied or cannot split.

Link: https://lore.kernel.org/20260908134739.96919-1-sj@kernel.org
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # v5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6d7a5f18158a0..f0da5cb2b88a0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -756,6 +756,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		unsigned long sz = damon_sz_region(r);
 		struct timespec64 begin, end;
 		unsigned long sz_applied = 0;
+		bool skip = false;
 
 		if (!s->wmarks.activated)
 			continue;
@@ -768,14 +769,11 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->charge_target_from) {
 			if (t != quota->charge_target_from)
 				continue;
-			if (r == damon_last_region(t)) {
-				quota->charge_target_from = NULL;
-				quota->charge_addr_from = 0;
-				continue;
-			}
 			if (quota->charge_addr_from &&
-					r->ar.end <= quota->charge_addr_from)
-				continue;
+					r->ar.end <= quota->charge_addr_from) {
+				skip = true;
+				goto clean_charge_from_skip;
+			}
 
 			if (quota->charge_addr_from && r->ar.start <
 					quota->charge_addr_from) {
@@ -783,16 +781,23 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 						r->ar.start, DAMON_MIN_REGION);
 				if (!sz) {
 					if (damon_sz_region(r) <=
-					    DAMON_MIN_REGION)
-						continue;
+					    DAMON_MIN_REGION) {
+						skip = true;
+						goto clean_charge_from_skip;
+					}
 					sz = DAMON_MIN_REGION;
 				}
 				damon_split_region_at(t, r, sz);
-				continue;
+				skip = true;
 			}
+		}
+clean_charge_from_skip:
+		if (r == damon_last_region(t)) {
 			quota->charge_target_from = NULL;
 			quota->charge_addr_from = 0;
 		}
+		if (skip)
+			continue;
 
 		if (!damos_valid_target(c, t, r, s))
 			continue;
-- 
2.53.0



