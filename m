Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060744;
	b=hRx95Ka4/2Ch+4+xY/KMs+PFpJDVLXTOlxUbuE0urV/Q8e4I3LBzV8GLfuNEgySTbaDC
	 Wg1cNwIwQh25TI8dCD1fye9rpNCEHwAWjAeXhok9nnlyGCsM8+W3igfQejgHSn6sGjbvt
	 rCsXE5aVYyYXiznOfQ0wwNPPUzYAWYP3D/8BYvRtpwG7+ALHINeJmll5qVMLBPcg+YqOJ
	 cNcWrz7QB2L8wO3GtmiqIGSyBr9lZGNN6rLOg83B6I4v3K7ve/qs5EM7noHouspWjdgYn
	 /4xiaHtQqYJs3lqxbFbb9XtaJVRab1FXFZlel1HMtZ1rLpoEeHYk1HnxTsNQ0PhS48Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8yZiHElVxqLG93wBnh8J+7qQ/w08ZKJ5kD0NjDMYM/Q=;
	b=Evq/fj0qMOcuoPOxe94kNR+UMqNtlS1j3rY4d6uV/Y0OFUreuPxQTMYemEcOLsTq5IP3
	 1rFFaKcNGIa16f3HaOgrhwgEWhAo3DgpwtyM7ygHnGEDxIXhC1P0t8IdRdm6IVqQ5/X1g
	 ssGvOD4c63qwwUpimolwADmYP7e2rG0Pqr6FSrpqRynt+rRB7AHI0Ay377VGJvLNi3Q15
	 RN2KtEOikck3iIlJhQ1ktDL+whZr75lQhTaif41gCsBJjX39zODO3hoy3BlhqPjUyMopG
	 bwX/ATj/PezohTcVlQ1u7r60VBkedp/lpxizAxS4iWQYrpcEawyFOkHIaRSVVDyE46g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AHi/8AHq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEC2606A326;
	Sat,  7 Nov 2026 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHi/8AHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F41F0089F;
	Sat,  7 Nov 2026 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060744;
	bh=8yZiHElVxqLG93wBnh8J+7qQ/w08ZKJ5kD0NjDMYM/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHi/8AHqcZnpn4XNlA3lK3G8PL6q2HIUEVp1lsMq9ET5phiKKvPAU8wBZt3bbGS9v
	 hBlZ1E9UyIMFOImsCOvhbJ2LPzMBtmCNF//L8kohzL3MtFxuOnO6lZTOf0JL0BXPDx
	 DK01GJgYwTn5peMB9f/dNhTi1x0yIFOww1ghIZqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0159/1536] misc: ibmvmc: release send buffer on write errors
Date: Sat,  7 Nov 2026 08:36:15 -0500
Message-ID: <20261107135002.141326970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



