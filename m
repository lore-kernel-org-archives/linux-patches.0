Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033323;
	b=ZzaVM5/UU47f94Kw1fK8Jj97VYTq+FHWOWDM34iV1X4pLzkM1w6MdWPkkdqJd7LjIeBt
	 0VdTGWmXF1O7QhAdOotbUkCDH47nlfmbT9gMUzUJtjPVDYGhRumHd0WADzVnO9QSQk55/
	 +04pCVg7GRKnkKGO4vcTrvcOq7e3D0yiK5F3IciT1WJiRq+nn5zHi4M0JZYHCAw1tSEfB
	 qgt8bw4OrjzGYJHQDz0EgKcstYzED7mygtATOWP/DTaH2Gv4Pb9ieu4/oox0A46JxAXS3
	 TjM/svR0Ypnkgi4s+iRi/cpW6LP8776uYqFzPWpXOkZQrzZLQbCGIgFOzsKjOfoToRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wAOJLMMB6IPE1JK28GbiZl6e5QJZF+YJzdOFHCqr3oo=;
	b=KNwVU1pVb66MfL/VycCAJuvnqrdnbkTc576KyEa5UU35+ICLopdXNv0EIWt9NbT9KqAz
	 pbtzyylNzrZjLmOetFzs24pE59rA2OrNegby5DsM2JChrjy2ISQsQMxHcWfurx4C/1yov
	 v+yzYSGkADVapEIJxIwdv/emMqMeUaDWG5RTewRPLNtAl03+ye5KcTYWkD4IQZzjOZBxt
	 XMW3QDXowN5tISCzCs3kYvvjpCEkiohsvxLHGAf/qWfdqy4hBesvDp6D0C/QjUoy+B+Te
	 fJYk514SWXNAJ3fpz8urR2FXoo/Kt4Amar7Hy7MHCZ7dWmJp/AwTm7rQRQFCHB8RGPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ds5eeR7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8F606A31C;
	Wed, 18 Nov 2026 20:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ds5eeR7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDA1F000C4;
	Wed, 18 Nov 2026 20:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033323;
	bh=wAOJLMMB6IPE1JK28GbiZl6e5QJZF+YJzdOFHCqr3oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ds5eeR7/x1c7+eLBE8D2nYGECjMqN/RDqqRFKWZXwO6yPPyzqP8ip6ulKhEsHS6Ay
	 fFnVsWgWQWp4nD8u07dvWHmvjSpXOvypQms//QQ7aLat2a8NQxohFRyMfUiDlVjG6d
	 jwxGeVUt/NdvkRSpLebzAR0Kdc5v+CPU6uwbx10M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 1727/1756] kernfs: avoid READ_ONCE() on a kgid_t in kernfs_new_node()
Date: Wed, 18 Nov 2026 16:04:14 +0100
Message-ID: <20261118150118.330320452@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit ef179363b04306dbc645c53207b9ad3516ebc75f upstream.

kernfs_new_node() reads the parent's gid with READ_ONCE(attrs->ia_gid).
That gid is a kgid_t, which is a struct.

On SMP alpha, READ_ONCE() ends by casting the value it loaded back to
the type of its argument. Here that is a cast from a struct to the same
struct. GCC accepts that as an extension, but ISO C does not allow a
cast to or from a struct type, so sparse warns:

  fs/kernfs/dir.c:751:31: sparse: sparse: cast to non-scalar
  fs/kernfs/dir.c:751:31: sparse: sparse: cast from non-scalar

Read the gid_t inside the kgid_t instead, and wrap it back up with
KGIDT_INIT(). This is still a single marked load of the same four bytes.

There is no functional change. With GCC 12 for alpha (the config from
the report) and GCC 14 for x86-64 (with and without KCSAN),
fs/kernfs/dir.o has the same object code before and after this change.

Fixes: 81bdc85b4c08 ("kernfs: fix up the unlocked attribute reads on the creation paths")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610261608.vItiXCGW-lkp@intel.com/
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261027143247.3537239-1-shakeel.butt@linux.dev
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -697,7 +697,7 @@ struct kernfs_node *kernfs_new_node(stru
 		struct kernfs_iattrs *attrs = READ_ONCE(parent->iattr);
 
 		if (attrs)
-			gid = READ_ONCE(attrs->ia_gid);
+			gid = KGIDT_INIT(READ_ONCE(attrs->ia_gid.val));
 
 		if (flags & KERNFS_DIR)
 			mode |= S_ISGID;


