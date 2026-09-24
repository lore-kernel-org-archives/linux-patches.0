Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7C133EB17
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290150; cv=none; b=GOtRiZGgc5EpQUgOQmTPQlLZq6AH6dj114amvZoHeLX6glAKY4IqHx3Hh/Z0GQJOrHqss9F2FLWER8/THZvT03XXyXoyc50dHFpCIQFuVfAX9zYxCOQx9GkzVfnM72njWYNnDqcu1Sr/IAjroq+8wMgyozKUJJ+mqxAfbJyQtxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290150; c=relaxed/simple;
	bh=EsE+bP4ImbF198tRF/p/BEO5nlCx3+LrGeUaFu0gIWU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgTO/1PGi+2rI4mCY4h8XZK1HwdY15SiyoMPKUSJgdTFFWhNvhuobon2FC1/5yDsSAd6jSJSqAKW1fZ76W1Q6kRP8UcXxbm+iwnMcY2wIwMCsLxHnpSerdf1ZVSUCxDO8CpwrNzeMr2u78RwHfPe4rhAmp6179W582VLYHOBnD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UnwyqbzY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bzJrPHvG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UnwyqbzY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bzJrPHvG"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMPLpV2767678
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oo8YGRfyp+kAVxf53tgrQWeKF/gkFQ1vpq3RnEKr7OY=; b=UnwyqbzYYs+KvHQI
	pdaCx1jtw5ZY0g35b3TDHY1cZfUiyOOybRzb2dGrJpMmxlONRNVSQrHCIK6+AoC7
	QnvuyVkfsbutTtg/yDMfBQUkcTg+g9F3yaain8P0Plp1XMrZxMEFtivmZwU0CQSe
	ofHBo1aKp2Fj7gieTJXChc0guhXjz78g5/YQm8yV6jdF4DVlAjn/ZKGezuK1U1zf
	EgGFGjtO6diq8oxU1+jfEQZtkOeEUAA1QQjM+IUboDFRrPF9yqUpJATk3M3VjNOY
	A8FRKURil3a5aaVAiLtj8asDhAlxSaEDtDqf0iqQI5xndVjM8Dveu39DfcoA+QTX
	4xyL3w==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94k8u4v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:49:07 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33713e5e6daso410329eec.0
        for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790290147; x=1790894947; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oo8YGRfyp+kAVxf53tgrQWeKF/gkFQ1vpq3RnEKr7OY=;
        b=bzJrPHvGoOyLH8/deh4C9SL5m04ya3c0FH6+QZGJqBag4HOk8a6TOV6kms4ivP6hYY
         sQy6B13B+dXpL9oXWF3O7qCxC2qeevO8BNfaP6yyD1w+xdQIfN1LPLN3Hnj86Z2tqKGA
         5wwQ0WmH36+O5bXJD87PfrTL8peq/mdwExpeAIVJud263bURcdp+W6a+tr1qh8EWvt6Q
         UcO8cOaRF39iS5OIKgb+7/8zC0qbHRqIIaP6H79brfri6e7SwX0bySHjswxvuL0cNhCj
         8K5LtCpU/S+f2gkA3TXEl1gcULjsaAixDt9hPHEzuAz4gRt4JuHTX1OQYYof8s5QY0wR
         trVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790290147; x=1790894947;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oo8YGRfyp+kAVxf53tgrQWeKF/gkFQ1vpq3RnEKr7OY=;
        b=v21EdHzuafTVn7R3/TE+VgaLBB1gDqb6+EHxnjP222YZBn3XHh0VvmG+fQtV2YGP6H
         tp0tPUgqQ2KLrcoCwQA2i28/RgjwpHfYDBe6TG72tduMaCRBx0nZfhcHfTq6YM/5LFZO
         ppbeFb3AMrkWG6MBAWaItvxcxyeEJVsuwp1Yo+NXJGqtOgYhTFuxExekWHgfBku7T+JZ
         snrEdn6ZsbSoC7DQcr73lA3GhFNu1aYGdWaDwnaF5U+NAZBaez5z/v9dC3mJqmh4f9uS
         2zKrfyw7OnqBCBcIGAdViTGHwmPnkAapPH34TLD1WWunT3vCFPuFKkqofRImMkubfuMO
         VzKg==
X-Forwarded-Encrypted: i=1; AKwUvBysUAKD8tbQjYsDKyzJ/6QYDPc9CMnBqOyJzKdO8UENsr/LYNoh9bHaCvUs4vmFnFdD0UTqcBHb@lists.linux.dev
X-Gm-Message-State: AFuF++mQvvnS7V0hVkEnTkXjUlcZpkogHvhvbDkD4F3e6dkAd7lFjYG9
	rUmq7jd3H+iAIPJBZ9q+2q13guZk4lbC3N0w96tsq09ByocrgwVV7ukJ72gPFokDL0yQB+r8HPT
	fd00HOrWL9MwfjLPvUxpEsnJfbY9QNFLcU5TMD2z0IPqnv3x74gWyJECHZj9d
