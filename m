Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066B45198E
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289765; cv=none; b=V08UeN1QkYrQEp4n7fw4oIcPwDhFwS0VwIKffEBHzbf9mgjMzpJeN91OzbZhkh1icB3tknAEdJlMYU7hjFUsRsJK1rssf1BG6htXJfwg65+e//vcwqW0ioSWiE5ukzB3USnu4l42FOubeBBx5wh9KUCf1aK468D64FACZa2PF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289765; c=relaxed/simple;
	bh=2G1FOvOSJrV6/l8sO+qjbSBFUO9X0CWF5KTVr1JnZkM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qtJNEvXT85+QKlWrEfQ3SxA+E0Vra7VfzcahcFzuAq+lnDtT8+PYqcAbiiSdjwscL+qG0x1rV99Y69YM1ObzXxn8idwAoKxeYB4A9aeoI/fyrknIufBo2WsC5l9iihCxcgg+IQcSHUZmv+U6eWkEgT8155VrE3JBjcobEC5vKa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eaJiYBco; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pg6xO2H4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eaJiYBco";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pg6xO2H4"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMOoGr2766695
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	81QaywXThCj9GvWcrqbFC8hrrggxf6pFQEEvB0A8Stc=; b=eaJiYBcoVJ7qevSl
	dhfq+tXf9Yrht/mLq/jwiRTObIgOPPAp4gq7bt1mDqjTW0V6kXIW+8178jTvvqEY
	/g72Tu5uLFr9TmxDOZ/WTOw4Db3jptMoLUpu03x0RYDq28zhhqtQH8+V6kNLVLAO
	1Ua+MyDrNoK2wgREaJE/EZogzihYwOq1s6HaLVkWSmzeuJh3HKsCfCtwvHP6+Jd8
	ENol9vchyHUhmq3K8SCqt3P2t3zGBv8XLggSyAt3yjEQk8zBoVPz6YK9sKvOoTjx
	qeijDJMaDaBEWWHG3mt12b/Lo717uv1T508Ea2fRW/yjOhQsk+HBOm2Y6914Juvl
	Prcy/g==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94k8tmr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:42:40 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33310847fcaso426150eec.1
        for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790289760; x=1790894560; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=81QaywXThCj9GvWcrqbFC8hrrggxf6pFQEEvB0A8Stc=;
        b=Pg6xO2H44kyewz8JjrRJeUvFe0WIc3Ab3f6vgiAb8x7cV4GAnYMPGQb2bt7cE+ZxaZ
         1hpneqCaKd5FMdLCLR8u9RJEC06L2xqSzhUpzlauHmdjYcXotuwHaFOrunJeTsu2chTN
         HO8J6Nbm8l1vZP3sXHitbIfsjfxyvyPdkhAjHQP2wJR9j/zBEAnYLzDeVj8EedGoDpwr
         9fA4CXVzQoWBHl2hB0YW4xUZEKsmCG5jBBxTrOkNeZpINexVJP6U0330FJn2241JvdrY
         BLIiNdhcJoWxDb/ZXnnokkhGOBg0Ift7a8kQZ3fsKhWdyDU0YUS35NlXfWATk5ah9rqd
         QpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790289760; x=1790894560;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=81QaywXThCj9GvWcrqbFC8hrrggxf6pFQEEvB0A8Stc=;
        b=iYLz68TGypcRPZ+nHIqhWoXGiXrLkTax0DgcBSkplNclubz5f//Btkug7PPQi4POj+
         nAWUVIAiL2S8o5Z6P8TFk6urfsu6ltCN8XiZBMiJPSmoEv+BcbaonG5wk9Un2fF/WFd/
         byiC+Y/njEwF+M2TI7FA1L+4/zAyTr+aiEOkQqfL6mU+d4lJpIFR7Efg3qKwwCRBOAtG
         8Ei6aKxfkmjCwS7+4zg+Ml/BkPRUy65snSwk3iX6UHARDi/fepzN3UF1yUtxgyfOwVZD
         LEt7sWbtVnULG9zaP6KoASdy3po5fxLjP2Zsyv3TQOPf09pnS3U/JCSJ3iuenCLWvObs
         ZVtA==
X-Forwarded-Encrypted: i=1; AKwUvByVcZLssMmDCtRJMCdaO3tc+wKuLJdvJyGtwRxcrsE3DJ9r1mTLzJOshNRYAhDVnVRa8ov0hvpq@lists.linux.dev
X-Gm-Message-State: AFuF++kdwHJxSlw/baO1uKp5DVx0Y6Axi7ivAIWnytH219e6CJcukDJ8
	4xPEv+7UEIh/HNGY6G4WCCmNlYerC+SBfFeyhmriGXP7uU7h+jLRM7pWkjorpGR1rZmmBDa9YLK
	1cHiw117lGLDvMdiku5bomUuuSB6ws+JB6Hh8CoBmpDBB17kFjkAwlGcFzpUm
