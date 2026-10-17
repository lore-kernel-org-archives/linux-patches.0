Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C173876CC
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.182.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257046; cv=pass; b=ZoVPpbTyjXv+Br1UGNbudi31Dgtikw6XJ7a72xVFvlJ+CvMM+RttxAp+DGtMBIAGfzNabv5BFBIsbe184rG2Z0Da0gkw8og+1ma6UBtv6/kfircrKhMFWaYt3WA7P3WUT1KwHQ5mBYIXqFwlZPkzU/2jDOK3+gHrcNGryT6H1gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257046; c=relaxed/simple;
	bh=iozjnFkxCiiTwQlu+j+CxArKllFj0c/8ndYKclfq5Fo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CsVdVrQS/BJwh9TU2Xxo5tGHOFw0qHsTpkqRnCzuVqBarHL6dIJ+VbDpFjua3efMvhjYn2VqNyHwV6Qh9HwkdttKSMfP3tlYkasLfgvrdpJVNMJZooDVgjVTrvRZr8NSgvL+sDYgktoUpU5ZPI20IuIvubWsHetmKENLcSKwWZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=harin.net; spf=pass smtp.mailfrom=harin.net; dkim=pass (2048-bit key) header.d=harin.net header.i=me@harin.net header.b=boXjqO65; arc=pass smtp.client-ip=165.173.182.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=harin.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harin.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=harin.net header.i=me@harin.net header.b="boXjqO65"
ARC-Seal: i=1; a=rsa-sha256; t=1792257036; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CvCR1Q2TAxtMtLSYwj6Y61fNK0Y+32bg7GcgPDSwPSymERL2yXkjGJwhDasvzI1cRxnP1p4pwzxQyCluAWVMEBpJT3TLG5Hbk7piSjPvEqds7TQkTPXBvI180iMxDnlNpjR7GJQ4SCgU5m2tYk3DPViAy6+1FiMK59I53JWZMcU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792257036; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=3WFVvLtJoB0TK3diVAgs8EoDrJe8KzXlVcTqfDi57fQ=; 
	b=TvQAk4meqR9ivoE+UOocIkBwOTsBmC2vJrKPT2dQXStTDKQ8nnqAgCgGV1xtk8W/NtDImzCtJKsxBjyfgn6f/8Ct7CyTz2M6A9qF0SEHKyFm7MFHXZoXXMfJ5X/7Soeg0a8XN9BsIlNJKLlAQ3jNMnyL7f7k5mvReK1d5/um/D4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=harin.net;
	spf=pass  smtp.mailfrom=me@harin.net;
	dmarc=pass header.from=<me@harin.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792257036;
	s=zmail; d=harin.net; i=me@harin.net;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=3WFVvLtJoB0TK3diVAgs8EoDrJe8KzXlVcTqfDi57fQ=;
	b=boXjqO65Mwqs8mATE/Iduy1eP9Dw+A7GCh1iRihYHqj22fLKTZFQm0ONrW3Q3ZVL
	unRadeD5Ej4X6PRAx8605xh0WxdTgKRCBy7dKypv/liTZ3Jd7fosCpemm//FFwv9G/c
	7LIQmtXgJTEY+dBSy9Af1NPJtN36vp3XAhinItoZY+T98gmFsNYK+jcTnnR02ca2jxr
	QG5VlKSyAto7HmAGZYZxrlDqJpWVXYajRF9ndRIAkcYW6mKDUYoHfc1Oph4KBDyvu1N
	ru8dh9ZGLFy4ClmEC9BXsi92785PL/fzzo8RqlCMuOANjCoHEHagNHrWFyJhoVTLvAw
	xsWBxecXhw==
Received: by smtp.zohomail.com with SMTPS id 1792257033000660.1066121521346;
	Sat, 17 Oct 2026 10:10:33 -0700 (PDT)
Message-ID: <0029273a-f61f-4b08-9a0a-79eb96a02998@harin.net>
Date: Sun, 18 Oct 2026 02:10:29 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 205/869] ALSA: ctxfi: Refactor resource alloc for
 sparse mappings
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
 Sasha Levin <sashal@kernel.org>
References: <20261017160036.979869304@linuxfoundation.org>
 <20261017160042.310502519@linuxfoundation.org>
Content-Language: en-US
From: Harin Lee <me@harin.net>
Autocrypt: addr=me@harin.net; keydata=
 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
