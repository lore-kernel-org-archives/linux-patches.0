Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8E629B231;
	Wed, 23 Apr 2025 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421823; cv=none; b=ggj2ECWclNjsxfi/tPRd9pWCnlRcRX9v8MBw9/Md5+AsQT2q94PH/nukdBztgwHlDT+jM4yAveRVJZqZYSIkDKjAKs7kUCgglQd+GETW/zok5X6DRYBM4KWp0fdd6l+DVHNSmUukBDIiQw3bQgchla9tOOxUMrp3jG3x9fqX/2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421823; c=relaxed/simple;
	bh=e8vB4UEAberaVf/23GYKRa6WhLHopQu3CttAgidp57Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRg1qNEj9oe4xJypN0ZcTMMnLRO50FKYEThTGMYNeXacBik1bWp4Pha5si2WgxnOSdU4NWoMrKlUo0HmFKPAuKnu1KI7dn6cdIYQgWDoafAGuccUuCKS2h08cxVMUHDKZiwdVmHThVQpDgoeC4hZeao8bFnXVEQSALqoCLbrl3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoEQToae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoEQToae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F604C4CEE2;
	Wed, 23 Apr 2025 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421823;
	bh=e8vB4UEAberaVf/23GYKRa6WhLHopQu3CttAgidp57Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoEQToaeX5osUkw/MqoN65nnkg5j2VDydh4HRSHca2tB6yp02avczpVn443GWM0oX
	 j9bPhPue5/bMKclvH8OXINNVVYZGmhCDsKP5TD9MglURdzpb+C6xo7GgHS8MAFAgWD
	 V1maoie9jDmO+I7lNajwjGbZsKgoRuqZM0/8pRfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>
Subject: [PATCH 6.14 237/241] Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
Date: Wed, 23 Apr 2025 16:45:01 +0200
Message-ID: <20250423142630.252533049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Tsoy <alexander@tsoy.me>

This reverts commit 0c1015493f0e3979bcbd3a12ebc0977578c87f21 which is
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
@@ -2473,7 +2473,7 @@ int ath12k_dp_mon_rx_process_stats(struc
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_dst_get_next_entry(ab, srng);
+		ath12k_hal_srng_src_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 


