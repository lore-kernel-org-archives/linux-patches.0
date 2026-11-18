Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049619;
	b=Smt+BOfSKiUukm/6R3lMZI8/8A7NXXxdn4XjJbxEF4ioEOU+QyZU+bhwXEPkddqxB7tL
	 geHMr7tYWHfW1RAgLd0zhixsUJVZ20syVMvjBCQJz8Uia7xRTkOhyZ3g07/mIY5KEGIgW
	 DyzILNr6DMQhmwpytSG6KALUyruR63i7Pox+VJILhQdIkcnbBzOZn4WSsdg+6r3uJk6FU
	 B+4ePXJ77GKWBnh0QtnUC4JL5v5NL/tqUB81MNLlmSDu+00n7LiEHXqU6xPmqWHOiXNZa
	 xN50JdJk2H/AecpB9P6T8mWZjJdDw0LuIRq2IikuaQFjqEv0roDSkcwsyFVbzW1aXqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LNE8ZkzlqtiX+pHrsDuD7lC9VnFXn3ZxDDUZRahPOD0=;
	b=jH63rC8nqJQSI0KTLoaFpz8dXzpg8n+AfD4nxOYH7nN+vNQZzlYJkRkh3y3uJYltbYdi
	 rIdZtro0Yx9UU2vybr3p9yTdouH5t4u6VdDB+8wug1KWK2knUUATWrcJNOHMgMtulSnn+
	 gUBAIPjsk0HlsGa0x9oSWGnUXIoD+TbuqAGslsz8ADF4kF1PT9/mWsXEb2uIxvxZgMxi6
	 lwf+Mp0edr5Z1oeXIhZgXMLCPMAj6ZENcaMaczCZdvB8adIAF1LcKwuXBSmA8+y4uEOzB
	 3vL1J9SpqjBKrFIRiuD4xk2PpVRdR27fnNQBToUypfo8Fsgv1+t6iYfSoN8qun3vEJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLVextQZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2819606A325;
	Thu, 19 Nov 2026 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLVextQZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B531F000C4;
	Thu, 19 Nov 2026 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049618;
	bh=LNE8ZkzlqtiX+pHrsDuD7lC9VnFXn3ZxDDUZRahPOD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLVextQZZ97DRofK/7oOJKRDCJik3OscdmqvaU7Hr88WzapIKuJLm08OfdxlgBCoZ
	 pyiYmGqgQ4nxYA/pbcoYLugro7WFj4PuKUyJg3pr9fB257l9qmXoW8gtejgxsu1z8n
	 1HtfU0rTZE9+ku/9KaFERwPJaVByIzH9fCyU+724=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2417/2857] comedi: pcmmio: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:57:31 +0100
Message-ID: <20261118150328.581874272@linuxfoundation.org>
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
index db9cb3fedb48d..cd8b02e6ddc04 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -683,7 +683,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	pcmmio_reset(dev);
 
-	if (it->options[1]) {
+	/* the irq is configured in software, so any ISA irq is OK */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], interrupt_pcmmio, 0,
 				  dev->board_name, dev);
 		if (ret == 0) {
-- 
2.53.0



