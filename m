Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704930;
	b=IjKaO+NPfA9WwLkYu95R9EcWcGCOvyjLssCkEbXK2Y1gHy3SCAVzW5aqSUorLWjmAFqV
	 HDnlYu/OzI5u1BMbGBbkiaUOIQoG+ys4YKv6VzHcuiwgOl+f+Z7lvixvRsobtVyURgxrT
	 ddrGyKgKmtNDNYGTUuddLqOv+jtKRdz+utZw2c0EGskK4/ojZtvtQ9HJnP5iFOMqmsId0
	 V8nPM9XWun1SEEXB5NR/zogBFRdfWcfTfXRLhqHxFgL0tMulqz+EB+eb4JlyXAlnmphoJ
	 UHxut6MVY1KB1bTgDbifpIbekAm4bmQwL7RaT3NcmnlEzerwgNcrPxiEhuhghbQlVJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DkPIoIDqGfhOg5UdaZwzNj6VsB8r1bP/1oP1iOO8IlM=;
	b=U9Be3D6+VrG9jVkYWF/9jCPTM+VUvKDLjGll8mv83HvXJRnreWK0aSmA52yyZ5Tj7MNE
	 J6WWXy4Ir9hy521HYmjxD0XOcTzG8rrRTHEmgjR+501E13XmeHuTU5S79xI/Gwn0Ccq7H
	 SrtcUVWPUyVKhixcVuc31DZsTinkoI974fFYxgaiTzNJQ1C/Amx8teH1TtMsOZK8pkXQK
	 OOfYhf/EDfs+vEfZqF9E54kUa4XQzykb7UZCrOlAM/h6w3wuc7nC09fHu36F3hhSKrzdH
	 Ah1bBUwsf1PByowTjy0u9N3omjj59WadKsroPAnyV9mJ779pT2pzAPhjo7xQDUUQOyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oi1yyTMd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AD606A31C;
	Thu, 26 Nov 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oi1yyTMd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711C71F000C0;
	Thu, 26 Nov 2026 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704929;
	bh=DkPIoIDqGfhOg5UdaZwzNj6VsB8r1bP/1oP1iOO8IlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oi1yyTMdjJZukMHCW1KO+gy8mO+sZI0bk6U3vSviH42xPvBApiQ2E4Yy8NFq3tqL7
	 s1PKVemcmyzbGdTBdnz2EBqTZYsFWhQJwiHEYP0vOaUAmHBsoRKmNjKSJ4LdTZi2QH
	 2AcOtjSPdBnd9LkaFgGul6YFiEVPTiORq4+kt4NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Matthew Whitehead <tedheadster@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/319] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
Date: Thu, 26 Nov 2026 15:36:32 +0100
Message-ID: <20261126144007.286394325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Matthew Whitehead <tedheadster@gmail.com>

[ Upstream commit 9ec6671b137de06f0345962fb8091466b7d56a96 ]

aha1542 never DMA maps the command's scatterlist. Data is bounced
through a per-command buffer allocated with dma_alloc_coherent() in
aha1542_init_cmd_priv(), the adapter is programmed with
acmd->data_buffer_handle, and the payload is copied to and from the
request segments in aha1542_queuecommand() and aha1542_free_cmd().

The scsi_dma_unmap() call left in aha1542_free_cmd() therefore unmaps
a scatterlist that was never mapped. With CONFIG_DMA_API_DEBUG enabled
this results in:

  device driver tries to free DMA memory it has not allocated
    [device address=0x0000000000000000] [size=0 bytes]

Remove the call.

Verified by testing on real hardware.

Fixes: 2f2fef022c3e ("aha1542: use a local bounce buffer")
Suggested-by: Laurence Oberman <loberman@redhat.com>
Assisted-by: LLM
Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20260929144528.7061-1-tedheadster@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aha1542.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 584a59522038b..f13a49b665c1c 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -273,8 +273,6 @@ static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 			buf += bv.bv_len;
 		}
 	}
-
-	scsi_dma_unmap(cmd);
 }
 
 static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
-- 
2.53.0



