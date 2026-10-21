Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792600405;
	b=bnnr0gorUQ4Uohiq6uu+zEhtBxBuRDi4FlLQ0OgvDauWYPUKEKI46YcLghudqYIuF7yP
	 ZpMWd8pEqyjo2ukm2zMUELA7ahHtqJyCvggotsAPrIufGu13dY3Kb25Ka7sfRhUqRw8lH
	 FQsgJ23fk24p9f7jZ8Kfbv0dYwBr9Ot/B+qtLs696yANMLgIeHA4qmeTNUGEMQseBtiXX
	 +kN0+eh9pD8qTKEZuMBaLFjxTqWSsdGNAj+SKXmDZf5PasgNYXQfKjXNDDgJLytx4Zz6n
	 xnI2uk7SXx6VschqelXX3HfdhQPxbe4dQpyUqpVIFAniNP34CeCAX19wMX/uqcY0tAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600405;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=;
	b=ShYmbr70jiYSQcslyISZWZeJU7rSutADX+m9q62UCsL2n/ELGZGmnF6kfUZ7i94HVl+d
	 s2y2sOlkeOYgbF5BPFS2r0LBE2Gb5sk4t+D99sGm5682xM1qtl14ODEXi5oGJdHw16mCG
	 /FsQ0boXzOSFMBiISZ7Wgl18kC436ZNbyJfB0wotR9wJxzwtDKNcwnKuGLR7BdJ1GQcUk
	 DJnRKGPayQrXuFS/Bp2c+2vwX8soVLWVlL4fT4XC4RU9P+CUCrDZoXrK81qtuJiAMMxiK
	 BgBoWv9LBCGdyZiTWCwHgQ1CKKsuqxyg89zsDawRemifPqV3QKfwUbE1N3UVhxPh1Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GUi+svDU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cehPNdHY;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D87606A324
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33D87606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GUi+svDU;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cehPNdHY
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFTvuo2102013
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=; b=GUi+svDU/yyymhsl
	VrHOtB1d73sBGwG7COM52idcWEEDctYMa+eF6Pt4VtlzcUUOeQtAh2n1Vsh/2WQu
	0u2tDuR/jArqfSZjo5WeZDkmKKnq5Cyx8LpPJLaBgJ14HSsFT34pk/oMJnE/QjZP
	wyw5Luv8WVqQT2T3xAGbmx03QPVfE3A+2OotuyjaMF4DqeoByKTYNGCQZF08de+c
	iWVSRHM+0Mr8/oSDoL8AAiVZP7kj7Tx91KaLcsM4HRQSlR0x5UCwgmmD9m+hLCQj
	/j5oJYm/JjLQzfXhoQU6IC244z8l/Pqlkc+kupWm84Z9ZYCfxIBs8ju/HIUwivyK
	DroMWg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heuhuhhuw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:33:24 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3acd21ba24eso777473a91.3
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 09:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792600404; x=1793205204; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=;
        b=cehPNdHYHbIfp5AgdMxSJzHccY8wJoGVmuJ9rMrUSsK95Z001j4sGhcgKhzPY5wK7n
         W1AB/wfpmuJLURYswl2SMIycCyXclnw4GGZ69+hthOOocxFf9SPgNwotzPUTOjgA8Rt9
         lNNXPEdoi8hmLVsK+QIVoIFmdOiWq3XSJgMxsSvasLVbbh+HRJDEzHh6jfXJNX7UNxRY
         ZADO4Fq9eKht6W5YYRJLSn79hLUqR8Gy46G8jBhahmsgycrOAVbk6YB2dXBzn8S8owxj
         TyPS0Xvp1pIWPpul/wdwFfBtPIUBOM5kvFVincXEy3HguOhGONwIQAZ1RZqmkjxTpsfj
         QcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792600404; x=1793205204;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=;
        b=oVmm0yEDpUbzL6ClQp1Vo4NxpA1ZxplVlz/qy9OR9Thh47DWd7Lneks4G4ykO1I14q
         RrqRt3lWy+bQuG8MeI6dti2hHQPwyq1neS8CmilkwDk2XZkjS2A2bt2mLxTy3OmxqI8N
         JNB6fg2K7ZrPg9qeeaPdeWWkr5vuwf/CM5LoRS3JLQz6sAYcO74svU83vgiEYUwtDeBE
         1D9uenv6/QnRVvJJgWZmsLgCL4WVP55/E/tfYkXI/2LRF+cm8m8RoMSyyK6ThdPLrQC8
         GuB4od1/tiApHlAPFGAc/aVW7ZIa5auuedBB/FHR4nYs+SRAOryDrU7Nmw3fmdL/TYgI
         8WEA==
X-Forwarded-Encrypted: i=1; AKwUvBzXpiPN6vtTcZP5I4+d8Mi2Z63XAW3vHbl17VNuREW9cBV/KVPakbZlbp+MC7zcxkOOHWNpY8jv@lists.linux.dev
X-Gm-Message-State: AFq9FYIbFRNb69aZugqnMHMa0+bxy8o44p2eDTfAiuUk3VMt58RjiLbL
	qtc4H9oMAG0L3ZFs37lbDHFtaFI+ybXa6hlS0JsQNOraS91UEANj7blQHfU3KVpDSJukkOPrLkw
	NnLtJZwIATjPz/0H1yj81PcImGbmLfGtcscTeGcY2I3jgev8EavM6cstYRjNY
