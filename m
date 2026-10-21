Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604854;
	b=26Gcav5ViXFCN/8/2enGWxMySkuAqj5MFbZSp373vl0VLK3UhlgVTsrXh4y94BUwGmto
	 MCRDXbAGKwnGKdfc6KisPxBfA3D4B5DgA99qTy+sXOf02XeBr5QXJLoqVtrIp+KAd/BJJ
	 Tj46fmB12jnn4fBbgDKVZKb2hWzdsaMyD3GOvzRBGGtS3c9wwWtd1nKlHIgZNy3jpLCRt
	 d5KZTGePwsi5qfW3mdz4UwtJg8i+NCXHMUiDy8Q3vE/ziZMFM0ZwaoO0JOYYkGahvzS9Z
	 g5n+h4aCVLWG+ZMUg+rT2BsJl5XUwO9hsqpnxDYQtoDi37XmXTMTmcheaM2OBNr8SpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604854;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=;
	b=pwNKIL5RCVBaF4yRZ8wD6MU8icPcBO4yCbUR0P7fWu7JBMrnSrxjnoatwnG7XZeYPn4V
	 K3+Fsn9tqVkbInoimTWW341LsykDANc5eMksSyUeSUl1LExgVAzIFctPA/S42JKiyX0d3
	 Mi6xhJC0SZpMLBmFVwdbc7aKVDNXMSB6vBPr8midyDNpnF47YENwfxnyPOtDuQ5q8Hoa8
	 cTtMD93TMO4YMkTYPHGG4tcunGzLoUwnAezg0n4cm7+y236Ebe+1MEq0BH0zD0aBCqhAf
	 2C4F+d1hqbegoW5lUhOdgchxqBJvmuk6WcQGfRiajdTTByFvnAQW6l205K/brYk1S3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hfpCRj+j;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HTQWydCV;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828EC606A31E
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 17:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 828EC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hfpCRj+j;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HTQWydCV
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU8Gb3727378
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 17:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=; b=hfpCRj+j2KxWdKAB
	AHRIXbKs8512TkOfMBg7uAuf4pQwBrgHnCXqjXGBqRwBoq/H7P7OrFgZF0Zfi+tR
	vu+VfuJDugBApslvid6veWNBEZZcyRXJAke9i6292jK0t0YZGi9NrNaWSpT8tY+V
	s0gVcVKmPr81HHIdp7X7HflfO6HpD/K1SRGxm3CFbfoBQBPSdCsoYQ7ODmPPoU7T
	R3UtMzJ9hljMDpG1WZQeQQuRgdzWHC+h+yxC/BvbZHBOb3CssvTUbrb7Z5UqBp16
	83IkxTQ0zg67ak7mU7qRBBySHW1fHCbjzIGN0Kp3HDrdNz9pEeOQETK0hUBs98qx
	h9bHVQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy7ae71-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 17:47:33 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-17dc865c94cso320412c88.1
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 10:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792604853; x=1793209653; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=;
        b=HTQWydCVI3qqBUoPzBSEBJadN68CIS378UaFsJRnvXy0cUAR80ooaB2JU4XmpaTbFY
         HyB3D6v9dNF8A+nNGL5abDK22Ym8QgCMAtCs5r5vYysMg3z3Tqb7p3Yq4Gm2vSSshbDD
         Bf9u+25ejcAjb8g1aOtE7PjG+XImleXIobaciIDxdxRI6wTedt+RSU2weDFCV/Utfi+U
         5W90yDifMajSm/X0WFhw4KXU1WGnDH176JO8BN6HdxFFLa7lheHjCeVMqdfkK1mkxSaU
         OkAfMGuZOLRrDQvjFYlCZsR+ihJ3mbBtrJCYRoLXpvKT25LN5z3FScCS+8v6g3Q5y46r
         LG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604853; x=1793209653;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=;
        b=12ueIZ7yEHUyENOTJo58uNxppb/uPo08fWWRsSfGLMyHYTnVp0123W4emiUAisMBWT
         N15Cn5dvbtum/9yfq0YXaVT/txaZ/YqPzeQErUe3J4+GKvaAJXLDxzIpPcBkBC+vMzKT
         nOuwHlcJ8Gz4grCxAJSAnAZmeFt/m8K3dw2KsawFhdvXG8s2hob3IbZf/ByWRcO/tdLw
         hcWMeqUXJQm0MYfhh8Sv5kmKwNdtfwl8z47136iBCFirnGZm1nTRABQ65g9MmOquNQRD
         vIWnhATrhlpSFiQ1GP4oI4Hu2h6qpx59J7x6wiO+JP0YYdbvTTiwPVn8Eeye6JfIDNEL
         Dghw==
