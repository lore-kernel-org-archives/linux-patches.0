Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036053;
	b=i53psKrycJlEEViMjl+dinaq74WlZSnO5NeE+lhiuEY88ktRU+PSSKPPbYwHg4UQzXDE
	 VAsLZxSVkqF0c/JaHWy5bPSz6VKfmkFrRMD9I1vp673V0q9H8JsgdKbqv04JH/5gsKcGa
	 mjfqeKf2aPo1BeW/FHo2zQX30jEC/VuXx8/9phdRM41duoA8UfK5E6Mwv+J/UAS2X4yNp
	 FDrCDsqAQGpUKrEMbt7tz12bqQQBVXRhf6pJ7c2txmDwzi4dQFIK+IWRxNnHYWd1ukKIg
	 AcIEs2Lq61J1BQv5UWpDGHIShKHLhuffbTk2vMGlkUsWTwMfHIpfpLgS8smO1aiwKAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hlmhEWcMd8JVl/jtHgvP5JKtqoad2KsfryPZuL44MX8=;
	b=Njn/DZVbHM8352238U5y88ldE4zF+ThlXUa11xPL4CdhP8kwFuYbU7f4KDdRocqzInu2
	 Oy225L0A33yMrVnGQWCkAG7u/MekBR5ZOzyHwPgmZ80ETIWEJQUpCczmo77Nqm5dsD/JV
	 mK94XL7bsVoEXiZ1kd5+MMKO8/f+oY+6kX92Q2K4XP20KL9ZACZYqqfbdXPwX/kZa7Ogu
	 7YcaXS//FyWnYTRMqJgmeOFc39Ho/EOujX/FVpcfeE3aJbFpky04TOuqWb9wbtkFyXY6m
	 z/VdOnYSqRuixjkIOQwFue8e5cSwLlD0Y8pZASl3TJUvABevbADOkvvVAWtyocz/hFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=imDpkBV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D552B606A31C;
	Wed, 18 Nov 2026 21:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=imDpkBV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E941F000C4;
	Wed, 18 Nov 2026 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036053;
	bh=hlmhEWcMd8JVl/jtHgvP5JKtqoad2KsfryPZuL44MX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imDpkBV1qiS0ygRSozKxXn5AAJq0fL88+/AAQ5pZksU28W4ru2O7pL+z6xaWMBYrv
	 UzMtk7N/69dz+7BM9sz1sIYk2Fi5+qsbcuUeyMeV+OrhfpS+keOwhhjBa/3zmn7A2Y
	 lUIpCFhUbjgRknOHtcW5CAR2PbGjqh7tFdE44T3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0920/3318] media: tw68: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:25:42 +0100
Message-ID: <20261118150347.128133113@linuxfoundation.org>
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



