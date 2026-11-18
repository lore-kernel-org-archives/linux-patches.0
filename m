Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054388;
	b=bX8dOMhjJYsjH0t336L22iOxh7IXE+LKSQZ9ZXAJs2tRDKGxcsaztWfJczt2qGnjJVuq
	 nLmRFNZyc+nPLbcYzm428dQbVv34KuU1SYRBxeLRFyzNtdwWAPm8bbjkqXA9bJYu5k73S
	 y2TxHzRkZotG4/rkOhyA/2POh658WbpLoIcJI2daBTHOfW/nuxmNwUKE85a+UEjYKvUbW
	 C40Fs/NryCy+tDzeYOAE3QCVlAXmLQ11ZoS50T+jCUC6V6UqZfPvNTk1ZlymqSGXWZVyH
	 0/tpzMm0bLUBYdoocrstWs/2kf/BAKDLfhAntkVXY2TMPzL8nXzx+L2fuRhFJ8oJanA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CWVkcU12rd9Tgrg2B4hF01SB9fnw2gaCPQLFLU8ysVc=;
	b=x3SmyRpedRhD9gKFqZ6OcojoEby+H61LtBNJDEl65cIbKejh2RQqFEN/6kCvT5dJAy27
	 ggQL+0/+bR5DBtprc1fpn8ru3aRXD7AwYAcGtgnvwKDdY+t8j7zRVWkNGeRobfQWkT1It
	 mViqW2w7HhMD60SZZ39Nan8QTIpOXaQ/i2kmTqpNQX2zi7HamRwMKxdy54Sft8qCCaO9R
	 1DbTM0oIl8yxfYp4UhSSPm5BH5BlE5lg6jUIvJ4hPI43Uk/J2aUKVQ9sJHIsRSSFemHic
	 jLfLe+WrKV8kF7UlVQgy3FH8IBWvP2gite1NlDm6vPIiHjML03gyY5JWPCSVQsR1MAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Nox/kIhN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47D3606A325;
	Thu, 19 Nov 2026 02:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nox/kIhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B8F1F000C6;
	Thu, 19 Nov 2026 02:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054387;
	bh=CWVkcU12rd9Tgrg2B4hF01SB9fnw2gaCPQLFLU8ysVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nox/kIhNIRGOjK4D/bhlzPcYr1hRcahCZ/npAl+GIXLNUXA/FVxxCAEUZeg4fmJRG
	 HDKyDdRUn3VtEkVteA0mdBfLkYHWi2OAswTVZTXyXvEhDoKFVzSy1+r1KT3/4lARQE
	 c/sbjjOWYpGIUMPrUnYWgJmvHovIfPkRxpCmpooc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1257/2214] drm/amdgpu: enable Navi 48-bit IH timestamp counter
Date: Wed, 18 Nov 2026 15:48:53 +0100
Message-ID: <20261118150101.947960771@linuxfoundation.org>
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 8888e2fe9c77983a9644cd9bf0d23ca9023b16d4 ]

By default this timestamp is 32 bit counter. It gets overflowed in
around 10 minutes.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 146b96974b33 ("drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
index 6aa1884147c4c..2c42b9a7ba74b 100644
--- a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
@@ -160,6 +160,7 @@ static int navi10_ih_toggle_ring_interrupts(struct amdgpu_device *adev,
 
 	tmp = RREG32(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_ENABLE, (enable ? 1 : 0));
+	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_GPU_TS_ENABLE, 1);
 	/* enable_intr field is only valid in ring0 */
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
-- 
2.53.0



