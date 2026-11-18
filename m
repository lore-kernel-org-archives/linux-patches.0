Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027897;
	b=IF+L9rHRUkS3XssU7DsnmkSLTRmSAHZAM2jOGxpRtIq1ii7ks7LOyG6BLbmzMeg34kew
	 R5qCYRs9+yy3nuRo6NFb6P6tYHOZ7Qxh9Jx/w2oY+1VYLmNDaLuqmcg+bEBcXeayqGQT6
	 3b0v/ib/Izz+AYZ7A0KuWBMfYGkJdqrOQ4hY5fvh2DeSZOiaeInQpLGxIRH5j79gnhQhL
	 jpA6mFOI1SXLjfYuZK9GkQ5TlLYegStydsZ17vxSRCECmYzGYFJi2eZfl3Z6ds4l4Mhqa
	 Gc9Zw8FUBFt/yYB1gx3/b/ycAiPqpyGDcYhU3aKPbb/k/kxnClOzLVA9InCUvIWehtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ujFrcRmP1Bi4BNguPrD8r+0ApmRX8sni+dBWpgQHTK8=;
	b=E3pZkXrAhQnCmbhfuS2FtLPX0euSwtrdBnW8aM/+u+i9Ns4CC1zat3YG8Eb0teKXhCkq
	 C477lEsxdw2PzqycUST+GwQsjRCgx6DZ2AcLuUcze+pUrCPqjnHzegQJijhdPYalU18R5
	 qVt9miH6WYLp2Msz30oqLbd2FmlbeRw47haBCBx0zL+b6wsHVMdaPkVombD13xsXd/1fi
	 7SHuI3SdpeM5J592Bszyyxf2hnXAs7KgWe+1KtTKlvgsZ5BvQMy6G/Kng5Ka2s8e5GgBY
	 AGDcvDyMIodQTFt6Q3tFKrot9OhXXxm+QE6h2EYH1C3Uqeh8d4FBvY7c3pberGhlDZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7fVpgdl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA749606A31C;
	Wed, 18 Nov 2026 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7fVpgdl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6E61F000C4;
	Wed, 18 Nov 2026 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027897;
	bh=ujFrcRmP1Bi4BNguPrD8r+0ApmRX8sni+dBWpgQHTK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7fVpgdlCzHASvOJSFujJXEeUfA2AxMsqpx95TZoJhdX16XfA8r4qwHbn8kIW9OEi
	 TPbBrGU5cG27iLygNb34jsv2MJjkBhpual1aZGYtUFFT1EcSj4FAzub5DaXCHbN3nK
	 Lplc60CxWQajyCyHyGqVzUn3JWD/4V/yHBkRqFmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1950/2151] ceph: remove unused field `i_cap_migration_resv`
Date: Wed, 18 Nov 2026 16:01:25 +0100
Message-ID: <20261118150232.795602682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 71870f2f7d244..1bae521ad6d9f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -438,7 +438,6 @@ struct ceph_inode_info {
 	wait_queue_head_t i_cap_wq;      /* threads waiting on a capability */
 	unsigned long i_hold_caps_max; /* jiffies */
 	struct list_head i_cap_delay_list;  /* for delayed cap release to mds */
-	struct ceph_cap_reservation i_cap_migration_resv;
 	struct list_head i_cap_snaps;   /* snapped state pending flush to mds */
 	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
 						    dirty|flushing caps */
-- 
2.53.0



