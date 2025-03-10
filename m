Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9098A23372F;
	Mon, 10 Mar 2025 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628443; cv=none; b=by3UEA3vRSP/i6vTawhIxc6GdNR8ygvh2MyjZpYPBNMHRyLjVnQFzG4bzFlXo/L+cHxqUlJG8n7v+ygs8ZNdvwGZ6wDEjnO7xLBvfn/tGNe5W59tcWB8UpT5IMzU8WtMZOk1cYg/7Ni0xqjCXdZFVA9M6R2jdUAswKkqxV7hJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628443; c=relaxed/simple;
	bh=SoSvxThbacRApDtgtkB8xW5OigpPt6XCYjdjhfv5a4g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IQ5lcnWvuRJzyWkb+WOqj91ms/TUViZoGCpEVBfL0dLH7wvXP+coPTIfQCoGwc5knaJ75lQUcPKoU243ecgyV9H4d3y6ufHID9uTee+xt9/6MsofqLcQ5X8Tr4g5Ah2skbpLY36JQZegoUXMQaOYxu9mPm+dEfdDiuWMXWdXvLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aPWTjWg3; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aPWTjWg3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wQ4D5QKHMIWNCaQvOfTHTeNkiuHKNnCopjm4zd/mJUE=;
	t=1741628441; x=1742838041; b=aPWTjWg31CV4G3WJ83Cf3z7pS/u8Ru/xJwQy7HvuVC9Hdo+
	h4gR7GKNH/JBmUnTBHqKHRREGazvPw/hYdNVuK5YkKNScq03mn8Mdebg4/vReMJFcu7zEW6S54SkJ
	q+ST2L006fg4WAnfAOx3OjexmIJxtkpfy7/5GOI+uJRSe2JKV9AzduRwBb9910C721RPrSToq9pfa
	mz/1d8Hbp0gEB5gePPQM9GeD4tNvtdawFu6CJmprwswpF5LeYD/t4YsZrn2CgXR1lzCDMTp7GRb9+
	TujW+NSCm3/kXMjMG9GhcKQSaoOaXNjcrUNviOlSntfAqQRqhq7VPBPY84Ig7DHQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1trh7A-00000006xwX-2frH;
	Mon, 10 Mar 2025 18:40:32 +0100
Message-ID: <5d129bda966b7a55b444f4d48f225038361e9253.camel@sipsolutions.net>
Subject: Re: [PATCH 6.13 088/207] wifi: iwlwifi: Fix A-MSDU TSO preparation
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ilan Peer <ilan.peer@intel.com>, Miri Korenblit
	 <miriam.rachel.korenblit@intel.com>, Johannes Berg
 <johannes.berg@intel.com>,  Sasha Levin <sashal@kernel.org>
Date: Mon, 10 Mar 2025 18:40:31 +0100
In-Reply-To: <20250310170451.257508843@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
	 <20250310170451.257508843@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

if you pick this patch, then please also pick "wifi: iwlwifi: pcie: Fix
TSO preparation" which was submitted recently. Otherwise there is a
regression in the n_segments calculation that can lead to packet loss.


https://lore.kernel.org/linux-wireless/20250306122425.8c0e23a3d583.I3cb4d67=
68c9d28ce3da6cd0a6c65466176cfc1ee@changeid/

Benjamin

