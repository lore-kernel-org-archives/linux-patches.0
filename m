Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792606304;
	b=OyN2X3cT1ANRqXSn+VPx93Kqudu2wB8E2rJmXLvDl1xGRAgFwWXP2B4jEJPSBCDEYYH6
	 yDFpsuYdXzbOLn04KkPU/GdZrfU2CWD3pEQ+lAjsJUDl039b8oGP0+xwPUH+TWZw+nQcm
	 A2WlQCUzfeTCsEPcriQgGUNCoTPoFFt0iPP5Q1WkRDvJeGUOlkrWGkdFndXDrKu4idn+5
	 Nj3noQOz5ZBWKjHMnRs38N89uYjQ4UXzdPbpw0rWt8whcEE0O0KRyEbrmpqHKe62jvw2C
	 qvzm3t8G/UkesFw8D7oWM9eMzZrHzPW4I2IVOh6V9w1g9/FH7uYoKBggutnHmHDDlqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606304;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=;
	b=BJ0xf9rJNJFQJQHZTj3Neo1Y6lMES8jVmA6grZNsn8wlBlUnzGWxF/1pj9fvOdFsHeZn
	 6s69K89DMDulGdji8nGCCDj7JoQzVFGpmcEMe8snNworFuD5uM+3I4uevZhxcfbmrjNli
	 mGEbiJm9dN6Bl2lMawgOLwUWyfr5CdvNoYjE43YfB7BG1rmjrPdEFKbj4R+Ma1dKiWiS9
	 230zz48ULyd26cWpwy1BtqKvSbFDqTqP263XpEwzvD2DV4HpIbVyyEGONlbczz0FOQpCX
	 GJEO2N8A1UiUoxTfTXTN+Cfag4KXJHRJtFD1dnq1c7E4l3JAPQ7p9B8KwyHdUlvbAzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KBq8By91;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BhkYzsQd;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98908606A323
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 18:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98908606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KBq8By91;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BhkYzsQd
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LHpfxG4039990
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 18:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=; b=KBq8By919CR0Wk6J
	i6AHGYv1uzl0plIu0g/ZjSagDkXy5EsbBsmzhImhAELaJ/l3SfReAUQpWiSHeVNf
	BufY1pa+JPkBGkez43hmPC7dSe/wTdocSPdgRHEIkjXg+77SAdYjTQAo3aTC702v
	wIJaXklJi5pC3EQlxvgOlS9JUMDPzA8ux1CypnFa/HaSbozJtLx5c4F1YuTj12X7
	fPuROybpD306YEcuArWKV69DugzhWLf5aBj0QG/MFJEbJRpq1GRrz3FGnTg4Sr+J
	HgvYZbYSilPrBWCFEs8avj6fFE58i34cFDbduqKYWVEMlX2iQVhEPuzZodKWCD3h
	tK/n4A==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy7ahed-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 18:11:42 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3580c07911eso2793807eec.0
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 11:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792606302; x=1793211102; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=;
        b=BhkYzsQdQ+byZjF0WmgtF5zTphtsdDzNvgYPD8OWEx4zN39QXBIQ1Nq5y4fn2tq5WU
         4qobq9gfNTVcgoquPPotZSO4OhlcGjbaGbcglST8Y/c0UsYJ5rraVakVodbGmTzSOBPp
         YF6PsQ+aYrM9q4ZD7OmpfUWfubXaZ7A5nmecKzxgp5Gjl02Ey4nQr010r9WNQjvPtm5Y
         ZWjMBAUyXkKgA8KnvbJjXml06WpzcKXpA97EFoJFJRLNCkL0bzCSjtg+b655nzXAILIn
         EnaequUGcaMkEixSTDTurskZULjn+uidbRqdpxl9kHZlkd5cmjcvNClVWQFX3weXJtzI
         xNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792606302; x=1793211102;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=;
        b=uwfkq8DPb6UHp130qZJ5pyEiJooHf3sGAt7/SNpIIYPCWTjliHIybhTathaRzmOcPM
         JNV2H/diNa/nFc3MVOJdjwkBss7Q6MCc9WFhj3ZXrMA7JyrpzzuS7/IqvJtcqyiV6o3E
         C/pqz4ydb2lz7DuIuYCBfKkcWtX/DYFueTA8HLNRrkxzWfTbRXX5LfqvhbMDUqBRbLUR
         9GHY+Nvmm4PmkezBe53FKip4gM8gL9t+9ngdUudBEo/5xmqeBTj/menMyhPziGDsJ0kI
         BfdBYrcM+3W9lsTLvxQ7OiKQjvjLaTwK2N9bl9edpU51RIBlPDMPrvhUM0FsIFTx0179
         1JiA==
