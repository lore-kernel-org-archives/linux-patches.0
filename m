Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211798;
	b=zGPX662ZE4pUzApoBDlgO9pDRnhDSK0j7IWaOe3e6bKzmPzpGS8N5PGkaXdCiOO7POSH
	 SCfEcW49zhgr42SfVrA2p4XpGkJRwf7VXoae1S3x2W4NiSa/2slkNUUD05SiC36CRibET
	 0SNbjly0dRXIm1TWPG58LIKBJUhEJ9SpvJ43Yuaj/LdAUeeUeIw/FBhmSo4KPRgaD7qkT
	 xemCnTq+668Pm3p0xXEJGvMPzTfcIcerLcnv3SzJyB4lW0FV1QLjcHiz2O2jXu1SzplmU
	 +4nPH06fg0xFEDA0g8aqhgmFfPQKjna/FNKMol83EM29Umy79rx+COjiCrkyjajvW/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0SZ2MsflEq0y0U8FYnFu94GtEXCuL0HAG0xxAgfFPm8=;
	b=eRag/wPO190ZxJCnLkTCjRvL5i354rt3ZVn3wGgDCnI7LAoxkHcwxweIPq5wXS2V6Kx9
	 MI+JEbcpwF2Q1YwJpp68AtShQEH//Ya8L29yGzaEUSGkIPifWLzwNwlYiLA8GNh7sQ4I1
	 WM9asfI34kmCFryg7LXBinJTOwvwawBLHuIICRYTyXG2+k+Juq0LCCJCOklAP0Qv9u0Fh
	 c+IhpGKqsorO3Wd6wxzM9rATqeNZlgm7NjaaYWdzut8quLE9qVOZWL9h6YjCWkI67j9En
	 1rCgwbE4EA7osw5UhcQSDvfVJYxgD8owPqmlJW44e5rTsbYPZk9lSRJcxvgzgsdVXpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaADK8XY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5667B606A335;
	Wed, 28 Oct 2026 18:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaADK8XY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E95D1F01825;
	Wed, 28 Oct 2026 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211798;
	bh=0SZ2MsflEq0y0U8FYnFu94GtEXCuL0HAG0xxAgfFPm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaADK8XY3bnzi0M7Gsa2JrxpQIZScDOvC1iqeXhTMO5Czng4efc8hl+psbOs4aw87
	 YU8GU/7capIq1B8qXEJmoFdf57gx/lepMpiElFVhxw4TCiQIvgPLLKmDo9N83kzugl
	 FWZur3FMP74Sd0VbNh3BixhtMQGt4DeTMlK2ADQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 502/571] scsi: libiscsi: Validate the task named by a management response
Date: Wed, 28 Oct 2026 18:00:49 +0100
Message-ID: <20261028170019.940721547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 11bffcd9cb346732eab2914ef44fe777a3f0b585 upstream.

__iscsi_complete_pdu() fetches the task for five response types from one
place and checks only that the index resolved:

      case ISCSI_OP_LOGOUT_RSP:
      case ISCSI_OP_LOGIN_RSP:
      case ISCSI_OP_TEXT_RSP:
      case ISCSI_OP_SCSI_TMFUNC_RSP:
      case ISCSI_OP_NOOP_IN:
              task = iscsi_itt_to_task(conn, hdr->itt);
              if (!task)
                      return ISCSI_ERR_BAD_ITT;

iscsi_itt_to_task() bounds the index against cmds_max and looks at
nothing else, so a target can name any slot in the pool, including one
that has never been used. task->conn is then NULL, and both
iscsi_nop_out_rsp() and iscsi_complete_task() dereference it. One
unsolicited NOP-In is enough; a Text Response carrying the same ITT
crashes in iscsi_complete_task() instead.

Require the task to be in flight and not a SCSI command, the way
iscsi_itt_to_ctask() does for the command opcodes.

[    6.298634] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
[    6.298642] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
[    6.298652] CPU: 1 UID: 0 PID: 111 Comm: iscsistart Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
[    6.298654] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.298656] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
[    6.298691] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
[    6.298698] RSP: 0018:ffff88806c907be8 EFLAGS: 00010206
[    6.298701] RAX: dffffc0000000000 RBX: ffff888006116800 RCX: 0000000000000020
[    6.298702] RDX: 000000000000000c RSI: ffff88800525d578 RDI: 0000000000000060
[    6.298703] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    6.298706] R10: 0000000000000020 R11: 0000000000000000 R12: 0000000000000000
[    6.298706] R13: 000000000000002e R14: ffff8880056eb440 R15: ffff888006116800
[    6.298707] FS:  00007fc02d1c2740(0000) GS:ffff8880b29bc000(0000) knlGS:0000000000000000
[    6.298710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.298711] CR2: 000055fe3b56ddf8 CR3: 00000000053b9004 CR4: 0000000000770ef0
[    6.298712] PKRU: 55555554
[    6.298713] Call Trace:
[    6.298714]  <IRQ>
[    6.298714]  __iscsi_complete_pdu+0x13a8/0x22a0
[    6.298758]  iscsi_complete_pdu+0x54/0xa0
[    6.298759]  iscsi_tcp_hdr_recv_done+0x870/0x2c80
[    6.298778]  iscsi_tcp_recv_skb+0x31e/0xec0
[    6.298800]  iscsi_sw_tcp_recv+0x12f/0x390
[    6.298804]  __tcp_read_sock+0x1ab/0x810
[    6.298812]  iscsi_sw_tcp_data_ready+0x18b/0x510
[    6.298814]  tcp_rcv_established+0x1f56/0x3a00
[    6.298842]  tcp_v4_do_rcv+0x449/0x960
[    6.298847]  tcp_v4_rcv+0x2245/0x3bc0

Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20261007015842.634893-4-yhlee@isslab.korea.ac.kr
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1227,7 +1227,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
 		task = iscsi_itt_to_task(conn, hdr->itt);
-		if (!task)
+		if (!task || task->state == ISCSI_TASK_FREE || task->sc)
 			return ISCSI_ERR_BAD_ITT;
 		break;
 	default:


