Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99DD38910F;
	Tue, 21 Jul 2026 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660391; cv=none; b=iBgDtK3LEctTlddMvwtNXW/wvEqCQWCWKgz7wIwNANVZEbkNJN+/bP84/pfc/UCXedZ6zd4BpEQ6Io2E/ZEJLtuu/fY6+kgZH0y5u4y1wsMqM/ker/FrDhrByqINeAfOCp7053KhyMQm0AbNIdXWDCEMLLps0cGEJHNTIBj+QrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660391; c=relaxed/simple;
	bh=Tcq3NikTG9jgZTxs9dbH0jnV3nxZQUn9BY2lp90lnQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rmUOHw3tn0UoSkOqcNZszr2FQk9PT47Y6IGSM5N8ZEw+HKdQZBw/rphOLn4HDejpytfZuU9mOnLm8t/gay88qCmc9Fd02VZGeffg2hJmM3w/DR8YfEZiNXDQV9c2+LaNO+UC+IIntcyZiwq1/5/FXuvlse+e8GzUX38ZsPSjONU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kD8iy2qM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kD8iy2qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2131F000E9;
	Tue, 21 Jul 2026 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660390;
	bh=2i3hM71rxgyN1DFbSBeatoYEOkOGXpLa+flHGtVh85s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kD8iy2qMT+YIS1NJQ4o135LJVRLPMEh9H9BFnGD1gVLvrsYqF3rAVKGyPZmPmN1G0
	 HWV9NW8MNFU3EhBoOLd1BoXNkLFwbkjpqLQtw6M0yDNk9xREilUZ+WkSeH9d2bzb9k
	 VCvvJppaLY0Bn3IcV1sfx3MR5TmEco8JyPMA66rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0960/2077] dmaengine: dma-axi-dmac: Properly free struct axi_dmac_desc
Date: Tue, 21 Jul 2026 17:10:33 +0200
Message-ID: <20260721152615.464066243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 4910ce1b3b35687bb2a5e742c4bfbea3c647c980 ]

Use axi_dmac_free_desc() to free fully the descriptor at fail path when
call axi_dmac_alloc_desc() in axi_dmac_prep_peripheral_dma_vec().

Fixes: 74609e568670 ("dmaengine: dma-axi-dmac: Implement device_prep_peripheral_dma_vec")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260424-dma-dmac-handle-vunmap-v4-2-90f43412fdc0@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index 45c2c8e4bc451d..127c3cf80a0e50 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -769,7 +769,7 @@ axi_dmac_prep_peripheral_dma_vec(struct dma_chan *c, const struct dma_vec *vecs,
 	for (i = 0; i < nb; i++) {
 		if (!axi_dmac_check_addr(chan, vecs[i].addr) ||
 		    !axi_dmac_check_len(chan, vecs[i].len)) {
-			kfree(desc);
+			axi_dmac_free_desc(desc);
 			return NULL;
 		}
 
-- 
2.53.0



