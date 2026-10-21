Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792598432;
	b=QNRyco8Dp7nucEfhE6hbb/Cv5SWPO4EbzcehoEKWbX+jlOMzoCr5/45iuDpQ2OJlI9Xq
	 a77l2mnLj7SScr5F+0pQ3JDGtB0EQOBVaR1aZzJhgGHA53hOYsoZeQkFEd4lNTdWTOxfc
	 oe9KwHbctl7bm2tCsX0jn8OjNACJkp9KT1aHmBV4pQ9piVDYwdiltcaqbIq0RuDY7VZdw
	 +I99ynGih8zFgiycPV48QY2oxdedlkHP/YeiOPyC3lGQy5MW0jND4HSX9WFvWnCmskWK8
	 RD8EJGIxH+aCW3QmSDU2Fj+HKEAjAzABxln5bJj+Jmbfhi2yUhXyGIaum/EWog2snfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792598432;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=;
	b=dy4YtYO9i+41H3oJ/JBZZwrFrzvENwYaY30BNOOZXfCnNAeBCUxd/JSh9KaPRXBp+0Lt
	 on52oV7asLGOTn1t9lz4dvUWE8Q6v21Huc1KEYTrdZ8pvzU5RYNEPzW2/nkljrMmTA4Fr
	 BHdris+NQv8nSkA01/KhwXswmCuow/tOb2MHHhYqm7S0lU++F/5Z+ukUfZw6Kp7f/FjvL
	 T9mou+vk+/8dvnDX0CEfVk+pxwifii3RDBkOb5A2eugqfHbLWooqkS23zfgzQc888BwJJ
	 TDCWd7zKh8OQ6ehZPTe695MuzWotI3282uLNRsXECmpJ3lZI6YDHr4xf7EBVHs7pSaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fwgbev1Y;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="hja3c/Kn";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B1F606A31D
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94B1F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fwgbev1Y;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hja3c/Kn
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFeu9a1016331
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=; b=fwgbev1Y755yo0Wk
	UtrQff0d+SDedqVBkyUwA25GdbsQr1gedtRARzdBI/EmAOe0XsQToYsDxG3dcNo7
	WzxSgYac/ZGOsmY8agUmPRwldZjLtqwf49ThqvX1StCK7jmI7HXPKz+sOHF/9RsX
	d2pytN0NJDGCo1MhMPxlfFPfca6UKvw74dPxLEl0uCzKdYPb+HZyLX3GECv4+38B
	1RGJ0zWdQGHzDf3e0b63brnwjxFoTAwfwuugTBfdk1u7TM1ZeuovSwyIH11w2+ZW
	SdnPxbpBiqOcHpBXKX9x9UDSHSBDxYFiyv72OFxlygXqyI/101YubsytU9S9Gndm
	8d/hEg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heh5r3w5w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:00:29 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3580c07911eso2444034eec.0
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792598427; x=1793203227; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=;
        b=hja3c/Kn9fA3ORpMJMVq+ukmYiXZdIvkoEzhhIcS4mSObNZz3bKyiXS2nzov0Aw9hO
         cX+TEDbrD0CD1vbTlI0Y/41aV34V95ijIsutNYpMWOwm4O8G2SRcmXIwmJa2Z+CjPTu0
         hOd3RlYOn8xsYxcSiYwzHrEmns9npJMhkcFwWkaZCSt6S67Nlp2FL+9dsfRsianhz4na
         qa9wXN5/9zWurjLXS+vzfLj6afDDp7EeAlY5RO7HCxOzixWS4L5rH2j12P31gHWaifJo
         IUy40E1SoYU9SlLOgEGgRPDXrEncahwqYR2HTxr9sTxQLt7bW93K7t/22brrRVwNW5bR
         EGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792598427; x=1793203227;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=;
        b=DWu3kS42rKGHq5Y+l7frOPy9VdA0KujI8gX6vL7tg1eX1VhTLxMx+rMmpDY2xGvElE
         uPrzKbMjb+egLfWIZlYDjk4TdhMfMqYAmUeUE3hN1jhBmTu80YJqTZFmy3BbDDWhM6kE
         4j/qhS0InohigPtqCM64JaDs3tFSCbH2PWbE3XSC9/idQPNEg9lraa7QVKFHmpq6GrU8
         HEb/I87Z5jf1g+bnH2cj9FlydXzJmqR8QI+7OJNBXv+oEJU0SICiydZxZfkob6T8tfsu
         MJw9H9lAvnaxZfWmZLlcKvHFc78I3oRVA3lGZZlxDq5oyLXithoCl9w/c6SmvN5wSJqv
         4sZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzquRLKp3Z2NJhsOgyVljlfFWDzgKMIAw0H2r7vdH8rF79ZMTQwzVoWMRkIVvlBS0Fz/VCwpko/@lists.linux.dev
X-Gm-Message-State: AFq9FYLySyXVqKZeaE06HM9k6maKtuMdUeduXU/6gBzb2aNm6/QxPzHp
	7CA64aQgj9b3sk/f9Tp9dt0POXog54P/JS0oF08rN61SICn0YFG6h9a2YZqcus/JAYZ+LJyX1Lw
	e3/l3z+v4sJT7vCtETc1QU5s9qxXnhMGgGrOKuqmSn+2aXbkdFdoT0MJ0Lqyf
