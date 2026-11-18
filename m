Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058270;
	b=C0AKSX8GgcFnITGxRIP4kfuaaw+jcafDol4fhQm2Vz2vgB9tJfgQAKdPgzB7Cz0p3lYT
	 J4F/SaC7Y7gCWPs8c59+0sll8qyoMNoDE+xRO7MaUkeDM4WJNi1MnaJuwiYva1Po9X1lU
	 eFOEYWqjrAzwOzYRIqDGo8IShC1DQOHf6PVkfm1Qcp76UM10AM7jfG4tIZgJOa5cNeldI
	 V9VsXPbPHdKJxfvKIivCKOk68rj53EMD3QsXER9EuR53FPJ+ThqzcuLul+cnbfpYlmsAl
	 4/0/vCNpFaAvjj+L1f5wP2m0Y1e1Q3X0a9jRAoOMhCw+Rypxglou+eXiISoERcofCOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmgBR5aSn5P1U6j1hkqMGbb+zB+djqDk6UWMtkNncpM=;
	b=AU3sQthxmPdiv6uRFWFUj/sUZ2uHYl2jctuHV8LiS3YzqKdMbsOSULZtZhnR3ph9LHYG
	 LqRwAbB8g07dJCs0rH0+Tl/sFK4qUnW0yHTFr3+XACokEt1lw/LyzIqkGtnxXbwG45svW
	 fscOQ5e3ZqIFRoe/NQ5RnwcOxpKOIYgNOye8P9T4tFVOQ2l/G7eMhumNWUOIXZg4gZOFJ
	 wzku6Dgq8F9albGMI9wUwq+pehkaJpQxjlYki12iDmagRNuPHp5XrppJhlMPFNtr34M1h
	 cc/ayXJf8GvQvOPZj7AlSGg4+IXPFnLkIF3DtMshjKDcwGj500qrbEDeudFkhrLL/WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHBO2S66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4CE606A320;
	Thu, 19 Nov 2026 03:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHBO2S66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385891F000C4;
	Thu, 19 Nov 2026 03:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058270;
	bh=RmgBR5aSn5P1U6j1hkqMGbb+zB+djqDk6UWMtkNncpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHBO2S668F8H6sVGkTs/0fGMkAXNb+Wd0wQmwrVk1w9KVRMqC6A5QAtnxn6JMBruj
	 Pn4M39RZTEZ1+rtP2VBbXG+khv0lM2WfmtpMj1XZUigkeUQA7074d6tia94E2Mdd9s
	 OdPmxHmzQHmxwQlmDgwwFA1Iz6JFdsPMwc8KVsyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0425/1848] media: tw68: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:41:03 +0100
Message-ID: <20261118145931.940924486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bf15fa7c0ea18..ee65b89d1a4fa 100644
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



