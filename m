Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624025;
	b=ighUXPmBk0xtWgTPfnszECXDEjK6gdl7qm3Aavh8Coq/hSf5cRXtCSckXcIJeWLSlkY0
	 4FVkXZhFbhDb5fB+sEprY6y1piEtcQkmnF9ww+VJ/nakzZWLwoGk6oc2MXEvehun/wnvj
	 6lTLrSniY0bpAIlDwimDuSZot71mrWLf4GmCy7mVvStPmjhq+TFKgnpTjYltTj/tFrHBA
	 igjeLoXx9uhIE8rHl2LrXBaWZAOVhvOCZDpSLNC0w1Himfz5nhI0VHVwti+ta6Av1UbjO
	 ibLYVZnNDy6DFcKhSd+ahf/cztbmazIfM3Azvu/kAeL/14LOj/Ut5Qy2BPnYEXOODLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o/vT/efHbi/wc47MrPyd/eLfmc5ABlX5QiwheVI7Uw8=;
	b=fLdrxmAz5pXX9ADQKL+0o++fn3SDttV34bvvKsvYRirQhw/omhUlnIUbf3CwoHjAfOl8
	 f5o+BPK+09SKeL7NUlYHcAlMcJUpu1Inw9kmJCMWB/xiOVgcnFqeOiMkGw+ksN/OE8Upl
	 /XHVu7N3HsKOLfB045heWopEVg+psYt5sOwWsXuLhjBBl/ulCmvP9JGD5NbGP5wHiK6yq
	 r34ODQ89NscVSO4CKFe8xJArjrnkwtrHEJtp6oNk+pcyLVByC4QklXKzgxfrNaJwYUwv6
	 +JObmpidUWGpXtksGaoGLkIjaL0Mwa+P9aehvbWP0S+sxizT93qYtVIl0TQ1xmA0lMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdje6VoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4478606A332;
	Wed, 25 Nov 2026 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdje6VoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A47C1F000D4;
	Wed, 25 Nov 2026 16:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624025;
	bh=o/vT/efHbi/wc47MrPyd/eLfmc5ABlX5QiwheVI7Uw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdje6VoW2hwhYFQWc+l5Y0uVY0isqd1yIWIYO0I81eGbM9JmaJfY2VvDWkJAoRcWb
	 Zh3Nli+D0F/WskJebdIQin+Dz7Zn3+4uZqU/2Q7s7GL6Jb+gUnhXMzVuodEo9Ffk1v
	 dUvFJskasgJnPwG0+tCCsbTjTpC4+2Q18xpEEU9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Matthew Whitehead <tedheadster@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/816] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
Date: Wed, 25 Nov 2026 15:26:49 +0100
Message-ID: <20261125143850.632138848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 389499d3e00aa..4feea64ce24cb 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -271,8 +271,6 @@ static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 			buf += bv.bv_len;
 		}
 	}
-
-	scsi_dma_unmap(cmd);
 }
 
 static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
-- 
2.53.0



