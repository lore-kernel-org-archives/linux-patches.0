Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618026;
	b=IPzru1zjPwrFQtzBwDi4LoHqTaJCmpnQgEbLN3jNr3Mp8oq8wSkRGBn+ra2GGE9WPeHc
	 VLGBNAkxkclUApSDsBjJxUHGykMIlVejS/EBTJcb4EX+bo6XVftBkhMNl1xEInKH9svjR
	 lND9N42TU5qca6MJgWXrwX1IBAZ6LmN+/FG6tEwvvhkRaPYh7pNkrfBbGhwpXyuCQm+5L
	 qcn8vIQrXJ+7Qj5HkmlUczS5tvRrXrJiEblExI7JOm41oi430zFdbQ7bQLXG/lR6Y5Mtc
	 fd0hM9lh3N9PIgMr+7iwCFm/oHz4Z2oyjdN+/adXLrfjWffqlCYbwSNgGrCc2ootebA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EVd0ZNVwEvDBXkJYZJD3pgLljbXrBirF4JWdkMvJMo0=;
	b=4c5jQfmG4Mv5eK+mW53tWwHYcb8pvsnWMpKE3VUesuP6IsLntZYr2vRfXyr7QpUbZ67Q
	 nBavAjYo9CUDINIYI3gxGkKIwo88mSAwnI6rRefScUygNLBfl95+EO++faa9jQdx15fcM
	 n41nPuYvtLAVkU8f8QUF4EE1DSSw7dd3BGVMa29UW6YCnWB+UwpE9KzyTa2r8aVn0SmLE
	 /+fnWknT1HADmSm/isWNNpyXVdRYf09AZqLiUL3hiDhKAzfSrq6lICdgYFG5VECTMFFcy
	 hzWWB9wFpyjaswfqqVEOEIBCQ05FTBhEK8yvG/SeEnHASHGQWn3et1RJoi9XsJPPElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ7swt+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B6B606A321;
	Wed, 25 Nov 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ7swt+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F5C1F000CA;
	Wed, 25 Nov 2026 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618025;
	bh=EVd0ZNVwEvDBXkJYZJD3pgLljbXrBirF4JWdkMvJMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ7swt+31AZAFN6LoLrWsUTwuhi6TnORL0TFMADbiMDiv2YTmOVDMpsLhwKsFRZ43
	 K7UiTuLBIYAmtxn2Ego171QKXYwVlL6yrZseFgmBvzCMzIXDQHwn9FHTEoI3iQMKGy
	 1srfiMajbjHF4kk8XuPXIgP5tJr0EhYFnPjEyBpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0148/1005] sfc: ptp: drop the stale frequency reset in efx_ptp_start()
Date: Wed, 25 Nov 2026 15:24:46 +0100
Message-ID: <20261125143825.203190284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alex Austin <alex.austin@amd.com>

[ Upstream commit 21d4917cfc8b6837c44d8aa186941a6a16ec17a0 ]

FW does not touch the clock frequency state on MC_CMD_PTP_OP_DISABLE or
MC_CMD_PTP_OP_ENABLE, so the driver doesn't need to either. Doing so
just desyncs the driver's cached current_adjfreq from what FW still has
programmed.

Resetting current_adjfreq to 0 here means the first efx_phc_adjtime()
call after efx_ptp_start() reprograms the NIC's clock frequency to 0,
since efx_phc_adjtime() always sends current_adjfreq to FW alongside
the time step. efx_ptp_start() runs on every SIOCSHWTSTAMP mode change,
on ifup, and on the reset_required path in efx_ptp_worker(), so each of
those silently drops any frequency correction the PTP servo had already
applied.

efx_ptp_start() is also reached from reset recovery, but that is fine:
on an FLR or PCIe reset FW does not touch the NIC clock, and on a full
MC reboot the clock is reset to 1970, so a stale current_adjfreq from
before the reset is hardly consequential - especially as it is bound to
MAX_PPB, 1000000 ppb.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Alex Austin <alex.austin@amd.com>
Link: https://patch.msgid.link/20261026123023.3566549-2-alex.austin@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 6ca9a75af01d8..2247e5e3e25a8 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1446,7 +1446,6 @@ static int efx_ptp_start(struct efx_nic *efx)
 		goto fail;
 
 	ptp->evt_frag_idx = 0;
-	ptp->current_adjfreq = 0;
 
 	return 0;
 
-- 
2.53.0



