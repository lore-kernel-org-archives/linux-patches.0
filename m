Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021370;
	b=Fa9M+UEWomLP11qAzNTKNA6bTN68CHlPveV/ud1Cm0/WTTl+AKJvEVV6R1uv/u2QTdiO
	 33ts7ZEiV1aEOogWU0ElIRiyV+HnZ3k/vUlzVNCAXd87YtRz7pXCaAujGB4kJYsmbtpBP
	 Ybx2Zlzraj1nOFD2EF7Gq8xbDqWq4LwLj93Z/g2ncS9ifRrAFlUykatQb2ftx0eiiLfTv
	 AEsS5Ydp+H5ylylQdZsEKlSwNZfvcIcwjyTUk/CWdgFDJBGuxxUHlWvK9RQ6HEKHxwYmJ
	 6YKUMvl9Dz18m4RgvrJlrCa9R6Fmf3yPgpxnbjf0JipY0158MgAWknrQeRThtzS9Wag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJZIlPJ9iViDYvtFxK31PdCKL7TZPQOuZFpULpkxBMQ=;
	b=mQ0xe3Cz1EIRKrQvW5mO4LOAJznd8oWAfApPLyYtbX5GgfyhIsjjSNkx5MuFYvFkDErl
	 YAdlGBVxdUd+EiPI27njtJGuqQ8oUFGWBWKiuWNqKZeAuirNhl+til6q/h/WW40xkhlq8
	 SmOuTEVY1n2ImFcZ6OrecGPE4GUL69t6g0DeTHz6gkDJ53FosavkdVnSXNwFKWrGqx7TE
	 Mxq7t8rFAj+NC2lWuq1ry6H6SRh3Z7zQBCxTChXU0s2WXmcia2vGgPxBbjouEnLOD+gtD
	 AVNl+RmgqZVzvAtPB4y04OoD/O+hECP5Pw7TsrCkMH0XmmRkD69M8rN11Ifhy69ZYhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jzCuIA/n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C239606A320;
	Wed, 18 Nov 2026 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzCuIA/n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675B91F000C4;
	Wed, 18 Nov 2026 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021369;
	bh=vJZIlPJ9iViDYvtFxK31PdCKL7TZPQOuZFpULpkxBMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzCuIA/nmAfghdoxKFRkWz26dYYrNF5ufU4jXITudqeOnMtontCle0775lFFV0YYi
	 1kDvVFlovPy7DseWjetSB0h/1GcPIgXChmdK6JWm3n4YSuguYqRgtYnZ48k925OVDW
	 0pq3bjKIl2GqTEJpWOj/qp/Vt/QxT5f+d41KbOFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2284/2651] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 15:58:44 +0100
Message-ID: <20261118150407.525785512@linuxfoundation.org>
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

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit a63bb4d91c784f63ad7c063717dff7920d8445be ]

fsctl_query_iface_info_ioctl() walks idev6->addr_list with a plain
list_for_each_entry() while holding only rtnl_lock(). rtnl does not
serialize all writers of this list: the DAD-failure path
(addrconf_dad_failure -> ipv6_add_addr) can insert addresses without
holding RTNL. It updates idev->addr_list with list_add_tail_rcu() under
write_lock_bh(&idev->lock), so it can race with the unlocked walk.

addr_list is RCU managed, so walk it with list_for_each_entry_rcu()
under rcu_read_lock(), matching the other lockless readers of the list.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Co-developed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 26dc8933e2a0f..efc3723389c5a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10761,13 +10761,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			if (!idev6)
 				continue;
 
-			list_for_each_entry(ifa, &idev6->addr_list, if_list) {
+			rcu_read_lock();
+			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
 				if (ifa->flags & (IFA_F_TENTATIVE |
 							IFA_F_DEPRECATED))
 					continue;
 				memcpy(ipv6_addr, ifa->addr.s6_addr, 16);
 				break;
 			}
+			rcu_read_unlock();
 			sockaddr_storage->addr6.ScopeId = 0;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
-- 
2.53.0



