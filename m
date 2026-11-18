Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022292;
	b=4fzp2BUAGjoI5pJTOoEB5N8FQliWORbnCEumzzn/lAuEj2FZORB+VNUYckRKAMTTUw0V
	 3d7/S7pxti0caVE4vEQA8ngy3LUQacUM4FS2RLgV2B0VZjXaB/DH6XW1ZPVuvXNqPhV0g
	 d66cezc+YPTJ/UpXUIeQ2DRCYmqm/E9oYKrAUp2o681/F59FdTtKXrLRtVdFErueRbLQR
	 O5j7pxWUV7LZp7c0AmhwPP4MqWZ7/H6jBhNQceX8qsEzzBPmeKyIqVBtFX7NH6pd7yJz8
	 SQbrXifmAClCkGoHKqsdep38+BMy4JDfxRvwj8WE9RXw6FdxlUN4PzMqGTEYYNfox9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9NYxp9Kf6YoKDmor0ZFo9uwurGM0rkFrEd69bRr7e5I=;
	b=lR7siKNA4qcmBG/yfShCDXMDUr2FHGODF1xzR8L2oiUdBOHYdX+V5kfRlU5IEFw9YyBL
	 mD7XXukpPpHaXFlGdRVF9qEqL7pXNu1Ta1MHI9XZ0egziKpIm3aEcgKkLVzabWdNTvRmR
	 bYfxmbrcA/LWbUPZ13ibduqRI0GpfxUKqfO6Ud1A5ZOp8VDwpJa1TdbLDIyq+sa6uN6ic
	 P8m6wc9Qlu0a9QGvkOy9/TSZytMMg65WSxCkt3t6QKsGpqmAPgyCp/g8h5KL0qH5nhD7w
	 HP22vUt8+PiC/YFwe13KvgcEFkN/dJK0QvIZV3SZ3WcNHoqvBJPwAlv/NvBGUkD6RmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Cgi6VYm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DEF606A320;
	Wed, 18 Nov 2026 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Cgi6VYm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8AE1F000C4;
	Wed, 18 Nov 2026 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022291;
	bh=9NYxp9Kf6YoKDmor0ZFo9uwurGM0rkFrEd69bRr7e5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Cgi6VYmNw0ATBrLkL9+hmVAnmYPLxDf6B6vKamVUJ2rMDffz0KOYPuak2v14cHHM
	 DVmuGIPTF/T59gnzAc1u2rd1a0vbKZ8DMUMIysMsNSe2pH0rODO6dh0LQA/5ZjKYyd
	 zgP4XuiTv6o+J19gJDrK/6Ky8gzpoxwlJ9VahMl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2609/2651] apparmor: fix table_size() integer overflow on 32 bit
Date: Wed, 18 Nov 2026 16:04:09 +0100
Message-ID: <20261118150418.180934479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 449195a4bb7d9c456c02b871eec6905edb449bd2 ]

table_size() checks ALIGN(sizeof(struct table_header) + len * el_size, 8)
in size_t, where @len is td_lolen, a u32 user-provided value from the
policy blob. On 32 bit kernels both operations can overflow.

Triggering this bug allows to:
 - overflow a 16 byte allocation with up to 4GiB of policy data
 - store the table header at address ZERO_SIZE_PTR (kvzalloc(0))

However, this bug requires CAP_MAC_ADMIN, only affects 32 bit kernels,
and the copy runs until the machine is destroyed, so it gives no
controllable primitive and is therefore not a security issue.

Compute the size with the checked helpers and return 0 when the result is
not representable, so the callers can reject the table. A valid table is
never 0 bytes, the header alone is 12.

64 bit kernels cannot overflow (these structs are 32 bit), and are hence
not affected.

Fixes: e06f75a6a2b4 ("AppArmor: dfa match engine")
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/match.h | 11 ++++++++++-
 security/apparmor/match.c         |  6 +++++-
 security/apparmor/policy_unpack.c |  5 +++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index f7bd7855f1bdf..66485f76d331e 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -12,6 +12,7 @@
 #define __AA_MATCH_H
 
 #include <linux/kref.h>
+#include <linux/overflow.h>
 
 #define DFA_NOMATCH			0
 #define DFA_START			1
@@ -120,7 +121,15 @@ struct aa_dfa {
 
 static inline size_t table_size(size_t len, size_t el_size)
 {
-	return ALIGN(sizeof(struct table_header) + len * el_size, 8);
+	size_t size;
+
+	/* Need check_*_overflow for 32 bit machines */
+	if (check_mul_overflow(len, el_size, &size) ||
+	    check_add_overflow(size, sizeof(struct table_header), &size) ||
+	    size > SIZE_MAX - 7)
+		return 0;
+
+	return ALIGN(size, 8);
 }
 
 #define aa_state_t unsigned int
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index ca30a4292c422..31b309043583e 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -58,7 +58,7 @@ static struct table_header *unpack_table(const char *blob, size_t bsize)
 	if (th.td_lolen == 0)
 		goto out;
 	tsize = table_size(th.td_lolen, th.td_flags);
-	if (bsize < tsize)
+	if (!tsize || bsize < tsize)
 		goto out;
 
 	table = kvzalloc(tsize, GFP_KERNEL);
@@ -281,6 +281,10 @@ static struct table_header *remap_data16_to_data32(struct table_header *old)
 	u32 i;
 
 	tsize = table_size(old->td_lolen, YYTD_DATA32);
+	if (!tsize) {
+		kvfree(old);
+		return NULL;
+	}
 	new = kvzalloc(tsize, GFP_KERNEL);
 	if (!new) {
 		kvfree(old);
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index a633f924948f2..35dfa3b451f39 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1053,6 +1053,11 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 		u16 tdflags = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_flags;
 		size_t tsize = table_size(noents, tdflags);
 
+		if (!tsize) {
+			*info = "invalid dfa flags table size";
+			error = -EPROTO;
+			goto fail;
+		}
 		pdb->dfa->tables[YYTD_ID_ACCEPT2] = kvzalloc(tsize, GFP_KERNEL);
 		if (!pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 			*info = "failed to alloc dfa flags table";
-- 
2.53.0



