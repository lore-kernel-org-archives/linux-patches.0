Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036917;
	b=A9UCRMfe33awkBFi2NTCHKDfa/N4VEQZXjGtYFB+PY8trqfLGcOhU/LDz5tijaS3eQkg
	 r73qd1vvfNmmk0dDqqiwazRCtEUB5wJPFNvKKfMOt2+uWkfnBWq/D/zckD32XtfcvhR6x
	 kQYeq4zjz52Xu4NggOI0TZH0XPf8aFsXTdeB3ueXaVM6dE8o4zOkzV8oKO4boCKJU1Nie
	 pl5XjNplPCawxOsgFouQbyfS2PuJd69Uqn3yy16LXy2wAXPHv8HfiindqqRYrWX5oQBD1
	 bBLHxHkSom2aVLsdYyxfyfYA4ZAOwx4Coc9l3778ygBkFOOjM/bm2Ze+H7iIJfselVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBPX++dw1ki5snwbQBYonyatbUia6HGXKwcJbTcVn+Q=;
	b=fdkY918NVDy9yZ6wZZGMrElqcN/Q2qblNgiEZU8DwbbNmMXf/AybHrhRCjS7DqMBZOXj
	 B8hOOyCYDLB5o3nPdGFbd6awgwuAHgDwLd+KDB5X4UhMopGPHy9flTmf3QgVb0VIXlSty
	 XU7Qcplfjo9WmogFH5H8lbqNRJ0etfsXxenKmyY5MwQ1sDTVGDcGh/QpGKKQHIshhTODl
	 f7DlHrfRSoAeQ0FbOzWa5R2QLAWj6yIzgAusbINAGC0Z+4oB88e9J26GzxSS2d6XCgJM5
	 79HFO3nYK/nsEIZtVMdFfNqRFArO8whU9pLjrydUkZZUUmbCg3C1mXmk2ERKmZGb1Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sb8SWoGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E37606A31C;
	Wed, 18 Nov 2026 21:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sb8SWoGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DCB1F000C4;
	Wed, 18 Nov 2026 21:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036917;
	bh=PBPX++dw1ki5snwbQBYonyatbUia6HGXKwcJbTcVn+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sb8SWoGgDBy6wdwkRdryFQEupk4HZ2vLGdVx3g+nltt0f2czT4j6eqIDH0nZq92bd
	 HCWOZiRG+EGVQgmMJKAU3QFXwhRs6aEs+U6T2KTlbZ0rHsY1GH/CMbDXHZhuuIed8X
	 /R3gqs0AugM2vXOeRuKkABBYjwrgj34QoXneAd/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+f8e3e01d8dda8689@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1228/3318] ceph: reject mdsmaps that claim more than CEPH_MAX_MDS ranks
Date: Wed, 18 Nov 2026 15:30:50 +0100
Message-ID: <20261118150357.028828114@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit c1742590d2b2fc5fb217e1a9b520108f1fe282e5 ]

check_new_map() sizes its export-target bitmap from CEPH_MAX_MDS but walks
it with newmap->possible_max_rank, which comes straight off the wire:
ceph_mdsmap_decode() sets it to max(m_num_active_mds, m_max_mds), then
overwrites it with the size of the "in" set.  Neither is bounded by
CEPH_MAX_MDS, only by m_info allocating, so a monitor announcing more ranks
than the bitmap holds makes test_bit() read past the end of targets[].  The
clear_bit() loop above indexes the same bitmap, though it is additionally
bounded by mdsc->max_sessions.  The map arrives on the monitor connection,
which is unauthenticated in legacy msgr mode.

CEPH_MAX_MDS is a protocol constant from src/mds/mdstypes.h, and the
reserved inode ranges in super.h are laid out one rank apart over that
span, so a map claiming more ranks is corrupt.  Reject it where the rank
space is established rather than letting the count reach check_new_map().

  BUG: KASAN: stack-out-of-bounds in check_new_map (fs/ceph/mds_client.c:5968)
  Read of size 8 at addr ffffc90000ac7798 by task kworker/1:2/127
  Workqueue: ceph-msgr ceph_con_workfn
  Call Trace:
   <TASK>
   dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
   print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
   kasan_report (mm/kasan/report.c:595)
   kasan_check_range (mm/kasan/generic.c:186 mm/kasan/generic.c:200)
   check_new_map (fs/ceph/mds_client.c:5968)
   ceph_mdsc_handle_mdsmap (fs/ceph/mds_client.c:7060)
   extra_mon_dispatch (fs/ceph/super.c:802)
   mon_dispatch (net/ceph/mon_client.c:1483)
   ceph_con_process_message (net/ceph/messenger.c:1424)
   ceph_con_v1_try_read (net/ceph/messenger_v1.c:1430)
   ceph_con_workfn (net/ceph/messenger.c:1576)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
   </TASK>
  The buggy address belongs to stack of task kworker/1:2/127
   and is located at offset 288 in frame:
   check_new_map (fs/ceph/mds_client.c:5846)
  This frame has 1 object:
   [32, 288) 'targets'

Cc: stable@vger.kernel.org
Fixes: d517b3983dd3 ("ceph: reconnect to the export targets on new mdsmaps")
Reported-by: co+f8e3e01d8dda8689@bugs.sh
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mdsmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 7a90c8f8a470a..8ddbe33306d19 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -170,6 +170,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 	 * and the mds rank >= m_num_active_mds.
 	 */
 	m->possible_max_rank = max(m->m_num_active_mds, m->m_max_mds);
+	if (m->possible_max_rank > CEPH_MAX_MDS) {
+		err = -EIO;
+		goto corrupt;
+	}
 
 	m->m_info = kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOFS);
 	if (!m->m_info)
@@ -316,6 +320,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 	{
 		int num_laggy = 0;
 		ceph_decode_32_safe(p, end, n, bad_ext);
+		if (n > CEPH_MAX_MDS) {
+			err = -EIO;
+			goto corrupt;
+		}
 		ceph_decode_need(p, end, sizeof(u32) * n, bad_ext);
 
 		for (i = 0; i < n; i++) {
-- 
2.53.0



