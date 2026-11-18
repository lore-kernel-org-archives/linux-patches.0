Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043178;
	b=cR570/YffXcrFGwP+BrG8LBy/YxWUnUChe55+hUvi72J1aYvZBv1Q6bCZA8vMA43gYLl
	 wckEYRvkmDmVUe8Zpd4pqHNKL89IA7OYQH1+5PLZ+54j0D7coAT1HCFcE8p33b9q0Jhw6
	 QOl0aQ0zgeXs65ESO/GL7YMuHmpkOMe8MLc8ZCLgK1PxUZRLhE7vgOicCk00orWuSedCi
	 SGm/fOFl/Nf12MwuglGEm/oeS+fVAoMzRy4EDJegDtk//zW+2Aba6FPc62OCPVrl7QIlS
	 Fqx0mBz5SRX5xdbIwUMfMIJX3LkwI/5QFzOGZLfI3AhQpkRqvYDz/0Ajuew0SlSb1Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hmRWF4gSfCsRSgxGiO/g8aSl2KKV4bVs/kl65WylHDU=;
	b=FuxzFUEKRnc9YDkg8EUbR465PfyPT9Hh7y1Y+Hl2Y9gAyR3ljkAXx2WFw8PVKcdgHw/G
	 DKxXZkHTtN/lRlX0Z0fMzh7l0y6dcEa+mGsulOyIMmpF0hZu4Sgq2hf6Xdr8a1SDtC2PD
	 ER85bamCqJX16DllhscqmDU1Y3AFIkXcAzkt67Oe1ie/yJW7PRixfrLJpn+CAEEBMvyjF
	 60VxaqUW88Re/TkEq6X1s7kGTTWD05DeGPN1UAbR2D3IC7WIbytOy0UwEZHevTSyqtPAL
	 KB0KV+Eg9EKMwoyl+nkpOrmS+mZ5I4mcWiQWBFk5gAKuYIPDM5a7RCR62XuFiZ5At+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rD1pQkZc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA52606A31C;
	Wed, 18 Nov 2026 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rD1pQkZc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5AE1F000C4;
	Wed, 18 Nov 2026 23:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043178;
	bh=hmRWF4gSfCsRSgxGiO/g8aSl2KKV4bVs/kl65WylHDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rD1pQkZchYZ17SRLvQKa2mTzdQdG72BUQvtUBrvsziIY99yMi3bzeb6d0e4uvVLGV
	 4140NZ2qYYp8QF1rB2P0DvYyibju45ksIMcRW50PEUTuOpPKZlzeSEUswMcwqq3FX+
	 JWEDka/bJmODXVxsYSqh0a8+U4AJPVG9mk4LaqRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0119/2857] misc: ibmvmc: release send buffer on write errors
Date: Wed, 18 Nov 2026 15:19:13 +0100
Message-ID: <20261118150205.642004911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit fd62c1f591372f7dc4c5bc041569c2f0a4a86be1 ]

ibmvmc_get_valid_hmc_buffer() marks the selected send buffer busy before
ibmvmc_write() validates the backing storage or copies data from user
space. Error exits after that point leave the buffer permanently busy.

Keep the buffer pointer until ownership is handed to the hypervisor, and
mark it free again on local write failures. Also report an RDMA send
failure instead of returning a successful byte count.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624185925.2133-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ibmvmc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index cbaf6d35e854e..d7e6fcd1ecf92 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1040,7 +1040,7 @@ static ssize_t ibmvmc_write(struct file *file, const char *buffer,
 			    size_t count, loff_t *ppos)
 {
 	struct inode *inode;
-	struct ibmvmc_buffer *vmc_buffer;
+	struct ibmvmc_buffer *vmc_buffer = NULL;
 	struct ibmvmc_file_session *session;
 	struct crq_server_adapter *adapter;
 	struct ibmvmc_hmc *hmc;
@@ -1130,9 +1130,15 @@ static ssize_t ibmvmc_write(struct file *file, const char *buffer,
 	dev_dbg(adapter->dev, "write: file = 0x%lx, count = 0x%lx\n",
 		(unsigned long)file, (unsigned long)count);
 
-	ibmvmc_send_msg(adapter, vmc_buffer, hmc, count);
+	if (ibmvmc_send_msg(adapter, vmc_buffer, hmc, count)) {
+		ret = -EIO;
+		goto out;
+	}
+	vmc_buffer = NULL;
 	ret = p - buffer;
  out:
+	if (vmc_buffer)
+		vmc_buffer->free = 1;
 	spin_unlock_irqrestore(&hmc->lock, flags);
 	return (ssize_t)(ret);
 }
-- 
2.53.0