In-Reply-To: <20261017160042.310502519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 10/18/26 12:50 AM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Harin Lee <me@harin.net>
> 
> [ Upstream commit a2dbaeb5c61ef110ceefe0d48fe94d428d3bcf16 ]
> 
> Refactor atc_get_resources(), atc_connect_resources(), and
> atc_release_resources() to allocate resources based on maximum type
> definitions.
> 
> This allows specific resources to be conditionally skipped based on
> capabilities. This is necessary for hardware variants where resource
> allocations do not follow a sequential order.
> 
> Signed-off-by: Harin Lee <me@harin.net>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Link: https://patch.msgid.link/20251124180501.2760421-5-me@harin.net
> Stable-dep-of: 277c6960d4dd ("ALSA: ctxfi: Check the error for index mapping")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   sound/pci/ctxfi/ctatc.c | 60 ++++++++++++++++++++++++-----------------
>   sound/pci/ctxfi/ctatc.h |  4 ---
>   2 files changed, 35 insertions(+), 29 deletions(-)
> 
> diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
> index fa70c4504db5f..6f0695efaafc8 100644
> --- a/sound/pci/ctxfi/ctatc.c
> +++ b/sound/pci/ctxfi/ctatc.c
> @@ -25,6 +25,9 @@
>   #include <sound/control.h>
>   #include <sound/asoundef.h>
>   
> +#define NUM_ATC_SRCS	6
> +#define NUM_ATC_PCM		(2 * 4)
> +
>   #define MONO_SUM_SCALE	0x19a8	/* 2^(-0.5) in 14-bit floating format */
>   #define MAX_MULTI_CHN	8
>   
> @@ -1164,8 +1167,10 @@ static int atc_release_resources(struct ct_atc *atc)
>   
>   	if (atc->daios) {
>   		daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
> -		for (i = 0; i < atc->n_daio; i++) {
> +		for (i = 0; i < NUM_DAIOTYP; i++) {
>   			daio = atc->daios[i];
> +			if (!daio)
> +				continue;
>   			if (daio->output) {
>   				dao = container_of(daio, struct dao, daio);
>   				dao->ops->clear_left_input(dao);
> @@ -1179,8 +1184,9 @@ static int atc_release_resources(struct ct_atc *atc)
>   
>   	if (atc->pcm) {
>   		sum_mgr = atc->rsc_mgrs[SUM];
> -		for (i = 0; i < atc->n_pcm; i++)
> -			sum_mgr->put_sum(sum_mgr, atc->pcm[i]);
> +		for (i = 0; i < NUM_ATC_PCM; i++)
> +			if (atc->pcm[i])
> +				sum_mgr->put_sum(sum_mgr, atc->pcm[i]);
>   
>   		kfree(atc->pcm);
>   		atc->pcm = NULL;
> @@ -1188,8 +1194,9 @@ static int atc_release_resources(struct ct_atc *atc)
>   
>   	if (atc->srcs) {
>   		src_mgr = atc->rsc_mgrs[SRC];
> -		for (i = 0; i < atc->n_src; i++)
> -			src_mgr->put_src(src_mgr, atc->srcs[i]);
> +		for (i = 0; i < NUM_ATC_SRCS; i++)
> +			if (atc->srcs[i])
> +				src_mgr->put_src(src_mgr, atc->srcs[i]);
>   
>   		kfree(atc->srcs);
>   		atc->srcs = NULL;
> @@ -1197,7 +1204,9 @@ static int atc_release_resources(struct ct_atc *atc)
>   
>   	if (atc->srcimps) {
>   		srcimp_mgr = atc->rsc_mgrs[SRCIMP];
> -		for (i = 0; i < atc->n_srcimp; i++) {
> +		for (i = 0; i < NUM_ATC_SRCS; i++) {
> +			if (!atc->srcimps[i])
> +				continue;
>   			srcimp = atc->srcimps[i];
>   			srcimp->ops->unmap(srcimp);
>   			srcimp_mgr->put_srcimp(srcimp_mgr, atc->srcimps[i]);
> @@ -1370,30 +1379,32 @@ static int atc_get_resources(struct ct_atc *atc)
>   	struct srcimp_mgr *srcimp_mgr;
>   	struct sum_desc sum_dsc = {0};
>   	struct sum_mgr *sum_mgr;
> -	int err, i, num_srcs, num_daios;
> +	struct capabilities cap;
> +	int err, i;
>   
> -	num_daios = ((atc->model == CTSB1270) ? 8 : 7);
> -	num_srcs = ((atc->model == CTSB1270) ? 6 : 4);
> +	cap = atc->capabilities(atc);
>   
> -	atc->daios = kcalloc(num_daios, sizeof(void *), GFP_KERNEL);
> +	atc->daios = kcalloc(NUM_DAIOTYP, sizeof(void *), GFP_KERNEL);
>   	if (!atc->daios)
>   		return -ENOMEM;
>   
> -	atc->srcs = kcalloc(num_srcs, sizeof(void *), GFP_KERNEL);
> +	atc->srcs = kcalloc(NUM_ATC_SRCS, sizeof(void *), GFP_KERNEL);
>   	if (!atc->srcs)
>   		return -ENOMEM;
>   
> -	atc->srcimps = kcalloc(num_srcs, sizeof(void *), GFP_KERNEL);
> +	atc->srcimps = kcalloc(NUM_ATC_SRCS, sizeof(void *), GFP_KERNEL);
>   	if (!atc->srcimps)
>   		return -ENOMEM;
>   
> -	atc->pcm = kcalloc(2 * 4, sizeof(void *), GFP_KERNEL);
> +	atc->pcm = kcalloc(NUM_ATC_PCM, sizeof(void *), GFP_KERNEL);
>   	if (!atc->pcm)
>   		return -ENOMEM;
>   
>   	daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
>   	da_desc.msr = atc->msr;
> -	for (i = 0, atc->n_daio = 0; i < num_daios; i++) {
> +	for (i = 0; i < NUM_DAIOTYP; i++) {
> +		if ((i == MIC) && !cap.dedicated_mic)
> +			continue;
>   		da_desc.type = (atc->model != CTSB073X) ? i :
>   			     ((i == SPDIFIO) ? SPDIFI1 : i);
>   		da_desc.output = i < LINEIM;
> @@ -1405,42 +1416,39 @@ static int atc_get_resources(struct ct_atc *atc)
>   				i);
>   			return err;
>   		}
> -		atc->n_daio++;
>   	}
>   
>   	src_mgr = atc->rsc_mgrs[SRC];
>   	src_dsc.multi = 1;
>   	src_dsc.msr = atc->msr;
>   	src_dsc.mode = ARCRW;
> -	for (i = 0, atc->n_src = 0; i < num_srcs; i++) {
> +	for (i = 0; i < NUM_ATC_SRCS; i++) {
> +		if (((i > 3) && !cap.dedicated_mic))
> +			continue;
>   		err = src_mgr->get_src(src_mgr, &src_dsc,
>   					(struct src **)&atc->srcs[i]);
>   		if (err)
>   			return err;
> -
> -		atc->n_src++;
>   	}
>   
>   	srcimp_mgr = atc->rsc_mgrs[SRCIMP];
>   	srcimp_dsc.msr = 8;
> -	for (i = 0, atc->n_srcimp = 0; i < num_srcs; i++) {
> +	for (i = 0; i < NUM_ATC_SRCS; i++) {
> +		if (((i > 3) && !cap.dedicated_mic))
> +			continue;
>   		err = srcimp_mgr->get_srcimp(srcimp_mgr, &srcimp_dsc,
>   					(struct srcimp **)&atc->srcimps[i]);
>   		if (err)
>   			return err;
> -
> -		atc->n_srcimp++;
>   	}
>   
>   	sum_mgr = atc->rsc_mgrs[SUM];
>   	sum_dsc.msr = atc->msr;
> -	for (i = 0, atc->n_pcm = 0; i < (2*4); i++) {
> +	for (i = 0; i < NUM_ATC_PCM; i++) {
>   		err = sum_mgr->get_sum(sum_mgr, &sum_dsc,
>   					(struct sum **)&atc->pcm[i]);
>   		if (err)
>   			return err;
> -
> -		atc->n_pcm++;
>   	}
>   
>   	return 0;
> @@ -1493,9 +1501,11 @@ static void atc_connect_resources(struct ct_atc *atc)
>   	struct sum *sum;
>   	struct ct_mixer *mixer;
>   	struct rsc *rscs[2] = {NULL};
> +	struct capabilities cap;
>   	int i, j;
>   
>   	mixer = atc->mixer;
> +	cap = atc->capabilities(atc);
>   
>   	for (i = MIX_WAVE_FRONT, j = LINEO1; i <= MIX_SPDIF_OUT; i++, j++) {
>   		mixer->get_output_ports(mixer, i, &rscs[0], &rscs[1]);
> @@ -1513,7 +1523,7 @@ static void atc_connect_resources(struct ct_atc *atc)
>   	src = atc->srcs[3];
>   	mixer->set_input_right(mixer, MIX_LINE_IN, &src->rsc);
>   
> -	if (atc->model == CTSB1270) {
> +	if (cap.dedicated_mic) {
>   		/* Titanium HD has a dedicated ADC for the Mic. */
>   		dai = container_of(atc->daios[MIC], struct dai, daio);
>   		atc_connect_dai(atc->rsc_mgrs[SRC], dai,
> diff --git a/sound/pci/ctxfi/ctatc.h b/sound/pci/ctxfi/ctatc.h
> index 0bc7b71d910b0..671edc46bd503 100644
> --- a/sound/pci/ctxfi/ctatc.h
> +++ b/sound/pci/ctxfi/ctatc.h
> @@ -132,10 +132,6 @@ struct ct_atc {
>   	void **pcm;		/* SUMs for collecting all pcm stream */
>   	void **srcs;		/* Sample Rate Converters for input signal */
>   	void **srcimps;		/* input mappers for SRCs */
> -	unsigned char n_daio;
> -	unsigned char n_src;
> -	unsigned char n_srcimp;
> -	unsigned char n_pcm;
>   
>   	struct ct_timer *timer;
>   

Hello,

Please check my earlier emails if you missed them:
https://lore.kernel.org/stable/e5b53e3f-02ac-4afc-9fa1-823ddb80875e@harin.net/
https://lore.kernel.org/stable/d19f3435-57fd-4ddf-9465-36f359c8b8bd@harin.net/

Thanks,
Harin Lee
