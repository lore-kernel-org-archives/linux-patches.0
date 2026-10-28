Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214295;
	b=poV2OGSLmhDfQtwKhL7YqLRcNbSm7bI+lXPHFKnrpUNdZtUexnq5PvIH4b1WszZFnuHJ
	 uWfrv0xsHVmH0Fi9gU1FO0S8bYncO3XhpbbdSP4zPbEOYJDMsgjmnlUKoJ7GImF0ihiA0
	 DLHLAQPokvH/ylC+/TFMZD9KR/RN7aNB/e3mIl3bEMY4P/+CTcv0CJkbsRiFfpmSsYI1O
	 hDaNYUNm8/TF/PvnIKD58yY5gUR8VJ1R/dGXaMkRW/50VzTKGC61WiRnat+j6jXOEiSFo
	 jtu5rxggP5oce5kbipMQsiAldnDOS84o8Hy7G0NAmbZcIPCzhSkJwle8Jay58eiQJFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otlP6laHUVRug/ySGbiXMpQYxXAz4/LR3ouEhqzVfoY=;
	b=1YGg9HkpqqHJaN8YNek0nLGne2zUmuqBkcF+q1EopVQpCaSL/ZUqdRwsbRCIhtNkIEJs
	 NmrHBTC7W/uMjVgC5MtnhNlQsOG+BajNiwn+yGAIiay3XVEfjDy2fVoQ236ovutr6kmy4
	 DJGmqcPzG5HtZ8EM1u/WJYe2kx9gSgWodcGz/Lfo+094m4YGNJkrbuOvlU1ar2Tmc/YYU
	 97Q3KHqF1G9YdBBg6/hmS4Br/tGrsog42oPiBSYnBtveR9KudLNPznUhgPTcsiMMzHQF4
	 6IJAy914e9XVoT7zngOum76qPGRnYs7AmvcgQx4GJ20pMOBApjK4/08aJJ5n/NEdrCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEHRzHPC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAC7606A334;
	Wed, 28 Oct 2026 19:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEHRzHPC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F631F01825;
	Wed, 28 Oct 2026 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214295;
	bh=otlP6laHUVRug/ySGbiXMpQYxXAz4/LR3ouEhqzVfoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEHRzHPCoPUHP8kHF3dsRUP3vtZwzEpUPVRjj2V5k4BBqA/1aXLrNEob8HU6HWjfL
	 gArX7VxLP6tWMzHTuaUhavU2/Ctd0ZFpo7DzJNdZZwVy6jTN6+B563mTkzrgie0F+k
	 63K1zI1KgoaXOwSCRWxDhuewPtW66/BGAaEuvjbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Sumit Kumar <quic_sumk@quicinc.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0806/1887] bus: mhi: ep: Update read pointer only after buffer is written
Date: Wed, 28 Oct 2026 17:48:22 +0100
Message-ID: <20261028170517.770511258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sumit Kumar <quic_sumk@quicinc.com>

[ Upstream commit 6f18d174b73d0ceeaa341f46c0986436b3aefc9a ]

Inside mhi_ep_ring_add_element, the read pointer (rd_offset) is updated
before the buffer is written, potentially causing race conditions where
the host sees an updated read pointer before the buffer is actually
written. Updating rd_offset prematurely can lead to the host accessing
an uninitialized or incomplete element, resulting in data corruption.

Invoke the buffer write before updating rd_offset to ensure the element
is fully written before signaling its availability.

Fixes: bbdcba57a1a2 ("bus: mhi: ep: Add support for ring management")
cc: stable@vger.kernel.org
Co-developed-by: Youssef Samir <quic_yabdulra@quicinc.com>
Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
Signed-off-by: Sumit Kumar <quic_sumk@quicinc.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250409-rp_fix-v1-1-8cf1fa22ed28@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/ring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/mhi/ep/ring.c b/drivers/bus/mhi/ep/ring.c
index 115518ec76a43..926a158bb22d4 100644
--- a/drivers/bus/mhi/ep/ring.c
+++ b/drivers/bus/mhi/ep/ring.c
@@ -125,19 +125,19 @@ int mhi_ep_ring_add_element(struct mhi_ep_ring *ring, struct mhi_ring_element *e
 	}
 
 	old_offset = ring->rd_offset;
-	mhi_ep_ring_inc_index(ring);
 
 	dev_dbg(dev, "Adding an element to ring at offset (%zu)\n", ring->rd_offset);
-
-	/* Update rp in ring context */
-	rp = cpu_to_le64(ring->rd_offset * sizeof(*el) + ring->rbase);
-	memcpy_toio((void __iomem *) &ring->ring_ctx->generic.rp, &rp, sizeof(u64));
-
 	ret = mhi_cntrl->write_to_host(mhi_cntrl, el, ring->rbase + (old_offset * sizeof(*el)),
 				       sizeof(*el));
 	if (ret < 0)
 		return ret;
 
+	mhi_ep_ring_inc_index(ring);
+
+	/* Update rp in ring context */
+	rp = cpu_to_le64(ring->rd_offset * sizeof(*el) + ring->rbase);
+	memcpy_toio((void __iomem *) &ring->ring_ctx->generic.rp, &rp, sizeof(u64));
+
 	return 0;
 }
 
-- 
2.53.0