X-Forwarded-Encrypted: i=1; AKwUvBwZELBj+aIYlAibWjfIo3bYgrP35y2Td/g40Bi1RYiS3HTw3NHVH3bdJ3IoRUiGETkeHBrAKyaI@lists.linux.dev
X-Gm-Message-State: AFq9FYKovkPMGUw2aSoEAsVdOtLmoIS+qQi01bsgICklzqKspe4xVRHS
	Dxf7lHOC7GDy+JHq0jN3wKUC5AQPKJak9446MC9lGvUO/7N8Moan0n1wmvHgWa38HYLLH1fxGzN
	v6zuRd5rZudvDNiGZToudSiEOQvozR0wF9+YO2tbfzurx/drIpffu0M4JZu7f
X-Gm-Gg: AYBFou1x9fgW/LernEyPHzA9qTZsCyCnXG1XRFR65Zt+v6G3H4llRvDq0/8/vZ685c3
	qjyXkssI942umYvwJ4zGUaiQUlVhFa/IQfRubfFxBz9kV6yvRNngowAYoOwBas/A9Xmm5IdNzE4
	NEtMFKp2sJlUITZI7FTsqo3Q2hNa+rigJXpsakMtp88nitFy3ccBu19DIlU0J1vbN0vCoO1BGXw
	Y3JnJJGZuCD9vwZN2yOlRnasDGQrB81gTaEC9c3ky/1vEMx2+9QTzxVvOLofmbS/zv/mfbyFbcy
	ET4ZJChrUTUq5x7fvoH+FbvPwfl5PuFNOJJlzXFgPsQ53eCQgKIiucOBTM3WXi/QXBDgTSj20TP
	1nPEIbsEgJqsaY4uOX0UgWb+s2eQj4WMAP8ByTmhXkBQ=
X-Received: by 2002:a05:693c:41cf:20b0:358:1f59:48c9 with SMTP id 5a478bee46e88-3674f21a97dmr3790783eec.24.1792606301664;
        Wed, 21 Oct 2026 11:11:41 -0700 (PDT)
X-Received: by 2002:a05:693c:41cf:20b0:358:1f59:48c9 with SMTP id 5a478bee46e88-3674f21a97dmr3790596eec.24.1792606298974;
        Wed, 21 Oct 2026 11:11:38 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674206d1f1sm9116156eec.28.2026.10.21.11.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 11:11:38 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:11:15 -0700
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
Subject: Re: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <20261021111115.00004c5c@oss.qualcomm.com>
In-Reply-To: <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: ugMEB8RH-k1d_iuckQUJJ5vHuqYtsv-u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA3MiBTYWx0ZWRfX9Gv4m+gh4AEl
 lI6dF3hB6OwtBem3LbhW+01AY0k+2OpEVKFlYjBin9vYXtrIA9bRP3xL4DBElNyFvqEA/L3b1e+
 zp3wzrY++7c6aUcK6fFYRH+01FwEZNIe1lwteYx3UgtH9TQ7bnIQcbgyvl7onjC/wWWE0EW6nXr
 DbMxljqPrEhIIanowqFuu/bAU/mFNDMZFsxAu8gA+pB73Q8iaPipkqU92WOpuCbf0cQsQKCJ1GQ
 4Eh8KpRXR4CPvC5rtzpZRFJMlxoqqM6wTSP9Rc/Gsr9L4bVNVrFEPZ2kmMs4uewGD3ounqG+307
 z1vY5DN8PgDpDlnngb9YVZgPrdy2Sroapwu6FzweSVvG3FVLj4Ik+5XSmEQ4ryQEa9Kg5d+N2tb
 Txt56gllKZZwrIBk5SqKNZ9PQyR0pdKDZiOS44909tsqExQA3GtZUgSNc3rqQP3y2IA/I8HR/zc
 ZojmRs/5zv7bBCn9+JQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA3MiBTYWx0ZWRfXy/gNqbx34kPN
 QuiEZReRhXV4Y4/ZHoXfhvA/hEpBKQbj4tv7gh2/hZ5NtHQGAJeLm3uHd/CgWfCfmP7IBG1ZNNR
 KVb6iOZFw8/1LlwG8MnLViMXxFVwYcA=
