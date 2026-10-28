Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208195;
	b=RLGyY+WKEpyZ2GBLkwxMf0Ea2l+oIqjC9uc++Ja+Gb79dSJ9BQBH2+0D9cD5uGI3h9mw
	 T0/HboOMxc2MNQAeYH/E6GRiBpg5fR8cd+9BF3EWBj8ADYg3oVfOgpMjO5W6cAn07XKiU
	 XZ6Rk+30aYunhB8c6teWA/bYdciiKnPlYJMYY0UpnQA+HoJfFiL+cI99nSgEalILBTrER
	 uv1w0aLtePVDH8Rs9AeYj8sRSKpyiFq79yYNGoO+denttwX13l+x+CvrYHoxWXHT8HaNc
	 7/uGC5vfl1w0CDMvP3OmKNmw7pxndrkwo2nX/PukGS4u+o9Vf3xEtrtn7kPDRE2HTVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EBlrrL/1A5eDGEQTBAOXtXLKBWKZRIU4W19xOfG+Y8E=;
	b=2ogvf7kvL015CsFB2BPsh2t1Z3K1vLZfmFZXca/P98QjN6B5I1CideWmqKndyU3uKQe3
	 nQOQsJFHXgTuH5CtcHdkKIb0JSAXRIp6l/7HNZKY38Ie6rahnCbPy8neOrJG/7f8YvISN
	 bmXIY4n823igupj5QCAiL7MigO8E/eo7D0Jy5vUsC4eY4LZgiEW38dNOzXAfcxZa+QF3M
	 34GrHjpSI5R/ImFhpCBGWKKP1xOoYKqMXr2pibk6GOOzt1OFKnGTCxHNqpFvV1T23nFCo
	 AnpHkEHailtUOYWzL+MWNtM3KEDOKoSjcKxHB51Q9bK2+vTglbK6V6XscPtbMQ2EQoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENaWVvZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104DE606A327;
	Wed, 28 Oct 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENaWVvZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC2D1F01828;
	Wed, 28 Oct 2026 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208194;
	bh=EBlrrL/1A5eDGEQTBAOXtXLKBWKZRIU4W19xOfG+Y8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENaWVvZyQGA01MATTpnvfcg7arbAXd+BsGSyz7tMrMnFBUtQTbgK5wfrz7TOi3Fre
	 eX26Cqgnl/bewpdfobKD0RPMtri1invSDCYfjy40fKkrtL97og5depPxRBH/gGqGKi
	 VeSjSJLWTIEcwBdnytI7h7VSP7r2qJ+w4VEBL9SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/516] smb: client: reject userspace cifs.idmap descriptions
Date: Wed, 28 Oct 2026 17:53:05 +0100
Message-ID: <20261028170004.312812926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Aohan Mei <henrymei@tencent.com>

[ Upstream commit d9d7eeb0cea5b55b82888f443622fd8d4ee064f3 ]

cifs.idmap key descriptions carry authority-bearing fields (owner and
group SIDs and uid/gid values in "os:"/"gs:"/"oi:"/"gi:" form) that the
cifs.idmap upcall helper treats as kernel-originating inputs.  Unlike
its sibling cifs.spnego, the cifs.idmap key type has no vet_description
hook, so userspace can create keys of this type through
request_key(2)/add_key(2) and supply those fields without CIFS origin.
A request_key(2) call with a non-NULL callout then drives a root
usermodehelper upcall (/sbin/request-key -> cifs.idmap) that consumes
the unvetted description in root context.

Only accept cifs.idmap descriptions while CIFS is using its private
root_cred to request the key.  id_to_sid()/sid_to_id() already run
under override_creds(root_cred), so the kernel-originated path is
unaffected.

This mirrors commit 3da1fdf4efbc ("smb: client: reject userspace
cifs.spnego descriptions"), which applied the same restriction to
cifs.spnego.

Fixes: 4d79dba0e007 ("cifs: Add idmap key and related data structures and functions (try #17 repost)")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d7f08116c4d5f..97a1f73b1a825 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -108,8 +108,23 @@ cifs_idmap_key_destroy(struct key *key)
 		kfree(key->payload.data[0]);
 }
 
+static int
+cifs_idmap_key_vet_description(const char *description)
+{
+	/*
+	 * cifs.idmap descriptions are authority-bearing inputs to the
+	 * cifs.idmap upcall helper.  Only allow the kernel to create this
+	 * type of key using the private root_cred installed in
+	 * init_cifs_idmap; reject userspace request_key(2)/add_key(2).
+	 */
+	if (current_cred() != root_cred)
+		return -EPERM;
+	return 0;
+}
+
 static struct key_type cifs_idmap_key_type = {
 	.name        = "cifs.idmap",
+	.vet_description = cifs_idmap_key_vet_description,
 	.instantiate = cifs_idmap_key_instantiate,
 	.destroy     = cifs_idmap_key_destroy,
 	.describe    = user_describe,
-- 
2.53.0



