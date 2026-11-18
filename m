Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033783;
	b=u5gH0FDu2y/snLgG37A7V3uxg2JTaAJ7Y9SJTXrB3rPAEbLUZeQoQ2lmuNb/L0DOa99y
	 PtlXRYI0z1NwV/bk8kYcfh5OFf3hG5qGKNsDuOTsII9N0bpCCidIBuPA99xoAwg4o3V37
	 ushhdLel/OkOBEosvz6uw8FM4gWb8gY8S7rZd4nmMWHQdUKMV56FQUSlKSRyPCNvOfoEi
	 ImGDSsoPqZRXUrm27RjupUK2cDq+/Rz2NjuOv3N2kXQnoJWcSABVXcwSpq4vP6S9I1M4X
	 TF4spSDZurZn1w0vtIIy8JDbiBPfbqWWwXSBBWlNtLMoflZCL4U9+ApGV6nB9lMu53g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNsWdUZCOjy1QRuij9XTtFmejXRWyL03iCamfubr7cE=;
	b=p0qeQnFHD9MyzPZm3hzV8uxl85MFSWKNr0qCRS6/OxGFnPNxpBbtuDoIzR88/HGRZWDj
	 fm/hFz9xCL7/5IGtZVRsdB+jh3PramnDZuPpI4KzWg49xE7jX61MR35MauC4N1voqBSFV
	 ibzqVbmvP0EFrQLTOZlhpqOVCLIZ04Vw0slXJ7UlB/C9dgXh8zCVZJvCIyKZQ+uwUZptX
	 aRAQIqEfdX53nPTb2lJMfb+xLsmWv37tfYJIaKrGobDq9/Jvg97oSQvMSemJ9/9NeISVC
	 uxtPIyZQLlensqA8tToAD0tF+n7F0T3vipct0rv2THR//IBbpcBLGv0lxxKHBluF2Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJgtY6S0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64674606A320;
	Wed, 18 Nov 2026 20:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJgtY6S0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7CD1F000C4;
	Wed, 18 Nov 2026 20:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033783;
	bh=lNsWdUZCOjy1QRuij9XTtFmejXRWyL03iCamfubr7cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJgtY6S08MYxadh2j9q85MF0X2KdmspiHMp/UUXHzUG24Ryfxanh/VkrYMh4OzNuH
	 51qj2XSTjtwjyb5yMpm66wkvn3pGh/GUfEdxQDZK8lFoj5OtZQ+NQ0epZgDoTG2EEr
	 2fYfdp39hfE8NSTDs0i3sis0lxIEkD6zGr7/U5r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0137/3318] misc: ibmvmc: release send buffer on write errors
Date: Wed, 18 Nov 2026 15:12:39 +0100
Message-ID: <20261118150318.546368064@linuxfoundation.org>
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
index 2101eb12bcba0..06eae39bfafe5 100644
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



