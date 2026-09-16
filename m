Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B82E48CD7F
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 09:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549661; cv=none; b=NFvzPV7yZpfe35mw2d+TzBXqwXtTSWnfGEY5gMIIhgdbdzCGPHQxVGYNT7rM9sBXEFuiHFjZZCsSK1k+e/ZoVKbwR0fcjmlfWiI/4k8u7o3qZMQ88f/AAM516pyXuYj61LGzQ/pglDx+Gg0xTOaRzjI5y1FnxIyki0H4znHyVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549661; c=relaxed/simple;
	bh=/oSHeo+dHrTJ4BeaXgDyE3G967AhC/96LwQQ8JcP8WA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c9f4WNdn+iUlCXhIOUL0qGGRF3gvnwkV3aB1m7zloqlg/B+bZkrVswVObEY+z96bK3PpULH8a44POwRBS1rEvYwXxIbkn88sKPTR761cIQjWJao2m8zjXKF7Xfr/VkWrWPs2FBst1clw/E+vNraasOa8NMN0vMBjGxFNpjjM22Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPaAh1oG; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPaAh1oG"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d9004a1ac0so5235335ad.3
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 02:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789549642; x=1790154442; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/oSHeo+dHrTJ4BeaXgDyE3G967AhC/96LwQQ8JcP8WA=;
        b=mPaAh1oGbnLc49Yxso9rY0Nr044LMzFU0igllVtQzbS5nBxAfhM6UWuKs9F+vFE5Oj
         w8x+dN+kSHY2x3tbfsAOFvNdf+mH6P62SMke0QOohfFvmzx0mWE8nm2hm2aPw0hxdFE8
         LoTgo3TTpn6ahzdcO+iydjXTrZODBqPRubV0bs2jVlwf1CfSIV1+FXTRnSPGGHMW/LrW
         Cm6htTU9/U29KF0szLnTAJSl370aJNZE01w1kqyyCUjBCbYvVBpoL72L+7ubEo9RXvff
         PzcUbon8IQaBirT+a/7oJH/CVQs0Pnd0BgAi4sVCF3/63cwbU1D8x8bdAqT5AdlzLpAe
         5cSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789549642; x=1790154442;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/oSHeo+dHrTJ4BeaXgDyE3G967AhC/96LwQQ8JcP8WA=;
        b=SzcjZD2BfTpk/10u3m7km0fZhhaboEs1PSjGASFqVBkbI8R+PyAm1xNiIEWuZEzOyk
         XEAvtFPVN80GhjWawO9iIZNnQzOncNM2tcZeAWjpFF/srq/uNnVZcWfxBnGh48FamudU
         sLhttsUq487PRBDBIJyMPws0Z59CB2YJJYn322BL7FNiVshX9eg2gdspaord9487AV/A
         xVs5v5o9V02V6kqMCUWTJgwS8z6Gx+EvMog9FW8gyRM3Cwmc+AxFeUZIS+vo3BC8y77T
         fmZPXqtpvUlsUK5vWw/Htk2B2ErO9vuBpyS1huJooiBttHHt+Ev8PjslBOdu2mnOcXdV
         IAEQ==
X-Gm-Message-State: AFuF++laNBnFx5V3b5db6mSJG0VwqySBRC8LnC86mztS25nqoUEBXZ84
	9JtNeMAhz067d4RR7Tb6KFrBOeofzVUibm5n0XKMsrRHzihCcYiMq8al
X-Gm-Gg: AYBFou2hm81SD24zxCFqF8U+8gQBL0/UfAWb/PGzi4ApsNLcFu+GcDfyrb2h2TngD44
	wi3qewSEFvv3y4ywzXFPn1jmZ1bCCNLEy9mvL7v7kcdqGF2Z8s62K+S5l1HrAX7IWVDgvD4ClCl
	VVmIyFpgJDcVcE/pzpKvls9koA6w40AWSrfxCu+hw8cM54174sP8iaOk17Q24mxhUIhbgQFYWKr
	EYMP2rhlgrw3Y9RY/xmLevEA0eoJLXJdh6lydcWRs/FloArOH65NrawvEOG6jC39Ops1N4urCDt
	SI/jMmlAOdeeONH2zwn0jl1CKOyagqaPxJDuXevhDa3GDQrTEQhuRcnxroNgJIHar1oEz9BXAbD
	BEXEKELmrAqbdhbbyyzrSe0i72ojeGn86uX9KVOcCxBaY98ws7uZ/2oMXBMtHNviflv3kJhATYg
	b3vzS0Z8pV9vO3Qj6/7zEc3SxbhCAKG45xzwLpjhORvBoMHIVassOkb+/aDKgERpRyxdUgNIqI7
	pjk6rEf6lNPu6exonbTDfZyEijZyvXH2qWJzg==
X-Received: by 2002:a17:902:d547:b0:2d0:cc92:f7a9 with SMTP id d9443c01a7336-2dd8dd0b15amr37176235ad.4.1789549641965;
        Wed, 16 Sep 2026 02:07:21 -0700 (PDT)
