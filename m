Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620947;
	b=GZRevz9OxCaPtWSM7dcUdl9pfFiPreY0T2czb0/o9kN/Ph3PICz3aru5STJxRverRpD6
	 kWDvitMu0mwoYvQOTuKhlHKpyP2/5AnIcD844MQVBibVgds/EBFnHQ7WMWRdZD9QKMK1u
	 7D3O7E0idgEVo6RJeg1LHylptYCjWBAI5R0Jy6lCvdY+zUv0UufiO+4WQq7aEeLU9bcom
	 D5tqswDbyV3zQ3tdKNeBUuArmHdqHL10+8mxv+5xhZpUqQN0C3jh/UC2wKlm81ysBLLWK
	 PcKj2zZWRUCsM76jCFQrThwUr5ZJ0/knnz0/L2yjMgRx8jaFNRHptfoxdNnoUijTDwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5KNfDkXMIH7TIufw8Jzk1nlFwHP+yT7bhWcHdU8f4U=;
	b=Wp97xwxh0Wd14GaWIHMDuAp0yxiHzzi3++CmxsL7e7682iiodTdj4rfe9O3f6LE44PwS
	 K5k9ESWrHgFrIxh9Uuy6JjuQ7i1vkp3WOhNaqfBQJQ18B4KGWphKXg14poA0ouUS94l86
	 W8rS0E8zS/QBJBJDp3+9DaBaeyvb5xKd6s97Uuy1BMZe5HnljXQthUG7XP5lQOCoLe8Rm
	 3egpq64vMVVuB19A+7P+VD2DyYs/2DZHG10tvE1b3lKZwbBGQV1dVEUE7QoYmlYkSAm0m
	 4sXQsUrUpKi31RJnX8mmS3Evcu5NSSVH83guRCmHoDCk3fUR4HLwG/40J9gI6xgd9mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfWkGWvU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A3606A6B3;
	Wed, 25 Nov 2026 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfWkGWvU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E251F00A00;
	Wed, 25 Nov 2026 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620947;
	bh=c5KNfDkXMIH7TIufw8Jzk1nlFwHP+yT7bhWcHdU8f4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfWkGWvUenXSn+9L0x2o67srUaWHBxifrH5lFz55YCSiPO3omyrl8NsX68SKA/UG2
	 sUFVN95ij/ukYmWxytVug3cN0MPP22y+5uNq3pzkfdCknlsp+jc1/qyfx8Z+e39wwW
	 9NOlQk5NzYx2ZlhYgRzSLR4BNUwwCeFydVtVS1Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	Matthew Whitehead <tedheadster@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/990] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
Date: Wed, 25 Nov 2026 15:24:01 +0100
Message-ID: <20261125143823.820397580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 371e8300f0291..8760556de568d 100644
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



