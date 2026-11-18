Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056110;
	b=nwEj2Wg+hwo3KajrUauX1ydRWInB73ny/sZOjxXTmaC9Ug7rq9H+rtQW17unsKhd8qdQ
	 UUy7p8eyiVjQrDvPE6hXiQoTfvVsqxdXENTniy4mHBHVnEX0BrPTXxtf6dKGX7oAxtwpE
	 qxViqK2BhgoLAKl9belK7BdQ7OJ81A3rUtkv8aCCQVHMOezGCpiwzHtCvcJ7d6iLFlImq
	 8L2wd1v4zwsf7WNG+7enTBsRQ9Mj+RGReCXRIaSc9vlqdNOrGtnRM2jBO5ldYFqbMAISs
	 1+5gmbB2nYjCQU9cIAY7QI8fVxCYLiSU/9seQb+DJfXIUEKYAM1GEfGaXXLoNTBOlkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RPhVKfcMV/2C7Dg5tk1yb20b/lp88Y3tCrlt+gOc/yA=;
	b=NzMuQ+LKOBkY8PdmkuRDKqQUvUudzwCithdsyb3x9RWfzjsaJBPjKhFk7E3b5wv6uJ/u
	 aUS3RejUKYtj15mKInjodbBRu3jPsCY8fp8byhRqi/Bnjb/l7rQ02t5MEhS4Xa1oLxoU9
	 yOtWeVKqe7s9IvFXZRTSg5cGsmfgbiLqGDAvOaOUNS+Vj0EWXCLhYiIJxZFyP1VxvW0ab
	 ItlB+QbuDtIRVnolGFpMWxC70ps42Sh0XKWX1f5nWz2K59PhNv815GA6fzwLd0b7Psxda
	 /vvToVLPPvD9sMSDHsm+cka00e06jcWaTdUgB9OjbUG/8X6/Dkowd/MQ8x+zhnykwBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18fYxbl+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CCD606A325;
	Thu, 19 Nov 2026 02:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18fYxbl+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7F31F000C4;
	Thu, 19 Nov 2026 02:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056110;
	bh=RPhVKfcMV/2C7Dg5tk1yb20b/lp88Y3tCrlt+gOc/yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18fYxbl+kS4RTu+NG3G1fjdQz+27arqg/jqFXFBhIYC916IPlKtVny6Sj8AH2qZDh
	 F+2spwcfQsWlNJBKITwbx0nCpKLbC+KVn2fU+x/YU0LhumiqKYkmrFuUbv0pH3f3I5
	 qIYS/m7Bhzb4PptAq6WzpeCF2oftFVSD5LkdEOUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1872/2214] comedi: ni_atmio16d: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:59:08 +0100
Message-ID: <20261118150126.174456027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3b2e714b47249..897413fb86ac7 100644
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



