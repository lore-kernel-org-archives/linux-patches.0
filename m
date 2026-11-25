Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625965;
	b=HGqUyh8MnbdYsAagjhFmr0CSdzG893fW2WTvmkQ0Xq9xvB+hX4sBI5UJ43iVU9QeuaI9
	 sZTK7xCJwq8MTsKdUcURCBnTwA9PHYBSiRpj9SQhZy7fU96UKiTrA0wEGzvInPl8HZ1ZJ
	 z9SdEXT0UMkApjtFa4FOByDqmI5omo4u1+X1+a6Ped0vibxuQJG7NCeKLg0+4+zeIkjJL
	 a8QGVmYT6726f9l8SMNg1POAlPSSL2uAVTG40R5o7bduTji59X7AX+Mf4pKgjYV70EaZ3
	 c3DfKFcIM8l0Jk2trh6fD7Li6yZKuqv5ox0ru/AvnhF/hWJN3rEkasTfjd6mGF18lTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fDJEkc3d9G93nkEXY+P5i1/huyvxWWlzkhEpOiJo2UQ=;
	b=Kqp6wHdRiF5YwqHzQ3RTB4UBderp5rhqtKmLihuWk+x52fAc4vH2XLlBAjtm8QriRmvT
	 6/iZSbtpbdN6yTS+E2PuLe22VRO5L1tNJFNxoyRht4X6Zuvu7X+khPQ48mghl9doJ5+mU
	 Rq5wRfBnUWS51wRMsCPMs/oMysqACkqUockXxj6Mls5uRjWqklcRV+Zc95JHNXKCxNamA
	 TKfL79GEWxDB6uHQatRCQaNyrsM9dyOXGou0xfeBx0Jxs3+58HZ9hfJjlsgCB4UAHTuSD
	 I9Q+9FwzWok8y7iIof9APdkY3aEIX1HQ3+vpAA6ijCQC3JAqg54huiEEF5TPQz8ViNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dV1Jis34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8DE606A31E;
	Wed, 25 Nov 2026 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dV1Jis34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CBC1F000D3;
	Wed, 25 Nov 2026 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625965;
	bh=fDJEkc3d9G93nkEXY+P5i1/huyvxWWlzkhEpOiJo2UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dV1Jis34atOhP2jzU/mkc+Dh7vIOhdXnX5kWzne4VZm0Wpf7cHDvjpLknurz26Vjx
	 +nTonQYJRqnQXW6DJDOpIId7Z7jfdXjmBINQjYcWSmM7DgvHIEA/c7qbwXqblykEwg
	 1L+FQ9nJ9FCSWVRPUXNGO6ez3b25uwDgTU/s9WXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 686/816] smb: client: fix out-of-bounds read in dfs_parse_target_referral()
Date: Wed, 25 Nov 2026 15:37:14 +0100
Message-ID: <20261125143905.060881463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

commit 86aacc2f3f6ba18e1d87feee24f37c94b3ce863a upstream.

dfs_parse_target_referral() decides whether a prefix path remains after
the consumed part of full_path with:

	if (strlen(full_path) - ref->path_consumed)

strlen() returns size_t, so if path_consumed is larger than the length
of full_path, the subtraction wraps around to a huge non-zero value.
The branch is then taken, prepath is set to a pointer past the
terminating NUL of full_path, and *prepath reads out of bounds.

path_consumed can exceed strlen(full_path) when the mount charset is
not utf8.  The referral code derives path_consumed from the canonical
path, which is in the DFS cache charset (utf8), but it is applied here
to full_path, which is in the mount charset.  Each non-ASCII character
in the consumed part of the path that is longer in utf8 than in the
mount charset makes the count too large by the difference.

This was reproduced with iocharset=iso8859-1 against a Samba DFS root
containing a link named "café", mounting with the single Latin-1 byte
0xe9 in the path.  On an unmodified tree such a mount fails earlier
with -ENOENT because the path is converted to utf8 twice in
setup_dfs_ref(); with that fixed ("smb: client: fix double conversion
of DFS path in setup_dfs_ref()"), the mount reaches this code.
full_path was 29 bytes while path_consumed was 30:

  BUG: KASAN: slab-out-of-bounds in dfs_parse_target_referral+0x26a/0x270
  Read of size 1 at addr ffff88810db89d5f by task mount/1743
  ...
  The buggy address is located 0 bytes to the right of
   allocated 31-byte region [ffff88810db89d40, ffff88810db89d5f)

Compare path_consumed against the string length instead of subtracting,
so that no prefix path is used when the consumed count covers the whole
string.  With the bounds check in place the same mount succeeds and no
KASAN report is produced.

This only prevents the out-of-bounds access.  path_consumed is still in
the wrong units, so a non-ASCII link followed by a path component can
still produce a wrong prefix path.  That needs a separate fix.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -31,7 +31,7 @@ int dfs_parse_target_referral(const char
 	if (WARN_ON_ONCE(!ref->node_name || ref->path_consumed < 0))
 		return -EINVAL;
 
-	if (strlen(full_path) - ref->path_consumed) {
+	if ((size_t)ref->path_consumed < strlen(full_path)) {
 		prepath = full_path + ref->path_consumed;
 		/* skip initial delimiter */
 		if (*prepath == '/' || *prepath == '\\')


