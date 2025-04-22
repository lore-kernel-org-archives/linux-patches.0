Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59697281355;
	Tue, 22 Apr 2025 13:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327252; cv=none; b=TVp7LWtwaCdR9lTCyU5qHWw+tRrjb9Owh0se2WAj/55rhsdxHtO12s/OfAztfgMXrBgyccfMPXptumlktHil46C0kc6npPhbnqtlf/Z+CVofjTIl0tb5hp7KZGelHTTGID9EIQHbAl7g4kpfCxEETyylgOTiOMacwKqUqFKxsTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327252; c=relaxed/simple;
	bh=ZkmPUtlLGPtyI9+L9q35mC4cMY+e5p6TwUpt4LCVhC4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=XkxZ1KgJz1dk2QtZhYbIgcpCH3lu54g8Sd8jFIdz9kkDIo42uFvd+QJLs5DXLe37PxXeqYRnHyD2nUA7FHbdaRAEtzGkIkA5luMBHo3mGCQrWeQmfHjXoeV/4jL36FqmVokXRjWTTr9wdgLfVbQfYr2Bd20VfY3QnBsxdlH7dWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDg8XFjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDg8XFjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1975C4CEE9;
	Tue, 22 Apr 2025 13:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745327252;
	bh=ZkmPUtlLGPtyI9+L9q35mC4cMY+e5p6TwUpt4LCVhC4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=tDg8XFjOwN0StzpBucZslkg8aZH79rJSERP3JMgjeH0RH3lvS34B/zETKdgmKWaRV
	 KIJhejJfJ3zjRHyPCWLQ/bsrklI0JMZLvqUCyv/gfjDff53X+bA9dRl8NL4WIr0M2N
	 wKDE+teOMuZ0bg8HwsDpbHUvOWnQqhNkNRkZY/mw=
Subject: Patch "Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"" has been added to the 6.14-stable tree
To: alexander@tsoy.me,gregkh@linuxfoundation.org,jeff.johnson@oss.qualcomm.com,patches@lists.linux.dev,quic_ppranees@quicinc.com,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Apr 2025 15:07:22 +0200
In-Reply-To: <20250422120237.228960-1-alexander@tsoy.me>
Message-ID: <2025042222-charter-battery-fefd@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"

to the 6.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-wifi-ath12k-fix-invalid-entry-fetch-in-ath12k_dp_mon_srng_process.patch
and it can be found in the queue-6.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From alexander@tsoy.me  Tue Apr 22 15:03:50 2025
From: Alexander Tsoy <alexander@tsoy.me>
Date: Tue, 22 Apr 2025 15:02:36 +0300
Subject: Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, P Praneesh <quic_ppranees@quicinc.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
Message-ID: <20250422120237.228960-1-alexander@tsoy.me>

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
 


Patches currently in stable-queue which might be from alexander@tsoy.me are

queue-6.14/revert-wifi-ath12k-fix-invalid-entry-fetch-in-ath12k_dp_mon_srng_process.patch
