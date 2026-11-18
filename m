Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054308;
	b=UE2dOdbSLsi3buChQz7Ef9Z+0DVW6eGhavfeoUeGN/HgBKNtVMBtNJkQyKhcMeuxlWCX
	 oRhjqJjvAnuMoevrG+r+nmqb7+yoxCHB1BObN70zaaetFratOfaCkNdBpy3M+MwUy5GeT
	 D21l6Q9Xtawrq8LsZjWl3KsM12EziT/YrHH+sTxuncqErrxgioF4MsNoDi2LcXG8b+aPK
	 pn/+NzWLVNZVOt94PJksx2p8v1DL3FUlAQs4u4Brb+dAFHWFzxqauz3o0gQbR6oPs3D1x
	 XUZcVo8YUuPPW135IyXqwL65s3SH/aNVHv5lg7yDQM5BZ0sKqr4xmIlyKj8IBRHZPDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZIkjp02LANGSOyPO7nSoQJYrx+ZSNt4dtRDOcGqyGA=;
	b=ZYaXpuigLnTMaO9PYWzawE1WayRvaOCj8ErbzLu84cobZbFbISxw+v++X3XKlHdFwAP/
	 6HwW5mlLsbJukBvzWwTnErpWYCf5aLZGVD/LWdGLvuCnkbDBYFPnjvWIPRnTvzLoFyv69
	 +6wTf1CcU9JnDqTW/JaqL4oa62wnXP5wRTuc34u0NMx2N1E06STTEoobQgdXWBZtTsp91
	 +MY99nzF7dePB6TefrsmqKn6oe5DLpiwf0LDJh6QjJIdJGcSmcoVuWGBSbHiC3sBM4zWv
	 xQMuLHc5eSqPspMqeO7/lQzV2/RtvOkPi+IBm33xh1Drdp/Y97IfML03G4rPkHrDkBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9K8uHio;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4ED606A332;
	Thu, 19 Nov 2026 02:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A9K8uHio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C35D1F000C4;
	Thu, 19 Nov 2026 02:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054308;
	bh=nZIkjp02LANGSOyPO7nSoQJYrx+ZSNt4dtRDOcGqyGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9K8uHiognFdDQBfv8lSnZx5Eb8y4ocH4jo+3BcxylSLW78tdkO1QGkzJF+2+y3eA
	 q5erJyxu5MkCpTLWrC0vlyTsMZEO8ahwxu22D4NT/RCqCPDBUv3i65uzNkyB1Yhx0q
	 hAYACQRfSjb/Q5awQpCigsW2wIHVzG92eX7YS1L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1229/2214] apparmor: remove fs entries created by a failed policy load
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118150100.920653815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit 6ec46f8f1977d218bf2494ce276152b2d01424af ]

aa_replace_profiles() creates the raw_data/<rev> directory for the
loaddata and the profile directories for new profiles before the last
checks that can fail. When one of those checks fails, the fail path
releases the ns lock without removing what this load created.

The raw_data directory is named after the current ns revision, and the
revision is only bumped by a successful load. The stale directory is
only removed once the loaddata's last profile reference is dropped, from
a workqueue. Until then, every load fails to create raw_data/<rev> with
-EEXIST. If the new profiles are never freed, which is the case when
their dents are left behind pinning the proxy, that never happens and no
policy can be loaded until reboot.

While still holding the ns lock in the fail path, remove the profile
directories of the new profiles and, if this load created it, the
raw_data directory.

Fixes: 5d5182cae401 ("apparmor: move to per loaddata files, instead of replicating in profiles")
Cc: stable@vger.kernel.org
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
[ sashal: adjusted declaration context to add rawdata_created beside the existing udata_sz declaration at function entry ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index f3592af433553..dd8439e9cf55b 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -923,6 +923,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	const char *op;
 	ssize_t count, error;
 	ssize_t udata_sz;
+	bool rawdata_created = false;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1041,6 +1042,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			ent = NULL;
 			goto fail_lock;
 		}
+		rawdata_created = true;
 	}
 	list_for_each_entry(ent, &lh, list) {
 		if (!ent->old) {
@@ -1119,6 +1121,18 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	return udata_sz;
 
 fail_lock:
+	/*
+	 * Remove fs entries created by this load. Nothing else references
+	 * them yet, and leaving them behind would leak the new profiles
+	 * (their dents pin the proxy) and make the next load at the same,
+	 * unbumped ns revision fail with -EEXIST on its raw_data dir.
+	 */
+	list_for_each_entry(tmp, &lh, list) {
+		if (!tmp->old)
+			__aafs_profile_rmdir(tmp->new);
+	}
+	if (rawdata_created)
+		__aa_fs_remove_rawdata(udata);
 	mutex_unlock(&ns->lock);
 
 	/* audit cause of failure */
-- 
2.53.0