X-Gm-Gg: AYBFou0+Dee0mwxplk/3T4Zjgwy1TgaUhs9o70MmF2Ag9tSRXJRa+VDOOnEMlR0ZcZU
	iwPVkC8jAWZGAg7UyB77j8o86jTaR9ec8pRc4r/XQA/4hgfziHshXce1DAqm+VdqsO0RfKi3wfE
	TQC7eba9VfOUR3paM076oBzZfKDA3F4g3mOt5dwREnxnnJAQXK9D1de+t7F1941YApi+1zksnW2
	GciGu3FEdInT9QhdkVBrfnWkt+sSLMYYlHnKsataRGl0H2mLHoLA3gda/Jmqv2ihKWKQ3PEl8lZ
	KyIQpOodTDU4yh06gTYEl8AeTDb2XTHgs2bJBUqN/JLPJCpcj7MJGcg9kDC6dht10E5PUYQt2PD
	V6ZiwjpfE1HNjc9SuRC2+EOZ1cuficrIj3R0f72cyEg==
X-Received: by 2002:a05:7300:106:b0:35d:d9a9:e455 with SMTP id 5a478bee46e88-3674ef292b9mr4299688eec.21.1792598427234;
        Wed, 21 Oct 2026 09:00:27 -0700 (PDT)
X-Received: by 2002:a05:7300:106:b0:35d:d9a9:e455 with SMTP id 5a478bee46e88-3674ef292b9mr4299533eec.21.1792598425455;
        Wed, 21 Oct 2026 09:00:25 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367405ed2absm10188327eec.5.2026.10.21.09.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:00:24 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:00:19 -0700
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
Subject: Re: [PATCH v2 02/15] efi/riscv: libstub: Don't set image_size in
 handle_kernel_image()
Message-ID: <20261021090019.000060c4@oss.qualcomm.com>
In-Reply-To: <2-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<2-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=aI5lOr9m c=1 sm=1 tr=0 ts=6ad8e19e cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=Ikd4Dj_1AAAA:8 a=xbFV6RGmdEKkzbgyJ_QA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: 38KOIUdG_dWiJ8JxNfvOV86i9tPrpa45
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MyBTYWx0ZWRfX5fizOZpY2guL
 ekkjPVEZJMEEyUKE5/gaRj5pD1uNoGdXcYqPSwPAQlukOMCbNmzw84gh2kfT0Vux1mWmYoJHD3s
 L8x/ygEQDzcJP4IVdrlZ3BcZw6reI5y5/SkqVokiyw/2D36jFwKEpt//eUtGm0QkdTUbZfqLBBv
 E6aOOS+9LHsjS7VFYqKrMoI+5870343YCutIIug5bjBmvoncqluIvRu+O60SV/enMnfbwahNtB+
 mOZq8FzcGBkqtNU45FE5UrWStXzcwxlR901HaI0+9TjslwCSmbz0DtLx+3ay6rFILjvHtTqF/hr
 jsi6SQcB51tkkqtWUjHwNyghuBcA53HbuSO66t2J13EbEMJjLy12xcvuIWKRpUSCQ399SyMuyo9
 pLmyBaWlVV5/bQfFNtgZJMEfJYZxq7cKEncjYjDfXOY+KAeXz4ngfLTkczOj0ZCfvDExV+8tqfJ
 +K770j5epyvCKBnK0fw==
X-Proofpoint-GUID: 38KOIUdG_dWiJ8JxNfvOV86i9tPrpa45
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MyBTYWx0ZWRfX8UVibhQoC0gQ
 PoE1dHtCQL9km5CrdurKKpF7GI2KZeBQIb+mBYqLvhsUlG/SYAiXSHc/ApdUVNUYD/u5dYxx94r
 RGoBm48oMAC4Bl6c7k32tXjZrWdIpQY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210063

On Fri,  2 Oct 2026 20:31:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko points out the image_size should only be set if image_addr was
> reassigned to some allocated memory. If image_size is not zero then the
> caller will free the image_addr pointer.
> 
> efi_kaslr_relocate_kernel() never works like that, if it changes
> image_addr to allocated memory the free is done through reserve_size.
> 
> Fixes: b7ac4b8ee73d ("riscv: libstub: Implement KASLR by using generic functions")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Hi Jason,

This made me curious on the differences across architectures...
Looks like there is perhaps some room to make them look more similar at least!
One small step below.

> ---
>  drivers/firmware/efi/libstub/riscv-stub.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
> index e7d9204baee312..725b634c517919 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -37,17 +37,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	kernel_codesize = __init_text_end - _start;
>  	kernel_memsize = kernel_size + (_end - _edata);
>  	*image_addr = (unsigned long)_start;
> -	*image_size = kernel_memsize;
> -	*reserve_size = *image_size;
> +	*reserve_size = kernel_memsize;
>  
>  	status = efi_kaslr_relocate_kernel(image_addr,
>  					   reserve_addr, reserve_size,
>  					   kernel_size, kernel_codesize, kernel_memsize,
>  					   efi_kaslr_get_phys_seed(image_handle));
> -	if (status != EFI_SUCCESS) {
> +	if (status != EFI_SUCCESS)
>  		efi_err("Failed to relocate kernel\n");

This print is replicated at the caller, so can drop this as well I think.

> -		*image_size = 0;
> -	}
>  
>  	return status;
>  }