On Mon, 2025-03-10 at 18:04 +0100, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.=C2=A0 If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Ilan Peer <ilan.peer@intel.com>
>=20
> [ Upstream commit 3640dbc1f75ce15d128ea4af44226960d894f3fd ]
>=20
> The TSO preparation assumed that the skb head contained the headers
> while the rest of the data was in the fragments. Since this is not
> always true, e.g., it is possible that the data was linearised, modify
> the TSO preparation to start the data processing after the network
> headers.
>=20
> Fixes: 7f5e3038f029 ("wifi: iwlwifi: map entire SKB when sending AMSDUs")
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
> Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> Link: https://patch.msgid.link/20250209143303.75769a4769bf.Iaf79e8538093c=
df8c446c292cc96164ad6498f61@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =C2=A0.../wireless/intel/iwlwifi/pcie/internal.h=C2=A0=C2=A0=C2=A0 |=C2=
=A0 5 +++--
> =C2=A0.../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |=C2=A0 5 +++--
> =C2=A0drivers/net/wireless/intel/iwlwifi/pcie/tx.c=C2=A0 | 20 +++++++++++=
--------
> =C2=A03 files changed, 18 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers=
/net/wireless/intel/iwlwifi/pcie/internal.h
> index 27a7e0b5b3d51..ebe9b25cc53a9 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> @@ -1,6 +1,6 @@
> =C2=A0/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> =C2=A0/*
> - * Copyright (C) 2003-2015, 2018-2024 Intel Corporation
> + * Copyright (C) 2003-2015, 2018-2025 Intel Corporation
> =C2=A0 * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
> =C2=A0 * Copyright (C) 2016-2017 Intel Deutschland GmbH
> =C2=A0 */
> @@ -643,7 +643,8 @@ dma_addr_t iwl_pcie_get_sgt_tb_phys(struct sg_table *=
sgt, unsigned int offset,
> =C2=A0				=C2=A0=C2=A0=C2=A0 unsigned int len);
> =C2=A0struct sg_table *iwl_pcie_prep_tso(struct iwl_trans *trans, struct =
sk_buff *skb,
> =C2=A0				=C2=A0=C2=A0 struct iwl_cmd_meta *cmd_meta,
> -				=C2=A0=C2=A0 u8 **hdr, unsigned int hdr_room);
> +				=C2=A0=C2=A0 u8 **hdr, unsigned int hdr_room,
> +				=C2=A0=C2=A0 unsigned int offset);
> =C2=A0
> =C2=A0void iwl_pcie_free_tso_pages(struct iwl_trans *trans, struct sk_buf=
f *skb,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 struct iwl_cmd_meta *cmd_meta);
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/=
net/wireless/intel/iwlwifi/pcie/tx-gen2.c
> index 7bb74a480d7f1..477a05cd1288b 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
> @@ -1,7 +1,7 @@
> =C2=A0// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> =C2=A0/*
> =C2=A0 * Copyright (C) 2017 Intel Deutschland GmbH
> - * Copyright (C) 2018-2020, 2023-2024 Intel Corporation
> + * Copyright (C) 2018-2020, 2023-2025 Intel Corporation
> =C2=A0 */
> =C2=A0#include <net/tso.h>
> =C2=A0#include <linux/tcp.h>
> @@ -188,7 +188,8 @@ static int iwl_txq_gen2_build_amsdu(struct iwl_trans =
*trans,
> =C2=A0		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr));
> =C2=A0
> =C2=A0	/* Our device supports 9 segments at most, it will fit in 1 page *=
/
> -	sgt =3D iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room);
> +	sgt =3D iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room,
> +				snap_ip_tcp_hdrlen + hdr_len);
> =C2=A0	if (!sgt)
> =C2=A0		return -ENOMEM;
> =C2=A0
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/w=
ireless/intel/iwlwifi/pcie/tx.c
> index 1ef14340953c3..f46bdc0a5fec9 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
> @@ -1,6 +1,6 @@
> =C2=A0// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> =C2=A0/*
> - * Copyright (C) 2003-2014, 2018-2021, 2023-2024 Intel Corporation
> + * Copyright (C) 2003-2014, 2018-2021, 2023-2025 Intel Corporation
> =C2=A0 * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
> =C2=A0 * Copyright (C) 2016-2017 Intel Deutschland GmbH
> =C2=A0 */
> @@ -1853,6 +1853,7 @@ dma_addr_t iwl_pcie_get_sgt_tb_phys(struct sg_table=
 *sgt, unsigned int offset,
> =C2=A0 * @cmd_meta: command meta to store the scatter list information fo=
r unmapping
> =C2=A0 * @hdr: output argument for TSO headers
> =C2=A0 * @hdr_room: requested length for TSO headers
> + * @offset: offset into the data from which mapping should start
> =C2=A0 *
> =C2=A0 * Allocate space for a scatter gather list and TSO headers and map=
 the SKB
> =C2=A0 * using the scatter gather list. The SKB is unmapped again when th=
e page is
> @@ -1862,18 +1863,20 @@ dma_addr_t iwl_pcie_get_sgt_tb_phys(struct sg_tab=
le *sgt, unsigned int offset,
> =C2=A0 */
> =C2=A0struct sg_table *iwl_pcie_prep_tso(struct iwl_trans *trans, struct =
sk_buff *skb,
> =C2=A0				=C2=A0=C2=A0 struct iwl_cmd_meta *cmd_meta,
> -				=C2=A0=C2=A0 u8 **hdr, unsigned int hdr_room)
> +				=C2=A0=C2=A0 u8 **hdr, unsigned int hdr_room,
> +				=C2=A0=C2=A0 unsigned int offset)
> =C2=A0{
> =C2=A0	struct sg_table *sgt;
> +	unsigned int n_segments;
> =C2=A0
> =C2=A0	if (WARN_ON_ONCE(skb_has_frag_list(skb)))
> =C2=A0		return NULL;
> =C2=A0
> +	n_segments =3D DIV_ROUND_UP(skb->len - offset, skb_shinfo(skb)->gso_siz=
e);
> =C2=A0	*hdr =3D iwl_pcie_get_page_hdr(trans,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 hdr_room + __alignof__(struct sg_table=
) +
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct sg_table) +
> -				=C2=A0=C2=A0=C2=A0=C2=A0 (skb_shinfo(skb)->nr_frags + 1) *
> -				=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct scatterlist),
> +				=C2=A0=C2=A0=C2=A0=C2=A0 n_segments * sizeof(struct scatterlist),
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0 skb);
> =C2=A0	if (!*hdr)
> =C2=A0		return NULL;
> @@ -1881,11 +1884,11 @@ struct sg_table *iwl_pcie_prep_tso(struct iwl_tra=
ns *trans, struct sk_buff *skb,
> =C2=A0	sgt =3D (void *)PTR_ALIGN(*hdr + hdr_room, __alignof__(struct sg_t=
able));
> =C2=A0	sgt->sgl =3D (void *)(sgt + 1);
> =C2=A0
> -	sg_init_table(sgt->sgl, skb_shinfo(skb)->nr_frags + 1);
> +	sg_init_table(sgt->sgl, n_segments);
> =C2=A0
> =C2=A0	/* Only map the data, not the header (it is copied to the TSO page=
) */
> -	sgt->orig_nents =3D skb_to_sgvec(skb, sgt->sgl, skb_headlen(skb),
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb->data_len);
> +	sgt->orig_nents =3D skb_to_sgvec(skb, sgt->sgl, offset,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb->len - offset);
> =C2=A0	if (WARN_ON_ONCE(sgt->orig_nents <=3D 0))
> =C2=A0		return NULL;
> =C2=A0
> @@ -1937,7 +1940,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans=
 *trans, struct sk_buff *skb,
> =C2=A0		(3 + snap_ip_tcp_hdrlen + sizeof(struct ethhdr)) + iv_len;
> =C2=A0
> =C2=A0	/* Our device supports 9 segments at most, it will fit in 1 page *=
/
> -	sgt =3D iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room);
> +	sgt =3D iwl_pcie_prep_tso(trans, skb, out_meta, &start_hdr, hdr_room,
> +				snap_ip_tcp_hdrlen + hdr_len + iv_len);
> =C2=A0	if (!sgt)
> =C2=A0		return -ENOMEM;
> =C2=A0

