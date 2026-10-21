Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792598916;
	b=o2UVsMXog6cEksqCvTwkjjbMDnaFm9zyNmbwFtlRJITX7UvKTaqSLfEbnbqcxsO2axoB
	 5pIshEF8Y6+W5C8/eH+o/PoB7HZEe30uBRFmnk6AAzh56b39bcObuXxTg38J8hXPAo8BS
	 CCZmG6tem4MnBPpExnHBlJJqHHhmgneV1zbGw0hHAd+iz2H84sIF3acFRckTsXpld3x0P
	 f6pst9DU5R81w0FN2rCO6PdRPtdAQo9vQIab+pOnlh7+oZeI9IWZJggy1UN6xKFBT4PSF
	 6PHtVcqs7rtideiOJiaXsdHZKy3MoCn4mOnMlYKZfnUh5HSqTOlOSJ8/L0vYxBQzUiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792598916;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=;
	b=Uo4/p+GaG7wLQkwbxNQ/wh9KHi+xtmNzUJFTXRzqrDG9SzS47ckeU/4z1ID0ImrgMWRy
	 Bl48Vrk5Xkhl2FNzxwcrCASdRS+jxaEsYYU1iqpl5nhbtYQ1HElNGxBJTsfwqTkuJUByf
	 J0elTJdTrb6uypezyScdbGUOyFCTHuix+h/0ZQGTF03DhZ23NIxO/JWkJNsXRajq9eXOI
	 2GxnffzJx6MXHZ25lQCevBixh6YpG2TvpKhZbg+MO/3DlDbYIch50O3RzCjlmuNnSi5NG
	 Xzws402g47dzHpRbzqXXG2vqH+aX/TrKhIVXXtA0+yg9qlZCNYj4grgngESjguzmlqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ppsqazaf;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XEkA5j+n;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C3B606A31D
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47C3B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ppsqazaf;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XEkA5j+n
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LG4DKm2149297
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=; b=ppsqazaf3z/Ovnn1
	SzWOwFC6FBH4fWPIj1FFpw1+MfbxoKTpq3L+dL3Z+e3w7356YZ6RysSOxUSlT+jE
	QJ63VeLe4fC9YoZU8/wWjZGfXODKSBwllcZGiYbUnENdNs5V4JoZtOO0xT0uHd/I
	xWphiIy5SHHmhNox7zwzrK2Vqs+UWLy3gU0nXuyduCWSyhwAtJrrWHEuN+VRgTMm
	hlzoca2KU2LPeFWWVXhGFOSPOe97rBtnG8yGmM71Gq6BNVbN2C1Iwmwrje5lGBva
	VCVasiUkD3EzsCgdmldMxwRAjdIFHG23zVG5vKxeMRaRrlso7XF2npL2q3GBF2Sc
	GdYlJQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf0ke00sx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:08:35 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a01e2962a1so1139190b3a.2
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792598915; x=1793203715; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=;
        b=XEkA5j+n2t/szk8gs1V3rtT4yA3yBIs6mghsrQDGpGyh7i5kha0JwHpxgajfF2qehw
         aRQo2iPo4J9yZ/MLKbhhpuz63OUA8ttWtqibOoDwwH3PFWLo6cJ/vfzCnDClRtDZ2W0u
         iiPZypjeVOx/SfbUABA1JGAcp7z9MZqOGf9fpLwRHv6iwLrI58h+lBxqKEwd8/5t6FGi
         ZuRNm3NjaY3l1IjJIryoSnFTTQQMrROVE+KG33EYdjc3fYZPG8YrM+1xjePz5yMyBd7L
         01og8hdJaqrNUFO3ttClmTDksJYOKMhGhUdSabU3FMzLkIWmO4ykpptkLt2IZg+2tTRi
         bl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792598915; x=1793203715;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=;
        b=24g0t+ic1+JzzsN1WoRya0M+K7jSiAdmhx5Ww7VQ+Vh164Z1NgFCEqOJIoTX71lSvk
         +lyXIE1FE1+FE/mTkm00Pz6bAPzbiON5D8ZPt/jrmyOIsjJL8e4cjiXHH4vAuPuGk60K
         Dsn4DPsgKHWK2JKsbIUxTaZzkXtXXvVh8Nw++YFku7Nwh2AcMLxONE9LMMBqKSKdDj52
         rC79VWyBwejlhfqpjX4GPJ/fCZtcva1m941H/gjxxtFp1GJZvao87A9rh5tQmaoq+95r
         N/hdqgLKUgLvrcIFgV6Dxz7EZyZ5jxcq9pSEjRzMVESkUDpa44QpJeUH8Jmzf1N3pHVB
         E0tA==
X-Forwarded-Encrypted: i=1; AKwUvByCZQissvluBxxu0KwdG4/nYf5Ank/8TksNvd5pK9QSXjqzGj2pwz7feRH+vF02dl7xdP7Hf8z6@lists.linux.dev
X-Gm-Message-State: AFq9FYIRloOVVw5bMfnoXYfhpTThC25G10G1vqoQqYRkbyExswfiXPoR
	8Kw1SceoXosejPxKPhgxP2cNBsggG/uyz8VPCZPLMcwsKkvvVXGFEuvQQffxP1v4GpehhSi1KeM
	UjiJaQiPd7fTIusWttQM0OWJGGBLKtb298afLJtydO7J7o6Q18ltgUWYL7ckZ
