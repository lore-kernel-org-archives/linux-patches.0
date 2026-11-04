Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829317;
	b=cb6D+Hsls3A4JNRrCTAHghmt1IfTXypq7s/W2sckSy1Gr0+IA34GncFHR0rsPFJqlOvE
	 6PNrGPys/s7lg1mMNvj89n9nK2lMdBzJAFyH98l+SUtZ3yg4pvCKX2Vti5seCulSOhKK2
	 0vmUsg7p3BU9Xhp2GYJbkHb3MvyXyOkqBfnZFKDhoXaQWdAySDjGDArfLu5k9ifr2e8SL
	 naAiZA1KBgAIsl1sxF3cUlUeQkvVZuFKMNggGmsI0+//24dJMyJ3FTEOUukOLvX/3gQbm
	 9uUfJek4ld3gAcJxzs0b2PaDI4UTHagRFPlcWL373s8IbuA+SzVe3SR/7PfVs25wPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YrJFtaxmRupOIdkBqg7gOVvEr+1BOMra2JGx292nUPc=;
	b=2Qok9uP3ocG63tYyXfyD0kSwpPCwXf7b+lQiDVrp5ww0V5+OaaJ8DP27TI8Sn0ISasEW
	 4+6bR5VuOuXYPiFHXoaO0FIV9HGeh+VN/Sef/z0DgaoiG8EhckQzFZrvJ1F92yz8vD/dK
	 dsAABvMsZM4Q+BsfH/OyjnFAJtZoePEDteDkl2Iq0BtK12TQb0rpdFU4xTqjpVkulTC16
	 NGqubR0MBaxfyyZlYc19aCK40sfsDw4dGWA8P67ZYnX2sRCoBwcOACfrbgTMAvoHMQw8r
	 CMxMR1+1cciHJ2t+FaeHSu8SletH8BFUNux+wUAplMMKlsoM0tfvtmDTe8lNgrOOe4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCdhaMcN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F016074917;
	Wed,  4 Nov 2026 21:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCdhaMcN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B431F000C1;
	Wed,  4 Nov 2026 21:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829317;
	bh=YrJFtaxmRupOIdkBqg7gOVvEr+1BOMra2JGx292nUPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCdhaMcNhK0ffZ2HUiyqyq66bQMGSoGO5kXjq6VdiKNyB5ZINcKTdbcT0GQsfzKwL
	 5xYDJMbqH1sa+7X7IlWexy6RQ22d4e2tfMz11NFJmTRCrFkpHFEyBAfU5FOyOK73hC
	 m6oDbruN9fpI62wSpkEnd3FyXmvMvQUZ/2b+xQgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0048/1005] fs/namespace: notify pollers of legacy propagation changes
Date: Wed,  4 Nov 2026 15:56:21 -0500
Message-ID: <20261104211044.933696869@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 0ae44a20835e5cf37d03a83e70c92e92deda3703 ]

Changing mount propagation through the legacy mount API changes
user-visible mountinfo contents, including the shared: and master:
optional fields.

The mount_setattr() path already touches the mount namespace after
change_mnt_propagation(), so pollers of /proc/<pid>/mountinfo are woken
when the namespace event changes.

The legacy mount --make-* path also changes propagation through
change_mnt_propagation(), and MOVE_MOUNT_SET_GROUP updates the
propagation relationship of the target mount. Both paths currently
return without touching the affected mount namespace.

As a result, userspace polling /proc/<pid>/mountinfo can miss these
propagation-only changes even though mountinfo has changed.

A simple reproducer that polls /proc/self/mountinfo while changing
propagation shows the inconsistency.

Before this change:

  legacy MS_SHARED: poll ret=0 revents=0x0
  mount_setattr MS_SHARED: poll ret=1 revents=0xa

After this change:

  legacy MS_SHARED: poll ret=1 revents=0xa
  mount_setattr MS_SHARED: poll ret=1 revents=0xa

Fix this by touching the affected mount namespace after successful
propagation changes in do_change_type() and do_set_group().

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Link: https://patch.msgid.link/20260601032911.940507-1-guopeng.zhang@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3b6d7271eb3d1..ab050a939cb53 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2932,6 +2932,9 @@ static int do_change_type(const struct path *path, int ms_flags)
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
 
+	guard(mount_locked_reader)();
+	touch_mnt_namespace(mnt->mnt_ns);
+
 	return 0;
 }
 
@@ -3414,6 +3417,10 @@ static int do_set_group(const struct path *from_path, const struct path *to_path
 		list_add(&to->mnt_share, &from->mnt_share);
 		set_mnt_shared(to);
 	}
+
+	guard(mount_locked_reader)();
+	touch_mnt_namespace(to->mnt_ns);
+
 	return 0;
 }
 
-- 
2.53.0



