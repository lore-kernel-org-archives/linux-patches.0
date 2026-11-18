Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037721;
	b=U3K8EjydlGMjcHRtwC+u7dFFY+uEC5MBAU5H5sjejZ+HT77eHf2halB3ai0Jc5SLVtF8
	 9FfloM6HQ1qrUc/xFHNyFUoJuRFnjWwBo3Gz0Pj8n4t7EVeqdTOmPHj6pVLpWJ0JwsCdC
	 4yag9apbeSuUi6QOLZBlOUbX0L9Kz3cU8YwCcny2g1KPwPeXk3QCZOEncQ9xyHYfXVFRi
	 4UwMg66PHxSzM26lFzWbNHZjm/rTyAA18n59ic7bHeBjoVcHv17FZyo+Xe3oEArGv+7WJ
	 qlYH6CBR2vup6rtdr9tfBFvZx40emq/aekwkGsNVpQmXUpjcan+PgZJzSfvKf/Gr7Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k03qEXciQdkR1JuKVN8VOBTNrPhpyVou2mIBF6PRV80=;
	b=vxsm3ZKCep18JWDG2MtBBMzjKNkPw+MK0uQmfBLv04KOPJLITotKg76btuAkYpyIDpfk
	 GD/IRF1IstK2ra5XhwEaEe1FId8tXw6fFsyp6j8Z1lj15kzNTQ9NApVz4EOiybEyMGlI9
	 cAaj1R5DjMnNJPLoCNlTdFKhPCigSnlGzQkniLRP9NFEWK/9lvcMsWE8kSoMwDoptIUmF
	 6LisAgYRoCBnW8B8to7JTp1J+HX/x0RbCWNmOMrIYojGRrkWNf2R2V6F7SHxxCe3olAzl
	 ysHKqyamZvlMjTzZvp+imKtaet5N6aG/xaU1/RENocQ2Y3xVbqrLDNBxdu46yDdt2Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDrRe8bm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D4606A320;
	Wed, 18 Nov 2026 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDrRe8bm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3C21F000C4;
	Wed, 18 Nov 2026 21:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037721;
	bh=k03qEXciQdkR1JuKVN8VOBTNrPhpyVou2mIBF6PRV80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDrRe8bmL4VtzWnn50gab0gvceKtAy2NLW1gz/d49O313/gd7dUrJxUMad1gtr9K8
	 TDaW4g8it9fJIbzxPjPj7gr9GKiTiaSfbvgtMQ/PLa4w8hCMZ7+HEqoZKrmT8f/Chk
	 TeASyFEH3aQVk/+BYf0zXLJllblkcZN2EqvApYqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1496/3318] vdpa/snet: Dont discard the DPU error in snet_send_ctrl_msg()
Date: Wed, 18 Nov 2026 15:35:18 +0100
Message-ID: <20261118150405.790968195@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit f41f153d49b4c18172ec61b69ba934c36e1be745 ]

snet_send_ctrl_msg() reads the error code the DPU reports when it ACKs
a control message, but then overwrites it with the return value of
snet_wait_for_dpu_completion(). As a result, a DESTROY, SUSPEND or
RESUME that the DPU rejects is reported to the caller as a success as
long as the DPU clears the opcode register in time.

For SUSPEND this means vhost-vdpa marks the device as suspended and
lets userspace reprogram the vrings while the DPU is still running
them; for DESTROY, snet_reset_dev() never even sees that the device
failed to stop.

Return the error from the saved ACK value once the completion wait
itself has succeeded.

Fixes: 3f3a1675b731 ("vdpa/snet: support getting and setting VQ state")
Cc: stable@vger.kernel.org
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261005044915.264532-1-oss.patchbox@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/solidrun/snet_ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/solidrun/snet_ctrl.c b/drivers/vdpa/solidrun/snet_ctrl.c
index 3cef2571d15d3..1c3b5f2e44990 100644
--- a/drivers/vdpa/solidrun/snet_ctrl.c
+++ b/drivers/vdpa/solidrun/snet_ctrl.c
@@ -291,7 +291,6 @@ static int snet_send_ctrl_msg(struct snet *snet, u16 opcode, u16 vq_idx)
 
 	/* Check for errors */
 	val = snet_read_ctrl(regs);
-	ret = SNET_VAL_TO_ERR(val);
 
 	/* Clear the chunk ready bit */
 	val &= ~SNET_CTRL_CHUNK_RDY_MASK;
@@ -301,6 +300,8 @@ static int snet_send_ctrl_msg(struct snet *snet, u16 opcode, u16 vq_idx)
 	if (ret)
 		SNET_WARN(pdev, "Timeout waiting for DPU to complete a control command, err %d\n",
 			  ret);
+	else
+		ret = SNET_VAL_TO_ERR(val);
 
 exit:
 	mutex_unlock(&snet->ctrl_lock);
-- 
2.53.0



