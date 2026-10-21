Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602393;
	b=rMmbT7ANXdje6bI+4kSboqNTPZhmm0WyNbxmG4h0iH9meqqO7sopVxV8F+rcD4LYgRIx
	 mCvHgFLNcx7N4xlDHTEDw28AYVfEopg5QS3jNzm2GairEhOYM2qvvYjOTgeKyNM2EXCmv
	 UwRFZS61dIkX6gUICLN71ddHWndW9wvivEIwo6elFd0rMl8186pMqV1/740MZCxnO21ao
	 Ds8GpH5xJIHTXnvzZkvKDpk9LFGYWwo8Ln9viUT2wYBzqCpQkde3lu8ebB75/4aiMbqTM
	 egzr6GgHC9o1dxJS8EO1pUONQT4qUybzmM5vLG/W9CwGbd6PCoE5BK65BT7/92sndJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602393;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=;
	b=RzHi/Dmp2FB8vVHolVZgI3Fl8VMP2JcqddAQq+jEuJF3TkgXTGhpSWS2QJzLR6ekWP5c
	 /7/fpLYHYOY6joPh+UxoF4cXSS8mWXoxZRW4xiF41yiE8eVzQYc4fscTMpN4mBEjrf0Qd
	 3MO3nRsT06VqnkG0P87rUHmgB6Ajlm4IVeK2Hd2AVK8DE22FM533sLtTcR2gkfEjc8Xt8
	 +Mi6JgFHPaI5qmyhhXtVGY4lBTb30SmTB/vxPW2qD/+JoFcr0caZppjbgnKbyh3sP/PAD
	 QWM2Ey/JVjtHJvJV3bsG5bSc6PIwdd1Q0aZpi0cY53DSBtOIOmn41fvtEkkfkGEOqUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OSlcL8cO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cbKLoQhq;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C7660A260F
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 17:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0C7660A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OSlcL8cO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cbKLoQhq
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU0vj682104
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 17:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=; b=OSlcL8cOU5zXbryB
	8fphfV9zo1XreQA4OpWxV/h7tO89Sx+6X2Zl5p6+0ULsUn90taN9eGxYH16jm+qk
	L0XZJ7Dn3v8XGxu9eL4AUwpW89Q08hqaGYjoQLd+s7IfocWo3yT9caDh8KNWlz5H
	s2wvu8IN32qEW3e4b+swbEmyIx4Sb7Bfs53jhsZpFAhMxFVFGH/lhgrGUhOIl9na
	ZHCzsoC6k5dyzggh321+7NzEQC0sx6z0Q589PxqQBdkJCqG9N/vTM/t84N6WLpwZ
	XNzQ4yeKMJxtggMzRJOTsDyC0PwIrehi/AU/krpfAg39mwEvzewP39PNMVc/Bg+a
	pxwNPQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hex7vs12a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 17:06:31 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35a04491c56so58101eec.0
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 10:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792602390; x=1793207190; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=;
        b=cbKLoQhqeNXCGLi4HHxFmMhOUxkSOfp7e3ZchtQjmOhGl80/JCiDH56chTbGPZ9pZo
         Z680Oya2WFxdUMAG6Q8PuxUVPQgjaaBxwsDLJIVA+Yt2VX2MUkxEHusLOETNuACPqfRH
         FbiPdUiJevXwieVXZl8x0Ap8UEPYdsvkJB9tTcNIOpj9Nhh+2ZsjRbOKhdV/bkI4s53N
         bqn983WDqbZ+K7n3lUXgRMM8lYfT9NXcw7RtZA3KFczEt8nXc68lz8/17apqMTPLjgsD
         e5xG5gXg0B/yx6D5s2X5g+pWRPOK+5H4707jzh/XwBlGa/kJ05kTsh6pjEAdt5RFpJZ7
         0CJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792602390; x=1793207190;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=;
        b=YYMLA1Gtji7iGf/wSxqEXEntrmHfQI0AmT1pcXTNmb/IYnxTDW9c1xHz1iwgdiSkv6
         ZrwYmeW/b+rIVH58P1nZc2WFGJ0+QuZJdAON6sq95E1mwho4qEVmyNmJxviKe/uPH1Jo
         mhuYQfYPYxO8Ys8Iy0kuBReU4tQlgJe2GGPNf+nRSvt0srx/vZGl1ClUWyacuSkYhKuN
         WKVtM5c+8WJ8BSuQ9xA5AncHV70d2jl6FCEp5gAQjyz3iiffXuRSpgYduPCPHPiZ1mOu
         Ue5ZrBz/edqZcnWghlR/gFx9cVgmdmurCRIBPuG28fLCIXzaj3GgDA9wxJV8zLdwAzBs
         B9bQ==
