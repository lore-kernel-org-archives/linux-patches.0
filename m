Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031629;
	b=Dw88AdMDZa7VNEe+DWjuxuoNfbBVronnvDJBiX8shld/E6bJlDYN9yM3+vvy9ucDUu6x
	 b9a3LAe5luR/PNJxnBsJLzNTFXPpMdSWxdFxlenDtoaXIh65zauK5Eg1P31SXMVmmDl4X
	 KXyo7yIB9Ybf3yi0BiXIl0xC5IbumceKHeszynjKL4JB1YLn1LY/67eFxp3jGI0b0e7C6
	 2FJoZOur8IXiR4IFxHSAX1dDlec/01KfH7RWXX9zQh4ksTuJXFqmT/pv+ngT73gA571mU
	 ePbcpqjqyD5xVUbxOOAuyApBh+Lror0dP5MgcC1fqtfXIE52U+gRM4tTRNJ5/HOR8ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kjQWwy4E6thDsYr5MCpIYJQm9fMMx1zqGJUzsnIMerk=;
	b=QTQIYfIVIZNxve8mLZGSDvHXluR8S4qaaaxZ6GuFHbfjbVDtdD/o+K2y7ANGwNyBfnNR
	 SbfJHnSdqG+j129u38Gk3V0wNGldnxkwvTcEj0AEmETY8gE+b7lXb9WB86NIWtNsKrzcA
	 zh9bbKtS717SDYZe4vlJ/P3KFrf+Qo7GqZNNC2nZ2MqEVUQ4XliAlikvGj7ndGuMwh9cr
	 Hr6V+EejsNqbDLZW+Rr+2bRbBbFDXtGYuNN3MymluHXYXj02EZg2UaZsxW6U2U6dz0wRM
	 29a0lMZCWzCcc3UIJ1V946Z0RVatl38fH2dqN5QXe50d7LqoAmCzb2UyhqtS8rSGfDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1oTjgjs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34CC606A32A;
	Wed, 18 Nov 2026 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1oTjgjs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032321F000C4;
	Wed, 18 Nov 2026 19:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031629;
	bh=kjQWwy4E6thDsYr5MCpIYJQm9fMMx1zqGJUzsnIMerk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1oTjgjsazoiieF9bThFQzVXwLx3M0LxXYnwqvAaymQZEf/ox7vfryGz4/VdF5g1p
	 BYWwmSlqvrjuzpLqaHeBDjhWDTsdNpOy+dZlp5Pzzb2s5M9RHdacgpb4N7jLyA6LNc
	 rhVlKop6y20CDeuO5+xQ81KJF+LK5VKup8tYg3NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1125/1756] comedi: ni_atmio16d: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:54:12 +0100
Message-ID: <20261118150054.884864628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index bf7fb6704710f..54371df0b4301 100644
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



