Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062948;
	b=q6xNdTu9NQXPNCj4SoQMt0PtexCcYXpw0MCKvlWyD2CHItIsGSf1mjKbRpH0jA7ZY4ww
	 aytIc26r8Vk8h4hDHnnwrWX7TDvPj8wNlWSb+JQwVeg3tS8PmeEunJ05b7TY3b5nC0X6Y
	 /XA+CP5KLDwAxs6hCB3moxLGpFCum+e3EjTLzJIiX/+qooi+y14RfaLRWDL27c2BQYT0W
	 xX3lMW9hI/Qfcj8gTBin8dRnAm36Vf9dvqIa574RXM59nkkDmzUq74yuAa9uZ+EBv0Yi5
	 TyKOKskGzGQxHXYrU74eieGISRfK3LtTiAssgM0W4kKDGlIJrgADSWvIEVRRB8OIipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Fk8rrxk7pNktPPHvFi2ylFkTVGneQjmS478AczL7MY=;
	b=pvR38tVcFyMB4mQLFe7avnapicnc3X/a4XDFRM3OxYZUaN/6jOT7Cp7n+dMSMMepqIWI
	 C3pHP7p2W3io1gIlaj13xDLK5Co3uhP9hlwiGoxOSw/xGnJpKCvV98+u6p0Azev7S3Llq
	 4q/K1oIoiVcn+nGVZbf1cFiMhaeju6a4Tn4ONEKqZw5BLU8VGNpPnw6Q+x6V4ZI5mOpR5
	 6OFqhIfauCQblDI+4u9iy3btO0qi8aTun5ZWVYCUdLY9nh5WF7Y/VmLx8AxAc7d5TmuoY
	 +Cvmc4PuHT2tZ6SJ0vfuYiytk1nA7wjlJgmaadkNLebdExYkw0x77an7ZKlIJoBNiSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wTSPjmX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB77606A33D;
	Sat,  7 Nov 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wTSPjmX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9061F0089F;
	Sat,  7 Nov 2026 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062947;
	bh=8Fk8rrxk7pNktPPHvFi2ylFkTVGneQjmS478AczL7MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTSPjmX12eic9EO9UkYXI6YaIJ0c7hM+929J/d18eAFTQpbSrIEGjP4iRcaBBKA19
	 jIcADOerqppjUHiHGKNPMPjzLZbI8PUUwl/234ULCPrYvZvgUmV+R7Yu7IPGD8XCSk
	 r43h32MUKXE4iHVB1Bs8cx/WIMJAPIoXSXWhFaII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/869] media: tw68: balance PCI enable on cleanup
Date: Sat,  7 Nov 2026 08:48:15 -0500
Message-ID: <20261107134859.175475466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit fc02261fdca3ea95e4dcb6b38ab77f0f197c3750 ]

tw68_initdev() leaves the PCI device enabled after a later probe failure
or tw68_finidev(). Use pcim_enable_device() to balance the enable reference
when the driver is detached or probe fails.

The managed disable runs after the managed IRQ has been released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: e15d1c12c587 ("[media] tw68: refactor and cleanup the tw68 driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw68/tw68-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 08b7ce1043aaf..27ce670197cc3 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -228,7 +228,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	/* pci init */
 	dev->pci = pci_dev;
-	if (pci_enable_device(pci_dev)) {
+	if (pcim_enable_device(pci_dev)) {
 		err = -EIO;
 		goto fail1;
 	}
-- 
2.53.0



