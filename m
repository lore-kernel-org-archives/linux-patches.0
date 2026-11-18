Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019808;
	b=W5jloWRfc8Kx7qT7RI8TU7NhZBAuocrSga/ZDUZajpu375qCtskkn1Lo2pz/RAEPyj34
	 SaQKF6Fwp60xgHwAWALn/EwYv/VVus94NBcD0amE8+1GqRy8wDF3JQXCOZRg8y2yaMq00
	 So97W/G4daT8FZdFsfz/TR+Gl0X1C720Hoogv0bMLbVW90BFb4HrUapKsoKTs4z5bEV7F
	 J6uq9thJ8lol9z2WSWROvWcW32nb12SmJeQxT+AAlEBzfz6BTSmtTebgXUrKt6su+apwG
	 QD2J4q4ziykzSwjtcuzs1x8es5XTM2AB+2JVUiqNVoZGI7kChvfjgfALxqODCpSvI2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTRT0D5AWSLYNGR0Z+30YaigqkDW3qle4SeqdT9yVDU=;
	b=RIy5V97slQBqjY8JSvAPWrN9474yL6e1ThF5xFw7Im8JB4PCS8sXdxUJnHZq512VWf6d
	 o5b1BU+Zqf5lrIJkgMTXL4yQwM/RhLBcgQCKcw1SuW/AXOg1UrxBuzsVi+sTjb8aWj0ij
	 0oNfj+ljg5H1dp5XeIiKkFNj+m8iaTh4maTQV8gdTRCJPUnAgfrWTnfKEvyA4X8yl6InM
	 xsOB7IccZwWzSMTrl7MUQvyqbsxGRPpy6ITK9g84I4Gq6ghtfvNYCTqTCa5nD0WBlv/Bl
	 u0nK1gmYrFoQePnN51vsDiGTBVmhbPtDeOHL6BuMKIg3OuAUUqGZT0xaC/doAxYZiyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj0QJWwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD14606A332;
	Wed, 18 Nov 2026 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj0QJWwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FB91F000C4;
	Wed, 18 Nov 2026 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019808;
	bh=bTRT0D5AWSLYNGR0Z+30YaigqkDW3qle4SeqdT9yVDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj0QJWwWU7wOU51HzUQzWS7QBINMVtUkrLJws1OdYfWnpvGG5s7ECGvJ+KLtxkeij
	 Mq6+3MAHutIpBOPqU//jyqlnZyzVM9WGclSGHoq9+ybxUcQzhWcaPeYkkZutkjgJRX
	 35O0mQEpBHpoZigmnbxoL0vafO/ulDAlIU+BAVF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1728/2651] comedi: dt2814: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:49:28 +0100
Message-ID: <20261118150349.835084898@linuxfoundation.org>
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
index caec16482afba..63b7f17691ffa 100644
--- a/drivers/comedi/drivers/dt2814.c
+++ b/drivers/comedi/drivers/dt2814.c
@@ -316,7 +316,8 @@ static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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



