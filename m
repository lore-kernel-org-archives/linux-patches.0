Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619323;
	b=Z4czvCfgtfWvPxafx3YbfDJXa35e7YT3jJlvmpVR4zj5AbtA/JBNJiTkre0Tw8cZN5ql
	 tzpRtPF6qa+03/wjxb4GiTenA6nQklUzL5l//iab7KOU915+asbL4RjRmlAxcZboh/e+l
	 vuLSMqVKyN/hwe+cGsuUSUfzWdU/KXx0JTePA4hgfJtWlmg+DOW4WgzAQ4nKVTzRl6vCd
	 2plxSvnqOL6OlHrMPDy5slE6KfF5iXlBVvhGYBISWHOdpu2k05dGHZfOzT49aLlOKc7gl
	 DDXGSQOyPESVH3o/oFdgKDlYJ+obzVNEJgWNe79ro8yyUNJsk29Z6obFgdQ2iUf9wqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RGebGP4nrZzG424WlkDGkv377jqsDWpVer9l8O//bxE=;
	b=AhhutM3UyE+OG+/EM2m5uWsdaFijcLCI1DfaqSnWmWmEsiQ3vsWRkWVLNrhi14PlDWsK
	 OEPlD76CEMIuxFlHLVIZp0NlSdn2cR0aGEKFfYTBNXj4qe04318KVUK0HSWU1I/ZruyDf
	 c0Rg6KnMwYUCO2rmz0PIHzfxJdQx3xQgtpgWs510wa5NDCDNtVB9Fs8eA06nCz51niUt8
	 11oRed3eIwpfNyEuxsl15iJLRIhPmHdSPxm6G9Bba/gvl80y2twA/VInSz6ZPv1djjKH0
	 E2RH4HcgTTZO2nG+eGspJJuItwYehXs863Fc6mKQy+zdwV8hyp+zWlpM8c+B53U6ZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MMP9/04h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47BD606A323;
	Wed, 25 Nov 2026 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMP9/04h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4501F000C4;
	Wed, 25 Nov 2026 15:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619323;
	bh=RGebGP4nrZzG424WlkDGkv377jqsDWpVer9l8O//bxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMP9/04h1s0NTmjWfAJkkf6j25Q1w0vi0TyfcZjMu/4goOmTs5rxhnvPijgOs1hCY
	 11vbnI7HjIAy/7BUyncljlHhHXVJYvSNCZKpb1mwx6oGjwssJuebit/FoBdeDT5Zat
	 OzV9gLS9LCiYcgvamDZp8RWYEMlqNSSqHVu4V1fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 0561/1005] KEYS: Expand key->{datalen,quotalen} to unsigned int
Date: Wed, 25 Nov 2026 15:31:39 +0100
Message-ID: <20261125143834.892157958@linuxfoundation.org>
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

commit 4a65eaf146f0d10ebaa88cfaef9c3b24f93766d9 upstream.

In key_alloc() and key_payload_reserve(), key->quotalen and key->datalen
can receive values larger than USHRT_MAX.

Example:

  keyctl new_session >/dev/null
  owner=$(keyctl newring owner @s)
  keeper=$(keyctl newring keeper @s)

  for ((i=0; i<16384; i++)); do
      key=$(keyctl add user "k$i" x "$keeper")
      keyctl link "$key" "$owner"
  done

  awk -v uid="$(id -u):" '$1 == uid {print $NF}' /proc/key-users
  keyctl clear "$owner"
  awk -v uid="$(id -u):" '$1 == uid {print $NF}' /proc/key-users

Because key->datalen wraps around 65535, the quota refunded upon clearing
is truncated, causing quota bytes to leak in /proc/key-users.

Change the types of key->datalen and key->quotalen from unsigned short to
unsigned int so that they can carry the full payload length without
truncation.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-2-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    6 +++---
 include/linux/key.h     |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -385,7 +385,7 @@ id_to_sid(unsigned int cid, uint sidtype
 		goto out_revert_creds;
 	} else if (sidkey->datalen < CIFS_SID_BASE_SIZE) {
 		rc = smb_EIO1(smb_eio_trace_malformed_sid_key, sidkey->datalen);
-		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%u)\n",
 			 __func__, sidkey->datalen);
 		goto invalidate_key;
 	}
@@ -403,7 +403,7 @@ id_to_sid(unsigned int cid, uint sidtype
 	if (ksid_size > sidkey->datalen) {
 		rc = smb_EIO2(smb_eio_trace_malformed_ksid_key,
 			      ksid_size, sidkey->datalen);
-		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu, ksid_size=%u)\n",
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%u, ksid_size=%u)\n",
 			 __func__, sidkey->datalen, ksid_size);
 		goto invalidate_key;
 	}
@@ -498,7 +498,7 @@ try_upcall_to_get_id:
 	 */
 	BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
 	if (sidkey->datalen != sizeof(uid_t)) {
-		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%u)\n",
 			 __func__, sidkey->datalen);
 		key_invalidate(sidkey);
 		goto out_key_put;
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -216,8 +216,8 @@ struct key {
 	kuid_t			uid;
 	kgid_t			gid;
 	key_perm_t		perm;		/* access permissions */
-	unsigned short		quotalen;	/* length added to quota */
-	unsigned short		datalen;	/* payload data length
+	unsigned int		quotalen;	/* length added to quota */
+	unsigned int		datalen;	/* payload data length
 						 * - may not match RCU dereferenced payload
 						 * - payload should contain own length
 						 */


