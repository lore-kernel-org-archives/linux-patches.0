Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AE538D406
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290402; cv=none; b=l25wgAS5fDw8wFPo1k4H60kOVcVXvwFEVO5pyCYiOuRBIf/Q8cNJDz4CBFBwlDHgC/s3bmh5FLMrSH1t+56kXLDrJyHghb8C1xy6xnpScNCOFtW0rWbkVZD12DtGxQh9O4Ttcba+Ujz6eQyS6XxNe+13kchnYKekMKLUrY19UCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290402; c=relaxed/simple;
	bh=kqsES4KHoZs1msV6+8Gynms+M5zjnX0qZVcy11wRno0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oUB0qhWtgk+lu/YDvT5CtqrM+MkD4c0v44cZ83HzO0xd4L2FfeTv5FgLjeQ3NFLhUmRcDZOm1pBmOkCC/C/DRO4mLJ5ZKoUa+4fYK2Uxrk7byPK4hngUERbQ7+4aRShgR+IzhTm3KHOFY/t2hD+RzjVcSIDjn6uRyP+gyV0s+QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ezYnMi7m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j666HmAJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ezYnMi7m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j666HmAJ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMPZF02145175
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	26IKywfxXF+ovz3cISEJ2vKRNs4eRXW7AlvCnEjLpWg=; b=ezYnMi7mMpeuODcw
	+WiLkeryjucsr3GUsliA6Q/qo9TCIvd1SSF+jrBzrQsbydlvqplcNShv16zQgQxI
	MZGRtlLbh1SH7v/AkrkJ4rsQTrubeuk55FyS3UYZA3e7Vb0jZYtOfaHJsc0CxZih
	etk7fMNAWWFGjHVbtpCZkh0C3smj0TUga8KPoHo0DhbMcC5s48nWQxTTlwwPM23X
	QjeAe/CIUE+1ffljI8bI50OGKNhfgBFjYbh7Tg1yB5i7NO5Vh63G1a/eoj//OtUr
	RfEUshvbHxlSjE1ljTH7HJPpxS/ad+gFcAm607wb7wN25GasXfj7gfZwpl42yLDA
	g5fLXw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw1scb1v1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:53:14 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-14373747468so442434c88.1
        for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790290394; x=1790895194; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=26IKywfxXF+ovz3cISEJ2vKRNs4eRXW7AlvCnEjLpWg=;
        b=j666HmAJLaVZbTtsbcuBThiB16WVPhA+E6ZP7rpO6vCE7mwsQIG8TzprN8REysK++i
         uDAZVhcoZ1UsAt5rLAKLF1NrZQmBCaY9IN9ocyLx2yWMung+i8m7NqAgz6wPKE51Wq+c
         dvPAc0QQaKQcahHk3wjHtAO72HtP0aoF/SIimHBqywxGx9WnRcFYCWA0sj67MiHJ7IEP
         xBas+KcVEJd1/aWiqe5G0hdRBiIOBqjApN++KFO9itbEdxmpPlpMD+b37Pp4JCnZdY2u
         bNnSfufu4hWx5qQLgvwwylV2D85rAEQ5OV0FnTB49DwavsiYLiSR3tLZ4AqNjEo4SIYs
         MJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790290394; x=1790895194;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=26IKywfxXF+ovz3cISEJ2vKRNs4eRXW7AlvCnEjLpWg=;
        b=whq9aRGZLTIoROPlqvThNVOcWy2/BuNihr7w+3WTXMLEG/FGKX44IPs26MvwFgp/vL
         NMQgJnKnUkm9d2WqFMcyT3hpz2A2cA9zWGaiduy8472WHn88Ib+fZOUEf42rQXNHMitV
         zS940dQPFaV+Qm6n6zYY+6di64yGuACxz2FkMmVntZbgjaytwDb1eeyBgBfUgca1xE30
         PuNPPc6QRyWvJcs5NJaesNGsrlOn2wHAmmfs+ZmGwbRHKVbTgZizHkCysWpygspR3+T3
         gjPm3iJJopo7xPH6XPhrgl47zesPGSNfKnOsNHH0Kk/69YjZ5ZNWKnnNY9/B/kLaVmsU
         1ZUQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDqvE4A3a4VNccum3opXchk1qe5sq53kRsetkQww+wMCKjjug0LQ163V1/WjTkpeliJS8DIz84@lists.linux.dev
