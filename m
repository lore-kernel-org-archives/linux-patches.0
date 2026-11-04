Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831114;
	b=GGtAii4NMQqvRuTj5/d/LEDJXoyJ0royWQq8yM/qNhvp1lKJFr5UDWd1GSuaFy94NVBh
	 BV3CT4uB9A0fSWPX6LVdIQlncuFJqxzPMOJbyhTrpGtylUS8t55uBGHlL2FnTYDjpvHhz
	 fYZJO2eYGj4kJNL723Alp9SwlzQvBGoOcLW2mE9YB5lvc4zgY2bQhkxnGmcXq3nTyA1Ce
	 Axg4+LS3XFOAQfsUi5m102pE3rWLptoCX0dMvIPYJQAMD6prJ1gde5pUrcV6s3qiMbYf2
	 ZgVS4ImKoP5iSQ7VMUN5Dc11tx7I8PkUEg6sZ+PSL2kVPFDG/7XWePwZn9XI31hI1yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SKkGlUdULYF+5/RNUp1JpV/ezVYpT8MnXzBIc3EHsLA=;
	b=0tZE7kpSwZfowLMySd+WxMFdglvmW/ZoBThNbcLVzcMRkVyrDlCZRcEO9eETln2PYBHP
	 SZGzWL1c6YPhavJ9XymY7KfTsJ3f7FlZwsxelnd+B0zVuTHiYjBPYf0LYBHy/V4oiZxRO
	 elwZw2pBAF4GwpHT95iYFO5hv0+0blCIkJTguPQ6J9AtF0UMefs0e9lw3kYoRZTHc5ZY5
	 sS6BWvvJ+ElcLixw6lUUkNI6fVtyuZzrQv1fsHc4PLEXgw8NxhbleiYhoXA3sQGB35PzO
	 WCsGzQscE4fmAi0D5ycLo6I7neZ1fhPOPsfenQUY0QNkwuDMR1kNibKsfP/rXxyxXqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3qcxXqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB83606B2D8;
	Wed,  4 Nov 2026 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3qcxXqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9C41F000C1;
	Wed,  4 Nov 2026 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831113;
	bh=SKkGlUdULYF+5/RNUp1JpV/ezVYpT8MnXzBIc3EHsLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3qcxXqqrb0d0dX/yhpZZdmiuptl7OcuRh8HEIlLzo93uuyuVZZcEyukWNSqKZeRb
	 ujwRQOeB5ySBhMomuhhq6mHrzm/5drCFU12DWy63dqywugkyJeZ6l6X2VfGNx9fnTT
	 aie46KKg1Wqrarw8ZOHRa8cmaOzVp7RCN+gU0yn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0472/1005] ceph: fix use-after-dereference of NULL ci in __ceph_remove_cap()
Date: Wed,  4 Nov 2026 16:03:25 -0500
Message-ID: <20261104211057.231800092@linuxfoundation.org>
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

From: Xiubo Li <xiubo.li@clyso.com>

[ Upstream commit a354d7eaa1a57f1532c8072a424cc2d339a73cc0 ]

The NULL check for "ci" in __ceph_remove_cap() was dead code because
ci was dereferenced via &ci->netfs.inode before the check, and
cap->session was dereferenced via session->s_mdsc->fsc->client even
earlier.  On a double-remove, both cap->ci and cap->session are set
to NULL by the first call, so the second call would crash before
ever reaching the guard.

Move ci, session, cl, and inode initializations after the NULL check
so that the early-return actually works.

Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7f4bb62df3def..91cb305815cbd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1141,18 +1141,21 @@ int ceph_is_any_caps(struct inode *inode)
  */
 void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 {
-	struct ceph_mds_session *session = cap->session;
-	struct ceph_client *cl = session->s_mdsc->fsc->client;
-	struct ceph_inode_info *ci = cap->ci;
-	struct inode *inode = &ci->netfs.inode;
+	struct ceph_mds_session *session;
+	struct ceph_client *cl;
+	struct ceph_inode_info *ci;
+	struct inode *inode;
 	struct ceph_mds_client *mdsc;
 	int removed = 0;
 
 	/* 'ci' being NULL means the remove have already occurred */
-	if (!ci) {
-		doutc(cl, "inode is NULL\n");
+	ci = cap->ci;
+	if (!ci)
 		return;
-	}
+
+	session = cap->session;
+	cl = session->s_mdsc->fsc->client;
+	inode = &ci->netfs.inode;
 
 	lockdep_assert_held(&ci->i_ceph_lock);
 
-- 
2.53.0



