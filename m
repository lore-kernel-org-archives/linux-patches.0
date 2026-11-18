Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020224;
	b=JmnbSACWwLdBIkRg36CpUBSQUojy3/jeozbSWMXmspACFhGPIqzQt9oLv9kcbNAv2w61
	 lrlJSHs6xTEjEqcaCMk2WAejG7Wf+c2YzTKMWpkh6kKs7XtTzGGdMxE60S+AdbDqI9FUt
	 +kLFuuCMXk84Xib1oRb7UOJRXozHg/Q+ChGRJYVqTA32mYHKvsG1g0stgR2xsCJ2SKdaJ
	 Q4C4NlMiAXJC4uu8240b8ObOwvFCLGFWygvVp96PLbwpahEGjnO4hsTyImEmJAwkM1vY2
	 il/AwbU+Hce7ETvAVcJfy9eN/bZM/SutAZkq0IhrrfydkOI08dyB8vr/u9FM+BzFHxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F9piDyGs7LkDVRo6K0eQXJhWKc3fposHkBfwDyo5B1w=;
	b=2I1P868Uv9y73vhg/lt5lvBVN7QznfGF96pPTrqVLeiiDtCyHM7+2qzXwULL17bMoQz5
	 yuegBjTNjofpPF/PIwhDTAHlsLwN+PkKBeInqryGZiqnVOZtoCdWdyAynUPpIvzuDwTRI
	 nFItYISfsnQIff3fBH2TyIKof2TopLqTMROrbuPXULMyGSbtn8oguRmFr7Cy+w+4iNpxl
	 jgaJrKe0epkq4Ov9qOuC+UyM3BbXDIu/4lWA3ukrR2JDJBV2Jwoi7lvRRxute+H0ktus/
	 tNzbHgwSeuoGOJ5PYZrfjJft+jHVAyCcZ+lYkiLte6Zjkg6DvnoPZt+slsjCMrlZcpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZ6lulQZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91E5606A320;
	Wed, 18 Nov 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZ6lulQZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D051F000C7;
	Wed, 18 Nov 2026 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020224;
	bh=F9piDyGs7LkDVRo6K0eQXJhWKc3fposHkBfwDyo5B1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZ6lulQZw6Dgm/AJi2fGiT6Js6+p9YmpOCatGE+W/ozN7BicpLsBHx40GmywC0c9c
	 v7JCxsZo8maULrm1wm/ZmVIot7mYY1PfTK3D3LGemT5wCRU0gxUyaXtN74L7JTTHK/
	 8XV66KTUBEpY4gxVVfyFi4ozql5Cw9qKS97hh6sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1873/2651] Bluetooth: 6lowpan: use l2cap_chan_close_unlocked()
Date: Wed, 18 Nov 2026 15:51:53 +0100
Message-ID: <20261118150354.387173471@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit a69dd52612ea6c763f76553e355ee03b981b4ed4 ]

6lowpan.c is using l2cap_chan_close() without taking chan->conn->lock,
so it may modify conn->chan_l without holding the guarding lock.

Fix the locking by using the l2cap_chan_close_unlocked() helper that
acquires the necessary locks.

Fixes: 15f32cabf426 ("Bluetooth: 6lowpan: add missing l2cap_chan_lock()")
Link: https://syzkaller.appspot.com/bug?extid=0e4ebcc970728e056324
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 20fb20eea8e79..50402bd4e1b07 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -921,9 +921,7 @@ static int bt_6lowpan_disconnect(struct l2cap_conn *conn, u8 dst_type)
 
 	BT_DBG("peer %p chan %p", peer, peer->chan);
 
-	l2cap_chan_lock(peer->chan);
-	l2cap_chan_close(peer->chan, ENOENT);
-	l2cap_chan_unlock(peer->chan);
+	l2cap_chan_close_unlocked(peer->chan, ENOENT);
 
 	return 0;
 }
@@ -1025,9 +1023,9 @@ static void disconnect_all_peers(void)
 	struct lowpan_peer *peer;
 	int nchans;
 
-	/* l2cap_chan_close() cannot be called from RCU, and lock ordering
-	 * chan->lock > devices_lock prevents taking write side lock, so copy
-	 * then close.
+	/* l2cap_chan_close_unlocked() cannot be called from RCU, and lock
+	 * ordering chan->lock > devices_lock prevents taking write side lock,
+	 * so copy then close.
 	 */
 
 	rcu_read_lock();
@@ -1062,9 +1060,7 @@ static void disconnect_all_peers(void)
 		spin_unlock(&devices_lock);
 
 		for (i = 0; i < nchans; ++i) {
-			l2cap_chan_lock(chans[i]);
-			l2cap_chan_close(chans[i], ENOENT);
-			l2cap_chan_unlock(chans[i]);
+			l2cap_chan_close_unlocked(chans[i], ENOENT);
 			l2cap_chan_put(chans[i]);
 		}
 	} while (nchans);
@@ -1082,9 +1078,7 @@ static void do_enable_set(bool flag)
 
 	mutex_lock(&set_lock);
 	if (listen_chan) {
-		l2cap_chan_lock(listen_chan);
-		l2cap_chan_close(listen_chan, 0);
-		l2cap_chan_unlock(listen_chan);
+		l2cap_chan_close_unlocked(listen_chan, 0);
 		l2cap_chan_put(listen_chan);
 	}
 
@@ -1132,9 +1126,7 @@ static ssize_t lowpan_control_write(struct file *fp,
 
 		mutex_lock(&set_lock);
 		if (listen_chan) {
-			l2cap_chan_lock(listen_chan);
-			l2cap_chan_close(listen_chan, 0);
-			l2cap_chan_unlock(listen_chan);
+			l2cap_chan_close_unlocked(listen_chan, 0);
 			l2cap_chan_put(listen_chan);
 			listen_chan = NULL;
 		}
@@ -1304,10 +1296,9 @@ static void __exit bt_6lowpan_exit(void)
 	debugfs_remove(lowpan_control_debugfs);
 
 	if (listen_chan) {
-		l2cap_chan_lock(listen_chan);
-		l2cap_chan_close(listen_chan, 0);
-		l2cap_chan_unlock(listen_chan);
+		l2cap_chan_close_unlocked(listen_chan, 0);
 		l2cap_chan_put(listen_chan);
+		listen_chan = NULL;
 	}
 
 	disconnect_devices();
-- 
2.53.0



