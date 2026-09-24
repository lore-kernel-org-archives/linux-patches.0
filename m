Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1FC43D4EA
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290651; cv=none; b=QRsl/CyVdfA9PUcxifPhtIm4877T3DguN23JlLomKfwjZxTdwkfPBrAZdaIHuohVYJibGzmDoghd/tU98Bk2GGL26MMVArROzgpcEsE/UBRsnZLxq3xv8TFXnuBKQaloOHFPETqIIGVNyFFl9lOceVSWs5U1gF8C1y8ZAAEMLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290651; c=relaxed/simple;
	bh=fpfPQgsOtOc9WLlVwD3MxGuJHzdHkV63pmZ7ZwBuyzg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXJyQJ7cyuEJmuTTnSLU7DaABCm2Wgtt9YQ6VLXilRWkWDueVeqmQu+ZkhfMD9ghOfs8o0fC79i2Ou3gsISqtKYqfwmbWAqrnwcm+WhIX6EMgNSYDVTInkcdOYKQAFSeAF0RoszFAoLhQD8ggWjkNFB9VFdQVlqbtHfJwIQHbMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BI2Gayz/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RyMYUTrG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BI2Gayz/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RyMYUTrG"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMP3li3467102
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WdAcd3jJW9o4oT6W8Pd28WqwPKx89e7FKJveLvjxmTM=; b=BI2Gayz/LjxSc6mE
	Kg+MLNOusLPeYnOxYOG9xy/G6ynTgm5i8HXcMPcVaie12keAjyA2Oz1Cf0fyIkw2
	1iPHcxBnFcP9qOOkZ07f07f5aQw1qPFKV8ApXthFNkR53KsFmNN+apNakWPmF9KB
	GZ4On06jpyBc5aTWoomkmhaScQbrjk2k5yn95Es0ViLT4dyJ6vNbt0gJYJ4jce1c
	XIv1evwdRyzJbK4ev5ygZd0QRpNzogYF0Tn6LwzUygOtjjPo7wa0hzGZ8ulMQwj8
	1Dwm44i8PH1iR4SnWFtv/Stn36RWYL43Nv8n7mH5JL14F6v+yiIOppzxFkJgDYi0
	2R3TpQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw4652bt4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:57:28 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33baaba6371so967090eec.1
        for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790290648; x=1790895448; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WdAcd3jJW9o4oT6W8Pd28WqwPKx89e7FKJveLvjxmTM=;
        b=RyMYUTrGeeYk9xBbWWdolDRo7tNn3nmf9Yi/0IEW25G67v8T8S3DoJiCSuhwSH/Eu+
         Im77+/KN5CT+oIUINuSQ7WHeJfVuL9z5uEtxW3bDpJYE8+7dgKH47AFEQYk9g3vlfofL
         0hHHNXPVUazTYMPEjJuKl/nvXpan2Px1Zo08iLi8GOxE00/7XHSKhLzFwLtB1ywdgxOv
         QMgmqnCT4p9DqtHFKBTJtgnH8Nz1DFfXCcwxamir2GwMkkcBo+Yi5OdTPACoaK8FwaQv
         BWY+M7ROtA9lMktl4YIenTwBhWo5tB1H9SL8lR+RsQioOpSCutqd9vgRCyc+6dLpa/T1
         SWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790290648; x=1790895448;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WdAcd3jJW9o4oT6W8Pd28WqwPKx89e7FKJveLvjxmTM=;
        b=you/zsL6PxPn5FBxkLZf6Nu/9D0c39D5l4akm6KE/QmwfpgO+zJ9HLCASZ1IXMxsyw
         nk/zKu3Bk+5NFZk8xoJ36B2Q7HqMAxIW5uWteciyNCJe1KJeb8T2aCZCjfSAKi7K7uXr
         MOSdtjStHq2K+CxqEnA75HzGJOd/LkR+obL9qB543TgInMgSpEKFRgFSJ3Qw/LMq6llz
         Fi5vNF0vJvZAfR7MkUOII4Rr12aw6cwu77y7I7ufKW1a9IRKKuowqTUVaWt13OM5q+bp
         HJmSGlUkO8OCLLvh7wR43eOfkPXjo8v5O82AFpPTyS38Z3iT9ISPHrwvSTGlDXClrLeV
         EBjw==
X-Forwarded-Encrypted: i=1; AKwUvBzay4HR9ka+aDxtB9i3rXh/eCVdGamgACjXW1lL8lQwSlHfqqy2iwlCT5IovOXyhJRMXu8bH9Sc@lists.linux.dev
X-Gm-Message-State: AFuF++mnh+GeQdvdCOem9U9SvrvKrCo2JqAMYPeCNLWpR7pQ4QkSju0F
	2ZQmHJtRQh/6kun6MDO8BMCGcliL1A2Nyl7llhdFy0m/SjApKYcgJ8ViL0J75RKl77ZhthNcki3
	nrtk4uG0kJAKQEe2YOVrasUkz1kWAvecc0OeLKjwswu8Ecur78BUupDrJsxUc
