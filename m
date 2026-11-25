Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618266;
	b=wzB23SVTk+6vpRt2r9t/mrfHZCvmXLsPopi6dEzTaGLS0wAgMEgODdrNqsTpFyA+EkXX
	 cz1CDSU1D91jWKJsQV2ZBYbTGYi1Q3fvd0i9xCm6KxJOxG+DH1T9Hq3t8PiuMOZPa2mTw
	 9jh9pcPBqRB7ydjd6qLIfnn8zfpiyeXomf06eLKM+Ju1What00qn7F6jxxofmknPg7goV
	 rIN1JkIxEMJCyBSRs69jShChjYRhQ20BZKO3WiCwvekD7eJWxD3G3+VRaUXLLCHQfoEZe
	 1VjQHBgnPhXqkmlu6vN92DwDKAkO2w9E8VvBmPIA5bHGxgldMzXyR0vdB9gLGXyxm/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrswDdqgs9u/a2iAEvJjBA0UBilBxrz0w7Oas1NrHcA=;
	b=FJYbx9wxt0bHeCSb3Q7WngV6gBSa/97hs/TSIgr5yc8gjoyQv1ArFTIi3bsugxw4FTE+
	 Ztl1qF5VhTU1VQAni0DM7haYu4rCHEKNPqZ8+P7adi1VEV0N0hlMbYD3OfHkLjHile9oX
	 FMP7npXeqsB/ixkRhG58ivAprT2I6e1kMnr7yu8vZddC4cpcAydCF2bvC1JxcwyCSF06i
	 wRN/cLq5m5NjNOCxkWxC0Q4MSCD8hoxvD4MriU7Lz5GvuzjfBXDRZ1JgXVln33bAhrh0+
	 b3QCleOLQNRgJ/sW15pwt5+UYffl2XMkf6BCaJHCH05ANE8TlKCBD41oirc8VAy65wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dK+/BBWd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E168606A321;
	Wed, 25 Nov 2026 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dK+/BBWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6994E1F000C4;
	Wed, 25 Nov 2026 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618266;
	bh=WrswDdqgs9u/a2iAEvJjBA0UBilBxrz0w7Oas1NrHcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dK+/BBWdWjMOzURKxdaLv1rbUO+GgEMFSqN3EjQ7x8O3xs1w7s0IDry6wx8RwpQ21
	 pCFZrYlireMy5Rp1S8ZYls28YB4SzvrQ8hfN+4MmyeFTmTnV5GTwY3HvBjfrP2BHmN
	 TOZHYoHnEiLBniuqFmZl9YPo8Ff/LzLPuzN9WiAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0226/1005] vhost-scsi: do not count PI bytes in the data length
Date: Wed, 25 Nov 2026 15:26:04 +0100
Message-ID: <20261125143827.034376416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 1f5bc40e33d8b3e5e3b89047956099b0c19f1d3d ]

vhost_scsi_handle_vq() moves pi_bytesout or pi_bytesin into the
protection sgl and subtracts those bytes from exp_data_len.  The length
passed to TCM is still exp_data_len + prot_bytes.

prot_bytes comes from virtio_scsi_cmd_req_pi.  With
VIRTIO_SCSI_F_T10_PI negotiated, vhost reads that header and does not
check that the CDB is a READ or WRITE.  sbc_check_prot() replaces
data_length from the CDB only when the protect field is non-zero.
target_cmd_size_check() leaves a write's data_length unchanged when the
CDB size is smaller, so a command that does not get that replacement
keeps a data_length larger than the data sgl.

The KASAN report is a MODE SELECT whose header had pi_bytesout set.
The data sgl held only the parameter list.  spc_emulate_modeselect()
walked data_length and read the next physical page.

Pass the data sgl length.  Protected READ and WRITE still take their
length from the CDB in sbc_check_prot().

KASAN reports:

  BUG: KASAN: use-after-free in spc_emulate_modeselect+0x145/0x380 [target_core_mod]
  Read of size 1

  spc_emulate_modeselect
  __target_execute_cmd
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd
  __target_submit
  target_queued_submit_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork
  ret_from_fork_asm

Fixes: 9f977ef7b671 ("vhost-scsi: Include prot_bytes into expected data transfer length")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261012103954.136698-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8f57a789814f5..886a9700351bb 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1546,9 +1546,17 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
 		cmd->tvc_vq_desc = vc.head;
+		/*
+		 * vhost_scsi_mapal() maps the PI bytes into cmd->prot_table.
+		 * It maps the remaining exp_data_len bytes into cmd->table,
+		 * which is the data SGL passed to the target core.  Its
+		 * expected length must therefore exclude prot_bytes.
+		 *
+		 * sbc_check_prot() derives the data length for protected READ
+		 * and WRITE commands from the CDB.
+		 */
 		vhost_scsi_target_queue_cmd(nexus, cmd, cdb, lun, task_attr,
-					    data_direction,
-					    exp_data_len + prot_bytes);
+					    data_direction, exp_data_len);
 		ret = 0;
 err:
 		/*
-- 
2.53.0



