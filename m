Received: from e2i340.smtp2go.com (e2i340.smtp2go.com [103.2.141.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD29A21B9E3
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.2.141.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746003436; cv=none; b=arj5m26VWMdlELplT1K+Q3uVcpp0WXIfeLg8dvLIgXTvfyxIOFRbTKdsiAMWbiXzWoOHOqHm06Dj6K/1xDG2ggyZ4Eoq8yr4/RA9QXo8QvbgSuZFDXr0kbX1xqPvx/o3t8gnOeBvwws81NGTI+XmR7VFOdCT6prb4ktGPPwOBHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746003436; c=relaxed/simple;
	bh=kZ7ImT5zfbzlRBanFhM9ITuwN/m7Xo8NR2YPEAruOTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2zIiYh6cWZ353RtX6eMKtgVdoOoB14N/BG6I8Efg0dhT48Qa7qRo0luhRSf2rpboaffXROiyRzS6Hk0VLJ6OQxYmgnW0jab8S8r7Bkibe8AMI9LleoXAS5HXvPf/mFVMnFeyhMFlUq/HQ3DoM1T7zTWfdpEuGL3q4pybMEW3+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt; spf=pass smtp.mailfrom=em510616.triplefau.lt; dkim=fail (0-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b=zKyAhu6D reason="unknown key version"; dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b=jQ1JcNj9; arc=none smtp.client-ip=103.2.141.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em510616.triplefau.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="unknown key version" (0-bit key) header.d=smtpservice.net header.i=@smtpservice.net header.b="zKyAhu6D";
	dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b="jQ1JcNj9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtpservice.net; s=maxzs0.a1-4.dyn; x=1746004331; h=Feedback-ID:
	X-Smtpcorp-Track:Message-ID:Subject:To:From:Date:Reply-To:Sender:
	List-Unsubscribe:List-Unsubscribe-Post;
	bh=Kgav3+rFuWlgAfp8zAMTZtwJ3iGx3mOTRhPWv27IYqs=; b=zKyAhu6DURYu7Jssi71YvUVCz4
	j8Zzkt3tIceXGuzQMLgsIyYdInyz1gJ3nyEiHDLWTN0XY39pnttpj31l0dkTupfBo2dcGL13KfbRd
	o1ct6gI4JKmcyB2fLc5e31SRGYwGUqVzQ1Fs9ksZFpSReCxle5Z5qa4nw8Uqqk5T2gsdEbH14wJOV
	WJgyCT3cwySJcsQvC9vn3Xlflc9o0RSkm0jGBMG2hDbFFEJk13KQtl7D06HNzbRa5l530unNFjWLc
	LWVs2e9MTcKXO1XKlRNGZOmS3HYxW4qdinAuYtPTIB4QXHxt/iwTxhcWHZmMRwZlj5RQD4reiDEZU
	QhycFUMg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triplefau.lt;
 i=@triplefau.lt; q=dns/txt; s=s510616; t=1746003431; h=from : subject
 : to : message-id : date;
 bh=Kgav3+rFuWlgAfp8zAMTZtwJ3iGx3mOTRhPWv27IYqs=;
 b=jQ1JcNj97GjHSJJpCpi0M7qhtJVO3/kib6DwjRIWuaQeqWrNSn4B8dKAOes4dMLlUx+8z
 LNqZZNBDJOcKwfFfyppvaNrrIANweHhz9y8xTEtWLwjgXmdhMq8oQoaRDxYoop2lH+5SvFo
 uIdgq2mqCaa9ML+P8Jhkq/mEzsQ+zkIs4ZaVgW+Rmdd6IRG5D27TDbsK8y1Y1RBbW+DD9VO
 3El0WFiKnGWuAIrb/lWC33ApcdkedWi/BLlCBox5yAwdCY7dGaZB4c47OcIT1PfpFyZlzHb
 mPwoM8J0MU7dFYUKJ2t8uevVDAOCnT3kgRtQd2Y7H7O9Xq5FVXc8e6xI/TZQ==
Received: from [10.176.58.103] (helo=SmtpCorp) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2-S2G) (envelope-from <repk@triplefau.lt>)
 id 1uA3FT-TRjz74-Js; Wed, 30 Apr 2025 08:56:59 +0000
Received: from [10.12.239.196] (helo=localhost) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.97.1-S2G) (envelope-from <repk@triplefau.lt>)
 id 1uA3FT-4o5NDgrkUe2-ptNp; Wed, 30 Apr 2025 08:56:59 +0000
Date: Wed, 30 Apr 2025 10:49:43 +0200
From: Remi Pommarel <repk@triplefau.lt>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Johannes Berg <johannes.berg@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 128/373] wifi: mac80211: Update skbs control block
 key in ieee80211_tx_dequeue()