X-Gm-Gg: AYBFou0zzPdD/6fHdq5MWhniscbrhl/gX/sQO5X7t9AoLggD/7crDMkaTysr4G4rs0h
	1GgozctTYR5XWRhefbRKyLcXlrgkeyZjVJ6kfdrIwI74V4wYwic/RbyTvvtGT8Y1E8BHn2lIo11
	1h3o2qavVkrGPulS+/83y8CWuu6hgliMl8axYOIvjGbY/Z1eVWY+cySOzfto40STXT0qjjEXnf8
	ANB2QFB8aZg56hDZsXMFgds+PU7MPWOnSfkUWUqIkpTkWjsD0rnKSqq7QRkKuFMGLIDKyHTocec
	lrH4PBKy5qB43TQsUbLJ+Yf8luY7MBdWoiZbQ3JwwHWbE9kvINoWE65/23Ul72J6OnAO9m/Cz6h
	bZOTfuTZ9oQ9Imyeqj8h0yvuix2190AI9GdCEDQWeMpoBysEFRmMqxA==
X-Received: by 2002:a05:693c:621a:b0:33c:e61:e201 with SMTP id 5a478bee46e88-34002edee42mr4033408eec.22.1790290647500;
        Thu, 24 Sep 2026 15:57:27 -0700 (PDT)
X-Received: by 2002:a05:693c:621a:b0:33c:e61:e201 with SMTP id 5a478bee46e88-34002edee42mr4033386eec.22.1790290646954;
        Thu, 24 Sep 2026 15:57:26 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144757f31sm2046484eec.14.2026.09.24.15.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:57:26 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:57:21 -0700
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
Subject: Re: [PATCH 07/16] efi/zboot: Lift efi_cache_sync_image() from
 efi_zboot_decompress()
Message-ID: <20260924155721.000016a9@oss.qualcomm.com>
In-Reply-To: <7-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<7-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=Wrq+otfv c=1 sm=1 tr=0 ts=6ab5aad8 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=Ikd4Dj_1AAAA:8 a=gav0J8kFgDfseqtY68YA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: dIgzxvuUkWbI0RrbQTP7Apy61jLk-1nF
X-Proofpoint-GUID: dIgzxvuUkWbI0RrbQTP7Apy61jLk-1nF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfXx7+dz3goLuSP
 E7tqyG1rwSneGsFkZGyYGcqYDwfyeN3L7xUkJ0vP4bMG9K/Befs3mDphV2Q4qHeKyMcUwhdtyK3
 UOBekZaW0i8fokNBEz8MtJyLU0s3qhzzi2mFaoW30A+NlewU1pHfxsQ9XA1LqLWB9L3UnXQbnWP
 1xBM7/qpVOmM/hgGy+QEpz1EGxO6qW9QLs7R6rXrLNz5JZ/3K69lRZfo2BSct67hRNIYkT5Pvpb
 iPboIM7Jn0up0I6r3u/EY8/OEpK9xh0e7SlNPmuHrJImWXB2e8VE/Xe3h1+OTWAEzBa5Kt6xXHs
 b1Tj+uefYugG6LCUBegfKVc2epviev8rxz6vJk+iOgJ6aw7dbqdnqxYLhwEdzlzKTB1Ut0o7JNR
 UCK7jMop4+dITZO9DiLUiJilAxe3xKCuiOkaxfSavroWXE6pNatanSYCKHm6q249ahfB9jZ1uen
 +0K6KwLRnXo4UafB0Sg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX7sZPDo+481b2
 us35qGPJjStvre0/aVt4EYDyDK/cjPniqPsNSPk8avIB3w9j9XCpVUCMegV935bM354Ozmmco1Z
 7Lqp3uKUnA8AvzhCVm2MF9DFk84/cmc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240093

On Thu, 24 Sep 2026 10:53:10 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The two decompressors duplicate this call and the next patch needs to
> change the argument. Hoist it up to remove the duplication.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
> index 4b76f74c56dae0..960a542881d875 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -92,9 +92,12 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
>  	}
>  
>  	// Decompress the payload into the newly allocated buffer
> -	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
> -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> -
> +	status = efi_zboot_decompress((void *)image_base, alloc_size);
> +	if (status == EFI_SUCCESS) {
> +		efi_cache_sync_image(image_base, alloc_size);
> +		status =
> +			efi_stub_common(handle, image, image_base, cmdline_ptr);

Just go one character longer!

> +	}
>  	efi_free(alloc_size, image_base);
>  	return status;
>  }

