Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056866;
	b=v8FFiQUAU5p54R4IF/oKX6qbJOueR/r+l4W6HEPEhf6NT3QwOXCk59mll2k+YBkT+ZOR
	 5ReGMjKXAgIqhgso7sKKfrbpIIUD66omwpRCTh466D/WnYyHuzMFLsfI8n1OGWnfD8Lmt
	 JJW+HWqSbM8F41D1xdhrEvL0qE9/D056fwQQxxpsACNztkujpYlP8z/3l27Jp/6nAJZmS
	 ywEUOkrMkRRBi/rbow62dPjHPuQp2O6oFOgKMiAczYY5H7k/yzRVMzzCGfQegQF02yknr
	 xg0TG2J62Fj0rXrE87ymKvrdYl1v+jjbBbvkUziPfe67MFKh0SNoo//Tpmt2263ZlcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OO78OohUJo18kNXUpR7BZFtBLdw16VPXsYYmzpUwzt0=;
	b=q9ZKMqvtENdDnKzzJW03M1OAL8PHPng4jQvx9mjqODeql3rtMR0/j6vpfxuxhL0Jz6/t
	 SVN+lKGwW985JrML6Unwh46BWh7fVIpfstpF1OWNiub5Fjc+XesprZ8H8sISLw+m14N9y
	 9VTg7NcnYIyrE7UrPF6ER34FEPZ7SkljrdBG+XZkFVanDxLfV1sUU8CbRfiAr/xw/EAFi
	 Y11a689U4DYfun4TxGfz5Dp69uVlS02wE0+HTioUiZxy5+kZ9CRwXcRGwBv0ZH/wxbGHL
	 +p6h2dLay/mvZKrucMfOcUml+m6m1i8WbcukSIuTWdQ4OhZ6X50z2NXjejdBDgOs4jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/XI94d7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA2606A320;
	Thu, 19 Nov 2026 02:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/XI94d7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25B51F000C4;
	Thu, 19 Nov 2026 02:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056866;
	bh=OO78OohUJo18kNXUpR7BZFtBLdw16VPXsYYmzpUwzt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/XI94d7OeLBXKXCUzfbmJ6wRpozq4eC2g9Qsgbfkao4Tyu0eXzSs9ntLObLyf+WP
	 DAYd+OsYLWWmdjgCm9C/HFwGqrnP1h91hhRIR4GbJTdOYXYHKS5l+zOyt0CzTvS9Ul
	 0u+8gaeqKYKWElAYR68DGW9zFcbK6mdbYmTkkwac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2123/2214] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:03:19 +0100
Message-ID: <20261118150135.497108513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit a200e12135c96893f7c29bdf97f46868132f695d ]

This field was added 17 years ago by commit de57606c23afd ("ceph:
client types") but it was never used.

This reduces the size of `struct ceph_inode_info` by 8 bytes.

Fixes: de57606c23afd ("ceph: client types")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 5e07715b895d1..85c3543d22693 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -381,7 +381,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



