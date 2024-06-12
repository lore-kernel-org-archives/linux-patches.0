Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BA616C6BE
	for <patches@lists.linux.dev>; Wed, 12 Jun 2024 08:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718179822; cv=none; b=tqlR7rLPllPAlCQrmxn5Docofs8RFLkCUINBLHhcAtXiI+FNhooYhosJhYghi4fxxo85v9HInWD058Y5ji+yQ3ctYWNY3txO2xC8CISQQTIcmGj5+DJ6IOz9sTtUfCHwHxzFeuiQc/WnMnZU3iuUOY+FThPGDhfTjT+RJImJGVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718179822; c=relaxed/simple;
	bh=KD8XsOYWtuKQcjM/eNkuQb8vTo+mQEltuXJ5GVxlhnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHbo0qPbkixMnCU8VAngUAp8B3PB7PjDcvQZYh5sws5QtrKB9uNwZHwdKutF+FGouTqmM3HT9p4cGOqct7t2pKUk7jvUJCeXLKRDVQn6z6n1Fi7Ji9MiVx0oY1pYx03sp2lZiB1LDuywlpG5vlSP9sODoCjSTogS9YY5528GwsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dv+r8zyX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dv+r8zyX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718179820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZzSDXkByvhQTe8Q6mgT19yqvdN/uz/2Piu84KIHlJ0=;
	b=dv+r8zyXeD7cZasZfsd8RiSznQQ9CeFPu7kODBK+CQMdW9izA4r/d4+i7/JzobRd5TSw6E
	nGw4PHxvdGCbbqttsw+jYx9OCT/JegPNLwyc3iw2Ga1Js5qdvlkWMkvTwZd1ax27rJuPyv
	6q2QtnZXn8h06VdS2jD2PoAyjul56/g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-BIFnWqiIM_yY6X0aI2Aeig-1; Wed, 12 Jun 2024 04:10:17 -0400
X-MC-Unique: BIFnWqiIM_yY6X0aI2Aeig-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-57a49b8a27eso2644148a12.0
        for <patches@lists.linux.dev>; Wed, 12 Jun 2024 01:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718179816; x=1718784616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZzSDXkByvhQTe8Q6mgT19yqvdN/uz/2Piu84KIHlJ0=;
        b=K1WUPbG3VLldt5tM85fj5IavRP4BYBQ3BkU/qnGMXXVBp849GeNJsU/WGF0CLYFpR5
         vUWMo694/mKEnYH3P5KsMf0hLbiTgehAEuaCKL4Pv6BDLKRNDpHYYNfsPTS/JbB8aPSd
         O0jw07i/Pz5opeQh+xU3g95OwZ1UHsWTw8Haj2VP/0UzRV1ZYHcV8HkcQevVCfLbRXAq
         +DrPjmEGOaO61Kes0/Qe+RkHraLAN44M2IfCNnSWaItocGwxT69VIetaPdcCfCYe2wTy
         5xry1x+h4uk2jM7a5AUvrIXqhbkYTjNPznK+bNqiBSUCntRR4EvzYx4BhgBfSWKPfiKr
         OOOg==
X-Forwarded-Encrypted: i=1; AJvYcCWE2pYoNRFEVZr+vxVC14v6YaJPE4b45+CYfHUWQYPj3ftXDhotUrXYJN6rYu3ASjpd6SMxQ54lPWccgrdrNK3kXwANgHXbLA==
X-Gm-Message-State: AOJu0YzkFWHvim89iYevQzJUvVlf38J8fhrUnRtcclYSLjIkr5j/iQhl
	k21AxloGSfgUDGL+UVm6dRUk9CmjpU7FRSzX/zIfkwza4AkB6cQ7sKBHEn4SM3ggP6T1jHNTEt+
	LaKzMH77JkM21Fw/yTuhvb/JbGuZ1BJRPp1U22q+OVfBfndK6m2g+89Q=
X-Received: by 2002:a50:d583:0:b0:57c:4769:562a with SMTP id 4fb4d7f45d1cf-57ca8dfff3dmr677216a12.0.1718179816663;
        Wed, 12 Jun 2024 01:10:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFmHuWpMoOlHLB/y32XdBF0kh5+hdKiBK6cLkE/6baSa9huKfKvmf3UKQQ1wP6lTycKWuKMA==
