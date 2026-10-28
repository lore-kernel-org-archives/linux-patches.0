Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216093;
	b=osY4TJ57KM8f8X/hRuyS8XXLzBgUZzLzd1xAP0d+tyZk8sn5LX7Dv11TJ7I/7wCtrMSB
	 y4I5dtzgjJbE+avKgtrPrR6J8WUS1ifp3iKS+2SSe3EwQm0/ScM6NVn002azLT1Crt3ut
	 xzPeQCH1EYIwRCJJLLSR9CGxIrilG7YtYnZjbKuK7/+/Rppxq+yTn5XlTinn+bekb4tVi
	 UDaU8MHU96xx3nXxcAQJB92qfCgteTt077Pew1rA1BgaX2lv9NlaVCSDtceC62l12gs7G
	 AdlnIV0jBVbC1jLt52NMKZ2sgaS1MI50YWDWks3675RYjFchHcLQMOs98WFBnxA1TGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JDTHoW0/bzy2tl9Dn7cBsaCE6uifmVZK8Sr2yCJQhr4=;
	b=mOApY9wQ2qKb+lmTVu/CzgEWQxd66f7ZVA0O792NUYtBmFVoz8BDFszWvEnBdTyalD0l
	 BMr3XZ5Nw2VwmvmustSI1W87mz20ZwqpcmFEubZB6OU7MmviBoQFIsJ3nl63YG59U4cqK
	 BE2y3H7IlfYydqUI3ePn4UOcIURO72/uKeZopN0P4Vd7x1zoPMEE1fVVjK7/Jc27vj9gt
	 dCR8W+bEke/qa//27smpyfMKiejAPWo55uiaRVPKPesEpazmVccrTVii9komSUAazsiOa
	 LzWZzrY5Ul5THP7JK5/jhtIiAOcU0p4oN7fKsemDJWa6uqBPkDDfPsP9dDxJNcclBFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnnhVCZI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06615606A31C;
	Wed, 28 Oct 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CnnhVCZI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5771F01825;
	Wed, 28 Oct 2026 19:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216092;
	bh=JDTHoW0/bzy2tl9Dn7cBsaCE6uifmVZK8Sr2yCJQhr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnnhVCZIoWMj4CFmIbFZHcur1PhMNe2s/r9FyLySuxrcpt+UK1Ai0+026rUyjuhbb
	 Eisu/sJz/vDzHUkS0JNRFLdpmwpVPO41qPPhNh/Qf1mb7zAFtsNemNtb3QYf4a0byQ
	 g9tZ0DEepHokCnJVX9EoOUfXWZDtmi5CRYWn9gJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 1438/1887] ice: Dont process extts if PTP is disabled
Date: Wed, 28 Oct 2026 17:58:54 +0100
Message-ID: <20261028170532.183424368@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 996422e3230e41468f652d754fefd1bdbcd4604e ]

The ice_ptp_extts_event() function can race with ice_ptp_release() and
result in a NULL pointer dereference which leads to a kernel panic.

Panic occurs because the ice_ptp_extts_event() function calls
ptp_clock_event() with a NULL pointer. The ice driver has already
released the PTP clock by the time the interrupt for the next external
timestamp event occurs.

To fix this, modify the ice_ptp_extts_event() function to check the
PTP state and bail early if PTP is not ready.

Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240702171459.2606611-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 0fa32ca5a9255..f2f1078166fc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1488,6 +1488,10 @@ void ice_ptp_extts_event(struct ice_pf *pf)
 	u8 chan, tmr_idx;
 	u32 hi, lo;
 
+	/* Don't process timestamp events if PTP is not ready */
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return;
+
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 	/* Event time is captured by one of the two matched registers
 	 *      GLTSYN_EVNT_L: 32 LSB of sampled time event
-- 
2.53.0



