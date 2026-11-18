Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041385;
	b=sv/67JwwbUKJ0qMticztXo6rX9xBshMQxphiqtlyLmqsjSWqinrKSF5FrS+5ZytvlM6B
	 fzg8oq2tdZspBePpqtGdMWdqKptASu6csQhaipB8UwOigoJYFcj5rJ4caQVEX+KBqozqn
	 ZndknGOeK1uS+telrPPOKkTuvIsgLLGDdNCZnekvy7qUnUwAKxTBMRkUehU+Dp44yy5Kx
	 riqFtfvmQXfZzCcD0MT1l5PgOtz3V02n9wc+Jf+/iWmCtjNZvqdj+VK/LGbyPOgaBA2Eg
	 CKtC3pdIpUsnnVXzd59akd0AQeZUHJY7PAYUmfUKNS2hDHdy6SuYCXzVbkBwNlNBxNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WpwUTmBajP4bUfPGG4uEZ0Mk2b5+VNu8TyZ6cRwx94I=;
	b=W6ipYkyeuQZM0FWTkqV4Odh1kE/ErglduLSI+vsODJ1AWsSIKaMWeUokv6dO8wReWv0G
	 F536nAR2QatJb6jPT/WqOywucZlXUnE4xoJGMjxNrQqsTuW9Mp86lXusGrEZpFx1dh49U
	 6HSUuC6XpScUvW4qtWfssUwlrckmQehxtEZJffxt4b4FmsVrHWLqpwGu9/iFvmE8DXTLt
	 0+hawnnsDnnffnfLQzB7AH+WjQHZRyXHQU/YDqtmRVVSDr6KrPH2GmwFPTjQ70nlwQYgA
	 qN5A0HgHZiYPM8KBo3F6HQ2hG+oq/BZtRxV5WxSUIDJk8nEPWJA9f9A+OCsxkcEBSmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GN5UC/xd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC9E606A325;
	Wed, 18 Nov 2026 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GN5UC/xd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360D61F000C4;
	Wed, 18 Nov 2026 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041385;
	bh=WpwUTmBajP4bUfPGG4uEZ0Mk2b5+VNu8TyZ6cRwx94I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GN5UC/xdP4Vcnnm1nnvvzW8quxfPpeUX9L4YfQc4qMehEk30wIT/6DD/UzGop0g+3
	 R4wCsutBrFlL46rYcSDFwPWyRLuRko5fH5Aq2blIrNbqoGSzdW7Qt68C89BZtVmSp8
	 12rXQVVCw4Nxbi5QX7CJ6GYNhkNBDWelrsoEtKQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2794/3318] comedi: ni_atmio16d: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:56:56 +0100
Message-ID: <20261118150444.504223132@linuxfoundation.org>
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



