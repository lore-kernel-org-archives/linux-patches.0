Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030445;
	b=pjiVVOMV2jYy/+v3p298+q4/3jHlylxqIGDWhYEYmYLlUyE2NZNbJ3I4/WbMa431n5Fl
	 Sz/qn1DQ7E4hrfMo060o6Tks/bbxQPQj76eXNsJ/tU4NGqpkyafSHL9HJbyvyk8rC1OnS
	 T3cHgea1i0Ok/dFtS7Vbp3Zv9/SI84025ce9d3vsV4szIIimv9c8lYdScwPoxOyRMfhdc
	 VlgDRwC6KHuQB7ePnagZNl745IKLBzC2A8z7QZMAdsjsoq9OJ9JIVKZxUJJwM9ud6WBJo
	 +b1tni11LI7dvQbgO/HKoJl5ILcgZAkAKd6EV5TNFQr3G9Y/IdgCygzn4c7pRHPbG0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xMnhEWm4jF+5Vkd2Lg7/FgZR9Z7h36Sj0vqkKpKcoc0=;
	b=kuyBJz9y7YlRJAQ4aHvwXa2M/w5ejuAuQ7jYS1o+yMJZDw/Xxe1MRhfvPuxSmac99KU0
	 508rfbMo6QnsJ3SBF07E5pRCWFt5hTRNYWzbz7Dxf4PIxyl6K81dmLmbxAfzm0DYqzSCG
	 GyozbyWyKHTGAINOttP3i/YDYE+xiVfGvbsLUYaUJMiSk9D69TuYxJJG5EIdgihCUkYyY
	 62fl/XSwMPYCflKS6Td7KSECphJr6LNhQoqD/bdQ80/PtTkxjXJiwu1hCpI8Lc4GUHTJv
	 F8d77y9LEwcueQ71balftwCQHMMT94HmektYVxAjeCelcXRX4MxJuA+yMe6Hk7fSsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lg/4T3V+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6336E606B10B;
	Wed, 18 Nov 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lg/4T3V+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B797F1F000C5;
	Wed, 18 Nov 2026 19:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030445;
	bh=xMnhEWm4jF+5Vkd2Lg7/FgZR9Z7h36Sj0vqkKpKcoc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lg/4T3V+TBn08cPrNWOwpjoIiTc7kpe9Q96CmuKxnZd6+pm0RZCqG1Xvo1clkWXPH
	 7qYy0O2ouHkPOwgO2Bn6dko5OG9gh63dQOwutzRVp8pUHxEaMDVLL6Dy//JZPqrZcg
	 F/JMu3jMLCcj5ZFsKv7YqSbM3jGMOmY88Xrfov9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0708/1756] RDMA/hfi1: shut down the trap timer before unregistering
Date: Wed, 18 Nov 2026 15:47:15 +0100
Message-ID: <20261118150037.528997091@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit a1c9d476c2316685f85fffb6450ad88d01836357 ]

MAD processing arms a trap timer embedded in each hfi1_ibport. Device
unregistration does not stop the timer, so its callback can run after
the port and its containing hfi1_devdata have been released.

Shut down every port timer before unregistering the IB device. The
shutdown form also prevents a concurrent path from rearming the timer.

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134151.1213-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 33af2196ef319..f9c333f22f4ff 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1890,6 +1890,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
+	int i;
+
+	for (i = 0; i < dd->num_pports; i++)
+		timer_shutdown_sync(&dd->pport[i].ibport_data.rvp.trap_timer);
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-- 
2.53.0



