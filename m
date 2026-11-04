Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829542;
	b=F3GVXQvtuGx2fv4t/aEUWATuRadH3tg9AzO6ENu2e89qH0Mf+02XyqFBofYdsHuo3krD
	 9IeZShcnJyz0VAlOjSXsON5pQXbHhipnchHbEl+eriUKABtd5iSUNb+sqmazMfql2C58I
	 27swmMqMl4wXh3OGYERC2mBAusdnLw87qA3mBiw6MzawQTPRs932R60nLLW6dpdWH4A5w
	 OwJA9ME4RLvn0MCPHzkNpURJsDM8uao9fUIVTG8pbbeoPh8JgmGOemYTgIFEOZx4KV97Y
	 D4EvB+wyrRPY/3f/y3uD5o9M+gEmMOkoKtFFiFkIbg6RKu2+4dJhquPS894YlfxQkpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7bsHF5IPdnpLhLx8xSRyrRJ8h4gpm4YufZBHo9+s6ls=;
	b=MiD0E/W21XNWKo/W/c6FN2oJDMpy9KQGTbdlSmyKiKyiADSEbh63ogR0vTLhOS3Qj7hP
	 oa7Ds9/QhpcEJQjU6rqf47NxieVygAJ9jyygeoBLQvS5tpP37M2hvLSAX0MVtlat1zV2w
	 miG6HqorWiOH4dDqpRGOI9tRNMUW9AgUGJGVBCTYOvGOBCkKQrDuPR58BqZAMc/aDb6+3
	 3shaco0DHRIvN+eQSHFhby//3GBC2xkLWseczE7wk/IqwSoMyRNLHchfcummt9WEUeoCl
	 wLmuTKVD3ZXZzNaYvOD+1yy6ukpI8w6QwlGfM42kJexBj3N0tLOjgnSi/wBIaqG0FxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTcWASiW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64076075267;
	Wed,  4 Nov 2026 21:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTcWASiW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415D61F00A16;
	Wed,  4 Nov 2026 21:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829541;
	bh=7bsHF5IPdnpLhLx8xSRyrRJ8h4gpm4YufZBHo9+s6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTcWASiWj+7yw+2i67OQbFgY+8vPN1l3eKo95gpHNMwlgj1r7+ucd1DBY8+un95XF
	 PBAq68F0canyMcYqH2qs5qIQf1jSaHAEd6gAuN8LJC++R+py/oKjmqGCcvbueLxBtg
	 aPXfE04qCRoTHMInbeNBx5/Ky3LYr9We04G8lJFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0192/1005] misc: ibmvmc: release send buffer on write errors
Date: Wed,  4 Nov 2026 15:58:45 -0500
Message-ID: <20261104211049.172902732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index e5f935b5249d5..af84e94ec5f0e 100644
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



