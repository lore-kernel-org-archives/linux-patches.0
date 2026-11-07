Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061075;
	b=Rv/aKAKZs6gIgF746KlfVO/eNEW5Po7GsFD2u0MY/c1hNnbSp9NwQRgL8U0zWMe7N9ll
	 wAxGnlmp4c3fov0ZSA4BenriawUsecFIRWLeyS4bMe/EQsP8S2GTN3qJeIFDSHruwDN5S
	 WhuZYEWS6fV9vLQUji9CBVF8/KUIOeYSAOoMA7DJuEGSmuHzZXN0gG4olQxGN3IMyfkdc
	 8m0j3/xw6EEXVtTNfBwdyyucvmOXmsybnv6BUTaa2Z+sdqZIFp+VupYp0UwWtIxSZWL7R
	 IB4DQfB08r721DrvAzXRsnIk2irihLw/R8UoYVw9ca8vKxvDRiRahND63YQmlLREFNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dhg5Pg0FZqsY8QgVpL/Oh84FZNvYeqAejPu3soO83qo=;
	b=Jbc9ArbR0MFS4/fO7TtUcoO2hnvURz4cXKnedbiqvaY7lPHEpVYKFPh4dFj6bgRsa7a7
	 hlluwzHlgeLlXLCiTtyozWMm2Ce/1w413Xta17TxR9bhUQ6ezZN0QQFtw91WNOb+Z5fT1
	 QDFfwA3kLRPSdNr/iZaAcaLi63JzUA/k/wh2qyNXx9oO9vKkh+IG8EysG2vjiiKDI/sRp
	 EQTfQlvsZTfXyZzd49/B+7i3dHXQwj0xqs0AgJpZ7zRYcJoxwaPJZElBk+f6Ad8/gASJl
	 TRMfY3nP7h4Zw26tKD+wLv8ANPSONtr2+HcZw0nwPWQmb5NmNr4FYAPgRUxHkmX7kXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N5dqw/Ih";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB84606A33A;
	Sat,  7 Nov 2026 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5dqw/Ih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB8A1F0089F;
	Sat,  7 Nov 2026 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061075;
	bh=Dhg5Pg0FZqsY8QgVpL/Oh84FZNvYeqAejPu3soO83qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5dqw/IhGNnQAnhmNQCOoUPoMUryVae7m2Wmyvg0tGqjuSXVDDIssMcNl9tN6lTXj
	 dp4t41QivWBy4tUv1bthf7rUxnjfDVDdCVa6WwW2DtUgt0Tx5YsuWQCmR+FVZWlo3M
	 xI7Y74Cck9LjTeU5scT/bvuFT7VC9mcEEDCzhs6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0400/1536] ceph: fix use-after-dereference of NULL ci in __ceph_remove_cap()
Date: Sat,  7 Nov 2026 08:40:16 -0500
Message-ID: <20261107135008.823664653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index c69321bf06a6d..e580a330d33fa 100644
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



