Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059980;
	b=JfgcA/7a7iFenxKYFcdaR/DzwYzlzTrUBMTvpxROOU633RhNkmPFUxhqIg0CCMtKlOm9
	 cotP5A3yX8VmdWCK+tCpc6ltvD7mLXxYJpUosMJM7Iy1CkyKdMw1J4MJDajtcoxgQAgrQ
	 VpCSYKHs9bD4sir6kFwjNI1iNziIvwGzIo4L05udLvT9QRLQM8yEs6TuBWv1uIPy2kgq+
	 3lG9LMJsclodZfPkC5reZpg8HHdl8ag+ZIM6M5HzgxyKwzTiaT1TP08XvRqcuPcu5n/+X
	 mmY+s/4qYIM7Iy+vylNztRzJxawDJVHIacUg5bDHLe49PlcPZwa78Lq43s9sIxn9ELw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3qk7PBBZf/ayfYA6HB707EPM1FUxQOyTN0Ou77K7mc0=;
	b=LShcylfsXAdBzYCusAVvneSQTKBuUM7HH+sqbjWH71V6JqkGlYjboiweDqzoqrX5oLDL
	 inoQDt5anGxGjcSJG88z8fluP8p0kRb8BTqUpRtX2TiS60/ywHL51FdQJXrVOaxsyDQHB
	 QYs2XLZcEisbRQ8QknW2dwU03FfUzodcY8YhX4Dkeu8t6056rR9KeluDI1qtvE28h3Fib
	 nqEEen6L3bLGgXrjPzYUVzf3tz1+qMWTHjIhXWpWVivPDpfuZYjPd3TqD/2uVk7yFqczV
	 UbG1XdFDcLY8xHkjapBp1j3iRQT++GG6DRX0jIhwaAFhEBiVTXxk7TxjMXZk6TVOzYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xyGNRzEj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3139B606A325;
	Thu, 19 Nov 2026 03:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xyGNRzEj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880DD1F000C5;
	Thu, 19 Nov 2026 03:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059980;
	bh=3qk7PBBZf/ayfYA6HB707EPM1FUxQOyTN0Ou77K7mc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyGNRzEjKL1vwx8mugqtOlPHkYvmOYyLoI4l26SfbErAw5lIUuYj1ej1/4cNfNoQ6
	 7X79pM2f9SGOuknny48EDqhoiIxua8D/r5RHZ1mqvsnEhN9fiRqXG5dLxZuDCjjCHR
	 kNYIshcBQn61PMGP6RhU/frVCm1OJvLd+wXrbpqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1036/1848] apparmor: remove fs entries created by a failed policy load
Date: Wed, 18 Nov 2026 15:51:14 +0100
Message-ID: <20261118150000.730060904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for different local variable declarations in aa_replace_profiles(). ]
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



