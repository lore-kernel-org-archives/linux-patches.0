Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041388;
	b=dSsjh50AB5k76QOp1ip0akKozbtpkjPWwZpopktZYUYCqOB4zQfmIGfLbwyWtd+4IhKi
	 R6m4lamn+xtSZ09vOvGrpn3vLf1hNnDK6JUUgplXVmvnCd3nE6pqlR8aTPRFzBFreGl4W
	 0T86OWAxk5VUaZQ58tgpzHV6uRcdGcihduESw+jU5ZmITZkgFAWc/SUHcOkzatwgnJwjx
	 AnnalH2AbQ0k9F6cwTKwHeSpVfeGrca+Vqy16E+WI3W4FtknNjscWjQ+tTVBddIuu0wTj
	 pGVM+zqREF1pykrYEvJGkmMHcivc6V/h/vJZEwu1wWsl0LWC9agMDSR/peKsG4Eq6tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7h3p26KW/0ufbrrbbasFpILqr2qA3QI6ChLgccS2nd8=;
	b=VU7alJmYcUf9XQaYLPhGMhYhkal0KFRxdvkGuZlyPGmHHV+66SsFdtKyVn07CoUCmoeb
	 f7akwS51LoPLrPvw4Ps0uv8jhfcawfx2SCxEbSX67gmeov2hQ2Cq3lykeRO6ql6ONok8D
	 ONQI84aKqrLlEly/fVokktBzi3BDKDJ1/FJpesgy+tBOedX0rISb3/sw4AH8OKiRj7fDH
	 UKDTeWLQzaHjVzsuV+KAhj3cZPoD7CIBN6Xi3BzaxGv4dMSFPsUdqILWxBfxPSE7sUJo8
	 LXn3GLwaV8k/EevjiH0lZG3aHSAthXNK8mkdKLj2NCX+6AafAmUytipO3rLwW+9tDrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kv9SFp1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4330606A325;
	Wed, 18 Nov 2026 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kv9SFp1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12891F000C4;
	Wed, 18 Nov 2026 22:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041388;
	bh=7h3p26KW/0ufbrrbbasFpILqr2qA3QI6ChLgccS2nd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kv9SFp1+CKR3IrbmMr+pFTOSA2MNQeC2+aISfthUMI27AVqY3Snb+o4LrffRVjfV+
	 3vz9YeIoeIqgDuoawZrn+Rk6digF9a+utV4IBI/6aODe+LlIe/5MAIydve8km7SjnA
	 oYaOFz6+PbzmoQ3Lu2sLhPxlgaW0oqZW8EcX0gOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2795/3318] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:56:57 +0100
Message-ID: <20261118150444.535393440@linuxfoundation.org>
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

[ Upstream commit 81026c2b3f9096cdfdfa02918f94865629fb7f90 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. dt2814 passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

Every interrupt this board can assert is a legacy ISA one, so the ISA
range is the right bound; it is also sufficient, because
mp_chip_data->isa_irq is set only by alloc_isa_irq_from_domain() and
mp_unmap_irq() returns early when it is set.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: a211ea977a41 ("Staging: comedi: add dt2814 driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-4-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/dt2814.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/dt2814.c b/drivers/comedi/drivers/dt2814.c
index c98a5a4a7aecf..3e734e343431b 100644
--- a/drivers/comedi/drivers/dt2814.c
+++ b/drivers/comedi/drivers/dt2814.c
@@ -315,7 +315,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dt2814_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