X-Received: by 2002:a50:d583:0:b0:57c:4769:562a with SMTP id 4fb4d7f45d1cf-57ca8dfff3dmr677193a12.0.1718179816152;
        Wed, 12 Jun 2024 01:10:16 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cae50adc2sm38283a12.75.2024.06.12.01.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 01:10:15 -0700 (PDT)
Message-ID: <38336785-cb59-464f-b2a7-49812f4c2ce0@redhat.com>
Date: Wed, 12 Jun 2024 10:10:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/49 RESEND] media: atomisp: Switch to new Intel CPU
 model defines
To: Tony Luck <tony.luck@intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Cc: linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
 Andy Shevchenko <andy@kernel.org>
References: <20240611173406.352874-1-tony.luck@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20240611173406.352874-1-tony.luck@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Tony,

On 6/11/24 7:34 PM, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Andy Shevchenko <andy@kernel.org>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> ---
> 
> Mauro, Hans, Greg: Which one of you owns this one. Can you take
> a look please. Let me know if changes are needed.

I'll pick this one up. But atomisp support is a side project,
so I only work on this every few weeks.

My intent is to get this send to Mauro (media-next) in time
for the 6.11 merge window.

Regards,

Hans



> 
>  .../atomisp/include/linux/atomisp_platform.h  | 27 ++++++++-----------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
> index 0e3f6fb78483..fdeb247036b0 100644
> --- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
> +++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
> @@ -18,7 +18,7 @@
>  #ifndef ATOMISP_PLATFORM_H_
>  #define ATOMISP_PLATFORM_H_
>  
> -#include <asm/intel-family.h>
> +#include <asm/cpu_device_id.h>
>  #include <asm/processor.h>
>  
>  #include <linux/i2c.h>
> @@ -178,22 +178,17 @@ void atomisp_unregister_subdev(struct v4l2_subdev *subdev);
>  int v4l2_get_acpi_sensor_info(struct device *dev, char **module_id_str);
>  
>  /* API from old platform_camera.h, new CPUID implementation */
> -#define __IS_SOC(x) (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL && \
> -		     boot_cpu_data.x86 == 6 &&                       \
> -		     boot_cpu_data.x86_model == (x))
> -#define __IS_SOCS(x,y) (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL && \
> -		        boot_cpu_data.x86 == 6 &&                       \
> -		        (boot_cpu_data.x86_model == (x) || \
> -		         boot_cpu_data.x86_model == (y)))
> -
> -#define IS_MFLD	__IS_SOC(INTEL_FAM6_ATOM_SALTWELL_MID)
> -#define IS_BYT	__IS_SOC(INTEL_FAM6_ATOM_SILVERMONT)
> -#define IS_CHT	__IS_SOC(INTEL_FAM6_ATOM_AIRMONT)
> -#define IS_MRFD	__IS_SOC(INTEL_FAM6_ATOM_SILVERMONT_MID)
> -#define IS_MOFD	__IS_SOC(INTEL_FAM6_ATOM_AIRMONT_MID)
> +#define __IS_SOC(x) (boot_cpu_data.x86_vfm == x)
> +#define __IS_SOCS(x, y) (boot_cpu_data.x86_vfm == x || boot_cpu_data.x86_vfm == y)
> +
> +#define IS_MFLD	__IS_SOC(INTEL_ATOM_SALTWELL_MID)
> +#define IS_BYT	__IS_SOC(INTEL_ATOM_SILVERMONT)
> +#define IS_CHT	__IS_SOC(INTEL_ATOM_AIRMONT)
> +#define IS_MRFD	__IS_SOC(INTEL_ATOM_SILVERMONT_MID)
> +#define IS_MOFD	__IS_SOC(INTEL_ATOM_AIRMONT_MID)
>  
>  /* Both CHT and MOFD come with ISP2401 */
> -#define IS_ISP2401 __IS_SOCS(INTEL_FAM6_ATOM_AIRMONT, \
> -			     INTEL_FAM6_ATOM_AIRMONT_MID)
> +#define IS_ISP2401 __IS_SOCS(INTEL_ATOM_AIRMONT, \
> +			     INTEL_ATOM_AIRMONT_MID)
>  
>  #endif /* ATOMISP_PLATFORM_H_ */