Message-ID: <aBHkJ0v5UnXPlRWl@pilgrim>
References: <20250429161123.119104857@linuxfoundation.org>
 <20250429161128.436695769@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429161128.436695769@linuxfoundation.org>
X-Smtpcorp-Track: k5Zd_mCmS_az.rsq4dw40dADU.46QN_wvhSL5
Feedback-ID: 510616m:510616apGKSTK:510616susjtUlcmQ
X-Report-Abuse: Please forward a copy of this message, including all headers,
 to <abuse-report@smtp2go.com>

Hello,

On Tue, Apr 29, 2025 at 06:40:05PM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.

This patch should not be included in any stable version.

-- 
Remi

> 
> ------------------
> 
> From: Remi Pommarel <repk@triplefau.lt>
> 
> [ Upstream commit a104042e2bf6528199adb6ca901efe7b60c2c27f ]
> 
> The ieee80211 skb control block key (set when skb was queued) could have
> been removed before ieee80211_tx_dequeue() call. ieee80211_tx_dequeue()
> already called ieee80211_tx_h_select_key() to get the current key, but
> the latter do not update the key in skb control block in case it is
> NULL. Because some drivers actually use this key in their TX callbacks
> (e.g. ath1{1,2}k_mac_op_tx()) this could lead to the use after free
> below:
> 
>   BUG: KASAN: slab-use-after-free in ath11k_mac_op_tx+0x590/0x61c
>   Read of size 4 at addr ffffff803083c248 by task kworker/u16:4/1440
> 
>   CPU: 3 UID: 0 PID: 1440 Comm: kworker/u16:4 Not tainted 6.13.0-ge128f627f404 #2
>   Hardware name: HW (DT)
>   Workqueue: bat_events batadv_send_outstanding_bcast_packet
>   Call trace:
>    show_stack+0x14/0x1c (C)
>    dump_stack_lvl+0x58/0x74
>    print_report+0x164/0x4c0
>    kasan_report+0xac/0xe8
>    __asan_report_load4_noabort+0x1c/0x24
>    ath11k_mac_op_tx+0x590/0x61c
>    ieee80211_handle_wake_tx_queue+0x12c/0x1c8
>    ieee80211_queue_skb+0xdcc/0x1b4c
>    ieee80211_tx+0x1ec/0x2bc
>    ieee80211_xmit+0x224/0x324
>    __ieee80211_subif_start_xmit+0x85c/0xcf8
>    ieee80211_subif_start_xmit+0xc0/0xec4
>    dev_hard_start_xmit+0xf4/0x28c
>    __dev_queue_xmit+0x6ac/0x318c
>    batadv_send_skb_packet+0x38c/0x4b0
>    batadv_send_outstanding_bcast_packet+0x110/0x328
>    process_one_work+0x578/0xc10
>    worker_thread+0x4bc/0xc7c
>    kthread+0x2f8/0x380
>    ret_from_fork+0x10/0x20
> 
>   Allocated by task 1906:
>    kasan_save_stack+0x28/0x4c
>    kasan_save_track+0x1c/0x40
>    kasan_save_alloc_info+0x3c/0x4c
>    __kasan_kmalloc+0xac/0xb0
>    __kmalloc_noprof+0x1b4/0x380
>    ieee80211_key_alloc+0x3c/0xb64
>    ieee80211_add_key+0x1b4/0x71c
>    nl80211_new_key+0x2b4/0x5d8
>    genl_family_rcv_msg_doit+0x198/0x240
>   <...>
> 
>   Freed by task 1494:
>    kasan_save_stack+0x28/0x4c
>    kasan_save_track+0x1c/0x40
>    kasan_save_free_info+0x48/0x94
>    __kasan_slab_free+0x48/0x60
>    kfree+0xc8/0x31c
>    kfree_sensitive+0x70/0x80
>    ieee80211_key_free_common+0x10c/0x174
>    ieee80211_free_keys+0x188/0x46c
>    ieee80211_stop_mesh+0x70/0x2cc
>    ieee80211_leave_mesh+0x1c/0x60
>    cfg80211_leave_mesh+0xe0/0x280
>    cfg80211_leave+0x1e0/0x244
>   <...>
> 
> Reset SKB control block key before calling ieee80211_tx_h_select_key()
> to avoid that.
> 
> Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> Link: https://patch.msgid.link/06aa507b853ca385ceded81c18b0a6dd0f081bc8.1742833382.git.repk@triplefau.lt
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/mac80211/tx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index c4e6fbe4343ee..0a658e747798b 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3704,6 +3704,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>  	 * The key can be removed while the packet was queued, so need to call
>  	 * this here to get the current key.
>  	 */
> +	info->control.hw_key = NULL;
>  	r = ieee80211_tx_h_select_key(&tx);
>  	if (r != TX_CONTINUE) {
>  		ieee80211_free_txskb(&local->hw, skb);
> -- 
> 2.39.5
> 
> 
> 