X-Gm-Gg: AYBFou3RLJ8/w0xVkDbmvQ8q5+chG4ybruIOoQ2rF7CL2LtRYqPssyENLfVZq/hwdYB
	jwYi9o+20Mnr75xUh8GcHZ0sJDlXrvRQQfMxVM15ZcpRcbabuxyIdnx47yNUcM8kvUqIgRbUQYK
	M9TDdG8smEz5jifh98RXH0fvwiu9hAtjvm8NcN6ITfJbMOm9KabVpI+TmPB+PGNVwxX0e8FPfED
	erRzsIz8/Qsw5C5LVBqwCq2cjjuAEHYdLk5fh3Cdk7Yo2gQHz6A3kTgBpD+ZdHQg1sma5RgFuBl
	CSwO+yr6koSoXMemMbnZOo2aW4/eSIGP5N5U8fbQ26zM7XOvw6xvgsCmA/nLdSmYwBzJ5a1z1XK
	eL5ytzkSqRCiLXcZ1nv4WUmvYk/Lhc4Ks5eIA2yIHWA==
X-Received: by 2002:a17:90b:5688:b0:3ac:b185:fa16 with SMTP id 98e67ed59e1d1-3ad86ef57d3mr2257166a91.43.1792600403609;
        Wed, 21 Oct 2026 09:33:23 -0700 (PDT)
X-Received: by 2002:a17:90b:5688:b0:3ac:b185:fa16 with SMTP id 98e67ed59e1d1-3ad86ef57d3mr2257139a91.43.1792600403107;
        Wed, 21 Oct 2026 09:33:23 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea4005a7c1sm11891595ad.71.2026.10.21.09.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:33:22 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:33:16 -0700
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
Subject: Re: [PATCH v2 06/15] efi/zboot: Lift efi_cache_sync_image() from
 efi_zboot_decompress()
Message-ID: <20261021093316.0000594b@oss.qualcomm.com>
In-Reply-To: <6-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<6-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=d4JgWhjE c=1 sm=1 tr=0 ts=6ad8e954 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=w7afb6Jpyl5axNu8_tQA:9 a=CjuIK1q_8ugA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NSBTYWx0ZWRfXxJVeLqwGhD+9
 V6zKYTkB3JDULrBWgwPqcJFz6EklgbEUB5QrvbZXDnaoGIQgOssiFDOXmFoyFA9QzdcT3mbEmP5
 hPubB1UKXC/nmOlqdiqshJeVGmJsDF4=
X-Proofpoint-GUID: oSjskR3RjGULovGJltZ1xytWtZAWdh9I
X-Proofpoint-ORIG-GUID: oSjskR3RjGULovGJltZ1xytWtZAWdh9I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NSBTYWx0ZWRfX5CLnQk0hB3Xk
 YpRyzzQ+Xh9dqDPfQua/RW+8MRvExuEz0cz/Z7FPGHqAJ1zOim3xkDhNHkmXMuyBr/bW0zgJSa3
 O7LvJQKT3TU4WXswLCkxaeUd4xiW48bZQBTouKwPZ+zPO7/F3HTBZb4Zy29SxG1vxjOAiUFP/Dn
 wNPUxGhzr41ZB00oicALElTwMDXCHmhyt8YlFYpGcCs33fOOnnCye06szASU3ZBhYGkfen8CJsD
 KBA5N7EL7gZu/1ChkFb1SimyUKhe7Yc8UFdI/YZej7VnGKgeEFr8F99n1Z+zaOmm4auObP3VepU
 xTuGprKt+yRPnz83vQxh1pcSK+pzhduak/v61zIEff6oiOFn+5odmhRzgiDvsGInSxRbXF8soue
 rr/SVW03catYhAUgDJRBVSYm74nnXJcT+OwPhq5SHFe8U1h9/2mDQo7piB/C/Z2CRdfCy+4JktN
 ji/DJKZjoMTq8jIGgXA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210065

On Fri,  2 Oct 2026 20:31:43 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The two decompressors duplicate this call and the next patch needs to
> change the argument. Hoist it up to remove the duplication.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Some mutterings below, but I couldn't come up with a better code
style, so

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
> index 4b76f74c56dae0..e3abaa05fc4183 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -92,9 +92,11 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
>  	}
>  
>  	// Decompress the payload into the newly allocated buffer
> -	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
> -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> -
> +	status = efi_zboot_decompress((void *)image_base, alloc_size);
> +	if (status == EFI_SUCCESS) {
> +		efi_cache_sync_image(image_base, alloc_size);
> +		status = efi_stub_common(handle, image, image_base, cmdline_ptr);

A little ugly though less so than original code with that implicit assumption
of EFI_SUCCCESS == 0 that is avoided in most the rest of this code.
__free magic would be complex given the need to provide the size and hence
we are down to a helper.  Ok. Maybe just not worth the effort given how small
the code is.

> +	}
>  	efi_free(alloc_size, image_base);
>  	return status;
>  }

