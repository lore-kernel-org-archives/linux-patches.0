Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061557;
	b=nCDg+6MdB+G5JvrVi3xq5QIcXiufInA1wnKaxiQ8lIgqCxUByek+md6Z/0aY9T5F2YgQ
	 5hhu1WzOA/zlIMqnsy2aE8Vk9trS4ycRif7p8b4cahtMyQG4syd8HKwqljphAVcztWHua
	 +QxkLf1KMjoMwQylY6OCSVlH5aDQvkAr5cDbBfrbdeEvtC/ZWaKsV642E5m9rxrH87+U+
	 n7m75g4KtNmbA52BRVdjjfjByNDtDSVHuzLIq6p69Z31n9O7aZdMXTYhwtjVyqeV2O6sR
	 kUIYjaxHY9yVXzM7UiaD4XoYny9rLeyIlVXUDNGAs5ci+CWEA7SlG2Mu2pKYFym771g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bs7GCfWfYre2hJ0mdMCPqSCXbiWt9YSjwaNxg2QcYOc=;
	b=CXsbzNQxcG2m42o9Z9Sxlgwojd+DT3SDPS9okP3VlybfJb6O9KaBSrVqrvmPpDA03QQL
	 z7Z8DFK3FELbgykdU4kHxjGXacSZWYMZifNqa2zjwXHEB6qE/MEIf6z7Pn8dFFeM0vnPY
	 GMY3/W7UJ9UI8qckHr3FVJ/Tjlq2VStQMx4zjxRtsiMcaq6YQ6D1R4h0TX8/I5IM4Habx
	 Nht+ecvEy3/kHn+17LLTEGngbjn4gYAodqxZ5wPvi3nfxHjyS/pEA3CmllISiTPKC0Bad
	 M7mf9XhPg9M/Heqr2utZ2Kh/RHb+3Z6JzBaL0WmWJ2D2QGrEOeRmJbmtKAvIiX3Nj7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHpTCuXJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFB7606A335;
	Thu, 19 Nov 2026 04:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHpTCuXJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D291F000C4;
	Thu, 19 Nov 2026 04:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061556;
	bh=Bs7GCfWfYre2hJ0mdMCPqSCXbiWt9YSjwaNxg2QcYOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHpTCuXJtKFdlk7zmfiZ8pgjDT9+WHr3JtKWJRu4eQevh9fgh80Ztb92GFaIPiZtv
	 Lr5B1lQ+BtGKpd6Akr8aNG6AeKvpUjgfZbkmk7KkdHydCylZEiIqBatmO6opW4XjOL
	 sXmZJ9Ytmh4hUkK4seQ0RqmbT491h7pZKiApWBms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+690d666eb12fca6e1e61@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1593/1848] comedi: comedi_parport: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 16:00:31 +0100
Message-ID: <20261118150026.192525327@linuxfoundation.org>
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

[ Upstream commit 790ea6844593bcd03b0379986fc821d8c511746e ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. comedi_parport passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

A parallel port asserts a legacy ISA interrupt, so the ISA range is the
right bound; it is also sufficient, because mp_chip_data->isa_irq is set
only by alloc_isa_irq_from_domain() and mp_unmap_irq() returns early when
it is set.

syzbot hit this one:

	remove_proc_entry: removing non-empty directory 'irq/20', leaking at least 'comedi_parport'
	WARNING: fs/proc/generic.c:747 at remove_proc_entry+0x4e7/0x610 fs/proc/generic.c:747
	Call Trace:
	 <TASK>
	 unregister_irq_proc+0x206/0x2a0 kernel/irq/proc.c:406
	 free_desc+0x89/0x330 kernel/irq/irqdesc.c:482
	 irq_free_descs+0x84/0xc0 kernel/irq/irqdesc.c:865
	 irq_domain_free_irqs+0x46a/0x5c0 kernel/irq/irqdomain.c:1917
	 mp_unmap_irq+0xf8/0x130 arch/x86/kernel/apic/io_apic.c:1061
	 acpi_unregister_gsi_ioapic+0x40/0x60 arch/x86/kernel/acpi/boot.c:722
	 acpi_pci_irq_disable+0x275/0x360 drivers/acpi/pci_irq.c:517
	 pci_disable_device+0x130/0x270 drivers/pci/pci.c:2206
	 pci_device_remove+0xb2/0x1d0 drivers/pci/pci-driver.c:512
	 device_release_driver_internal+0x44e/0x620 drivers/base/dd.c:1372
	 unbind_store+0xf8/0x110 drivers/base/bus.c:244
	 </TASK>

The leaked /proc entry the warning names is the mild part.
mp_chip_data->count tracks GSI mappings rather than request_irq() users,
and __setup_irq() takes no reference on the descriptor, so the irq_desc
is freed with the comedi irqaction still attached to it.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: 241ab6ad7108 ("Staging: comedi: add comedi_parport driver")
Reported-by: syzbot+690d666eb12fca6e1e61@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=690d666eb12fca6e1e61
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-2-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/comedi_parport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 1a7dd9c186ad7..782579692b1d3 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -241,7 +241,8 @@ static int parport_attach(struct comedi_device *dev,
 	outb(0, dev->iobase + PARPORT_DATA_REG);
 	outb(0, dev->iobase + PARPORT_CTRL_REG);
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on a parallel port */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], parport_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



