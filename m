Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84580280CFF;
	Tue, 22 Apr 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327244; cv=none; b=J93Oqn6vGqfuk7Ewr+FdqE5i3vdNVDTneU5RYWcpPTzSOhvbWw3cYoaXxgqzjMHcs1Wl66QbYci/68tEahW0ehu5CqM5CavB+/DTkL0JgeOxdYw6MycnjphCUcKWWXj0W26UELw5EGJ6WdE9xaeVcMgmrJrgae8YSNzrYbIdZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327244; c=relaxed/simple;
	bh=f5nmMZ//klaZLzI3eu0s59dSu1QdOEbMMtmPi05vKz0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=nigNDnpsZyokI2QQE5aPRB24dCKQpX3DvclLI4DlOoHWAu0/fyPWAqSEPeyQIX9hT075o2dx6iFamV4Yuf5WLvZ7Ziri7unwWQIes7TpYNGOb0LmQjQA137ra0Oskr3MIHflVE3eJMQg91+j6iQn+fAR+QA/lbpmasWNU08KFLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5c+Bks8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5c+Bks8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7779C4CEE9;
	Tue, 22 Apr 2025 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745327244;
	bh=f5nmMZ//klaZLzI3eu0s59dSu1QdOEbMMtmPi05vKz0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=u5c+Bks8jl8WHYzob/rSAcvt83jc8B7cCOTCQi6KW2aX3/cKa8WeBmU7goGSXHtMX
	 BVJVykJl4BVC1t3zM5H3gylooq2nq3A81KD+SqLLn2nBCmW6jZT7AdOVDvb6ujmDJq
	 YSAxL6tw+5V9hO5e8cTkzuvsCQuLdUk3wAI1waMA=
Subject: Patch "Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"" has been added to the 6.12-stable tree
To: alexander@tsoy.me,gregkh@linuxfoundation.org,jeff.johnson@oss.qualcomm.com,patches@lists.linux.dev,quic_ppranees@quicinc.com,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Apr 2025 15:07:14 +0200
In-Reply-To: <20250422120338.229099-1-alexander@tsoy.me>
Message-ID: <2025042213-fastness-spinning-22a2@gregkh>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-wifi-ath12k-fix-invalid-entry-fetch-in-ath12k_dp_mon_srng_process.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From alexander@tsoy.me  Tue Apr 22 15:04:41 2025
From: Alexander Tsoy <alexander@tsoy.me>
Date: Tue, 22 Apr 2025 15:03:37 +0300
Subject: Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, P Praneesh <quic_ppranees@quicinc.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
Message-ID: <20250422120338.229099-1-alexander@tsoy.me>

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
 


Patches currently in stable-queue which might be from alexander@tsoy.me are

queue-6.12/revert-wifi-ath12k-fix-invalid-entry-fetch-in-ath12k_dp_mon_srng_process.patch