X-Proofpoint-ORIG-GUID: ugMEB8RH-k1d_iuckQUJJ5vHuqYtsv-u
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad9005e cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=Ikd4Dj_1AAAA:8 a=Sk9Lk7371zlc0StAK_oA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210072

On Fri,  2 Oct 2026 20:31:52 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Provide an implementation of the CONFIG_EFI_STUB_DRTM protocol for ARM64
> DEN0113 >= v1.1.
> 
> First, it queries the FW for support and collects all the
> information. This is needed to compute the extra_size, which comes
> from FW reporting how much memory it needs during the launch for the
> DLME Data and DCE-owned data. The generic stub ensures there is
> trailing memory after Image for this.
> 
> Then the DRTM_PARAMETERS launch structure is computed using the
> offsets in the efi_info.
> 
> Finally, the stub does ExitBootServices and calls the actual launch.
> 
> The feature discovery process is deliberately fairly verbose to help
> debug any FW weirdness in the field. Enable it with efi=debug
> 
> It looks something like:
> 
>  EFI stub: DRTM: interface version 1.4
>  EFI stub: DEBUG: DRTM: TPM algorithm 0xc, TPM hashing unavailable, PCR schemas 0x1
>  EFI stub: DEBUG: DRTM: minimum DLME data 73728 bytes, Normal-world DCE 0 bytes
>  EFI stub: Decompressing Linux Kernel...
>  EFI stub: Generating empty DTB
>  EFI stub: Exiting boot services...
>  EFI stub: DEBUG: DRTM: will launch, selected launch features 0x0
>  [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
> 
> Eventually the launch'd kernel is going to require built in crypto
> libraries that match what the FW is using so it can validate some of the
> information left behind during early boot. Refuse to launch if these are
> not built in and build in the most common ones from the ARM64_DRTM
> kconfig.
> 
> One nit, if the platform does not support SMC then using drtm=auto may
> crash on the SMC op. As far as I can tell there is no way to discover SMC
> support through EFI. Learning it from the ACPI FADT is doable and costs
> about 250 lines of code.

Ouch. Sounds like a must have if there is no easier way.

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

One thing inline that confused me.

Otherwise seems fine to me

> diff --git a/drivers/firmware/efi/libstub/arm64-drtm.c b/drivers/firmware/efi/libstub/arm64-drtm.c
> new file mode 100644
> index 00000000000000..2fc58babc3e7cb
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/arm64-drtm.c
> @@ -0,0 +1,426 @@

> +
> +/* True if SMCCC 1.0 or later is available. */
> +static bool efi_arm64_psci_smccc_compatible(void)
> +{
> +	struct arm_smccc_res res;
> +	s32 status;
> +
> +	arm_smccc_1_1_smc(PSCI_0_2_FN_PSCI_VERSION, &res);

A function that is meant to check for smccc 1.0 is using the
smccc_1_1 namespaced calls?  Maybe add a comment on why that
is ok to do.  Is anyone actually using SMCCC 1.0 on systems like this?

I a bit surprised we don't have a common helper for this -
I guess the version checks are often explicit in a particular
driver being bound.

> +	if ((s32)res.a0 < 0)
> +		return false;
> +
> +	if (PSCI_VERSION_MAJOR(res.a0) < 1)
> +		return false;
> +
> +	arm_smccc_1_1_smc(PSCI_1_0_FN_PSCI_FEATURES, ARM_SMCCC_VERSION_FUNC_ID,
> +			  &res);
> +	status = (s32)res.a0;
> +	if (status == PSCI_RET_NOT_SUPPORTED) {
> +		/*
> +		 * SMCCC_VERSION was introduced by SMCCC 1.1, so firmware that
> +		 * does not advertise that function through PSCI_FEATURES is
> +		 * using the valid SMCCC 1.0 baseline.
> +		 */
> +		return true;
> +	} else if (status < 0) {
> +		return false;
> +	} else {
> +		u32 version;
> +
> +		arm_smccc_1_1_smc(ARM_SMCCC_VERSION_FUNC_ID, &res);
> +		version = res.a0;
> +		if ((version >> 16) != 1 || version < ARM_SMCCC_VERSION_1_1)
> +			return false;
> +	}
> +	return true;
> +}


