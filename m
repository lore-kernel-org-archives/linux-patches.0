Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599394;
	b=tR+EZTiGouIux7dHEoNKktwuDElXytPJXOEdnnk4NdJh89mqB1Na0a7L7wYRMWN7w14z
	 ZGLDc7V48fnJTJf7n7CZThXXJDJznOT8GHsY/dY4jlvNd2RqVZSsRNUZUZg+o5OTpL1dm
	 dZnkW+B6GvHH1fcLb77h5Ujm2mDC+/u39xqVPIpY2MTNbMrNdNraY5AXMQx6YGTPdLqp/
	 Xtq0OWBprOe1P1Da9l6oXQ1yaB+cdir8Yd/oJ0gJmc1cqJQry6wBqQMS20Nh3TkmvFFte
	 4/2+FannLoOgG6ZxoKLb0Bq+gje7WXuRTScR8TjGIVTn/ErGmrk3rIwZdVOkWXSR8UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599394;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=9hWqXEuq9iUvICKJmtCYJXRTGUsjg4czRSsoSn+YADM=;
	b=xmRzwasALmxWasHC9OleZWHM4ANT66MQFARhGrWADgsVYtSP4mMO6NSxVyfeKqHQYldA
	 zD54fqkrsmgXMcvCt1yQhjRz1jpzUKeK20R+chZNtjvC3Gf10GMGrBf23R4IgWyqibkv7
	 mBxLvB/WaaXUlX8uIm/5FgHJK8oZbG8YH9wikzn9x2OeC8eEnFQVSEyN3RhS7KsAR4u/x
	 skmTEOonCcpUW7xlCwHbESCek+BLbOT/8MRkuCT7mBYgP++wW7htok9Y+JDu30V+oeKJQ
	 HyFanjEkU+s9XFuoE2hPbUSQQa45Vq0FYF4Ia7gBu4DsUHvYaO1ccVp8VTenDQZB2Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=i9+3PrHW;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DBVl3Jns;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A760606A565
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A760606A565
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=i9+3PrHW;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DBVl3Jns
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU1hU3726209
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9hWqXEuq9iUvICKJmtCYJXRTGUsjg4czRSsoSn+YADM=; b=i9+3PrHWHdY9KcEx
	Rkizp5TA6LO3x6JHCBfisbZ0xVIII/InNbBxuEouoj5Gl5TOhuvbQWrw8eL06u4X
	qiHRcvAhNmVYdbjfFVOwPWC3tQY0bR5kWrXLzQ6N++TpSf/0W4Z9TASh0cWZS0a4
	Xr9AZ/sJJsXeg1+6ffdBlzPEUJbhqfq/9wHvJh7xsRqxJSeMNgDYFH12igwOZIPc
	9Ae4kXTrb8SAFEmNoQRNByJbkPWjKBdcjRrRz6EVRgeBw92KcZMZBQC+kZVat+X1
	ZWlx2gub9lucHtn0mdnHsO852q/e0aPYuMDdx068yiGnUphUu4BvJDEy1BXUn9xg
	8ukbIQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy7a0q5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:16:33 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd0e92d64a1so3246a12.1
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792599393; x=1793204193; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9hWqXEuq9iUvICKJmtCYJXRTGUsjg4czRSsoSn+YADM=;
        b=DBVl3Jns7HWD7ypxKIo1AqODOKOn6aq5rXSGWn6bArF2wXjN+Y45xjWiNtPB1UIIDF
         IFrD00gAlZmPUHNYm3zE91Rj5pvbqXQgHf00IbytCPKP7YKlZlL0SCs9d1N8hIqO1yaX
         sX3uhF/0f6yKHGdmBgBsIcX1ePFfzRsxD8guLoiXzQSk73eZJLI1P3+0W9lKrp/Xyhds
         DmGyNN06mUpF475PEwktBQmLQJIGmHKugn7aLTtjj5tEhYx0pm+qES0C4SOhGy3GAlAp
         cHBfFU+ci9MxTQ4cA+FmEmWS5JcsRyMdVvX+Gow93/sj89vf8QHcIOQA2wuY0BOGEQpi
         5fTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792599393; x=1793204193;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9hWqXEuq9iUvICKJmtCYJXRTGUsjg4czRSsoSn+YADM=;
        b=0JQmlvLOI7rAjWAitA1T7imgS8FEujhcfpSPS2OsMlQjOTTOXnhRMJS2E4dSWNgb8I
         uFvcQ1YmA01j86J1HkpoJ4v2Z3PAJlX23cnXepiw5TWolonQBAYxkc+Npy6W3N2aAs23
         xLHb85UNAkgVt0ezNyYqthY9o4mgB5NGVYKVf95naKByF8wbTKPvNuuqTQL3cZbEsZhD
         qKEOsmi909wOCRLlChQe22nfNr3cP9+9oLFJBX7tGxPZ6b8BIgDIf/8DksjFA91OomUH
         maS6Hp0vUHEUZ0n6R4g9vLf77kmPjn+bGl+mblPCOz5YI8dq4wMhjTAZJTMWJB00Uqg7
         YoMg==
