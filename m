Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063766;
	b=HuUyU9MkKFWB4GFPrM8Cm1WdBgAOWKNKRAlob3XphNUbFuTqmJ147kpu19aoELS+qcM3
	 qlbO0Dk9SUF1omEBL+Va1wrFMiQEPUZiBlzUwndnhyEqrBj037b8f9FetSoeoBqB1wXij
	 fvMXaSPCCDBb+IgW5PyefQp+M5UE/lslnG2YCVgfPdj9YM6C5sXJDogfRxCduFX1rkr/I
	 ZA/L6n2AzRJ3MNI8prQHlFDh3f5ZQTm4Zo78yQPlhTLYm6jw7ps5Rc3sqKS059pKgnRQQ
	 BX7g3ZFSXh+VtQ/eVXEJZwm5opkglltiq+z74xY3dXXeb2i4kQrRpKHbmgYNHVF2A5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LHeqmHy5rIyIc2AprDwjASxHD+4Tdlh8rYxdk1lZpe4=;
	b=ET8zft3OThcCp4Rtt8PSNoRNdcNR7EE030PplmqQnA2d3hAlOT5JWmcGHhZo5+eF6Xl1
	 /a9tjmWKf74C1IgaKm9Iw/KKvik1zJPkjljiwoa97Othh+jQJdNuc9miOXcEZT+FsRlZb
	 fgpplNiwSi9z3ildm/nARg52o1uiugpgah7BEnVU3OhIPUVdyWlBuXEIqL+hi2N1c6cwM
	 7c1S5j//dxbVoQVKaa1wpZ4j3hWAMrmiMN73caOYXVzDNwGGtQfIRKBOmXEFHJf/e0m1Z
	 rldgxGJa/NgxpGuUz9QGtId31KsTVgk6HZxT1hPtmpYPrPdj5kXl/Q1bZhVg4vby+gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xH9sGP8O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A4860A2605;
	Sat,  7 Nov 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xH9sGP8O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF51F008A5;
	Sat,  7 Nov 2026 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063765;
	bh=LHeqmHy5rIyIc2AprDwjASxHD+4Tdlh8rYxdk1lZpe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xH9sGP8OT6K4XOnaJXsFn5TSf6pqhMDosGvcLN5SPSyBZuC+pe66ijBo23ckt6E+Y
	 vz4a5tppV8nkVUOvYq8K9kYqecoOv9TStPok2aRoRC3nHpnb+FI8eNQnHSQztER7cP
	 cqGN0Y855MOvQmyH7RalAqa7XKBv3Gqy7KTNpQ6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 858/869] apparmor: remove fs entries created by a failed policy load
Date: Sat,  7 Nov 2026 08:59:00 -0500
Message-ID: <20261107134921.841654237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 70d6315a059af..14c91fc94b22e 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1163,6 +1163,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	bool rawdata_created = false;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1302,6 +1303,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			ent = NULL;
 			goto fail_lock;
 		}
+		rawdata_created = true;
 	}
 	list_for_each_entry(ent, &lh, list) {
 		if (!ent->old) {
@@ -1397,6 +1399,18 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



