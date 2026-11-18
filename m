Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061579;
	b=mBUZM5T2snBgMmjfmiSYf/roQx2d5yGqWWkV66of6q5yzHul8yi0qFh8SiyfpisFiBwC
	 v2wYRgZcZiGKlz5IpEZfTR7Lj2LHsd3ysCURduEgK5D0G7swLOL1bOKfZaaLcGG3aqia8
	 HRST68hJ8CXOKwIcmBGMdkCLQX6L9mI2ZkTyMwrvCSCcwi6jMZ6c92CjQaI1fzgZ80UBO
	 O/ERFLg+ELoGTSmCxSjbBbFw2CVE5lfYkd1eaSimFoZa1gSJetHdk6ObCRItklw3m8Kay
	 d/JO+f6gOv4W+ZcTJzyvOUGlHzuOmOrEyuqz6fHJ/O0CIpF5KXCyjiqpkbpcGWQ9K3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9Ao98khvnzMZHuOU2D5IAKZcExqgSfZ6T/bbwoHOPI=;
	b=N5E3LzBLjIStj1B+f2LMQlB1iqMzaMFvTfiH3MXkUZ2mlfbnhFFnQJCaEOxPQSrl8FDr
	 4UjnUp5j/O3Jz17FNzoN4uXGoMMSMV04QUdWftTQubm9Btm87wg/PVPRbvfTpzvyfNAii
	 //seHihpT5t7uD/TwE7Y/fGx6XuJxThCvYKOqdx8Nz+GiE02CMBAOt601f0rWZdEQPVDQ
	 V0jUJGA8PsekIuCrUvVoUwYZ7KjEDkdwbw4jbukifFvps2RSjeOKQK7LlqFjg6BlkbX5F
	 4qBesh/MPvC/I4gBtEVP/rDr/ax3v7dAIuvYOTBW0kUHMFxL215TTK8RhICpEaUI+Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJN0J9Td;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EBD60A2605;
	Thu, 19 Nov 2026 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJN0J9Td
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B32E1F000C5;
	Thu, 19 Nov 2026 04:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061578;
	bh=u9Ao98khvnzMZHuOU2D5IAKZcExqgSfZ6T/bbwoHOPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJN0J9TdyM4Y8wE8dYSFlNKofvRUaNHrv0/rrD2goyU3qVV0oo8oblLjOV5aLa5cb
	 xRq4GblrO3VE7alu5Sxou08NNKyecXscdOJTHP2q5vIG5mfGUAjiC54JCQevI/SJag
	 qKv98jydNZXqYbM9s0i9InC6LdmEgu60/RDH5tEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1596/1848] comedi: dmm32at: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 16:00:34 +0100
Message-ID: <20261118150026.302869819@linuxfoundation.org>
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

[ Upstream commit 797d56d7f90864e67424f8e82639a9b3aedf37e0 ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. dmm32at passes it to
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

Fixes: 3c501880ac44 ("Staging: comedi: add dmm32at driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-5-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 85a0f58c134ff..a7304c5502c94 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -585,7 +585,8 @@ static int dmm32at_attach(struct comedi_device *dev,
 		return ret;
 	}
 
-	if (it->options[1]) {
+	/* only ISA interrupts are valid on this board */
+	if (it->options[1] >= 1 && it->options[1] <= 15) {
 		ret = request_irq(it->options[1], dmm32at_isr, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