X-Gm-Message-State: AFuF++niuEntysyArS5VJhUCYP8j8uLbUPxEYQU7SWTfyxxzcGsWOU+I
	zJC602pmxCOQDc8SXWaccPE3lYap6j6iGGo/mip9Az7MlaI9b9rOjkdN+DhSx9aEBshJqxdSkKs
	jYzWPSY9IM3itNLBNl3FFeXJH5vzJUl4/9e0QGPA9/e5U2xu4TAWANggH0UAx
X-Gm-Gg: AYBFou3azLURromphNMuqODKKJZ7/rvBRcUingEQKhLQXHRavpbiqN7G/JnuYvMQ2sa
	Xc2s62W/nf3SS9gxssZMgocburiezlZ8xb2jwlCN61qB0+swsgDhoIda/ZCh8kDC+7SJSvUzHZD
	710s6fT4ETgSgD/ftZGJdjFCCan2GMg9fvEuSK5XKd4ZsFaE7sqFl9U6ug4bRw7z5YZvzL4WIm3
	MCok3DbjV/tn8Tz+6Y2nue8uhizOSKs4XqCMG8izsif1mvw4XsDBlptq26S0E6Hnmly35abcb/G
	mtiVdRb+Jq89fD+6/tXMd2Yk3gRz3KcXoY9hilAXg34dqYLwHPKzyFxsxJ8BbzpmDs9r7Jg0Q3u
	8ggOd4lr77ziuABchidIkUadUmNCoTpjWpuHOMfd8V31YMbC76EbrVQ==
X-Received: by 2002:a05:701b:204f:20b0:13b:3132:6e99 with SMTP id a92af1059eb24-14503f966ecmr3398034c88.20.1790290393074;
        Thu, 24 Sep 2026 15:53:13 -0700 (PDT)
X-Received: by 2002:a05:701b:204f:20b0:13b:3132:6e99 with SMTP id a92af1059eb24-14503f966ecmr3398015c88.20.1790290392489;
        Thu, 24 Sep 2026 15:53:12 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ad8e43d2sm1524306c88.12.2026.09.24.15.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:53:12 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:53:07 -0700
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
 Shuai <songshuaishuai@tinylab.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 04/16] vmlinux.lds: Move DATA_LE32() from arm64 to the
 common linker script
Message-ID: <20260924155307.00007dfc@oss.qualcomm.com>
In-Reply-To: <4-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<4-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: 2vlOZY2O2BhP3Cppe68uBUqglZDabQvl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfXxeiH0qkn6jbb
 sSTDR/d0iagWdKoknGlLj3fu917THC3j3FjKSg+6YAuJNXW30U6YNa2fJEo29KTee78KxM3Qo5T
 SB5lsMnnIcTXFTXup8y4ikTCX5QYkF7wfpokVCLIIDtaRGa6kV6HsIuCZqd7xq7hhkEyzGisbVq
 f13yqQdQfhmoMeipP4L/TLGycxxe4TRp4MLCITXcN/DNMJKttlEz6i6hgJ0Ehyp7gpR/VzGdDOZ
 RRKE95m8khKL5k5N+EqE1mUQCo9CiTLpx0StyrlCRgJbv1Ys4p2wktqRBrvPKbbE+vUqqMwSDgO
 8LOKiwVZ8ME2VeEZ5A/Y5Fq990GxG151SkwtGujYNRao2dp1L+7EUmVa8veK1t1Pi0TOdJZgiXr
 yI08LkdUxMeiVRtbCT7WYCCMvQI5e5gMzNVVt/DtQ+e8PWre23Wj2j5vOAMBCKpOYdLAtQ4ikx5
 nY2nGGCGpTZS7ZUKh8Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX1WMFjK1a7Nxv
 FQABnU2ykmaaahfedG5wCOLMLgGNpR49RSpK6CLtU3sEgZhjg8ouePp36uYsZZwS/4cu7cqzZu3
 XUKq9bIiL6J9kmrsq+A96EmLpQsi+ag=
