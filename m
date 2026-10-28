Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210478;
	b=JZvmR7GZeK9BmvPAnIgokXeEW9YsY6efUhip4D6zu1M6a260p7VMWgl54OzlIz9w9Zh7
	 EPNBbSdR1yOKFSPR1LKzaAx2VUTbVJSCLp2Cw6X0vU9v3XYO388tHp2VY2QqiDnPvzIG2
	 es5QnulFV4r97kRovTUjOxfvEV5p1Gzbh3FWOX+ZALPGdGZPmUCvQrOVkjU/bISGsye6L
	 VjC3N5jKFMou4rj4m+E1Q9vL9SbriE/BkRa7Dt2ZkNKEHpKXU2vXJ7SlRmEhpkiDNeqgt
	 X/a8NjlG1CSDdq9T+gHGH38/VZMwzqcjAuBHIMSqfGX/vk7QPngNbF9X/VPEeeAkihA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZP8vaK09ae9qmKiVyxv6DtlvYfZkUkZrJl/CRyPQ9Y=;
	b=ncP5dTmOYf4bnH7VlCJJXrcIttK4WDueC9NQFym+l4ARQD9JKbb/vwHOlix9IzeG4aHW
	 jlHtOhU4IRNx2I6SAfwOTR0fJxTM/F5wGJMEylZy7QvCrLNvWLW+JNRtZS1aZlLMXiAjb
	 yX6dv84s4framo/2PPSAOJW7XzrlFdC6FZSeasv0Dn0OqUgmRDgab05sbTLJVBDnZ5tNK
	 kCNdL+bzRHDmTRVwbW2/re/w8tvcBqC1Z3f/P4tCTK797s+aQZMPKCz29MD3HoF02fYxh
	 91sESueynEM7I4qaHtGKw17AkjcCG4GNtnsPz3lwdqdYdVkrCwXv6yLb6iyQSBjr3nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxbRjkyG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42546606A325;
	Wed, 28 Oct 2026 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxbRjkyG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFEE1F01825;
	Wed, 28 Oct 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210478;
	bh=eZP8vaK09ae9qmKiVyxv6DtlvYfZkUkZrJl/CRyPQ9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxbRjkyGR4p5bhcPiwhhv7wwg9o+7FYBHA1a63tYchbOIXIOfPGFU+6PG/hMcRgVI
	 YNMyh831NAJVcCBWklGmJpprThe2e8r1PEpZAb3a4SY0TaxKpTWKHtHnUUWT3I82cx
	 BQK3iCdyj4gN8KY0JDfDAYWym0TowjDK+lPKmw6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/571] smb: client: reject userspace cifs.idmap descriptions
Date: Wed, 28 Oct 2026 17:53:00 +0100
Message-ID: <20261028170008.809659531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 3872bef8c063a..19d2d68706ad0 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -96,8 +96,23 @@ cifs_idmap_key_destroy(struct key *key)
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



