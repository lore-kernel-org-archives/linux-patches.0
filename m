Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF4846EC62
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 07:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249485; cv=none; b=JEcUyVzsIs0Rj7fD1yRhleV4r5INJQGUorYn/Y207kSwTK/GS7QLvpPgvdeDeyWuZ75ldROsPRFUvvpO5rscbJdVO1XUbIE6J7GMtXn6g+TpZXg2VuSz9D6siz8uWlAjTPNF6nz0JKyV+8ehPgsTC/IzR9beIyjlc9K5jhNSQV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249485; c=relaxed/simple;
	bh=OF4PmkLvY5GSsd7Src3ioGuPiipTbXPvzKRpbMVQZ/g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tjk88qNVyhXftG3+4FF2oSHPoUgphgKkdpJXqV4AVNZFQpaUKLvuht/3fXA6NVW9ujwGN0HADO88RwgEHDqmyqqMxx2Fz86ATpw/NR47287hEZm6MihQ9sCbWbsq0XLmapxc7/z0wIgeTjdi4swGr/g3o/4erAXh28K4D5zaIHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=ehLYtvLC; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="ehLYtvLC"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id C2D3F206E9;
	Tue,  1 Sep 2026 09:50:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A28iTAiBBD1T; Tue,  1 Sep 2026 09:50:37 +0200 (CEST)
Received: from EXCH-02.secunet.de (rl2.secunet.de [10.32.0.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id 214A7205CF;
	Tue,  1 Sep 2026 09:50:37 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com 214A7205CF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1788249037;
	bh=fuzmQA8uJ6nVSzIQSJCnaHiz/M3SxDKCF5x/oJzAl/Y=;
	h=Date:From:To:CC:Subject:Reply-To:References:In-Reply-To:From;
	b=ehLYtvLChJQjKw2Egvoir8hyDbwWL5u+t0s4EsvEXHBHStzYqyBVFLawC2wxQhJht
	 Gzcv0b0tUO09tN3g+FNTSc29zgeoI+cnyr9TI6VZvaSgYbk9tJHfWOxMg26Ur+JlI8
	 6nn1Dh7YqnxKJoqPmeXIbPPGbSkM76jEQmUAQy7iZplfBZp63USyzc3ieVHsPFfJUR
	 JVZLP8SwlJeKtu/LTExmvt1UqCmwOkhlt0Cr6rFs1j/Go5VaIlZ0OgQEFgnvOH9D4H
	 xLGxw8EfxsUkAMeMqscspRjKV600v3AXuVLWGOkvATVaiXuwqtrORIRWURFvxj8r6l
	 GN72blANBmE8w==
Received: from moon.secunet.de (172.18.149.1) by EXCH-02.secunet.de
 (10.32.0.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 1 Sep
 2026 09:50:35 +0200
Date: Tue, 1 Sep 2026 09:50:28 +0200
From: Antony Antony <antony.antony@secunet.com>
To: Sasha Levin <sashal@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>
CC: <patches@lists.linux.dev>, <stable@vger.kernel.org>, Antony Antony
	<antony.antony@secunet.com>, Yan Yan <evitayan@google.com>, Sabrina Dubroca
	<sd@queasysnail.net>, Steffen Klassert <steffen.klassert@secunet.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.18-5.10] xfrm: allow migration from UDP
 encapsulated to non-encapsulated ESP
Message-ID: <apaDxC5gBw7G2zMc@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-428-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260831133314.4125787-428-sashal@kernel.org>
Precedence: first-class
Priority: normal
Organization: secunet
X-ClientProxiedBy: EXCH-04.secunet.de (10.32.0.184) To EXCH-02.secunet.de
 (10.32.0.172)

Hi,

I am thinking of not to back port this patch.
As it may become a surprise behavior change on older kernels.

I vote not to backport!  Anyone vote to be back port it?

-antony

On Mon, Aug 31, 2026 at 09:27:36 -0400, Sasha Levin wrote:
> From: Antony Antony <antony.antony@secunet.com>
> 
> [ Upstream commit b8addb8884f2dc1b13cf3e4fa0265ecd0bc58b69 ]
> 
> The current code prevents migrating an SA from UDP encapsulation to
> plain ESP. This is needed when moving from a NATed path to a non-NATed
> one, for example when switching from IPv4+NAT to IPv6.
> 
> Only copy the existing encapsulation during migration if the encap
> attribute is explicitly provided.
> 
> Note: PF_KEY's SADB_X_MIGRATE always passes encap=NULL and never
> supported encapsulation in migration. PF_KEY is deprecated and was
> in feature freeze when UDP encapsulation was added to xfrm.
> 
> Tested-by: Yan Yan <evitayan@google.com>
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> The branch check finished. Commit `b8addb8884f2d` is in mainline and
> several `-next` trees (via the `ipsec-next-2026-06-12` merge), but not
> in `stable/linux-6.18.y` — which matches the earlier analysis.
> 
> **Summary:** Backport to 6.18.y is warranted. The buggy encap-
> inheritance code is still present, the adapted patch applies cleanly on
> top of the already-backported `b64120d`, and this completes the MOBIKE
> NAT→non-NAT migration fix that partial stable work started.
> 
> **YES**
> 
>  net/xfrm/xfrm_state.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index b9049c2297bd5..0a629fce0a00f 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -2017,14 +2017,8 @@ static struct xfrm_state *xfrm_state_clone_and_setup(struct xfrm_state *orig,
>  	}
>  	x->props.calgo = orig->props.calgo;
>  
> -	if (encap || orig->encap) {
> -		if (encap)
> -			x->encap = kmemdup(encap, sizeof(*x->encap),
> -					GFP_KERNEL);
> -		else
> -			x->encap = kmemdup(orig->encap, sizeof(*x->encap),
> -					GFP_KERNEL);
> -
> +	if (encap) {
> +		x->encap = kmemdup(encap, sizeof(*x->encap), GFP_KERNEL);
>  		if (!x->encap)
>  			goto error;
>  		x->mapping_maxage = orig->mapping_maxage;
> -- 
> 2.53.0
> 
