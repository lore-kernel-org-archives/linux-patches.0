Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043966;
	b=WhPyOJIROzE2Ht/mVqwgsWApfB8C00sRfT5VWiT0gpJ+tzytPI5+igkKo0YZKG6m6A3u
	 KG980gaIFEUhBPWWdD92R9XVkDZeWlDgs1iz8xqOMIHocPcgxzSBKZDVfnlqBOYmAPODL
	 WxO0/P8iloJsMxJdlOxK5JO/HR4bhB2caGMHjm489vHMXBJj7z47ictFoTIMlz3Ehkkmr
	 BWFOQq/FD8MrrjOhf9E7pD7W3SRXSvboYnTYUTOmtug5BH/Wg/L+TQ3ha4dL9zSQE/3pk
	 4VOtDTOOPdEbq4Bc1ub4QPo6SNkebkCT8U15WccsHFievBPHBXr1SPzWykN7dFfNN1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FmhQr+RDh94lDpl3I9O6NUxdeHJ9n7bV/2rTOP07Ek0=;
	b=AF9wZ7PWEsT0jSbS5eiE2arCe0EdZNxH4PsRQWVPfIurWbeeH59n5DkeVQ9ZkdWOFAXh
	 b+lBA+RfcwPNJAsr4z06qwU0bl+BTMip6BEBFgP1bvKVlQDlFt/r2O4+eyyOGGWitmA9f
	 ZFP1q7llDT38p1bhP+fEoMx4PiaFh566s+hyMECgNxLpfMpDzsQ6cMBDbwK49xMGT75jn
	 KEwqv0B8jgRMNduM4tIRDbh0zJQKCz4It7FH63yXuOPhh5873mhbQSPLybsuhhS+0hxP8
	 VqDmvfKQp2AnjCUiugMI+wr5eOrBxQpay7uT02xmugGFhuhDJmf0trHi0QKKpg12gQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cm/LdcbA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B14606A320;
	Wed, 18 Nov 2026 23:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cm/LdcbA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF1D1F000C4;
	Wed, 18 Nov 2026 23:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043966;
	bh=FmhQr+RDh94lDpl3I9O6NUxdeHJ9n7bV/2rTOP07Ek0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm/LdcbAofsP3AlxkHaCRF2QYWvzfI/eiOrwOXtydb3qHexpBrI7gt3a62G0IIZYs
	 2mlkNFEopDyGJFCm1xUVuRNu+Jm30ZWk/4bWbU6ZL2v64eFISfEm5Kz3+yQj615k0S
	 K6RF/PX+YOBlfm9jneiVIxe4BVPNdEWGs7PttfyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0398/2857] smb: client: pin DFS superblock in iterator callback
Date: Wed, 18 Nov 2026 15:23:52 +0100
Message-ID: <20261118150215.722816450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d806d5a85dcbe2a0f181b2f0f9f61ddfbefa1818 ]

tcon_super_cb() stores a raw superblock pointer, but __cifs_get_super()
takes its active reference only after iterate_supers_type() has dropped
s_umount and its passive reference. Concurrent DFS automount expiry can
therefore free the superblock before cifs_sb_active() uses it.

A deterministic KASAN test reproduces the race as:

  BUG: KASAN: slab-use-after-free in cifs_sb_active+0x77/0x80

The same test passes with this change applied.

Take the active reference in the callback while iterate_supers_type()
still holds s_umount shared. cifs_put_tcp_super() remains the matching
release.

Fixes: bacd704a95ad ("cifs: handle prefix paths in reconnect")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Applied the fix to tcp_super_cb() and its tcp_super match condition, since tcon_super_cb() and its DFS matching logic don't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/misc.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index fb841235617c1..0dd57b5d6a0ab 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1379,8 +1379,14 @@ static void tcp_super_cb(struct super_block *sb, void *arg)
 
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (tcon->ses->server == server)
+	if (tcon->ses->server == server) {
+		/*
+		 * Take the active reference while iterate_supers_type() still
+		 * holds s_umount shared.
+		 */
+		cifs_sb_active(sb);
 		sd->sb = sb;
+	}
 }
 
 static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void *),
@@ -1396,15 +1402,8 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
 
 	for (; *fs_type; fs_type++) {
 		iterate_supers_type(*fs_type, f, &sd);
-		if (sd.sb) {
-			/*
-			 * Grab an active reference in order to prevent automounts (DFS links)
-			 * of expiring and then freeing up our cifs superblock pointer while
-			 * we're doing failover.
-			 */
-			cifs_sb_active(sd.sb);
+		if (sd.sb)
 			return sd.sb;
-		}
 	}
 	return ERR_PTR(-EINVAL);
 }
-- 
2.53.0



