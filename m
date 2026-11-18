Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028544;
	b=rXgtZsC6TJaGgZSQpkMklxvI7UFL5SJaVUXwHus6SPPSyoqEEZiUOyuAjbhpX/2owtLp
	 798oz3DyZHMhMRqswHSUH1yG/+VAw+5XiR4Sk/+dGudvLJEx7uHtJciM1qXwcaaljvZhM
	 57iU1vjuhRD/oL9ahkE1xFalwusU68p7hVQaVAxJJ0ezLAiDfPmrIRKy9oMLwYPL169+t
	 /YBUm0lQOEryR+6L6HRpweU9FRY0gdh48kdan9B5Sm0f4RewVWzl3ceZEaoz1rH2gDFrY
	 sHSyXuVvHwPVJ+RyvJBNt4vVCD/CQ8foc/2cFPVtasYySDFUugOVPkpZ/zGKawyDgIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WNcD4kKMu/+ZVwgNEBH/RXCgjtFXY12ycCL8qL5dKtM=;
	b=M2llomf+zfKsbIS50pk3UxKlzJh/SaLbg0/cqvjJDEL7tvAZFLFKSbQdpQ0r2PUctkOU
	 FZfOf+0IxFXOhXXhIgyr4Yp6ROSAXrfTIqtuF+E0ejPRRMe2q+QVXgzM0p5JyVuC0JYVs
	 JH9FvBtlUbILZR7wjgubGNC1sKerz+Q9eLpz/dRLflCMn/ocAjjO2PAYAXogRnG+8YU25
	 YNyaW7kZSV3Z4IEjdvnrba4FBVvN24u9QnBHR+O2n/yP+ZVwZxhbZUgpYU15N6o4974kp
	 x3fR84zpbu+oXwhdJ4TQqVqKDdaxnIY3LoQcVZOuZ8kNFhExLh1LWrt5TPw5VuveXmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d59bM+Ww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C22606A31C;
	Wed, 18 Nov 2026 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d59bM+Ww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF011F000C4;
	Wed, 18 Nov 2026 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028544;
	bh=WNcD4kKMu/+ZVwgNEBH/RXCgjtFXY12ycCL8qL5dKtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d59bM+WwbajJ+vmTodfyURj8HWr45TIto892dj9cDaMeEp+SkRaCdq5zt4N4uWeN+
	 yH4dQ/MLZ+4w+mgAebjdiXhWvPEsazsjEI4jaOIxR/n3YdLzCUaycmweNfvUxbSQzi
	 6lSOR2Yoj+HDpGJnGg5I7FqlTF8OiVOj4WaVZ2pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0034/1756] apparmor: fix profile leak when a policy load fails
Date: Wed, 18 Nov 2026 15:36:01 +0100
Message-ID: <20261118150009.215376629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit ce94927fa4173fcc1eca27bdc65a140064c8f1e6 ]

The error paths of aa_replace_profiles() and aa_unpack() do not break
the refcount cycle between label and proxy. They just aa_put_profile()
the new profiles, which drops the label refcount from 2 to 1, and the
proxy keeps the profile alive. Every failed atomic policy load
(e.g. "profile can not be replaced", or a later profile in the blob
failing to unpack) leaks every new profile in the set, along with its
proxy, rules and its loaddata reference.

The leak is usually not visible from userspace, because the raw_data
directory for a failed load is not created, but it becomes visible
when the blob is deduplicated onto an existing loaddata, which then
keeps its policy/raw_data/<rev> directory forever.

Add aa_put_unpublished_profile(), which drops the profile's own proxy
before putting the profile, and use it on those error paths. The
proxy of an unpacked profile is always freshly allocated and not
referenced by anything else before the profile is published, so
putting it is safe.

Fixes: 637f688dc3dc ("apparmor: switch from profiles to using labels on contexts")
Cc: stable@vger.kernel.org
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
[ sashal: Adjusted helper insertion context to retain the existing non-const AUDIT_MODE() parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/policy.h | 20 ++++++++++++++++++++
 security/apparmor/policy.c         |  3 +++
 security/apparmor/policy_unpack.c  |  4 +++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index e85824c90f430..47199bead884b 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -382,6 +382,26 @@ static inline void aa_put_profile(struct aa_profile *p)
 		kref_put(&p->label.count.count, aa_label_kref);
 }
 
+/**
+ * aa_put_unpublished_profile - put a profile that was never made visible
+ * @p: profile  (MAYBE NULL)
+ *
+ * A newly allocated profile and its proxy reference each other
+ * (proxy->label holds a label refcount). That cycle is normally broken
+ * when the profile is replaced or removed, which redirects the proxy.
+ * A profile that is discarded before being added to the policy tree
+ * never goes through either path, so break the cycle here, otherwise
+ * the profile, its proxy and its rawdata are leaked.
+ */
+static inline void aa_put_unpublished_profile(struct aa_profile *p)
+{
+	if (p && p->label.proxy) {
+		aa_put_proxy(p->label.proxy);
+		p->label.proxy = NULL;
+	}
+	aa_put_profile(p);
+}
+
 static inline int AUDIT_MODE(struct aa_profile *profile)
 {
 	if (aa_g_audit != AUDIT_NORMAL)
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index c9ffb1eec7a7c..62345fad007c3 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1403,6 +1403,9 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	}
 	list_for_each_entry_safe(ent, tmp, &lh, list) {
 		list_del_init(&ent->list);
+		/* new was never added to the policy tree */
+		aa_put_unpublished_profile(ent->new);
+		ent->new = NULL;
 		aa_load_ent_free(ent);
 	}
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 61d7ef232f320..0928c064ee9f9 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1512,11 +1512,13 @@ int aa_unpack(struct aa_loaddata *udata, struct list_head *lh,
 
 fail_profile:
 	kfree(ns_name);
-	aa_put_profile(profile);
+	aa_put_unpublished_profile(profile);
 
 fail:
 	list_for_each_entry_safe(ent, tmp, lh, list) {
 		list_del_init(&ent->list);
+		aa_put_unpublished_profile(ent->new);
+		ent->new = NULL;
 		aa_load_ent_free(ent);
 	}
 
-- 
2.53.0



