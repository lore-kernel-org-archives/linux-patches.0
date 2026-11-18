Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034437;
	b=0s8CwBbkiCB3JAX8gTqPavTAPq/2wk+k/K9bjXm/w0luxuUinTgdaenpFTlnnFpPPSbk
	 x6FJ3uP97oVsGnRyNGRqPMJ6FHN/IVIjCgrjgMX6uHmUv91a/O2wxberhspL89o7W083X
	 cg2sJOYZXTeWazgqdGrwcLX6uaDwkI2/ysDDaLIQYe8T+iocLKwYB8wCRQFfrn3B6qiPF
	 nvsXDkhdcrZooEoFC7v0gGz6XNDkmeeaBSU3c3AS8nVdRlJIKQ8qb8Y0AzAP+XbhViYEO
	 zzdJWvuu7X1R0aJvj1ywNIAgoDiLhMQg8ly4UATkWLX9OeLuT7bbi7CeV8nrNLAVNvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEkK4Iy2YUj0GGGRurdubCSgh1/b0QphRHgAuXDQq4s=;
	b=tV1X07+MkvYKS9FvwiRy0K/wWyMDir4SLPKsr2NE2XZHE4zGVGfizqCiszlLYhLf/VeW
	 jelDZFcM00vM/0t9EdHrol6aH7hYdf9R+P5cqCXCPc58CzzVOfPwDFU1nhG/qiLIAMJ7p
	 iraD24l7llmtMAvfRhXKl3uqFCsqgxAkXgGZP3cBMX0V3C4S1oIh6MUxcYBIWVEOl+LYs
	 f9l7a2Qs3QJUlOQkKOpbpAMrZcnFn8mXsEsVPihuSVmdmI5Tl98PbKFCKHfzOvWgyxLr5
	 qCDhL8XMOTkLKft76RKM8XGE1PgI+rst28NGC1o53oucFvjBWhforlWlpFXMPpvNZgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZF7CGU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF9F606A31C;
	Wed, 18 Nov 2026 20:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZF7CGU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05801F000C4;
	Wed, 18 Nov 2026 20:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034437;
	bh=IEkK4Iy2YUj0GGGRurdubCSgh1/b0QphRHgAuXDQq4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZF7CGU7b9OIBRL95XVP3vW5QfRBm30FsBpIrmFOkOHxtG12+d2M3P1kWkGhrx45K
	 7PRVqD0b9sJht8PAwVGL/dOMKgenWJORFUj/BR7/+4aWgUJyju+L1Y755eI+J8vMjb
	 X7uf60S823Z+qOB4IcbNXHQ//bJP1TtEfmyRIUAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0332/3318] ceph: fix use-after-dereference of NULL ci in __ceph_remove_cap()
Date: Wed, 18 Nov 2026 15:15:54 +0100
Message-ID: <20261118150325.891751611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4688ae99c8ef6..ee80fe4c0266a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1133,18 +1133,21 @@ int ceph_is_any_caps(struct inode *inode)
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