X-Gm-Gg: AYBFou2rABYu/UQ6pr3GQGsGB+W+8uRHX5ayFEtx3WTZsxSfCu7d/xujPpqV07AAyd4
	JmEY00a96XbLPqNWirn0Qo5nMXWJTi/PX2UHFvzchYHz0hqwkU/u7t7vM1wOkV/DXacl+wzHxmW
	CySTf4k9rFNQoJvn1mzV235Mkj8UD0WZXaJn+BTQ7fMLTyP104TSENrFPQquTmcOlRnZUbPQpYp
	9NmIa6bp8Boiun1DfNYAY/Z01xQoUeI2HzqB1SXzeBrEktncSXbO0Dj3nPu6sNqabseyojZGwVf
	D4L7Xs8+i2R7aDe1gB0mJ93uvMBc6xC9D4IQNRT2Kgnh/m/MKRMXQGJ06i/ka/DVPEL3hNSMYrE
	aoqQ0DDfgfT3CNYM+uGte1OCrOO5OMaCavx1xnizuYg==
X-Received: by 2002:a05:6a21:3288:b0:3e2:2b76:bf23 with SMTP id adf61e73a8af0-3e287eda189mr2084256637.68.1792598914753;
        Wed, 21 Oct 2026 09:08:34 -0700 (PDT)
X-Received: by 2002:a05:6a21:3288:b0:3e2:2b76:bf23 with SMTP id adf61e73a8af0-3e287eda189mr2084221637.68.1792598914240;
        Wed, 21 Oct 2026 09:08:34 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6b861c7dfsm188964a12.25.2026.10.21.09.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:08:33 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:08:27 -0700
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
Subject: Re: [PATCH v2 03/15] efi/libstub: Free cmdline_ptr in efi_pe_entry
Message-ID: <20261021090827.000078b8@oss.qualcomm.com>
In-Reply-To: <3-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<3-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: icYGcB5WgJQoOf_nMYcbQQyh2v7LF8Na
X-Proofpoint-ORIG-GUID: icYGcB5WgJQoOf_nMYcbQQyh2v7LF8Na
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MyBTYWx0ZWRfX8d/biEr4L4lX
 1kKfbQ7316rIMHl6Kma9TXZM9oKFfoqGTDGjtZYL29lFxp74HnwIT8r+9i76PpfoAjzCJ9DrnDQ
 x206btzs4jTfK7AIHb8dVLdFMEEpBvs=
X-Authority-Analysis: v=2.4 cv=KOzPn1Fo c=1 sm=1 tr=0 ts=6ad8e383 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=gCM90IwNaqpJe8xd-nwA:9 a=CjuIK1q_8ugA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MyBTYWx0ZWRfX7ljFowhoAtaG
 QiLkBhJxDrk6tQdeUIaHTtv1hAmIgkOyy5evJ7JDj/oxc9HbOZh+Com0xiZLeDc5p4zxBFJcRJK
 q+3xAIdheSXBNYJ3FKHz4yM0xVC2Ft1XWbR15gjA8g7Lr+6Rww5JPQb7406s72IMxKkBjM6IeNu
 Z+0VFypMWcsYj8m+js4PVChXDZGmdXseyJtQHqOxYPXYIC3z3d964VtHILNUkQnOu/u78GHC7QF
 Gg9htzm0Vs+RAbJW7ODyQJLqoQ18aV9Hq9MBRzIetYH0zVA71VYONwbakF8c89UJrRYISUhA9X9
 W4QvaqGkHR7Hz9DieePIwRpIhxayacwaMpl+aZwGwhmSnsvenO7oQk2xOqsk2zocTjypSHDTmBa
 tMG3YWJILeeQ+RFYWD5JLFJlC+dLnEANwRi5h4bS5hWUrs4b1+J2zUNbdWD7FDjJuCuci3oOast
 bCHrRPGgPBVfiFU4T8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210063

On Fri,  2 Oct 2026 20:31:40 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko points out that efi_handle_cmdline() allocates this memory and
> hands it over to the caller. If efi_pe_entry() ever returns it should be
> freed. Add a __free annotation.
> 
> Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Seems sensible. 

If anyone has more time than either of us, I note the efi_handle_cmdline()
use of __free() should move down to the point of allocation.
It's only a couple of lines, but none the less...

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
>  drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
> index aa85e910fe595e..fc1282fb442e71 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-entry.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
> @@ -40,7 +40,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  	unsigned long image_addr;
>  	unsigned long image_size = 0;
>  	/* addr/point and size pairs for memory management*/
> -	char *cmdline_ptr = NULL;
>  	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
>  	unsigned long reserve_addr = 0;
>  	unsigned long reserve_size = 0;
> @@ -63,6 +62,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  		return status;
>  	}
>  
> +	char *cmdline_ptr __free(efi_pool) = NULL;
>  	status = efi_handle_cmdline(image, &cmdline_ptr);
>  	if (status != EFI_SUCCESS)
>  		return status;

