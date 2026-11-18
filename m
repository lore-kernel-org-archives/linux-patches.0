Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058822;
	b=1vO4fRzT9fPlA7rbGTToUxZy+yhm6ojRMPQ+v50MtFNy+HLUVwhKyodylgYn4JNUGVsG
	 eUxTvYsV0tQvqXfmq/cFzarw7Kw7MFxehGz7r2N8AhDeA0BMXFFZOoJ8KA5t5UtvrtrS8
	 k9p5wxFS2WghkP2avrz1YO6mfs449waJ4c3+toSlBn+Zu6GiOZdGza9K0lRHtLNVmVk9A
	 yJEEwvRpIAR4jPdBJbwPwDhsCd2dfkJt0icHs+B8vALEtUJmJ+nOBclkde31TkdmDGbzU
	 MjbSTAGVYuuznFLkRAz3NjQcD9c0QCmAdNWAthIavOoPruZf4bHlVgEmYvxjCM7XiwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BUVtMjZoa4zpKOQEIewQ6c/GmGNSXvdLIvOOji/Dp9E=;
	b=gHf8iurS3oefX4S1iku5Oe49TG3mgNX+g8NCx4sicyqwYkJFa+Oq8G5zvO+bNXuXWWUz
	 B+s+AvKbPSFy+CIKoFpqSGmLf8F8i6fd/N6XEcJmXp+ydu1yT8aYSBnu0T3ii/6bnxpiD
	 QwJKln4ZT/POqjPZquMxHikIMjbAd2gyEJCSBch9p1Ji5Hy3obbXS7w0K90LrUt+mt94a
	 Z59CgpJ1H6N6rJbWGtr8x1u1v5dNJqL0ASofoCUtNpXtBTN9AeUPtTGkfq75ytlF81/yV
	 gX73g6Ks3EiUcPZhsolHKwSLdN1jhUfESTmS4P1ugZYotmx9ZbulZ6e4RCJ8ckmiIWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wkz7zGKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F93A606A32C;
	Thu, 19 Nov 2026 03:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wkz7zGKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862F81F000C4;
	Thu, 19 Nov 2026 03:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058822;
	bh=BUVtMjZoa4zpKOQEIewQ6c/GmGNSXvdLIvOOji/Dp9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wkz7zGKn1wLJxstimZ4PkDa7e7TzjePdEvBcOlJsENGjMtuCSJ9iDZzUlsDgAW/LI
	 tE84p6L4h8ki+qCWPE8JcmtBWPYRDkwJ+qTMpnzPtkyW75mG7swN3/2zBmTDSaZ716
	 TIe8BVWuVdpkhJbdVD98I3huLcLRJVtZZ+ICQi/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0581/1848] ceph: Fix mds session leak in __open_export_target_session()
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118145939.648799617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 6c80207392fdb86107d7acbdbf4c86cac38da1af ]

__open_export_target_session() holds a reference on the target session,
either from __ceph_lookup_mds_session() or from register_session(),
which the caller is expected to drop. When __open_session() fails, the
helper returns ERR_PTR(ret) without dropping that reference, leaking
one session reference on every open failure.

Drop the session reference before returning the error.

Cc: stable@vger.kernel.org
Fixes: b682c6d41bc2 ("ceph: switch to WARN_ON_ONCE in encode_supported_features()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 165a0ec892acc..75ce0a52ace27 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1433,8 +1433,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
 	if (session->s_state == CEPH_MDS_SESSION_NEW ||
 	    session->s_state == CEPH_MDS_SESSION_CLOSING) {
 		ret = __open_session(mdsc, session);
-		if (ret)
+		if (ret) {
+			ceph_put_mds_session(session);
 			return ERR_PTR(ret);
+		}
 	}
 
 	return session;
-- 
2.53.0



