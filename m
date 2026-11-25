Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619330;
	b=VodlQfVbWrDZGA9wyObA+3WMt5bCHi2EKlnXvn4NPyPeGcG18WGX0TTiII1fQd+b0Cmr
	 67YcoH/b2qKbHNXUUKWURLLPGcuCa44ux8me9nkg14dM8wtEOnT7qTaL1m+qzr4A24Qlq
	 B+JtNkBXTKH26KEMjmZKp3rh7oRNXWQxq3BWaoImfDVPEuQrxvTnEBKVAscShbfwlcJYt
	 rbt34bGd+fzyTYLCt6XRx6BecVbCW1duPAxArA55PCSRJFuK5aNJKIrT0dCPsFelkYBx9
	 exQzlQo5ffoSzwcCbhzzYWDcXduNBxI5pk0CgpCIL8cBm/px7yf4AIpOnQQWF6VdDDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XQ089ZUluFhcNXSd8QE6ULxVYkELz9Bd7PjIkSBNsh0=;
	b=XtH1FzENH4uw6AGDJTLcfc7avppjnWTure5YdWKfwl0ubaR4Wh3XzSnI+dD9lSYSVzEZ
	 LTgokdbsPvcozSX15x7+mYrvIpw7+HNr/zWfYERe9APE7f3Aub0f9pS7/Baw1sEnzDn/1
	 wORGl1Qy3MlRFTnm+8K03gWElk2SgactkxL5NLdWpY6UIpatU91wdcStwhlnI/mWYu71N
	 zH+KWZiMoTYXscXT3egv0DkASNfL5vigsksgykmpa9dbHYw+s4B7vIUwEDDdw84i6UTGc
	 JudDUYgxlkoXSqaqy0ZMD6aRotFJTWRr2f3NAWc4X5Ay2yREpGa4OcSFGqHhORbMngA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvDLSDMi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DAD606A321;
	Wed, 25 Nov 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvDLSDMi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615671F000C6;
	Wed, 25 Nov 2026 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619329;
	bh=XQ089ZUluFhcNXSd8QE6ULxVYkELz9Bd7PjIkSBNsh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvDLSDMiQX7ZscikvG5zd7vo7b5tk46sCHReteJeZrg+AoFMDWzl/xnkdVO5r9mWq
	 JzyGiF2+g/eOMib55+h2gWc/p6ChtrcWqisIYMV3jTcRKswOB1ZJdd8PfhSUazdciN
	 UTgH6jd9jTBJTjM10SOXubwYIXxKBnE/RWzZOCjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 0563/1005] KEYS: Verify the key identity in __key_unlink_begin
Date: Wed, 25 Nov 2026 15:31:41 +0100
Message-ID: <20261125143834.940498287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 7a7f70ff7b26519c98b339a3e0cd9ee3c8d17f77 upstream.

When two keys have identical type and description, linking the second key
replaces the first in a keyring. However, attempting to unlink the first
key (no longer in the keyring) unlinks the second key.

This happens because __key_unlink_begin() calls assoc_array_delete() with
&key->index_key, matching only on type and description rather than the
key's identity.

Example:

  keyctl new_session >/dev/null
  keyctl newring ring_a @s
  keyctl newring ring_b @s
  A=$(keyctl add user A ss %:ring_a)
  B=$(keyctl add user A qq %:ring_b)
  keyctl newring R @s
  keyctl link $A %:R
  keyctl link $B %:R
  keyctl unlink $A %:R
  keyctl show

Verify the key identity before unlinking, and return -ENOENT on mismatch,
instead of unlinking the key with the wrong identity.

Cc: stable@vger.kernel.org
Fixes: b2a4df200d57 ("KEYS: Expand the capacity of a keyring")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-4-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1506,9 +1506,15 @@ static int __key_unlink_begin(struct key
 			      struct assoc_array_edit **_edit)
 {
 	struct assoc_array_edit *edit;
+	const void *object;
 
 	BUG_ON(*_edit != NULL);
 
+	object = assoc_array_find(&keyring->keys, &keyring_assoc_array_ops,
+				  &key->index_key);
+	if (!object || keyring_ptr_to_key(object) != key)
+		return -ENOENT;
+
 	edit = assoc_array_delete(&keyring->keys, &keyring_assoc_array_ops,
 				  &key->index_key);
 	if (IS_ERR(edit))