X-Gm-Gg: AYBFou2FbvqdUU05AwVA0J2J5QxdzK/wrpeet9Gc2W5MFcp/FzbCOTVQVavFf+oqcY5
	LEvXtFmaX5TAWNyz+AvkSOqavzUb+/zs8ahhlL4w+JRgCs5pjr49XDg5+jtaXjjHk04SMZDUyoG
	ZCi7nm1R8gDgy/4906EGJmXNr9CbAjC8jiA7akLdoFa9MHNAlBnxx9w4oyKU8Mm8AUK67eyqUlU
	UrkRkAhU1uoPmsG+SHlU+mC1kW1Oh5TYoSM4CYvdGnPCOb7NXW64Eu+4nIHmG12+Nc3H/vTHnyH
	+uE9j1DAJtYB0fLs1b7SrjWcYNQu89cLi31JZq9dhyhfd7sSVCaV78J7FAIIfilsMTvtZGFmOoL
	vAOp1i4z7OeOboIDN8U63/U8qyeAHoN/2NfsjgDmI3w+AO698I1n12g==
X-Received: by 2002:a05:693c:601c:b0:341:4f3:8f84 with SMTP id 5a478bee46e88-341973cf3cfmr121088eec.13.1790289760248;
        Thu, 24 Sep 2026 15:42:40 -0700 (PDT)
X-Received: by 2002:a05:693c:601c:b0:341:4f3:8f84 with SMTP id 5a478bee46e88-341973cf3cfmr120917eec.13.1790289752160;
        Thu, 24 Sep 2026 15:42:32 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34145d0fc9fsm1538764eec.25.2026.09.24.15.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:42:31 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:42:27 -0700
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
Subject: Re: [PATCH 01/16] efi/libstub: Fix error unwind freeing fdt in
 allocate_new_fdt_and_exit_boot()
Message-ID: <20260924154227.00001cbe@oss.qualcomm.com>
In-Reply-To: <1-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<1-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab5a761 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=7U2iMG9xLqzP7ZOKqLsA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=CjuIK1q_8ugA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: 2qMEW7ZCY7eE_kepZQO254lMMraQMTlv
X-Proofpoint-ORIG-GUID: 2qMEW7ZCY7eE_kepZQO254lMMraQMTlv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MiBTYWx0ZWRfX/M87KSrlKsou
 skIlbOWqOEi5ppEDKF7R9tXIi5d7nfkeY6H5TsmG4qk8K/4XKGvhR3QfKW4B3sHwA780J87NxUH
 Zz4O5FF6V1ZsyeNDWJb34CJ3Gp6JP8+VENjcGhLYZYRCnmmVb6LQNTrc96+3dqTramRKW3c1GGZ
 kj71OazaDGT2BW0fvcLXvrtyTQ/8RYd+JNa3LZ0ZokLIilth1lj5pz2cQs+E7iMe6lrs2l5Y1yS
 6p2QmAlGkBVIBKZtie8G/88zK4JQagEmk13yynEh/tGjSR4Bo6JVsw664WolemmcJsvOyR8IrKk
 bydgHXoi2zxft9rTkZ9tL2F/KAm+1VKG8MvKYzwam8Ovn7NiuW2RhzSCAVn3tws4KjgfzhnGopW
 3svBO3S8VH6eIhFGHwvj9QaRLELf55oFj5/eEIhSNl9SVuzeTgMrRItMS0OFgQDVWbzYYZw3uY/
 8Ic9nLHUbCgyFuBJ91Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MiBTYWx0ZWRfX8W3aqVqePaGo
 TjJ+gXqyTgszJmchmRl3q0tOYq99TYq2s7v0Y69IjU3fF5AkSolWnM4sgP1pxB4ofjD3qmdlt7h
 Dvf6npuVG71DUqKs6IXdiJz3SiYfij0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1011 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240092

On Thu, 24 Sep 2026 10:53:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
> get_fdt() which is memory owned by FW.
> 
> Only the allocated fdt should be freed on the error unwind path. Use a
> dedicated variable for the allocation's size so that the free does not get
> confused.
> 
> Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/firmware/efi/libstub/fdt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 23b3543d3041b0..5b2dd709d7b151 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
>  	u32 desc_ver;
>  	efi_status_t status;
>  	struct exit_boot_struct priv;
> +	unsigned long fdt_size_allocated = 0;
>  	unsigned long fdt_addr = 0;
>  	unsigned long fdt_size = 0;
>  
> @@ -257,6 +258,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
>  			efi_err("Failed to load device tree!\n");
>  			goto fail;
>  		}
> +		fdt_size_allocated = fdt_size;
Hmm. I argued with myself for a while on this.  Which one of fdt_size and fdt_size_allocate
is the appropriate one to pass to the call?  In the end I didn't get a good answer so
oh I guess this is as good as the other way around.

Bug looks real to me and this fixes it I think. Give I know this code very little
take this tag with a pinch of salt.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

>  	}
>  
>  	if (fdt_addr) {
> @@ -334,7 +336,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
>  	efi_free(MAX_FDT_SIZE, *new_fdt_addr);
>  
>  fail:
> -	efi_free(fdt_size, fdt_addr);
> +	efi_free(fdt_size_allocated, fdt_addr);
>  	if (!efi_novamap)
>  		efi_bs_call(free_pool, priv.runtime_map);
>  

