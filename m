Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062677;
	b=XffHGcZPVadA0WGKvJmiXCIBixGce4Hy2768o47hYFe3u9IKtNRmSjUEUzgh7On8z2Wn
	 8raTRSCagKbXlBnwL+hH3yVASK+JEJemqJuUAvqew3Z72ej9Cw7oam998rNI5bTrzyvtV
	 tV/Edh8ZRC9XBBZZp5BuuX+jNZef0G6VPu2pLwuoEh4m9bR0C6BDOmdQcTN1OOFuOSyMo
	 2BsdA/cXIye8oFw9rZE4/+H02hWz8rOlOfMuAtfRnL3mSZX0wJMJQCLr4IT4TU9pr6uB4
	 M+2dCGtJHela69fg2CyF9qSs4yRb6rhH0zhOe+qCs8uKP+4NTCSUhQ73ICRlC2zs4Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TMndP1/n4S+0vJ9B3u8n/2VcXGIgJGp/pv59L3pPiig=;
	b=njL6WS6njrylS23xlG1V+ayqYr3X72jTAArzs0M15xBalOZRE/DsU1NINAEWhNZXBFwM
	 LeXm21KOH2pEiwMXGcrSYArsznNht/ls+TWWsyr9JXHih1fTRyp8eY2Rh2U6O5cBTmoAB
	 1sDq8zWEC0xWMdXF8o20MODJn7qOtKKYsOhhxHnyYYYYnNmSY/x3VopY/9ujHcZmUCBXM
	 HTYuchRFww7vBpROAWG/EO1CAU2mf91f5Aj2z1NWjYXduA1GSf9ErTPLVOOW4BEog4UGa
	 3XMpq8m/Md/9ecmaP9JTw7sAWFggelw0hBmGh1I9A5sZrOUFc185gVJkwNrNkD0V69A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6WP5vRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C81606A32E;
	Sat,  7 Nov 2026 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6WP5vRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBE71F0089F;
	Sat,  7 Nov 2026 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062676;
	bh=TMndP1/n4S+0vJ9B3u8n/2VcXGIgJGp/pv59L3pPiig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6WP5vRZ/9KuEWJwHkp1ctpK2S8RJ99FO0K0JGXzHjIjtXxv69zVcqJtLWKXgNKn5
	 FBl3QjjnOxPiS+lgA7bnAXKO7OnXr37swtQMoZriJ7KwnVtLZD6UdYqmDdblnJvF8a
	 FqCTcw2aiIRbjzzOSh1KIl8RLe3AwKsLPSXTR4eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1527/1536] apparmor: remove fs entries created by a failed policy load
Date: Sat,  7 Nov 2026 08:59:03 -0500
Message-ID: <20261107135040.766942028@linuxfoundation.org>
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
index b3a602c9c23d7..efa11a1a297d4 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1132,6 +1132,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	bool rawdata_created = false;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1271,6 +1272,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			ent = NULL;
 			goto fail_lock;
 		}
+		rawdata_created = true;
 	}
 	list_for_each_entry(ent, &lh, list) {
 		if (!ent->old) {
@@ -1366,6 +1368,18 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



