Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052857;
	b=zqoy1BFBgq1cfofAarIO/1cgwSOUBqpDCiwEhJ/04vGY5nMwl3bg7NdvKrYr4yS/WcpR
	 EhqaDMhAN/87u+ErM9cOkE4iKv6kU0TGgUwUCDPWsFjIAWd/uIc7BWU6DawgY1GWuAT9S
	 2ajTItpASDKIMH80T0JdkcQnMp7gZmZMmgE9G4O5dfgCzLlqnXzWd9em8e8BSXd49m5sK
	 Ngu+EfJS3eK4MOxai5w/Xv0d4DHDtmOATToXgSOJIRICjrZcOVocUbLb0Aw9oyYAAcFBi
	 pmccuVrZcegiBBOYoEgJW2JEBTPrbtkn89Fq0TfTTncwjxqRw40qyBdF+tw9jklVbjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bqZDcOWWpaB9Ozwp94rvgy8INrfBM66VI0Y5cNudtaA=;
	b=YeG0eKAKvg9Jm+CGpuGKW3EH61GeA8+cy6nLdmlVvRHicAayXmby7TMTXiQcCfnjKr9x
	 90eplc60wqUyE0iNSS+HfAhBfwnZf7EQQHaDXJF6i8uJSp8FNjyHX9wcEVl5T1uRVCDrz
	 MzyQ1FmnaS4iRZibbrzjhauVtOcp80XSehZNik8g/+bwWg2hYgNxhexuA+2soWR6oyHlW
	 uXjYUkP/utGDjvnx7AslYUEbzFD3B1YOL2f7fGCJ13ljR/Ak01VfxkYgWO3Nf2f/PX8GE
	 0ydUyhhJPhxvN1V/JVAznAGMw4jWkPMm9VT5+2yXSyP14r2BSKoGEl7Hdlj+A7eZawg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfhw2Pk2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA4E606A32A;
	Thu, 19 Nov 2026 01:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfhw2Pk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B01F000C4;
	Thu, 19 Nov 2026 01:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052856;
	bh=bqZDcOWWpaB9Ozwp94rvgy8INrfBM66VI0Y5cNudtaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfhw2Pk2xFARLcyEpckJCWwICOoykE3StKDKyhW/T7M0P8rfUJvf4f6KVLRTomgqU
	 cAyFZT9nuvpDPM3eikN3DpnQllr2mWq0ln1ZPhDVZfKqqRAaF84CsT2mKVkKz/l+dF
	 VN1xR//LHq6Q0o5tydzPXAM5ap7NtPJcUwm85bVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+f8e3e01d8dda8689@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0711/2214] ceph: reject mdsmaps that claim more than CEPH_MAX_MDS ranks
Date: Wed, 18 Nov 2026 15:39:47 +0100
Message-ID: <20261118150040.240372656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0391ad0022e3a..77eca4d7aeff4 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -167,6 +167,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 	 * and the mds rank >= m_num_active_mds.
 	 */
 	m->possible_max_rank = max(m->m_num_active_mds, m->m_max_mds);
+	if (m->possible_max_rank > CEPH_MAX_MDS) {
+		err = -EIO;
+		goto corrupt;
+	}
 
 	m->m_info = kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOFS);
 	if (!m->m_info)
@@ -315,6 +319,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
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



