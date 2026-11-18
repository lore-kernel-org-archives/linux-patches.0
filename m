Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033675;
	b=s6op0Nq84ujQ9ZY1e/KqYyIeNstrd4nNwVrBKOx3Aa/QLwsaf5Nv1WPEGs8ztoSzt2JZ
	 RuAsq3hsJ+xv/YZ4hBOOYjNDEP9DCnT8hMhTiGB/6bCmVa2m7JkxGzK9hFJ7xhkK4YG0k
	 epuNloyg8olBLYD+BrwZHoARVXM4N0njoTdnm+x6tpsvHw24eZkxgHDnHGZlNdl4JWqwj
	 LqvGOAH2qAtbVJ2/iScDS2ETdJueukU48Qmw3CmKHFLTNN9mUZHikBVqyonBM862JZpqi
	 Q39M10RvNt/4VwXRXd1OP3dwCbo8wZDZjrFSDAzoRbTwcbJ1+m7ZHoajVf/+qk6gzxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n5ZeUSJ3upHnc+7U1ZxMj4l8BJL0yz91epxHHd114y8=;
	b=AzKEoVR339rTVFQSDLxQdBBHxAVBCr3YIiD1gMn9RKakPLHLiBj21bKtDd70a/cTVQtN
	 spwsRZLvVNkukKzYBPucrUSDLy2bUsiETfoNmGChiMOB21MT0MqNB05k4BcgyT4OjfSAk
	 AYwT4RQ+5UJH61ipZQW7MybguIY1XqKAhOYTCFjnS0MW4EdxJDgfH6Rg9KXRXdSmj5Tzh
	 A4Y8MATx5zgfSPYzK6aTVti5XD+lYWF/rPlyCTyrxSjD4r5ww8eFII34/+pK37YpM3U1I
	 tsn1rW01vJp6Jr1rPfzPXp0UGh4IsTwLgppknQd9U2AJfnHjsIbRY3vncjfTwYfEYGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTIXO14k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AB9606A320;
	Wed, 18 Nov 2026 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTIXO14k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1711F000C4;
	Wed, 18 Nov 2026 20:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033675;
	bh=n5ZeUSJ3upHnc+7U1ZxMj4l8BJL0yz91epxHHd114y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTIXO14kSfF750k67/NMfwIrdVu9BJUWDdY5KwHx8QVn/RaiMKNxb4Z0D/tEeMZFd
	 /cL4F5bBKigZkbzUiqKhB42ckcR4lRw9/Bbt1h81hqsuEj50BUGCPQZyPlX4s4AtmZ
	 EOe1Qplhi2dC84loSTifBj6SVPliF+Rk90SQyTMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0072/3318] mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state
Date: Wed, 18 Nov 2026 15:11:34 +0100
Message-ID: <20261118150316.202933373@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit cb3fcb8d118b874178251d1f02613f60d25e4ddc ]

When transfer was stopped in STATE_DATA_BUSY state, there was no call to
dma_ops->cleanup function, so the DMA mapped buffer was never properly
unmapped. Fix this by calling dw_mci_stop_dma() function also in that
state to ensure proper cleanup call when DMA transfer was used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index f97caaa829f70..9c7a16adeb086 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2209,6 +2209,7 @@ static void dw_mci_tasklet_func(struct tasklet_struct *t)
 			}
 
 			dw_mci_stop_fault_timer(host);
+			dw_mci_stop_dma(host);
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
-- 
2.53.0



