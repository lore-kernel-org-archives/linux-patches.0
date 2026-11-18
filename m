Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021742;
	b=CvEls7dMYZP/eKO+ZQmTQeWBazIBm32m8pyEdldGQlj64yW/X7AtsKBbVPxFHyzq1r+Z
	 8cGjcu3aUxq2SqStKWii1b7zQ/p4HIZL3tgIPvrDt8drkBCO08uuK1bxAhMX4DV7KAiGo
	 ECzQZdhxzgS7nV6LmE0RK6CpoM+Uv7uZWFEzq1tUHc1XjwP+6oSDz+q1qZKv36Car46PQ
	 Mg1ua3PjE98ANxM8bSENLRJ1tMGKdvkqyjH/c5UE1ld+oJFzMwo/HdRlHG3dIzfNsl+Ru
	 FYdOt8l8EmzmXJjoDzgzT+GZZvMn+6qJC8BsJ/0GXbcR9BZSNGVL74EufVhI1Hhe4rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sy4r3lOgDKfvQxvbpSSlLb6ovYR4pnMKhXX9vk4lIes=;
	b=Jw/Xr0IYeP3w6AXMnQpeqlv6eRQsruDbgwHU0nXs9h24Jo029GlIMyfS7k5KYd3sJyLu
	 NHzETD0Fc0VoE6dwk9e4eJ/e4OG0YM82LcNDr3n8pOWD1ygo3t5SHNlqOW9Xuk2yp7U6P
	 UqqtNkToEXTjL3f9h9wErHKptS6/MLnDG+7m9NihH9AxmUUpIWtlX7mvK/wSgoNE0T12T
	 qjzRt2ZG9FeA1kTWdBelQchUbgeFaasapSxGvJ68ifLJ+NhSCCCrFZVAO/zXzidcOTDmW
	 +qmRgU1SZ5YIqqLIrSniWS5lsFyVlEycnMpkAPBgHx9I6Z1y+4p9o+eSNrRyoPFPsFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOvA6p54;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF11F60A2605;
	Wed, 18 Nov 2026 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FOvA6p54
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9CA1F000C4;
	Wed, 18 Nov 2026 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021742;
	bh=sy4r3lOgDKfvQxvbpSSlLb6ovYR4pnMKhXX9vk4lIes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOvA6p54f45ao5l+74nZg0+/5WQaYYmclmcZQB2ZucG4VXp8gv3vknVgecRy8Spzh
	 2Du+cNqTJ2I8jYKKkGq4XMauyEAuJrAnnyh1J/xc3a0dZB4dKGTeVwi1vGr0UPOboT
	 khqfbRqXPaB9Mo9OzMVOt9NwHdAiVa+UQiAHZnwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2416/2651] ceph: wait for pending fscache write in write_folio_nounlock()
Date: Wed, 18 Nov 2026 16:00:56 +0100
Message-ID: <20261118150412.254376426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 3f7655f0d9186656c6f1cbc012a39c866d4aaabf ]

write_folio_nounlock() marks the folio with PG_private_2 via
ceph_set_page_fscache() and starts an async write to the cache via
ceph_fscache_write_to_cache(). PG_private_2 is only cleared once that
write completes.

If the OSD write fails, the error paths return without waiting for the
cache write. On retry, ceph_find_incompatible() would wait for
writeback, but not for PG_private_2, before calling
write_folio_nounlock() again, which would trip the VM_BUG_ON_FOLIO() in
folio_start_private_2().

Wait for any pending cache write before starting writeback on the
folio. Do so before bumping the writeback congestion count and
allocating the possibly mempool-backed OSD request, so that a thread
sleeping on the cache I/O does not hold either while it waits.
Add ceph_folio_wait_fscache(), a wrapper for folio_wait_private_2(), and
use it.

Fixes: 1702e7973410 ("ceph: add fscache writeback support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284%40columbia.edu?part=7
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5cccba9e010f3..6a61508be17e7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -575,6 +575,11 @@ static void ceph_set_page_fscache(struct page *page)
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
 }
 
+static void ceph_folio_wait_fscache(struct folio *folio)
+{
+	folio_wait_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_fscache_write_terminated(void *priv, ssize_t error)
 {
 	struct inode *inode = priv;
@@ -596,6 +601,10 @@ static inline void ceph_set_page_fscache(struct page *page)
 {
 }
 
+static inline void ceph_folio_wait_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
 {
 }
@@ -799,6 +808,9 @@ static int write_folio_nounlock(struct folio *folio,
 	      ceph_vinop(inode), folio, folio->index, page_off, wlen, snapc,
 	      snapc->seq);
 
+	/* wait for a cache write left pending by a previously failed attempt */
+	ceph_folio_wait_fscache(folio);
+
 	if (atomic_long_inc_return(&fsc->writeback_count) >
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		fsc->write_congested = true;
-- 
2.53.0



