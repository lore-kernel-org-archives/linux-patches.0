Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037107;
	b=DDTw7/ZurnIDHOR/aJ44tM6qfIJbu9hWPJUwvZY5jfberZMqWIm3TuCrJQlxm9RYaAc9
	 arJspSpm3XZZT2/qpHffm/X67Ere8Eo44Ut8oeSKcccwUALaP5x4gi38KAoTYbsUedbAD
	 8V/hlAeNYSN3AXMBBze6QUW1n3B02vhnUf8+8dU9D1ZysQEZaXM6urVQq92o2kEXDL0QJ
	 PsGgReZDd0BCCY0POFRBTNxkF5HWCAIUXEiQmlB2U9DgLHUwhjJV3AxeDO2xG69m1juxT
	 wNS5DtTtuRbRHTs1/tdRGMK/FQ4z9aQu3ii4hPoJv7b2GXdiWoKbCi6J8geKU/BSJCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RS5l4IZW4KJz19tkp6N+R9Cbg8PCktSmguKM0VKc/xw=;
	b=bRl42AZ03otdaz5gwDDdY8yH0dQyN4lvZOyyW8XI7ig0dxLCi8Z2IgXDk4QE9DGRZr4a
	 IFRwhciq1lj+Xhn08HNlGf6BBjK1X+b5+/Jrt7xIGj2TPkYN9LqMYglWLIiiOI+1hKJa3
	 SEaPB/4wBq79R2YAQWN3Q5fvk8B+XWArZrNF1WY/FlySIFL+yeDVVJBHYn+hlWiWyIJIm
	 //Uka4yhIBLZiLY3o7Z8DmMwcmHqg9iqGovq8hPMlvQGbugoJTUgkJIaIA6W6tjGm+FMy
	 llv/Hd2kXsM/rBRH7CPYYppCnnkK2ZSsb0MP1S667sbxBd6Js/pgF8jdk8XeLz7RcNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9sy+9Dk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8517D606A31C;
	Wed, 18 Nov 2026 21:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9sy+9Dk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68C21F000C4;
	Wed, 18 Nov 2026 21:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037107;
	bh=RS5l4IZW4KJz19tkp6N+R9Cbg8PCktSmguKM0VKc/xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9sy+9Dk3APVJE/6MWL75xASHULeGhI0iTFDqbC9XM//1PRpdpkFaixi0Np69OHkE
	 neD1Nsr0PBnAwIEYtM+Fv+5VEv0vEppFN8gwKlgi4wFd9lhj91vwV6VdqPXa7z0tuD
	 pwSVlGxFg1XeA6Ppiaz31CzppvT5fInQl7AajRUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1289/3318] apparmor: remove fs entries created by a failed policy load
Date: Wed, 18 Nov 2026 15:31:51 +0100
Message-ID: <20261118150358.933421956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c7182c4192ab..a6ce3f29480fc 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1130,6 +1130,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	bool rawdata_created = false;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1269,6 +1270,7 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 			ent = NULL;
 			goto fail_lock;
 		}
+		rawdata_created = true;
 	}
 	list_for_each_entry(ent, &lh, list) {
 		if (!ent->old) {
@@ -1349,6 +1351,18 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



