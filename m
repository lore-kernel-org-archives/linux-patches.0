Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062065;
	b=F0qxh6gh+H/fPeYHVo3dRiFxbe81C+HgfOAFMsSUtof/IdMtQ+RDzX1SHa/d4Zsp1U9q
	 Sli1xSVjTOgmCkt+CFMGsDN1Uo3W2mcumF/iadgqGtksLJcs2ZOsbctJSH4v/7lPr4Lq3
	 MBfmJdkFHW+7H6qBRA00NLxrIm5nsGkXtqD5tUHpV9hM2wz+AS9Z56O6UB2188N0/KlOT
	 xzlFe8mMenRqAUsJ7ch8DA5NOxOwnVoCFxi8nuvDtRuM62rRfGlM7k+NMIo00WhmeEMGa
	 5JtPx1ZVVb4/mQBOo1Y3LUS4HanaVw4NhddvPHMH2EHsO8hGfUOI1X0TAe0lZPCQVcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D55TV0F6pi356WNd1dk69oequciUtKwfBGGRXBc5vQ4=;
	b=GjnX5TDg3Lgj5oyU+4cUFdjeKVQ/4+xD0w6sA0BO9sXzDvUkeOX9zvdQaM6Y+s44qQIO
	 DNdsbIYVEkQPY9xLtkLHfhbDaZWOqqrSNVTT2rcEYCNkHPJT1tiQKJI2NoIdbM8iTvmkf
	 J1MP7ZdNW6wFY3GYtsS97RC4HoIFLlCRCueUZB5cNRtqufJE5nW9XuWHGThDXyQOBjHiZ
	 SNxKFti/zKJpmCaEGPwaNSlgJQOf8Mvsv0sIvVccCbflP4PzX6sAema55WHr8KOf4ttMc
	 sFqoj+rMyzikH56s47Dg5MciKjIAxYIf5pcay/hEcz+BxV+XY+O5I7tCFLLra6qEh/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQJG+wiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620CC606D80D;
	Sat,  7 Nov 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQJG+wiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104DA1F008A1;
	Sat,  7 Nov 2026 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062065;
	bh=D55TV0F6pi356WNd1dk69oequciUtKwfBGGRXBc5vQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQJG+wiPephqOIyBuc2yY32eXnB1f2DxL3onxWCkVr0QZK4PQ6aGqy1QWGo0g0/io
	 JzHTnuamR1JQV40n/gB7alnPfmI6RNivvwn7lQv72RgpZ8QnYzzznl0v6Apzea2H9S
	 nPpBiUdgtSb4TlQ7l/sGv9pJp9/ve1xdcB/OqSRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1045/1536] media: tw68: balance PCI enable on cleanup
Date: Sat,  7 Nov 2026 08:51:01 -0500
Message-ID: <20261107135027.027054440@linuxfoundation.org>
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
index 35dd19b2427ec..577035fdd7c2d 100644
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



