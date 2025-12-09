Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8153A2FDC26;
	Tue,  9 Dec 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239500; cv=none; b=dNcq5jOMslAmINWu/+0rRcYo1KZM0meGcdJ1tDNFU0YZOlmEGusLJh8kV3k50rGdRANn0QVA+2llVS/7I9v7QF7ivjc5OlKOkRPKItdt6+gBP5KdHOlZ4k+bkOws757/SWWQSBF9I4KA0BsfiqB/r8mdI1y/SU6+5VH5X7KO+7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239500; c=relaxed/simple;
	bh=6XxKFK7CvTqDhdMT0VQwuPqvrRIMTFpGI0cMHB6X1L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DI8I5gJsOfekA6pKHqRk7uhKzT1HUsQNnIlhqAYtjeHtKzNW7uh/mfCuokoCWKAmh6MJ9WSE2pqZZh8FVXhZ4wT/QYoE/igvyssV543rFFTsoa/trOKx13ADD3IFA2UPGWIxoeYQSaE3EVKp9Nce1h3fI4bM97bJqcymCBAmrEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kvpk413f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kvpk413f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702EDC4CEF1;
	Tue,  9 Dec 2025 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239500;
	bh=6XxKFK7CvTqDhdMT0VQwuPqvrRIMTFpGI0cMHB6X1L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kvpk413feaUH+Sle4dBiUKbPdTsXbX34NTpm7u18g6MRsOIN7/sibB5kXVb8D5JBK
	 tVfVxVcGEPytNZvi0g822nKOHzb2J4ZGvFTPx0l0Y+UphhrZYaU+Y/OsHdgBfqAL7C
	 23UXCh6e+oJK9KJGtPKysLA9EgKT7PcoEV4gmJLJ1ahktA6SWsRgxpJXJDVPWBPYY8
	 J+7/XS5DfD32lxyABr8fkMkKHEuqoGxCooHvCjg0rrdV8jdU5ZO3hiaNJgJxtwHarb
	 szvHNRZJWQubAFhm11S+tLcFL2DKjBeFTuHiZDUpHAku8JN3QysOgOFX8fWAftg2Ad
	 ckxa7OFf44dhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.12] gfs2: Fix "gfs2: Switch to wait_event in gfs2_quotad"
Date: Mon,  8 Dec 2025 19:15:34 -0500
Message-ID: <20251209001610.611575-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit dff1fb6d8b7abe5b1119fa060f5d6b3370bf10ac ]

Commit e4a8b5481c59a ("gfs2: Switch to wait_event in gfs2_quotad") broke
cyclic statfs syncing, so the numbers reported by "df" could easily get
completely out of sync with reality.  Fix this by reverting part of
commit e4a8b5481c59a for now.

A follow-up commit will clean this code up later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 7. STABILITY INDICATORS

- **Author**: Andreas Gruenbacher (GFS2 maintainer) - same person who
  introduced the bug
- **Fix type**: Partial revert - restores known-working behavior
- **Commit message**: Clear acknowledgment of the problem and solution
- **Testing**: Maintainer would have verified the fix given the severity

### Summary Assessment

| Criteria | Assessment |
|----------|------------|
| Fixes real bug | ✅ Yes - broken statfs sync breaks "df" reporting |
| Obviously correct | ✅ Yes - single character change restoring original
logic |
| Small and contained | ✅ Yes - 1 character change in 1 file |
| No new features | ✅ Yes - pure regression fix |
| User impact | HIGH - affects all GFS2 users |
| Risk | VERY LOW - restores proven behavior |
| Dependencies | Needs commit e4a8b5481c59a (in 6.6+) |

### Conclusion

This commit is an excellent candidate for stable backport:

1. **Fixes a real, user-visible bug**: Disk usage reporting being
   "completely out of sync with reality" is a serious issue for any
   filesystem.

2. **Minimal, surgical fix**: A single character change (`=` → `-=`)
   with zero risk of collateral damage.

3. **Restores original behavior**: This is a partial revert, returning
   to the proven timing logic that worked before the buggy conversion.

4. **Critical subsystem**: GFS2 is a clustered filesystem used in
   enterprise environments where correct disk space reporting is
   essential.

5. **Clear provenance**: Written by the GFS2 maintainer who introduced
   the original bug, so he understands exactly what went wrong.

The only consideration is that this fix requires the buggy commit
e4a8b5481c59a to be present (v6.6+). For stable trees 6.6.y and later,
this fix should be backported.

**YES**

 fs/gfs2/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 2298e06797ac3..f2df01f801b81 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1616,7 +1616,7 @@ int gfs2_quotad(void *data)
 
 		t = min(quotad_timeo, statfs_timeo);
 
-		t = wait_event_freezable_timeout(sdp->sd_quota_wait,
+		t -= wait_event_freezable_timeout(sdp->sd_quota_wait,
 				sdp->sd_statfs_force_sync ||
 				gfs2_withdrawing_or_withdrawn(sdp) ||
 				kthread_should_stop(),
-- 
2.51.0

