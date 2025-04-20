Received: from puleglot.ru (puleglot.ru [195.201.32.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A178258A;
	Sun, 20 Apr 2025 22:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.32.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745186483; cv=none; b=P/AnRc2G/O2hdcXMqs18iZp4uuCWgD6jMyfTKG42qwmHYZaumhj7Q1MxS9As5bmj/LnV1QjocImiP6kvOvLFQNB+qR1m7/TGMD+Pl8NqiTE8mYAgFcc6Rf/Ithme4T3owhdg4wGt/jzwD60X1l9x7cGePqs2n18qhz310Tn+2SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745186483; c=relaxed/simple;
	bh=y27lBexMpMdDQ9ATHisSn7RO/3qNZVbSmnn5C/oXcgs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sgu6OA8xd9W6Kgu14FzItDoGV9+nShkyjEg9CQi8L/2q3MsWz8jKgV7/k1egcwGgxyFdyaLVHjHs4kUqLh4Ef2cEbWOd33AsllADGXy4jobsdQln4uiwrk7C8GF/aAmbS1JNCy7qHj7XVqvdZ+m5hepJMC16vLaNJCNMXyvokjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me; spf=pass smtp.mailfrom=puleglot.ru; dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b=l61pO+j/; arc=none smtp.client-ip=195.201.32.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puleglot.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b="l61pO+j/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
	s=mymail; h=Sender:MIME-Version:Content-Transfer-Encoding:Content-Type:
	References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
	:List-Post:List-Owner:List-Archive;
	bh=KOOL8xqxHP+zdUYmVlvMw2ZcsNJ35ikxvej/FMZw7zM=; b=l61pO+j/bCeNXKMiZtRynW6w/v
	IYoBCZvGE7TyPj2bou7BrwwxWBckFIxh03YcSnuHRZF7f5zUIpzxgQycs3xD2gEcvaogEgRtbDUCe
	VpDvt629b6DZxZIEc0kg1BWTooIXH/NvrLFcsfpz6RmIzmYiGgvasZMfXHn07+IDeccI=;
Received: from [62.217.191.235] (helo=[192.168.1.144])
	by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <puleglot@puleglot.ru>)
	id 1u6cQU-00000001Tmx-0W7v;
	Mon, 21 Apr 2025 00:42:10 +0300
Message-ID: <4fed086db630ff37ceb9caf9094b74467ef5d0bd.camel@tsoy.me>
Subject: Re: [PATCH 6.12 085/393] wifi: ath12k: Fix invalid entry fetch in
 ath12k_dp_mon_srng_process
From: Alexander Tsoy <alexander@tsoy.me>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, P Praneesh <quic_ppranees@quicinc.com>, Jeff
 Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
Date: Mon, 21 Apr 2025 00:42:08 +0300
In-Reply-To: <20250417175111.019326590@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
	 <20250417175111.019326590@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Sender: puleglot@puleglot.ru

=D0=92 =D0=A7=D1=82, 17/04/2025 =D0=B2 19:48 +0200, Greg Kroah-Hartman =D0=
=BF=D0=B8=D1=88=D0=B5=D1=82:
> 6.12-stable review patch.=C2=A0 If anyone has any objections, please let
> me know.
>=20
> ------------------
>=20
> From: P Praneesh <quic_ppranees@quicinc.com>
>=20
> [ Upstream commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 ]
>=20
> Currently, ath12k_dp_mon_srng_process uses
> ath12k_hal_srng_src_get_next_entry
> to fetch the next entry from the destination ring. This is incorrect
> because
> ath12k_hal_srng_src_get_next_entry is intended for source rings, not
> destination
> rings. This leads to invalid entry fetches, causing potential data
> corruption or
> crashes due to accessing incorrect memory locations. This happens
> because the
> source ring and destination ring have different handling mechanisms
> and using
> the wrong function results in incorrect pointer arithmetic and ring
> management.
>=20
> To fix this issue, replace the call to
> ath12k_hal_srng_src_get_next_entry with
> ath12k_hal_srng_dst_get_next_entry in ath12k_dp_mon_srng_process.
> This ensures
> that the correct function is used for fetching entries from the
> destination
> ring, preventing invalid memory accesses.
>=20
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-
> 1
> Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-
> QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
>=20
> Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
> Link:
> https://patch.msgid.link/20241223060132.3506372-7-quic_ppranees@quicinc.c=
om
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =C2=A0drivers/net/wireless/ath/ath12k/dp_mon.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c
> b/drivers/net/wireless/ath/ath12k/dp_mon.c
> index 5c6749bc4039d..1706ec27eb9c0 100644
> --- a/drivers/net/wireless/ath/ath12k/dp_mon.c
> +++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
> @@ -2533,7 +2533,7 @@ int ath12k_dp_mon_rx_process_stats(struct

Hello!

I think this is incorrect backport. ath12k_dp_mon_srng_process() should
be patched.

> ath12k *ar, int mac_id,
> =C2=A0		dest_idx =3D 0;
> =C2=A0move_next:
> =C2=A0		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
> -		ath12k_hal_srng_src_get_next_entry(ab, srng);
> +		ath12k_hal_srng_dst_get_next_entry(ab, srng);
> =C2=A0		num_buffs_reaped++;
> =C2=A0	}
> =C2=A0

