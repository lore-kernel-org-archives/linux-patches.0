Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831955;
	b=XDpyHDvLGbu8HyPF/7o81bzErajunjSpq8mOI62WwPMCoEW1C48V7+jbUT71LXBEPsux
	 2TqAIcFV/duq1gRoYBKM26ABw8fSnjmWa2Ck8ShZDxWVLwGdr3G+nyRPXEDLDzHfinERI
	 U0UnV6MB1irkqEcu0ANLrcNB20Ii+HTJj15VszwovciW+CJsUp+wlFCxivw8lthCvTrK8
	 p7I8Bs+3uVCqiMZnOBzLaypFT67hpStGhfJDOeN4/+3TO8/GwUt6UP2j0hKX5/umPOjWL
	 rG0VgONbzRBmQYTiJsdnvbuKllabk2ecVhACs8b4CvyocRV6OKkDZsg9Kcmzg0Rk70g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OJ9nbU9mKCkfb0N0FFvJ1wX8D/7MVn2fPQzrkYAVPjc=;
	b=u99exlJOFwOgNxVT2tCJqo8qAoe0ie6rZCY34q1GKa5rEf52faeminzK+v4lt5TeQdNZ
	 rp4+jqkVD6TEoHsNoQ/iDLfk5fNPhByJmIHumcOcVgBxFa/R+xw1DCPhmk3KeRsJToyW/
	 AWgQEd5Utx1AJuGLz+m7plgw3EznS5ehPjUwglD1jcFkWV4bG2NrqInL7EVbKmQx2g4IC
	 TZlYMRDELYuLpEe9ey6r4HzoDW5GOtjDUGJNWp8Kc1P0CYBfaPelp6I1i9z050pV/Spfg
	 kjRlAf0tvjID2ff6XXPzvVNgn1UEBUfUbxr5kUwW8WB03bJ0b9SqPLUxscUvwM3n6rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzqA0A6G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CBC606A326;
	Wed,  4 Nov 2026 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzqA0A6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A8F1F00919;
	Wed,  4 Nov 2026 22:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831954;
	bh=OJ9nbU9mKCkfb0N0FFvJ1wX8D/7MVn2fPQzrkYAVPjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzqA0A6G6TmTBIEJCzEq77WQ6HpIlVYqEYO2Yq0ifOt9djvhveuWAYQ9xX7+JYTRi
	 msd4KPybfKhKtnHUPqQ7wBn448IBoksyxc3bk2KorND9WRxsKBRgrK864JyFYntIqG
	 aPj4DuVLaSXkvlBVn3dLCxmgE6s4uPzfyOo4o6P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zachariah Mithani (AploSec)" <zachariah@aplosai.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0988/1005] ksmbd: prevent share root removal through empty paths
Date: Wed,  4 Nov 2026 16:12:01 -0500
Message-ID: <20261104211110.713843642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9fd1fcbbf84986a7bcf601a2b90540899069d263 ]

A FileLinkInformation request can supply "/" as the new link name.
smb2_get_name() strips the trailing slash and passes an empty string to
ksmbd_vfs_kern_path_start_removing().

ksmbd_vfs_path_lookup() resolves an empty pathname as the configured share
path, without LOOKUP_BENEATH. With ReplaceIfExists set, smb2_create_link()
can therefore remove the share root from its parent before link creation
fails. An authenticated client with a writable share and DELETE access to
a file can trigger this if the share root is empty and the mapped user
has write and search permission on its parent directory.

Return -EINVAL for empty pathnames when for_remove is set, before
resolving the share path or acquiring removal resources. Ordinary lookups
continue to accept empty pathnames for opening the share root.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Cc: stable@vger.kernel.org
Reported-by: Zachariah Mithani (AploSec) <zachariah@aplosai.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Replaced for_remove with the existing do_lock parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -78,6 +78,10 @@ static int ksmbd_vfs_path_lookup(struct
 	struct dentry *d;
 
 	if (pathname[0] == '\0') {
+		/* The share root must never be removed. */
+		if (do_lock)
+			return -EINVAL;
+
 		pathname = share_conf->path;
 		root_share_path = NULL;
 	} else {