X-Forwarded-Encrypted: i=1; AKwUvBzQ8zzVz8HNVghime/fH9qB7iOSgfQU5mRKZw/Mr3+AeOflO0HCR6loTYCIkpWIHzwo2/VgoE2z@lists.linux.dev
X-Gm-Message-State: AFq9FYLyyiP3UE/hhS3xZvc0OGo15D/8FoPgoLeIlDUdFoM/xszi0G0Q
	PE7ZhY5RYCLOkJyQIzIQz9YKVjnt++GuVdmaqWFkIteNRRiy7meKz4lCQ5LtRVf8m8ZE8YmD/Vs
	8jXfkQZV8KJTdhEHngP3IUnTA6Pt7BhMqvnkn63NN/NKSvKXSgfbZEHEqQa7I
X-Gm-Gg: AYBFou0KrRqdgQcWO0nRBtrs4Kd7Tn+sPAx4t9BF+HvESRfH98+PuyVbMWVTcv9EY9K
	mskowQ11PVzgUFcVJIEUtCu0DAdWVJCxRfTJO+THrEpZ1FdGw7V/D5hgqVJ4tMWO2gpZPnehsGr
	XlWfCVE8s8JEEqSG0u6MTMan0p84oJv6PdleUOWmCwMT8wk+lx3DNO7b6Sc1zgfHNJJPtcJpgYD
	9Nh1pPi9WxFAI7X/TLQ4FFEdFec5vCAJDrV6Ig3AH6SIbnLe2hY1BeznMZ7IrAR7W0yENppC8aq
	/sOm2kyXMAswAKQ+tA2m6LZ4DH4+o+fVmM+mk/nQDpoMfOneqKcT4c0RbWR8r47SjQYTZvfY6+T
	GvwSFFKSO8BTacvVsBCMwlMxlGKgfpcOFhPccEJx4Hg==
X-Received: by 2002:a05:6a20:2f98:b0:3e2:6653:149c with SMTP id adf61e73a8af0-3e26fc04d39mr3512945637.10.1792599392803;
        Wed, 21 Oct 2026 09:16:32 -0700 (PDT)
X-Received: by 2002:a05:6a20:2f98:b0:3e2:6653:149c with SMTP id adf61e73a8af0-3e26fc04d39mr3512915637.10.1792599392315;
        Wed, 21 Oct 2026 09:16:32 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6b84b6b17sm205866a12.13.2026.10.21.09.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:16:31 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:16:25 -0700
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
Subject: Re: [PATCH v2 04/15] efi/libstub: Add a general way to get symbols
 from the vmlinux into zboot
Message-ID: <20261021091625.0000515e@oss.qualcomm.com>
In-Reply-To: <4-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<4-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: FOxMHQt4hl-pRMT4gQ-Z2Rx-PEggx-Xr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NCBTYWx0ZWRfXyiNk8S5QHyiz
 qArvvROtAdWWpHgzouzTb7VW6V1/C3/hIsp3hYllOq7iAa3KAj1wuOYCeRSCT1t4F32+CxPsLxG
 XWLLD+Qg4aLctTx2LS+Ik0K8p0gXhw4N7z8W0uJC3dCH6mKO8qsIuZzbTRy8J4z0U7LLWYfYojJ
 9PmcYj1snPc50zjelg5cCgJ5BU8UkL13J52pYJNq0xc+HYP3E8lPwFNJpEyC1TxdBc5SNErE09F
 gxBVtfysewjL59WTlZjMKi0ufD/dQP5L0soalj5yNduKUlO3IZQjKE1Bl/t9EMmAKj6x/UcObGR
 hQc/O+4cjBRj0D/FaPcpLTdz7hLdofbft9gsaPUdyyC/x4z+09oDYU4XESuE8o0bJwv08Os3JAd
 RcHd+M0JDNDzj99w0Xy6Hq1/KV/k3Vxz3rhNR0d2bI5avrzEsf/szta6J9wFjN0dYbtqXi4ejbw
 xGvHCROvp9SzVICQjww==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NCBTYWx0ZWRfXx5UuTPYDwLce
 agzIgvTTwKdWhiybl7U797Db39oF8jblUoJ5sKbc0BXSebB2ZLtyp+tZv015tiAsjriDBuRW7IS
 VUtjpSIeQcG6Bzy/aFWW3bybPmJSqTo=