X-Forwarded-Encrypted: i=1; AKwUvBy+/PYUhqS7nnJp6WCTIKv0RWSAlBaYJfad2juNP/llTIoo9NoKTRhmSaPlHDQlsQR/jkLaW5aI@lists.linux.dev
X-Gm-Message-State: AFq9FYJULn1EVLyJ5Ut6sMyKOSuF+En2vSGSKT4XRIeok4a5hgbbcYMS
	WK/TQ0UMnDJM+gwT7VUeZpo7w2AdS6yhnyL9IAcOLD531wxSQjWNyaSzT4G8tWBp3QTXPBYZ7zU
	+KV68n4LQSt0IaSzw+Hag4xKXTOpyFRbe5VkoUUdnlJ8v+hdOG098G1NmWn49
X-Gm-Gg: AYBFou12vt3fTm2F9e51HL63BXqWMKvqL2gXuBTZ+iQJ+ShpnepFCVuMBzIM+mtslZv
	fhT5F3MaTB1JieGk8iGmvBQVpXDDuXNMLDHZdHyAtWi32ib6wizh8uoEH7i34RmAJPu+TzFd3R0
	QUHbrza7MIyedXalnR2+CE646RYeMDf3XKEhIcyE9JMluds7SaSfIk8XGnY/8iY4IQHroMrv3cR
	Tfyw4p3PbLe5oZIs0W1RMAAAh/I0BzgxBpEWpYW0QR3ZNQnXBb7Xb8mOgyjLLVV1wiU9DloWGba
	nZ6QYbFG6FeUWz/1mptfAo/k/fU/WNMfBserSLAYBugFdM0fsB6/oLXmeUJIpDtG9wzfzQKrH2H
	0j+EGUfikWms6V0iJhg7zmJWpM6+7txUwsxvWiLnbHw==
X-Received: by 2002:a05:701b:4214:20b0:143:297c:276c with SMTP id a92af1059eb24-190a5d6f349mr3478034c88.33.1792604852556;
        Wed, 21 Oct 2026 10:47:32 -0700 (PDT)
X-Received: by 2002:a05:701b:4214:20b0:143:297c:276c with SMTP id a92af1059eb24-190a5d6f349mr3477983c88.33.1792604851896;
        Wed, 21 Oct 2026 10:47:31 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc848fsm8915123eec.13.2026.10.21.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:47:31 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:47:26 -0700
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
Subject: Re: [PATCH v2 14/15] arm64: drtm: Call UNPROTECT_MEMORY
Message-ID: <20261021104726.00002640@oss.qualcomm.com>
In-Reply-To: <14-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<14-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: kQXp1IStjL0eyP2cZix76rhdT0B8bc2k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA3MCBTYWx0ZWRfXywNyH7CIlPph
 hNqUISznWUPyEVYGCFmCCRUIc4nWLJW8hqEpQOQ1SCu3rxQLW0dhSkIyKuXqEDyCcHGUHFPjYpv
 245YPEo+GqLLog6E7F4SSA/r6pji/nEEsKPrgnKWOUl1mEB0IHbQuE5tz0m9JYtvOK3/IlM3VlW
 e1HpFUOgcy1NPY0J2wPW/s/sLrhjWvv5xIwUgJGvLDAXo5809yl2SioY9Fj32YFcRkR3+Mi1hF2
 pq4F6zpW8wr2MiVPMeR11/bCygCZW+tj3WnWrh6gIuefmvBeP7jWGGkUSssVuIBcj+1CuGFsY4j
 Fgw0gHJHOFjeIq1QUTkGrfK1Z5/TJlEOFa0A5peSq8PGrx3t+T4HTJ+3qUvnWZCMfIPI0vrczwd
 f9RYGDt6cY/q/4P3oaT1zfPHRn0+J/wgbjvPMBNhYa7MHAyrII63CB9HvrtJWEtWavyBMFijvnZ
 gxEJtcHt42qkm5BUUAg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA3MCBTYWx0ZWRfX8ChxhjmadRMh
 se7Dt/MLh46kF6w49xVRVn+m6zyDtp9a/q/mM6UlOSyElkZVby8hnP4MD7s0BOdlLWiqNylEdWq
 rnsyDR/68jy6N0fHNjQVTyongv4ukzw=