X-Forwarded-Encrypted: i=1; AKwUvByZ5sa56URf3H12RRDzc66n1DZm7niuoCF12mo/tBkT7N2ZqZnoABHYk4QwhnAwKWvcVzBG4UQo@lists.linux.dev
X-Gm-Message-State: AFq9FYKgA2dzufyXECoZNMfxtHdnCMkKGN464joJ40wJwWl6gnEGvCNs
	yVsqRURxudoMBtDhHgOj3NOIXtqRFvVLdXUhVfsgFdbjUHTW70+D3ha6YgYLMr2gRRiS2bFv3L6
	U39peWNPMfO4PsOprAGd3+nRfFxFggEIlTyOyg+zJyDDRnaq3FNMIr/0mvyta
X-Gm-Gg: AYBFou0Iu/fOWrMXyBj1+YlrqU/N3teSWEp71fvDdDiqkoS+XzMMy0owXA+/l9pdgUV
	7N1289uolusI6PaltKSPH707kUdlr2TyUnanQfCaLaIzEV3qg3CIBwZnFNcvCXxXZXiHjDNq+hB
	4fsm60p0qL1opSI6w33gx+TrjNeRcugMfc4pnaWHeKxb/JYngeYRIcaUUnlgyMbS71Z9FWM/STA
	Ycpq9iDavd/Pnmr+4GAVIuisidQ137uIwjHRYArapOfofN8g5nOsSTQw2LPnm2BNZsHa9stx0ao
	RieQWyTiMaXg/0ew6kvGKpyvJzWNCyUr+Y2zCceSlJfVs6zG8wjY/VwpLDMqya8SdUa/mmHJ8H+
	DUGHT7sSeP1VEczIubczZY2RqV5KIwsE5N2VJmcsnYw==
X-Received: by 2002:a05:693c:20cf:20b0:363:a45d:10b1 with SMTP id 5a478bee46e88-365fa49061dmr6847150eec.5.1792602390113;
        Wed, 21 Oct 2026 10:06:30 -0700 (PDT)
X-Received: by 2002:a05:693c:20cf:20b0:363:a45d:10b1 with SMTP id 5a478bee46e88-365fa49061dmr6847104eec.5.1792602389510;
        Wed, 21 Oct 2026 10:06:29 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367f52ce166sm5334511eec.29.2026.10.21.10.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:06:29 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:06:22 -0700
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
        patches@lists.linux.dev,
        Piotr
 =?ISO-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
        Ross Philipson
 <ross.philipson@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Song
 Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 08/15] efi/libstub: Have efi_kaslr_relocate_kernel()
 handle extra_size
Message-ID: <20261021100622.00007ae5@oss.qualcomm.com>
In-Reply-To: <8-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<8-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: QFiSS8aRpaElBQxKVjrDKC1E37GMIhCb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2OCBTYWx0ZWRfX/3Wj9leRH8ek
 ZJKwWdHe1Smip0Df2Mb/d3nh23pNKyK+oU1UP5w7q8NBcXVtFXEVi1Vp9Zedsr6c5EYglvZStfx
 GK3g/Phk0FSMUcnhc0YI5a7+zt207TI=