X-Proofpoint-ORIG-GUID: FOxMHQt4hl-pRMT4gQ-Z2Rx-PEggx-Xr
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad8e561 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=ah4THgOBrJhmsRMU:21 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=Ikd4Dj_1AAAA:8 a=_GvItbcUg7J-DuPKX2oA:9 a=CjuIK1q_8ugA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210064

On Fri,  2 Oct 2026 20:31:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Currently the zboot stub has no access to symbols in the vmlinux. In
> contrast x86 has a voffsets.h header that allows the stub to know whatever
> symbols it wants for the decompressed image. ARM DRTM needs another 4
> symbol locations to work, and it also wants to compile the DRTM libstub
> code once and have it work in both zboot and embedded.
> 
> The current solution in arm is "code_size" from commit 45dd403da851
> ("efi/zboot: arm64: Inject kernel code size symbol into the zboot
> payload"). This is neat, but it makes the zboot and embedded cases
> work differently.

Not a real review as linker fun is not my forte.  So just some
trivial formatting comments.


> 
> The x86 voffsets.h approach is also nice, but it can only work in zboot
> since it relies on 'nm vmlinux' to extract the locations. That's a
> circular dependency for the embedded stub.
> 
> One idea that meets the requirements is to embed a struct of offsets
> inside the vmlinux and then have both stubs know its offset from the start
> of the image.
> 
> First, each arch defines what information it wants the stub to have in a
> struct:
> 
>        struct efi_image_info {
> 	       __le64 code_size;
>        };
> 
> Second, it populates the struct with the linker:
> 
>        EFI_IMAGE_INFO(
> 	       /* code_size */
> 	       EFI_IMAGE_INFO_OFFSET(__inittext_end)
>        )
> 
> This approach with the linker is guaranteed to emit a value and not a
> relocation. I looked at writing the struct initializer in C, but that can
> result in relocations inside the struct. That seemed sketchy so I stuck
> with a linker script approach.
> 
> Finally, any stub code, either in zboot or embedded can access the struct
> through:
> 
>   const struct efi_image_info *efi_get_image_info(unsigned long image_base);
> 
> The makefiles arrange that both links have a "u64 __efi_image_info_offset"
> symbol that contains the value. For vmlinux this links to a symbol created
> by the EFI_IMAGE_INFO() macro, for zboot it uses the same technique as
> code_size through the zboot.lds.
> 
> Since this needs arch changes, protect it under
> CONFIG_EFI_STUB_IMAGE_INFO. The arch should define the struct and use the

Odd line wrap as moving the CONFIG up a line is still shorter than some of
the lines above.

> linker macro before enabling that config.
> 
> Since everything is linked together, and the actual location of the struct
> is not fixed, this is all private within the kernel build and can't become
> ABI to any bootloader.
> 
> As some follow-up work, it seems interesting to standardize on this
> mechanism and remove the PROVIDE() and voffset.h alternatives. This would
> also avoid needing to pass sysfb_primary_display through EFI from zboot,
> for example.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b2988aa12f6645..4dd52ddb148401 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -83,6 +83,44 @@
>  #define RO_EXCEPTION_TABLE
>  #endif
>  
> +/*
> + * Architecture specific information made available to the EFI stub, see
> + * CONFIG_EFI_STUB_IMAGE_INFO. The architecture describes the data with a
> + * struct efi_image_info in its asm/image.h and emits the matching bytes here
> + * through contents, using linker expressions the compiler cannot compute.
> + *
> + * Place in the same section as INIT_DATA.
> + *
> + * The architecture must also define EFI_IMAGE_INFO_SIZE to sizeof(struct
> + * efi_image_info), and that definition has to be visible to the linker script

I'd wrap this to have the whole sizeof() on one line line.

> + * before this macro is used. Keeping the two in sync is checked by a
> + * static_assert() next to the struct and by the ASSERT() below.
> + *
> + * The struct's offset from _text is emitted as a u64 at
> + * __efi_image_info_offset. The architecture aliases this location to
> + * __efistub_efi_image_info_offset for the embedded stub. The absolute
> + * _efi_image_info_offset_value contains the offset itself; Makefile.zboot
> + * extracts it with nm and zboot.lds emits it for the compressed image.
> + */

>  

