Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043284;
	b=d4wRECp9Den64usggBSvPs22j7j4DTufd1amw8jROwQnesJrdSdC5tvD+ykW0wlEJIaT
	 8BKNF10myG3HicKr24Kwb5pRvWJTXWbJqpPljxkFHh7CcpJ+Reb9f4zg2grOkPWLgTUUu
	 NfhTqEc86G1kuipxijezftP96Kk1Cefg6LiBdRlBCAmEdzSXKRc+9IGIr15zs6ppSFjlC
	 sEzXdWaAmpRcwvPBAfOQXccFYILNeGRpM538ZtRKb6C5swACufPv0SLj/kjx6v9gRxwR1
	 yHPzlF+NwiQPqY4V+zQv7iozLbDbiEgnf9wJAEOLDTGFaBzPnR4jYnLCgiHdlYKG8Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wBf656c3j2p0bUTwB6yxeLdghmJJMmVVuLN32gIRWro=;
	b=lRoj504LmbDjCXJXFBtDgOL7HJiSqodPpTGeqyjdDYAg+hHmNzKhzR1nbB1Qjvxu4YCv
	 ZhNTzjt+Red7xeNZITn6CZT78HCM+/ihqRWmM8u5ucsWPV0I0a44Vrtg6xrFTh8fFMYgp
	 W5ETGbxptzHx0PE5aD8aQDLq2MHZcK2vjUXbj0ONCWD0cEbhhrT28PeNXMOm5jJzZYtrv
	 MfAJP6YgPATNki8kHGBO9xv/r2yazesjndvFwaF4qNogkocSQSXLvxtaTNlGnzsZ8qCNj
	 aH+IOrrHvMUsj/ThB6H6Qif5dYXMP9pD6/pcWIrShw5nISaz0UHuDz3P8+P56FrvDgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJg98+Xi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A95606A325;
	Wed, 18 Nov 2026 23:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJg98+Xi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2D41F000C4;
	Wed, 18 Nov 2026 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043284;
	bh=wBf656c3j2p0bUTwB6yxeLdghmJJMmVVuLN32gIRWro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJg98+XiYdszQhouuXMl5V3cz8NnXeDDKyzKzHr4I+e12aZcN6Fz+h4BhGHHDrtwA
	 2btOIqSH8E6Zv3CWamL7lSAcNigj34GE5iIrM+ZJ4AZlHmjYO2OEwyZDyPFoFaIuLh
	 G8L6nRliCTG0qkZ7KGcAl0iYkpFMkspM8T/JOjeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0157/2857] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Wed, 18 Nov 2026 15:19:51 +0100
Message-ID: <20261118150207.003350611@linuxfoundation.org>
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

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 99143433f7f14139ac373c553ec8e1317d0ae58a ]

The ibmvfc_target *tgt structures for discovery are allocated using
mempool_alloc but in turn free'd via kfree in ibmvfc_release_target
breaking pool guarentees.

Fixup ibmvfc_release_target to call mempool_free instead so that memory
is properly returned to the mempool instead of the general allocator.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-5-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 16f8272003e5f..1d83895b43470 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1352,7 +1352,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 static void ibmvfc_release_tgt(struct kref *kref)
 {
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
-	kfree(tgt);
+	mempool_free(tgt, tgt->vhost->tgt_pool);
 }
 
 /**
-- 
2.53.0



