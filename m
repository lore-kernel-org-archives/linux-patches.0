Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617726;
	b=tWUE7DA//xTBMCYoinlHllDpGt43WNLtvApY7wdngDJaDsaMJ3wOpPpX2Avm9ZuhYt6l
	 iQ9dyfq7Hv3iMAXGE2T3Xo9r/SxQtX2athPpIPbg424tn33raBEdEm/DvejLPi1FMtZEJ
	 c2yF4cF2MugnXD3sq7gjxi0tQ0lL9EPJGjG+9vBSKI9pbiqppvQhBe5qv6QaCUSv4TIVs
	 gMHM6DQYj/KkGMdrmMZIM3zCxpiyYq91fd0Xr2RH3rNa3hcnYPCgqzxMqqxoBBuKx2eFC
	 qCusmLHpLjUBJqWEaEjJ59/0/dDsPljc8ZpREzAuzdSZ1VP7ySBvY4Eldz3vKhRiO8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ciiJ2U2ubuE0aAkmLsUBKbOyAZKrDnZ1VmcGvPlnPtk=;
	b=y7p2lTvJ+slTPfXV3tHpxY6AddBjqaV+68efOO7BIlupcbJOq0n0lOLZT36Ybq+4zBU5
	 9wv1nea9aCSigVbUY5/oOOIK9M+V8JYUF6/VGZt/kjqhxARyumu7mAbW5OCZgPllR2RzN
	 Ozkj3jUFKEydqS7TLSm/3cg7H71/SJ4AzAJnBJc8YOymhtBQbw2AnhgjvRvWv+awBgMRf
	 rrvq8Df+W6N7d4yUEfLtpotKtwsp2eXll2r+cytK6mvbblkL/GGGxcCfHq6WdyfXlB/wo
	 NSlUo3/huxnTPjG07TdNTTGctnPkluURN6Y9UABnQ4zveKcI8vQido9JUkvkEaTlL2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xa9q31MP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A1F606A329;
	Wed, 25 Nov 2026 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xa9q31MP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996181F000C6;
	Wed, 25 Nov 2026 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617726;
	bh=ciiJ2U2ubuE0aAkmLsUBKbOyAZKrDnZ1VmcGvPlnPtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xa9q31MPV2xjqaQovZUMcLfwIZVaBMHx2fvRXnBkP4Sc+D2X+YhFVxjeeY64iQpqn
	 MtDAyvHKexBaeidOzUlKh4ilCG2eL1YBQ6G5t5QsCThLEOCMq0QMvZSqBUb+TL2IRT
	 CJ9OXtzDYvvra0PKYlFchVrzkEKEuC5OADZPjZ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Matthew Whitehead <tedheadster@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0054/1005] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
Date: Wed, 25 Nov 2026 15:23:12 +0100
Message-ID: <20261125143823.007623640@linuxfoundation.org>
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
index 93dab19c1cb95..1cd85da47cc9c 100644
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



