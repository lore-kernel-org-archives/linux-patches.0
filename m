Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0126A941
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 06:25:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 6AE4E6015F;
	Thu, 27 Jul 2023 08:19:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1690438766; bh=713PFtKI1z/4EgIBZda56llwEq1ZIDGkX9TkQXmO25w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c2efXiytADcbUYyMUmPn2KTi60Km5C4SiT/2oSAnVRsHjb0yz3J83TwlXBtgJYsk6
	 qx3o2OY6SuOoLaf/sJlnIcIvsmluWRuLOgvgg/Ht29sZnOA9DonA/swttwDJT7otQ5
	 jGRy0T6dSro033SnDHI0utV8LJjqc1KtI6wF/5lOwnBCdTfBBT9093RZnQwUeC3gm3
	 MoO5RyxhI2IwtLg7gpZ7IoTgFxAGKJQgB3E0HG+Qu1kH6dHFTGOCobjTKntPCcmm26
	 ywAv1qk0n9HOtnxz3UvB1/PtGl8ZvjzdDhQ9t8SuEP2x1dYJFKkrbTnIn8RGVMpggv
	 fPJUn7tJ4MbDg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eFxYPOKn94hT; Thu, 27 Jul 2023 08:19:24 +0200 (CEST)
Received: from [10.0.2.76] (grf-nat.grf.hr [161.53.83.23])
	by domac.alu.hr (Postfix) with ESMTPSA id 246E960155;
	Thu, 27 Jul 2023 08:19:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1690438764; bh=713PFtKI1z/4EgIBZda56llwEq1ZIDGkX9TkQXmO25w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oQirhGTDcBTXPeZuPqLFknp/ZYvHWYSkknqD+piA98uZZFXOzNZe2jbbw0hVGu+Fc
	 r4sSo0sh6o4XQgszhlPv5DkK6XQEBjQiE0M6Pa3UvmkGeUVt/QoXFC8KtsKiA5dCzD
	 Q+0Qzm1pg3qpCeOSxzFoT+ykSIryeW/1aRQMbBr7J5EPUJPqa4DpP+RifF7mo/aVRK
	 XACUdbfjS65DJAQyBwKYgtli+JL7x8TirmpTTP0oof2rOpEZZsxY0Pgdq08frb6kEW
	 j6MsDK7H8Hv3EHZmEG+HORmcWGz0dvQm8LVJ9CcEEMGKpdyg7Dit2D0Nn2UDGU+yjo
	 E8cOkm3XcamhA==
Message-ID: <37d18826-2e51-dd6b-b423-ba9159aa6c9f@alu.unizg.hr>
Date: Thu, 27 Jul 2023 08:19:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 300/532] test_firmware: return ENOMEM instead of
 ENOSPC on failed memory allocation
Content-Language: en-US, hr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
 Takashi Iwai <tiwai@suse.de>, Kees Cook <keescook@chromium.org>,
 "Luis R. Rodriguez" <mcgrof@ruslug.rutgers.edu>,
 Scott Branden <sbranden@broadcom.com>, Hans de Goede <hdegoede@redhat.com>,
 Brian Norris <briannorris@chromium.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, Sasha Levin <sashal@kernel.org>
References: <20230721160614.695323302@linuxfoundation.org>
 <20230721160630.668952292@linuxfoundation.org>
From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230721160630.668952292@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21.7.2023. 18:03, Greg Kroah-Hartman wrote:
> From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> 
> [ Upstream commit 7dae593cd226a0bca61201cf85ceb9335cf63682 ]
> 
> In a couple of situations like
> 
> 	name = kstrndup(buf, count, GFP_KERNEL);
> 	if (!name)
> 		return -ENOSPC;
> 
> the error is not actually "No space left on device", but "Out of memory".
> 
> It is semantically correct to return -ENOMEM in all failed kstrndup()
> and kzalloc() cases in this driver, as it is not a problem with disk
> space, but with kernel memory allocator failing allocation.
> 
> The semantically correct should be:
> 
>          name = kstrndup(buf, count, GFP_KERNEL);
>          if (!name)
>                  return -ENOMEM;
> 
> Cc: Dan Carpenter <error27@gmail.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Luis R. Rodriguez" <mcgrof@ruslug.rutgers.edu>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Fixes: c92316bf8e948 ("test_firmware: add batched firmware tests")
> Fixes: 0a8adf584759c ("test: add firmware_class loader test")
> Fixes: 548193cba2a7d ("test_firmware: add support for firmware_request_platform")
> Fixes: eb910947c82f9 ("test: firmware_class: add asynchronous request trigger")
> Fixes: 061132d2b9c95 ("test_firmware: add test custom fallback trigger")
> Fixes: 7feebfa487b92 ("test_firmware: add support for request_firmware_into_buf")
> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
> Message-ID: <20230606070808.9300-1-mirsad.todorovac@alu.unizg.hr>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   lib/test_firmware.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/test_firmware.c b/lib/test_firmware.c
> index 2a4078946a3fd..b64f87f4f2284 100644
> --- a/lib/test_firmware.c
> +++ b/lib/test_firmware.c
> @@ -183,7 +183,7 @@ static int __kstrncpy(char **dst, const char *name, size_t count, gfp_t gfp)
>   {
>   	*dst = kstrndup(name, count, gfp);
>   	if (!*dst)
> -		return -ENOSPC;
> +		return -ENOMEM;
>   	return count;
>   }
>   
> @@ -606,7 +606,7 @@ static ssize_t trigger_request_store(struct device *dev,
>   
>   	name = kstrndup(buf, count, GFP_KERNEL);
>   	if (!name)
> -		return -ENOSPC;
> +		return -ENOMEM;
>   
>   	pr_info("loading '%s'\n", name);
>   
> @@ -654,7 +654,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
>   
>   	name = kstrndup(buf, count, GFP_KERNEL);
>   	if (!name)
> -		return -ENOSPC;
> +		return -ENOMEM;
>   
>   	pr_info("inserting test platform fw '%s'\n", name);
>   	efi_embedded_fw.name = name;
> @@ -707,7 +707,7 @@ static ssize_t trigger_async_request_store(struct device *dev,
>   
>   	name = kstrndup(buf, count, GFP_KERNEL);
>   	if (!name)
> -		return -ENOSPC;
> +		return -ENOMEM;
>   
>   	pr_info("loading '%s'\n", name);
>   
> @@ -752,7 +752,7 @@ static ssize_t trigger_custom_fallback_store(struct device *dev,
>   
>   	name = kstrndup(buf, count, GFP_KERNEL);
>   	if (!name)
> -		return -ENOSPC;
> +		return -ENOMEM;
>   
>   	pr_info("loading '%s' using custom fallback mechanism\n", name);
>   
> @@ -803,7 +803,7 @@ static int test_fw_run_batch_request(void *data)
>   
>   		test_buf = kzalloc(TEST_FIRMWARE_BUF_SIZE, GFP_KERNEL);
>   		if (!test_buf)
> -			return -ENOSPC;
> +			return -ENOMEM;
>   
>   		if (test_fw_config->partial)
>   			req->rc = request_partial_firmware_into_buf

Just to note: this patch went to 5.10, 5.15 and 6.4, but not to 6.1 LTS.

Is there a particular reason for that, or is it a patchwork glitch?

Thanks,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