X-Proofpoint-ORIG-GUID: 2vlOZY2O2BhP3Cppe68uBUqglZDabQvl
X-Authority-Analysis: v=2.4 cv=GI+dgeNK c=1 sm=1 tr=0 ts=6ab5a9da cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=Qd5iYfxjV735tpeAhwAA:9 a=CjuIK1q_8ugA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240093

On Thu, 24 Sep 2026 10:53:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Other arches may want to use this to get consistent fixed endian output.

You will have to grab it quickly!
https://lore.kernel.org/all/20260918145217.1669-10-will@kernel.org/#Z31arch:arm64:kernel:image.h
drops that definition as part of ripping out arm64 big endian support.

+CC Will for awareness.

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/kernel/image.h         | 14 --------------
>  include/asm-generic/vmlinux.lds.h | 15 +++++++++++++++
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
> index 7bc3ba89790191..1bff6b061b6cab 100644
> --- a/arch/arm64/kernel/image.h
> +++ b/arch/arm64/kernel/image.h
> @@ -14,26 +14,12 @@
>  #include <asm/image.h>
>  
>  /*
> - * There aren't any ELF relocations we can use to endian-swap values known only
> - * at link time (e.g. the subtraction of two symbol addresses), so we must get
> - * the linker to endian-swap certain values before emitting them.
> - *
>   * Note that, in order for this to work when building the ELF64 PIE executable
>   * (for KASLR), these values should not be referenced via R_AARCH64_ABS64
>   * relocations, since these are fixed up at runtime rather than at build time
>   * when PIE is in effect. So we need to split them up in 32-bit high and low
>   * words.
>   */
> -#ifdef CONFIG_CPU_BIG_ENDIAN
> -#define DATA_LE32(data)				\
> -	((((data) & 0x000000ff) << 24) |	\
> -	 (((data) & 0x0000ff00) << 8)  |	\
> -	 (((data) & 0x00ff0000) >> 8)  |	\
> -	 (((data) & 0xff000000) >> 24))
> -#else
> -#define DATA_LE32(data) ((data) & 0xffffffff)
> -#endif
> -
>  #define DEFINE_IMAGE_LE64(sym, data)				\
>  	sym##_lo32 = DATA_LE32((data) & 0xffffffff);		\
>  	sym##_hi32 = DATA_LE32((data) >> 32)
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b2988aa12f6645..1786a8e4323b9f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -56,6 +56,21 @@
>  #define LOAD_OFFSET 0
>  #endif
>  
> +/*
> + * There aren't any ELF relocations we can use to endian-swap values known only
> + * at link time (e.g. the subtraction of two symbol addresses), so we must get
> + * the linker to endian-swap certain values before emitting them.
> + */
> +#ifdef CONFIG_CPU_BIG_ENDIAN
> +#define DATA_LE32(data)				\
> +	((((data) & 0x000000ff) << 24) |	\
> +	 (((data) & 0x0000ff00) << 8)  |	\
> +	 (((data) & 0x00ff0000) >> 8)  |	\
> +	 (((data) & 0xff000000) >> 24))
> +#else
> +#define DATA_LE32(data) ((data) & 0xffffffff)
> +#endif
> +
>  /*
>   * Only some architectures want to have the .notes segment visible in
>   * a separate PT_NOTE ELF Program Header. When this happens, it needs