X-Proofpoint-ORIG-GUID: kQXp1IStjL0eyP2cZix76rhdT0B8bc2k
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad8fab5 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=Ikd4Dj_1AAAA:8 a=4lc54p1sSd76nvOad-kA:9 a=CjuIK1q_8ugA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210070

On Fri,  2 Oct 2026 20:31:51 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The stub always requests ARM_DRTM_LAUNCH_DMA_COMPLETE. On a system
> with an SMMU the COMPLETE option is sanely implemented using the SMMU
> global abort register. DMA_COMPLETE should be mostly a no-op. It
> seems to be designed for the region protection mode that Linux does
> not use.
> 
> However, the FW can still do something interesting under it and we
> should call it. Choose late_initcall as we know the SMMU drivers are
> loaded by then. If some platform does actually block DMA beyond the
> SMMU, then this would result in a noisy failure of built-in driver
> DMA, not a silent security gap.
> 
> The platforms I'm aware of are OK with this placement, and it is a
> reasonable place to start.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/kernel/drtm.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/kernel/drtm.c b/arch/arm64/kernel/drtm.c
> index 14493948a27f0d..6062980a5d9e53 100644
> --- a/arch/arm64/kernel/drtm.c
> +++ b/arch/arm64/kernel/drtm.c
> @@ -3,8 +3,47 @@
>   *
>   * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
>   */
> +#include <linux/bug.h>
>  #include <linux/efi.h>
> +#include <linux/init.h>
> +#include <linux/printk.h>
>  
>  #include <asm/drtm.h>
>  
>  struct arm64_drtm_handoff arm64_drtm_handoff __efi_data_handoff;
> +
> +static int __init arm64_drtm_unprotect_memory(void)
> +{
> +	s64 status;
> +
> +	if (!arm64_drtm_handoff.drtm_enabled)
> +		return 0;
> +
> +	/*
> +	 * Currently Linux can only fully support a DRTM implementation that
> +	 * relies only the SMMU.

That sentence doesn't parse.  relies on maybe?

> This should be called directly after attaching
> +	 * a driver to every SMMU but before binding any drivers that want to
> +	 * use devices attached to the SMMU. Our boot flow does not have a way
> +	 * to do that, so for now call it here.
> +	 *
> +	 * For SMMU based implementations their UNPROTECT_MEMORY is probably a
> +	 * NOP since touching the SMMU here is forbidden, but they may still do
> +	 * something interesting so be sure to call it at least.
> +	 *
> +	 * The stub excludes the most likely case of non-SMMU by only using
> +	 * ARM_DRTM_DMA_PROTECTION_COMPLETE, which is defined as:
> +	 *    Complete DMA protection is hardware-based enforcement at the SMMU
> +	 *    that blocks all DMA from Non- secure devices."
> +	 *
> +	 * For now if people have such systems they cannot include built-in
> +	 * drivers for any DMA devices, those have to be modules to be ordered
> +	 * after this.
> +	 */
> +	status = arm_drtm_unprotect_memory();
> +	WARN(status != ARM_DRTM_SUCCESS,
> +	     "DRTM: failed to unprotect memory (x0=%lld)", status);
> +	if (status == ARM_DRTM_SUCCESS)
> +		pr_info("DRTM: launch completed\n");
> +	return 0;
> +}
> +late_initcall_sync(arm64_drtm_unprotect_memory);

