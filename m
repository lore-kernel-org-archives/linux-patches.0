Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021850;
	b=fCY7mHMK4/5lswqQCiM7uNh1kzPEXQpHYcMX887xGxD6J3BpCFwps2cR1RWDtUvS07RK
	 H0Eow/DMduSv9KCtlorL9A/MIGu7ly2bYqvnPJmapZEwgCKSnM4709L8J3ODNmRMlU+MW
	 vd2Tb+Hy8ZV1uN0+V+mHXzA3fmmEssCcq+jXyo7+nsz+lSy4n9a6vcpKj1JIGDflZZ/Jw
	 FK17rEGWxx+ae52i3lVbw56M/Ss6S3ONJC2kJaikuVtT1dPiZlQpYCq2R2zmSkcAvJds2
	 UKcEFxdlQoBUkgDB7Y6vHIPF5+yYRruA/ftJ0BOkX9LLqKL8z035cJIYrusA6LT3JAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n6JUENAya67jGlF6dOAPDF8vDxduB4vL75lmkn0NqAU=;
	b=BBL27yofVwCr9Dby3TCAW8K/N2iCRIzDPxYh80eXtlIClYb+BKSsoTcw7x4ZtkRY1xRx
	 iJHZQRd4QE4t16D4ZNCwyjOYyAEr2wKKAmN3P+yo46GlHjD/lVQFl0wq60wLu58k9in5i
	 tIj6DUFFYLNx9NXGWF7DJkN9/KPu7W43uBXl5m4RjmTWgzIuTcmiCnt8e1VneMbaac1LZ
	 roXNaumJEZoPGurGIaaaoj8uRGsYX9LgnLt4Fh7FQFsp4LWqxCF5y7fDk0iIlOydbZOdd
	 Oubb/BVFl/r2/gArrIDQZ98kYmGEzDyV4ZpqEd21fqnjCKKmEXi0xFDcULBI88JJlRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jd+R8vV5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBA606A31C;
	Wed, 18 Nov 2026 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jd+R8vV5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD3D1F000C4;
	Wed, 18 Nov 2026 17:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021849;
	bh=n6JUENAya67jGlF6dOAPDF8vDxduB4vL75lmkn0NqAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jd+R8vV5ySQZdLg3ImTDaUelsWKCgrJ+w+m9omG1hESrOnGdmCbYy779HDhlNUJQ/
	 hi8FKiboYBf+Jv4JnF/+Y1EapzeFblvGVTek+Mfcmlf6PXLYka1S8Oce9wimxGM9Rj
	 DBvj/GmucJtrKPT2DpnzvBt1RiVX+A4XFos1Ku+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2412/2651] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:00:52 +0100
Message-ID: <20261118150412.132839875@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 72d4e30304dca..1c91e73a63aca 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -463,7 +463,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