X-Gm-Gg: AYBFou3gqyBOs7NNJk+qb4oP6m6dSEAUSLCkXev+jtK75ddCx6GhFUOMhaA0SD1zVUi
	cjCCtQ3rime03046ZjMfKeeLtTo14h6m9q1QUTooo6hGFrSbDRWR/xn5e5vAEKVupti/2Wm4CWz
	+k07pjKcqrN2MrQdVJvvrHcnbeKqMh02G/kd6t6j3gjjIxgDFkg2pbqQlo3tuqP7Aq8L5evbqxh
	XwLYRuDWPV4A9OHs03Kp0Q0eODEljf0Kz4/Lw9ahcINXozQ5CtAzwLd98F0DGtxmG6//buzVN6Y
	/YfeYPJh38YMCk7YBn7/4pjA5Iz6WUCHSrC0zwYUsqmuNEt6JSA1MK0B0wXujLDcO/HHSt2bkoU
	WC0xjY7B+70jYDMQ13akuAAgYTq2KdL1UsoXRRaa0ocZTCBeU3X/wHw==
X-Received: by 2002:a05:7301:8614:b0:33b:dcbc:6046 with SMTP id 5a478bee46e88-33ffe341a5fmr3054539eec.7.1790290146781;
        Thu, 24 Sep 2026 15:49:06 -0700 (PDT)
X-Received: by 2002:a05:7301:8614:b0:33b:dcbc:6046 with SMTP id 5a478bee46e88-33ffe341a5fmr3054509eec.7.1790290146115;
        Thu, 24 Sep 2026 15:49:06 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3414407d18fsm1417100eec.10.2026.09.24.15.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:49:05 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:49:02 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Ard
 Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin
 Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, David
 Sterba <dsterba@suse.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Randy
 Dunlap <rdunlap@infradead.org>, Simon Glass <sjg@chromium.org>,
        Shuah Khan
 <skhan@linuxfoundation.org>,
        Nick Terrell <terrelln@fb.com>, Will Deacon
 <will@kernel.org>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Conor Dooley
 <conor.dooley@microchip.com>,
        linux-integrity@vger.kernel.org, Palmer
 Dabbelt <palmer@rivosinc.com>,
        patches@lists.linux.dev, Ross Philipson
 <ross.philipson@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Song
 Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH 03/16] efi/libstub: Free cmdline_ptr in efi_pe_entry
Message-ID: <20260924154902.0000528b@oss.qualcomm.com>
In-Reply-To: <3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab5a8e3 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Ikd4Dj_1AAAA:8 a=xhtQj0KKqAk-GveBB2QA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: QHLW5PwJVESUU2umwIxpNEmsA7KxrFWD
X-Proofpoint-ORIG-GUID: QHLW5PwJVESUU2umwIxpNEmsA7KxrFWD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX+NzzWAcwqlgO
 qKCraAOvZXOI437iPB16ykTpjVXqY3zUBEGnhbEO1cFWsguy6jw7/HNctyv+HlzHDv6xgGBppNx
 xz78hXg8cyKxm6cJ2HDczx7g39Q9RJruQkvvwxFpLe78lkpyjE8Njvhjt+8oucOW1ICdgQ64nZD
 N4TpPUppCDY6wo5pwUhOvkitRl9c2F6UPVNv/s7dFwURhHQhEIg1e6nWZBS1T8KWs9xh+S/TvXv
 YkJvvW9TV+Gr+QwLkw4cfppTkPj9sgNZK6aw/dlp8WtE6oabIeadoSIGFrVLWdpqS1M0rxjyYIN
 LofrAFugCvX9LQj+2a8fPYnp2d0qyHtZEcX+nBzajomqX47v7FuXH0bLqIchhiAiCY7rLDMVWo4
 iJ6g9xjyzJgcpA8dBrPhp8jpyyNWKJPbOhJBH+7rsPB+PQ+UBOHg7zf/8S+roPzRLNOuMdzD73U
 8LxGZ8FRnp/vjsbQ+Vg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX87Y7u/Vi9XRE
 v6YKd1fZLIpcaQND7vBPgkVBdF4xjKO/3zDj6pEb6SkXq+ArobwU7JSCbgA2xgY2iVtNemWx5tP
 LycZ+U7dKlr97qVkgsvN0cuQ/XfGzDg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240093

On Thu, 24 Sep 2026 10:53:06 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko points out that efi_handle_cmdline() allocates this memory and
> hands it over to the caller. If efi_pe_entry() ever returns it should be
> freed. Add a __free annotation.
> 
> Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
> index aa85e910fe595e..83fade2b0d3b84 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-entry.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
> @@ -40,7 +40,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  	unsigned long image_addr;
>  	unsigned long image_size = 0;
>  	/* addr/point and size pairs for memory management*/
> -	char *cmdline_ptr = NULL;
> +	char *cmdline_ptr __free(efi_pool) = NULL;

Can we move this down to just above the call to efi_handle_cmdline that
does the constructor side of this?

I see none of the efi stuff follow those guidance note that went in cleanup.h.

Ah well, not my problem :)

J

>  	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
>  	unsigned long reserve_addr = 0;
>  	unsigned long reserve_size = 0;