X-Proofpoint-GUID: QFiSS8aRpaElBQxKVjrDKC1E37GMIhCb
X-Authority-Analysis: v=2.4 cv=e4uT2qp/ c=1 sm=1 tr=0 ts=6ad8f117 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=z1Vexnt6jiiBlSUV7TIA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2OCBTYWx0ZWRfX90Wo6x4B0Tti
 Yb+46DqQzOh2ZdpQ+81og/jTxtjOwZSN0PLh0lHLuyB3Tb+Ejooedd+nQRU7WXjN2ox8nRb0y+v
 JUp1capFv8m1Zjz0537LIIi5p63Y4CjtSfRcaPjKFONYiH/JUFaH8uReV8fctJkngy8Vphgu8lv
 TQvM2E3B3ysfRYcCiLtoLQwOQoGeTj49xlSdPZcW2ty3MgBfn6x1+dcr1g5U0ONuAby8bK/5oJy
 ZW0BlVx6M2MCNdbEkTqHxmjnOl/SybmVqrzYrCPT8LVa1jDhOilIPAfvJlBJoBtyGZPI8hGMIg+
 mUNxNkqB+ZXVCoeCVn7aXRZ0feB+RtINY5ySjVMPHFq7BOyC08Uu+F83+q8RG40cHPS07QFtAK2
 wlxGAPIK2mYl0o1/YbNm7GrYMsfsKmE/rq33AdsIUEt6B9qzrA0hh6qu17WDc0RthC+tQ9vldRX
 Y3pS9ZuZy23if8JwJ5w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210068

On Fri,  2 Oct 2026 20:31:45 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> There are three possibilities here, each a little different:
> - relocating for kaslr, just request extra_size like the zboot flow does
>   when allocating from EFI
> - in place, attempt to allocate from EFI precisely after Image to
>   confirm nothing weird is there, failing that
> - like any other error with the in place EFI location allocate
>   non-randomly with extra_size included
> 
> Remove the callers' assignments of reserve_size since
> efi_kaslr_relocate_kernel() now does it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
A couple of trivial comments.  Otherwise looks good to me.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
> index 4bc963e999eb97..e419f3800af517 100644
> --- a/drivers/firmware/efi/libstub/kaslr.c
> +++ b/drivers/firmware/efi/libstub/kaslr.c

> @@ -125,16 +164,29 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
>  	}
>  
>  	if (status != EFI_SUCCESS) {
> -		if (!check_image_region(*image_addr, kernel_memsize)) {
> +		bool image_region_ok =
> +			check_image_region(*image_addr, kernel_memsize);
> +
> +		if (!image_region_ok) {

Why this change?  I don't particularly mind but seems to be churn that isn't
necessarily needed.

>  			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
>  		} else if (IS_ALIGNED(*image_addr, min_kimg_align) &&
> -			   (unsigned long)_end < EFI_ALLOC_LIMIT) {
> -			/*
> -			 * Just execute from wherever we were loaded by the
> -			 * UEFI PE/COFF loader if the placement is suitable.
> -			 */
> -			*reserve_size = 0;
> -			return EFI_SUCCESS;
> +			   (unsigned long)_end + extra_size < EFI_ALLOC_LIMIT) {
> +			if (!extra_size) {
> +				/*
> +				 * Just execute from wherever we were loaded by
> +				 * the UEFI PE/COFF loader if the placement is
> +				 * suitable.
> +				 */
> +				*reserve_size = 0;
> +				return EFI_SUCCESS;
> +			}
> +
> +			status = allocate_image_tail(*image_addr,
> +						     kernel_memsize, extra_size,
> +						     reserve_addr,
> +						     reserve_size);

I'd move reserve_size up a line to group it with reserve_addr.


> +			if (status == EFI_SUCCESS)
> +				return EFI_SUCCESS;
>  		}
>  
>  		status = efi_allocate_pages_aligned(*reserve_size, reserve_addr,
> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
> index 725b634c517919..a88b2d275e5bb0 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -37,7 +37,6 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	kernel_codesize = __init_text_end - _start;
>  	kernel_memsize = kernel_size + (_end - _edata);
>  	*image_addr = (unsigned long)_start;
> -	*reserve_size = kernel_memsize;
>  
>  	status = efi_kaslr_relocate_kernel(image_addr,
>  					   reserve_addr, reserve_size,

