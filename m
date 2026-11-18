Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041228;
	b=M0ONnTm65RDKhq/pSoTGnEUezKW72i8+isMdpYwrpqDxqp3E0uA6YBjFdwktKNpNkT6U
	 VphZ1pwqeYrRXmulWiKsF4pTyQuQ44FMS/6Xb2KFoRx/86AvNDjo3aBiI8Sb/EICyNPwe
	 QRfvVwoQctyjaV/3GUUhGINryO4ky82JDXy7g0xKwTGrQcYrDS8KisdqEoYKpHHTm7FlT
	 zhXt1QEdu7KPAx/MWMmf9HCqE69Luduc5XRmyY1Z7LLqPMDENskzI8/ETqQwRNtvZsNTt
	 JTK1J1sLTCOcYwKU17HgYXSVGUsIsPeEQqoaM+0g27o3+ngTqW64RsFmlpbVnlZ3J5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kkET5gHZkCmjeVC2QjxkMOHvuIakzKlRzE0gKtlAe1I=;
	b=Nfnr+TuVS0TQ7i2Q+MM1ogZaUqluaudaiuoQipkMkR37E9QCytSKQgaIXq4y5nrozbwe
	 oLzLO9J5rMjCUJ51asPb9xLWIuBMQ8SIiw1ld6y9j4J5DrmGmahVw1GSfx31Sv6LEDw9c
	 F27zN0aBR1mFx9i3nwM5sxYyaiqvUzFu9Io7qqh/y9kQN4Sz9b187y6pB782xmczd9tjv
	 rCpRNlU6Nad+LEkjDj+Vg/LRi+fA2znSTKOrat73X1j6uMrOpCvDD4iUVAhBjjw17zPIz
	 ATPAdCvsC0HU/MCVL+Un4RWLeUsiT1PQb0bcvyqSZxkZNr2qsN4I+Rj6msLYR4vKIXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S38h66cC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B63606A325;
	Wed, 18 Nov 2026 22:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S38h66cC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9939C1F000C4;
	Wed, 18 Nov 2026 22:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041228;
	bh=kkET5gHZkCmjeVC2QjxkMOHvuIakzKlRzE0gKtlAe1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S38h66cC+5kTpxaFrr4Az+qO4DUOBLOdCkAmGTP2Rjl2eHESE6Ba+9EL81fOxDMjd
	 F4fhpg1IbKmv7tBjJRFG2SejL7WIwAS+i5ZR7NWlLdmWHMcN/Ya6FRgYrsBm5gMkiy
	 RLBF8k1jmyKrtb49RqicVQqHxGE1GqSZZUBIlP2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2738/3318] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150442.933857166@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit a0ab2bb269e7fd8523f87950b91a42a36c7f8f2a ]

GSI completions queue notify_work to invoke the CQ completion handler.
CQ destruction drains hardware events and core polling, but does not
cancel this software notifier.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index d26a9b30ebb34..6b14832173d4d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1055,6 +1055,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.53.0



