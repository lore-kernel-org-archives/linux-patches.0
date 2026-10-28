Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217271;
	b=l0SeGbaoi0+9htoss21tFxZMb7gSEYSKbG76lVot706ATf9uglUYWdfdwtOIuxdHpyLD
	 CjlmhPPjIbAM4wtiTTkNZyTiZZ6jUn4qSa7N0vs2VhRapYc50bb5QxTbWjst32l6lnsF2
	 yu9036WqjzaighJ7cewtjo3iKgcnTbI44zGJOyIei3zcqy9yWrstInO2ueroH8JPpci/K
	 7umf8v/2vWze7vIItibUchQknUJfSFjwy8fJ9AYrS8z7j+IHxCzZN5sFx2LM8fB9OCSiY
	 M5ihrYIwgG6LnJ3M2lSbi4EotsalDigCENzTZwQmDCLrm/vEqhOqpe3bv+mMIq/0JYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKZQShpjXdEpb6W9BJw6t61xFVBM+GpVBWoJY7ss+hc=;
	b=q2j1gPRuqQHgovpBqyBk5jAThKcpu9ook+rrWpmp9gJbq/bJ98CkEomhcT9dPKogaJgV
	 UfAG51V4kmiGb//TcfJevdw/QCfTlGBEMdi/p7CG+iMM+PjWhZnzzfE6PRtocgmg0Qnpz
	 DH7HIA37fsPL7d03uM7KwUzbQa/S1jssQ6sxJBlbdq0sqEqYz/SYZupT0CZqOSHfUiCPC
	 Y+R/y01p1iniAHMgLxeE4jkVo5+yTj8mCUqobtaJmiU8d0QGD+/ZmCXew+XPZsJ76+HZj
	 vLK1abi8Oqtyzrk+TM62O5OxtRx/QdmN4AAG1Qa5EdIEanY5sFXWGNELfkQrw7OEwqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkwfLJ0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEB0606A31C;
	Wed, 28 Oct 2026 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkwfLJ0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDC1F01825;
	Wed, 28 Oct 2026 19:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217271;
	bh=zKZQShpjXdEpb6W9BJw6t61xFVBM+GpVBWoJY7ss+hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkwfLJ0g9yK6wcpfXDoKHADSdVgSEKC+SPH06qVNbtI18SwrOl2xv5HVRju7/kFJv
	 MPUOhWWcEaLSvCCIStYJgvYimVrek85gY2h2EO2UMBIe1j/2bfZa4EUBGNl4AnreUi
	 np16p6WYxUOJDT82xSIVkwVncFwLQwdMvupOQVgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Allison Henderson <achender@kernel.org>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1847/1887] rds: tcp: unregister sysctl before tearing down listen socket
Date: Wed, 28 Oct 2026 18:05:43 +0100
Message-ID: <20261028170541.480900409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit 167e54c703ccd4fa028feb568b0d1002020cff86 ]

rds_tcp_exit_net() frees the per-netns RDS TCP listen socket via
rds_tcp_kill_sock() before unregistering the per-netns sysctl table.  Since
rds_tcp_skbuf_handler() derives the netns from
rtn->rds_tcp_listen_sock->sk, a concurrent sysctl write can race with
netns teardown and dereference the freed socket/sk.

KASAN reports the race as:

  BUG: KASAN: slab-use-after-free in rds_tcp_skbuf_handler+0x2aa/0x2e0
  rds_tcp_skbuf_handler              net/rds/tcp.c:721
  proc_sys_call_handler              fs/proc/proc_sysctl.c
  vfs_write                          fs/read_write.c
  __x64_sys_pwrite64                 fs/read_write.c

Fix this by unregistering the RDS TCP sysctl table before calling
rds_tcp_kill_sock().  unregister_net_sysctl_table() prevents new sysctl
handlers from starting and waits for in-flight handlers to finish, so
the listen socket can then be released safely. The fix was tested
against the linked reproducer.

Fixes: 7f5611cbc487 ("rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy")
Reported-by: AutonomousCodeSecurity@microsoft.com
Link: https://lore.kernel.org/all/20260719203718.9680-1-blbllhy@gmail.com
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260719210357.10179-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5b4af800dcdc5..0967540f90f6b 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -711,13 +711,13 @@ static void __net_exit rds_tcp_exit_net(struct net *net)
 {
 	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
 
-	rds_tcp_kill_sock(net);
-
 	if (rtn->rds_tcp_sysctl)
 		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
 
 	if (net != &init_net)
 		kfree(rtn->ctl_table);
+
+	rds_tcp_kill_sock(net);
 }
 
 static struct pernet_operations rds_tcp_net_ops = {
-- 
2.53.0



