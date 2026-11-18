Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019806;
	b=sNMouMl3mgBjHORVueIO/pYDMzeqOusNpkfRvxGCHw0GlFR3VKm7KkdH5fi14l2cM0er
	 MQjKVdwWj6hm6qY24amYpOUB0kPYPdeyF3C/FEwHtotfqjwYgMcxW7d/qem0MwVAjGT3v
	 /SY+iAeXBdLiOa0KNf6H4oVI8vfGtAA4gZqysfERJmcy0viSlNyZ/nWZpXHsU3Pw+bbgn
	 lTCUKZRvWlSrMACe56xwpIk47uWsucOG/wLbguFwg8mhw+YXfqdrktZpVW9hf4ATCopuS
	 O6mkYw0I9LU5nddYpOaAmcDt9ajOheyat+zHpho02NWx025zFRON8ymeqX4ShJQcQGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mn9DivL4g1S2KdIHpdG/i5ePOiWjLaXcq+4eJDtEFe8=;
	b=4yvYkzxa8fyWHiDI4joc4Xh1Qk/o+bMQje0tr0ijZrt2ODgUQa64DriMEzg9vEF0Vmtb
	 iCRXWoD3q4ozINmECY0oaIxHrNl+EAuVAvGn+gdIeqKb0rnFof6aU3tM1U/GLsUbConlD
	 HQUk5Zv1PmgPvOqkZQnPoRJu2Fk2JuOmDkf5I3Svla0M2FsE5kHSMOsNQSNb4CcRzsMpc
	 w79RBX0yBDF/MORRuDBcTYPX0Co0loB2xI76EyqNDncfa5SgwCXVrxgXsifDM6BIYlQ9+
	 X8asjlwFBwI54R9AYUjQJ2t1MF4gskd5pUbehBOl1Ax1/9EhabdtNjn84A0z40BHpfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dntV8vc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3748B606A325;
	Wed, 18 Nov 2026 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dntV8vc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7531F000C4;
	Wed, 18 Nov 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019806;
	bh=Mn9DivL4g1S2KdIHpdG/i5ePOiWjLaXcq+4eJDtEFe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dntV8vc80UX+CuavFed8+h96dsA9Gx+DHJDlLUABRDIQKAnOiXXXRce/guOLY98J9
	 9X4f8tegBqZXmaKkpXe3jrjG8touREPYxgJVuh0MW//3QSvgLo4p01ClnJOEQa371o
	 2GROA0dVYhgTC9iivDJ0IbaEOUBSghfEKe1JaTeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1727/2651] comedi: ni_atmio16d: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:49:27 +0100
Message-ID: <20261118150349.799381604@linuxfoundation.org>
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
index 6765cdc276cad..87fed16b112ce 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -593,7 +593,9 @@ static int atmio16d_attach(struct comedi_device *dev,
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



