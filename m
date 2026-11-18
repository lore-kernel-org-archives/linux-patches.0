Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061609;
	b=1RWbz1HPex5374KTKt3hfDtfWA5oPDSleAi59RmPq6kr4ktdo+sbH9l2GouhiiMP4f7B
	 15X1OkwU3AGnG9OT1CvAtOloaM5LytsAcv+UbtK88PpnoVDgue7u/89pLHjawm60FCELD
	 aFSyQBHcIVm4n6Kp5RysD3tmNeJo0unVDPMrghCkZjjY0i48qH105+OF6YwVl2vt+nmuD
	 Uki+UbXH65L44Kgj2P77q9VnznptnxUh+C89oX+f56ajk8+zju6mM6pFkCjVYTTKY5SXJ
	 sylnj/3GVGcJVjAxR6Z6zW0yuGQXga4M1ryQrOJTpOEtqGlI/Bn9hKwc4K2YktfiB2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hg6YrlCBjFbY10nKclMNiN64mmhQM8iDzcE5wGEK4mU=;
	b=shhmgt04r3Uo4Dtw7fD3zVyvHcBf90IHHWU7piFAHEgqKej1aaZUvphNyAvtkqG5cfR2
	 Q2wiWyhRrXZ/wFGjvH7y9ReFhjCX/uKEr35UeCL5Ffc3S8cy0SfT/mZuvCEwkg61ypzgS
	 Ej7zdxeVo44LNJcZ+y+//cDDIvki2G/Io33LrcYiXu9OgzT4/wqVLzfL16AynN1xGpAyp
	 cgUFnER06R36h+wGGMojho0C/bEIiyoVB/1UjVWflvF/s1/vYNFA3qz+dDR4zzoqmfeFO
	 TdenpZ2ixiRI3AY2UndTZ3DVfowRjUHULgsVbudLEV0l+jNBlSb++MS8bSMMlP5azXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMWKwyhv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19CB606A339;
	Thu, 19 Nov 2026 04:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMWKwyhv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64AA1F000C4;
	Thu, 19 Nov 2026 04:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061609;
	bh=Hg6YrlCBjFbY10nKclMNiN64mmhQM8iDzcE5wGEK4mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMWKwyhv+FTVbjYBWRC7B/OZr+5URFSH0kckuIwq34/H7neKu2ysKP4Kb2FUycg6I
	 yNIt0az9yE4w80pURScsd70WOQHIfIY2byziHn/OPlX0Il5Box995+sGQRvzHmZ9Hf
	 BTV1TLMSvIVJZsxI2g6FHFm6GExfqgC7CSfoEPqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1597/1848] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150026.337437278@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 23c6fc62e754f8bc412ceb5c0d9aaa14f2c9ff31 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. pcmmio passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

The board's interrupt is routed in software rather than jumpered, and the
driver notes that "any IRQ from 1-15 is OK", so the ISA range is exactly
the right bound.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: 6baef150380d ("Staging: comedi: add pcmmio and pcmuio drivers")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-6-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/pcmmio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index d1cd4bc7f36e8..1ff08455d42fe 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -684,7 +684,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmmio_reset(dev);
 
-	if (it->options[1]) {
+	/* the irq is configured in software, so any ISA irq is OK */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], interrupt_pcmmio, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {
-- 
2.53.0