Received: from [10.89.160.219] (wf124-219.ust.hk. [175.159.124.219])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89eb7d15sm8234195ad.39.2026.09.16.02.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 02:07:21 -0700 (PDT)
Message-ID: <dc927d3e-e7f1-461c-9a75-259f71899224@gmail.com>
Date: Wed, 16 Sep 2026 17:07:17 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1061/1376] nvme-apple: Drop the PRP null check
 chicken bit
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Joshua Peisach <jpeisach@ubuntu.com>,
 Janne Grunau <j@jannau.net>, Sven Peter <sven@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065631.206877541@linuxfoundation.org>
 <9be379ae-7589-40fb-a0b0-4d4659f46e71@oracle.com>
Content-Language: en-US
From: Nick Chan <towinchenmi@gmail.com>
In-Reply-To: <9be379ae-7589-40fb-a0b0-4d4659f46e71@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Harshit Mogalapalli 於 2026/9/16 下午4:32 寫道:
>
>
> On 12/09/26 12:28 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Sven Peter <sven@kernel.org>
>>
>> [ Upstream commit 8ce883fd068b7ba9ab493cd3ecca3a7ea868c375 ]
>>
>> Now that we program the DMA direction correctly the NULL check that used
>> to make commands fail passes. Another side effect of this bit was that
>> non-align buffers on the admin queue were silently allowed and that's
>> been fixed now as well and we this don't need this chicken bit anymore.
>> More importantly, starting with the firmware installed with macOS 15,
>> which is required for M4 but can also be installed on the previous SoCs,
>> the controller no longer exposes this control register and any access
>> SErrors instead. Just drop the write entirely.
>>
>> Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
>> Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
>> Tested-by: Janne Grunau <j@jannau.net>
>> Tested-by: Nick Chan <towinchenmi@gmail.com>
>> Signed-off-by: Sven Peter <sven@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/nvme/host/apple.c | 14 --------------
>>   1 file changed, 14 deletions(-)
>>
>> diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
>> index 8fc466588c4f2..5f745bf615fe7 100644
>> --- a/drivers/nvme/host/apple.c
>> +++ b/drivers/nvme/host/apple.c
>> @@ -47,9 +47,6 @@
>>   #define APPLE_ANS_BOOT_STATUS     0x1300
>>   #define APPLE_ANS_BOOT_STATUS_OK 0xde71ce55
>>   -#define APPLE_ANS_UNKNOWN_CTRL     0x24008
>> -#define APPLE_ANS_PRP_NULL_CHECK BIT(11)
>> -
>>   #define APPLE_ANS_LINEAR_SQ_CTRL 0x24908
>>   #define APPLE_ANS_LINEAR_SQ_EN     BIT(0)
>>   @@ -1130,17 +1127,6 @@ static void apple_nvme_reset_work(struct work_struct *work)
>>           /* Setup the NVMMU for the maximum admin and IO queue depth */
>>           writel(anv->hw->max_queue_depth - 1,
>>               anv->mmio_nvme + APPLE_NVMMU_NUM_TCBS);
>> -
>> -        /*
>> -         * This is probably a chicken bit: without it all commands
>> -         * where any PRP is set to zero (including those that don't use
>> -         * that field) fail and the co-processor complains about
>> -         * "completed with err BAD_CMD-" or a "NULL_PRP_PTR_ERR" in the
>> -         * syslog
>> -         */
>> -        writel(readl(anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL) &
>> -            ~APPLE_ANS_PRP_NULL_CHECK,
>> -            anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL);
>>       }
>
> Hi Greg/Sasha,
>
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
>
> Upstream removes the Apple PRP workaround only after
> 69d22a6b2f698 adds a page-alignment quirk and ea2160c7b7818 enables it for nvme-apple.
>
> Upstream code with both alignment prerequisites:
>
>     if (is_admin &&
>         (ctrl->quirks & NVME_QUIRK_ADMIN_PAGE_ALIGN))
>             lim->dma_alignment = NVME_CTRL_PAGE_SIZE - 1;
>
> Downstream 6.12.y code:
>
>     lim->dma_alignment = 3;
>     NVME_QUIRK_SKIP_CID_GEN | NVME_QUIRK_IDENTIFY_CNS
>
>
> Neither is present in 6.12, whose admin queue still permits four-byte
> buffer alignment.
>
> I suggest porting those two prerequisites to the older queue-limit API
> and applying them before this deletion. Thoughts?

This appears to be correct. In addition, the way this deletion is currently
structured depends on commit 

04d8ecf37b5e06d1 ("nvme: apple: Add Apple A11 support")

solely because adding A11 support wrapped the existing
code in an if statement. The correct patch would be to
remove the corresponding code directly in 6.1, 6.6 and
6.12.

I suggest this patch and all of its dependencies to be
dropped from 6.1, 6.6 and 6.12 so this patch can be
backported properly alongside the page size quirk later.

Patches that should be dropped:

04d8ecf37b5e06d1 ("nvme: apple: Add Apple A11 support")
6fe0687245e8406b ("nvme-apple: Prevent shared tags across queues on Apple A11")
a6ab75639e23169a ("nvme-apple: Reset q->sq_tail during queue init")
8ce883fd068b7ba9 ("nvme-apple: Drop the PRP null check chicken bit")

Best Regards,
Nick Chan


>
> thanks,
> Harshit
>>         /* Setup the admin queue */
>
