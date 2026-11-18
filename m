Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019817;
	b=bYlOEDUfungvL8gQLFbi2A5rRSa7NvEz3Avyji5seJ4KXsl03L7uYmNBOEaV3da+YQiH
	 4z/6rSJOHy5uXZGdyTFEWGYUWADlJ5ZjRz97JXabmcmeQSIIIHdvWqfcK7qmooaLzXp5I
	 x6Uh7svx5Vv/RxTObxmpXFbU28/WsT3uHsbugh75Lx5m0cYSrllLc+YOctfy8ppBTvRCP
	 wnJn/ocXAppIis4uk8DVsDlkhyzNony9MiGTgzB7msrntILqDFTEkGVTjvWBbaXENI1pj
	 ZNCOwodPCrG+qLWUqOW9UOc/8u4hJilFW0zu3neLkQAmi9eT3Kj2e8iVfG67cgFbL1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iTx/muVfB3pbd8VGMq50ZWj+DFNF5rZlEvJtFQfi6xo=;
	b=OGxv0sJf3JNiIM7A6mHKssfqPgzRZUw7bsMKlDoCtnk9xhXLg6k03888nfZe204e4odS
	 hbWRPtYeUujoe14TN5XkJ2IGyUH1m50bfyegRqiikXNbHlIqo2LVZjX45HPCYNwnMKH+U
	 V1zCUDKm9QbC2i66qHga7IXdpfC+ETG8SFhxdhucl6Kw20KPv8fC+FTnHxi1C7lEi0u1E
	 wEGsYe+/fj1tb/15ajLaFrYJxXCQkJcTRXGPGVCN7sWBuRRVigqjZOkg7VzebPEXBAQTX
	 vqLRC450d/BOxiVmfwK/ML1Wu3fBQbZrNG+F2gT0cGzo7FquTvBY1YMrXsaVNzhEwXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPOw7JmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3B60A2607;
	Wed, 18 Nov 2026 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPOw7JmN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B955A1F000CE;
	Wed, 18 Nov 2026 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019817;
	bh=iTx/muVfB3pbd8VGMq50ZWj+DFNF5rZlEvJtFQfi6xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPOw7JmNg6719ZT05a+eM8FijM4BMit5KTXCLB91jJL9DOysWi39GNHY/nG927SKi
	 D5oHU5AIlFm0uHC8pnty7EEbpaUHdDFOqmof4tkQgGV0AHmUPzMU2jyvacIEDo82Pc
	 uA/EAmnxe7+HLY3Rh9G0qw+lER7cYly4O0Z+olbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1730/2651] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118150349.904919530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/comedi/drivers/pcmmio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index f42b7343b4e45..afe2bda916591 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
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



