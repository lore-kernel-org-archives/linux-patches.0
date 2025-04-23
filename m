Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780C828A1E8;
	Wed, 23 Apr 2025 15:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421309; cv=none; b=Caf527GG0bldP1YeugE+0xPjsyEUsTI/jJ/ZZovsxsjfYVHTbRAo+wDE9VKELo+oJymMLD8UcUskuIlNTxnd1nh/Isy66n2GMS/r3QGkriuepYenrhCOpeGVdP+DKcmGE6ankqzz9pIUq70kKWRuSrTFlIt2r9MxXZokdEQy/Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421309; c=relaxed/simple;
	bh=PfbNxH9D4joNxQoxKvf0ZGvZrZinRRbXGSSn0AbSKRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHLUdyGNTKwpHCeBxUPix4OybOFHzgzNVF3Kx73ecO+EclQgnpFCj3RaFZn828zAH7pxsoMHSstCKMuGKr1D54BKT0+OecN4S2u6NHmCq5U5KTUwSkb+xMl7wxVJcy6kWrALoDy7OPnWgZbMR7BARGLiWtrhfFpcI+Iz1t0/nl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML1qrIW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML1qrIW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E04C4CEE2;
	Wed, 23 Apr 2025 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421309;
	bh=PfbNxH9D4joNxQoxKvf0ZGvZrZinRRbXGSSn0AbSKRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML1qrIW4bbMlCossj8jIS9DXejKu3Y/4VDtyX102pzjVPkXRummBAcFhkBgJBE2vP
	 UnttWuBnhClJ+aRXWneHAszOFB2UxAlGkIVE48hu3zWIH5ZeVuoWDoao0TvEueDFVI
	 s7kfaoBvitPLP03E0FidV61go4KFvQPNGnV9+8Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>
Subject: [PATCH 6.12 210/223] Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
Date: Wed, 23 Apr 2025 16:44:42 +0200
Message-ID: <20250423142625.716103796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Tsoy <alexander@tsoy.me>

This reverts commit 535b666118f6ddeae90a480a146c061796d37022 which is
commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 upstream as it was
backported incorrectly.

A subsequent commit will re-backport the original patch.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2533,7 +2533,7 @@ int ath12k_dp_mon_rx_process_stats(struc
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_dst_get_next_entry(ab, srng);
+		ath12k_hal_srng_src_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 


