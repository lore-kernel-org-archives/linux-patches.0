Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065584;
	b=Uq8boBiHtoa1mdqN0b0LomnTuDFDOVO+776BBflb+kXUP3pnOqDorMkZ1Jw6mvsYuM34
	 aeFEr9FCCROq/yo8RmHLjbuMzA47aJrJUmhgix15mSP7jqKQrw7MIbSjEDS4UkJmDD5Fr
	 q4XwpBWUWDAmof46TGiE3cK9pXBV5HIx89IW+6wvzI6vXIOBIcZtvrJ1tTEiDXMG+x9LO
	 56LZi8sncHFVUmipyW3nBm1eoQq/GdJcDFLxbjuDRHZ6m4dRtcGsqzgoal7+ACyQN90xv
	 jViMPX4OloqSRtw0K1SEL/7tEFAz6EjT5k4oAIDt0FpuFbe5Mpw+yH9qMzE7WFHeR5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hLcjufXs3wT6XxCteWXzTvXpIVHjJVSFrgb0Ynwu10=;
	b=dgDEBQpd0Ma3QvvGpQqCSBltRzECzKT+LzsaitCZwseHoStvfk/N20X8LsRF0CAdPFo0
	 NsoWiuPj1CKG38UHDyCp6ckkhRSEhhLHoMrho9LEoEEyA7fVykEZ9M+p04wb6bTnyeW0V
	 hJa9Np//x8Y8Me0i7Xh8enYnf/yGnfVaPwuD8gNtDxJfukmmiXDpT9qbyBzsx9uAZbYSO
	 BubpFlALeN6R7wr+wnRENIy8yqu07m3dnbZQ9Sf4vUddikNkmSFnh7fOLdPkFM4oDsJ1L
	 Ed/oKf1q8c8qD6IRmUXRUoKDHuFo4o+UH6xGtaKa5C5K/ZDeD5POlsKDx576FNBS9WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLJj6w3j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA213606A32C;
	Sat,  7 Nov 2026 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLJj6w3j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886511F0089F;
	Sat,  7 Nov 2026 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065583;
	bh=+hLcjufXs3wT6XxCteWXzTvXpIVHjJVSFrgb0Ynwu10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLJj6w3jK31hl8glDZgJWak7yKG1H8I4ZMemOUgKVRzMZexCCBY0qnGxgJrOT4W86
	 pyAmNoq22hgiKMxxZO4cmb5cLRC3FGVGkvT9uKkSIjUUxYSvUnkkPp/4UX84klBKMb
	 ln2RMBPZhtiHOIhp0GBF7jzxRUFLyj0rU+PKKqns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1242/1257] apparmor: remove fs entries created by a failed policy load
Date: Sat,  7 Nov 2026 08:58:58 -0500
Message-ID: <20261107135013.634579677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 397f9ff78aeb1..f6f7cdcb62126 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1191,6 +1191,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	bool rawdata_created = false;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1330,6 +1331,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			ent = NULL;
 			goto fail_lock;
 		}
+		rawdata_created = true;
 	}
 	list_for_each_entry(ent, &lh, list) {
 		if (!ent->old) {
@@ -1425,6 +1427,18 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



