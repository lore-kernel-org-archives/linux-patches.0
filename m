Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049610;
	b=Fu92hTQ8p9OShGDvmgwVYVBWRSjNuo3UxGRpjr4II6OkgR5uIujASSJRnRxVDPQV9BD1
	 +gq8ERuLjkDTAYIztpOi4rmJ4PyOWFEELjbbwX7cIK8fmN2X7COCLcGSaiex9DQGUZaV7
	 QL+K6Gv2qzDZ4uUt3/9YGug41Dasvq8qHuPCVRYlX3yS+03+nYgXYI11ubC8+68PxaEn7
	 KYq1xYjpBLOPvO6GOhnpmLP4UqFR93A3HEWIA3EupSwEZrxZbYIF5Itx5xMkPwfXNpaTB
	 rgBmqoaRKj5niwfadOT32PiHdOyTaZhJQqv/QPWdTgGET+b2DuCDXrWM7ZWyHifHIBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NV8frUFL9JLa9cu1jY9+cZHTrIC8aSUC/6wRsW388/M=;
	b=MLdTp5aIFWXwG10oAYY5uNJvetqr9JTDB6fihJErt6ZZkE0Sc5BT+3ExSviF+zTAOmB8
	 VWaOS2YCDrZYh7Kx55pbz70G86q/zt8wFTkAiCjB964eRfTtgRTBqd7cD3JFJT+cEZm7J
	 ZXZDNVG56+I76vyj6pNl4mfr5+V1gZGlqcmt7hM6+I0+3PUDsEIvdPRxVGBe4mDvZ1T21
	 kHkoE5mHK51cl5hIaLn2jMjnJqXIjiGJp2/RRa74iq68KYsNaGQlEYXyJmR4gje6TELcV
	 Aexovsie35GMmFIIlsmCAq7rDadH3D7npToDqLfDp+W+ak/hNR2RgkyX8fpzbdB0LEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIzXueja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C8D606A325;
	Thu, 19 Nov 2026 00:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIzXueja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9141F000C4;
	Thu, 19 Nov 2026 00:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049610;
	bh=NV8frUFL9JLa9cu1jY9+cZHTrIC8aSUC/6wRsW388/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIzXuejaoS571CLxbXdJdszCXNEFHHYEqRQUcBuhwqTp8y3wf+uiyJAqezZC5NVxQ
	 PjELlS0Du08AGfo9YHmO/MXThAF40SAMAafVaZOeM31p9eVGPMSAG70F0arD+3Jdkz
	 hLYxirv2IxtqrPQt33kBn/KHNnf7w0qXfo3gwnSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2414/2857] comedi: ni_atmio16d: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150328.468660451@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 71424db0ebb5f484fa3f386910f8ce9da95b8b2e ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. ni_atmio16d passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

The driver already documents which interrupts the board can assert --
"0 == no irq; or 3,4,5,6,7,9,10,11,12,14,15" -- so use exactly that set
rather than the whole ISA range.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: 2323b276308a ("Staging: comedi: add ni_at_atmio16d driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-3-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_atmio16d.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index b4c25a8b8d40e..c4af8140634a5 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -592,7 +592,9 @@ static int atmio16d_attach(struct comedi_device *dev,
 	/* reset the atmio16d hardware */
 	reset_atmio16d(dev);
 
-	if (it->options[1]) {
+	/* only irqs 3, 4, 5, 6, 7, 9, 10, 11, 12, 14, and 15 are valid */
+	if (it->options[1] >= 3 && it->options[1] <= 15 &&
+	    (1 << it->options[1]) & 0xdef8) {
 		ret = request_irq(it->options[1], atmio16d_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



