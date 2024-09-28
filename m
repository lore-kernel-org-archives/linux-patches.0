Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44701474D3
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727546090; cv=none; b=Bk5qxDko76KjavZF6yStapUswdkU6Y5oNfD9M44CZtdk0feVmNfQPyjON4Xib7Vm0PSvUjTs5GPShBPFwBEgLIqXtT+b/zdCcjcr150HzusRIrGN5SROv19MLJR1pwiNA6ysowR2EFTKoKLjaM0VkmH9QAmDvMjNdIvi143KEYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727546090; c=relaxed/simple;
	bh=YnJn56dspqrgEO4yZyq18ioo9BpMKUylvweGnP0SlM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDLHCfmTghMU7vwGdRB6tF7X+6n0IGMnaayuhdQwNb969qyTYLI+u06xmdHyAvYSxvou8WZh6//R6LCkDlRiPyDBPi0uhGU6Vn8wNAloRd8MY7L9mVEhqxeX1gX4rio6XfR5fY8FKT7CVMWryvDn5w+7dAL2hN5zM6Y5rkVAqug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2O97F8U; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2O97F8U"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a340f9dd8aso15425795ab.2
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 10:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727546088; x=1728150888; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Msen2x255bExjiElFNnAzBvYvdv/zmccGmPf0vr8LjM=;
        b=E2O97F8UQh/EJpnTiqUeDAA9eXT1w0V1qeuhEOi/egRnRL4mLX5ePBjS+HFaPzX4H8
         kO0Aoj4OSsSSyo8HdguEiHZt53da1H6wuKpkHubUPv0ZBj9ZGMCvJFVWBUnp7YeujnTj
         weJl85TXKDekrmdisFhXOtDzirJVHUf/r2Luc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727546088; x=1728150888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Msen2x255bExjiElFNnAzBvYvdv/zmccGmPf0vr8LjM=;
        b=daaRO8DWCDGxIUySsMV7A4PoUY88OWHt5+KR5DmNs2JW1Z7oVYx92yeG2dUJMEpDcF
         9lhQmfieliSEwMQwutHqWWrfuFOmL9z9s+lmzCezF1GDVqxRceJCBccki9aw39PkFDhd
         aV/spLK6d3AjyI8KpqiN4l8a6QQdz1Tb+jP20ZoPMn92hMhVm07WWbZutq+RC1478cnS
         hwAUtlM7YarFFxxRoumh3c5ykZv8Dp0j0QR3utwyxpo4sruh/1r2R2Hqo4ishuyCuNKk
         31YKRA+dEJzxEnBPm6GhS4hKRbq7dkGmug9dwlU9iG3sE1TzXCwPMkRz8lFrz4fDct+p
         V0Yw==
X-Forwarded-Encrypted: i=1; AJvYcCW4PauM+dKIY9SWEjHhEVEmGdp3Pt7pUstYICIR+f06uiVboCcY/Oozl7+e/xV/8Ugi2nrHylab@lists.linux.dev
X-Gm-Message-State: AOJu0YxHQBFSw2nkjrkaEBK1OxDK8F3sRWnafBn6yCOyWlUWX+OQdpDz
	u9jQSQrUE8Da3MXhPm2+0yLqMB6nr8fHiV/UODACgr0KWFmSgwQuAJKr5ZVcNQw=
X-Google-Smtp-Source: AGHT+IH4BRzR5A26RUJXbqOU2RQnz3HhhzO3kNc4QEEwnwocfFFf2kbjmbqKEAg8TshvYlzb9Orozw==
X-Received: by 2002:a05:6e02:214e:b0:3a0:909c:812d with SMTP id e9e14a558f8ab-3a345174574mr64314205ab.11.1727546088065;
        Sat, 28 Sep 2024 10:54:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm13621865ab.2.2024.09.28.10.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 10:54:47 -0700 (PDT)
Message-ID: <879831a8-2039-4cdb-bce2-aefdeb7ab25f@linuxfoundation.org>
Date: Sat, 28 Sep 2024 11:54:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/8] clk: Add KUnit tests for clks registered with
 struct clk_parent_data
To: Guenter Roeck <linux@roeck-us.net>, Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org,
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow
 <davidgow@google.com>, Rae Moar <rmoar@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>,
 Saravana Kannan <saravanak@google.com>, Daniel Latypov
 <dlatypov@google.com>, Christian Marangi <ansuelsmth@gmail.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Maxime Ripard <maxime@cerno.tech>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240718210513.3801024-1-sboyd@kernel.org>
 <20240718210513.3801024-9-sboyd@kernel.org>
 <6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net>
 <a339ec8c-38f6-425a-94d1-ad69b5ddbd88@roeck-us.net>
 <dcd8894f-1eb6-4b5c-9e6f-f6e584c601d2@roeck-us.net>
 <6f5a5b5f-71a7-4ed3-8cb3-d930bbce599b@linuxfoundation.org>
 <ba88a29c-f05e-4ca3-82d1-0a634613caee@roeck-us.net>
 <4216b852-11a2-41ae-bb01-5f9b578ee41b@roeck-us.net>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <4216b852-11a2-41ae-bb01-5f9b578ee41b@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/28/24 11:31, Guenter Roeck wrote:
> On 9/27/24 17:08, Guenter Roeck wrote:
>> On 9/27/24 13:45, Shuah Khan wrote:
>>> On 9/27/24 10:19, Guenter Roeck wrote:
>>>> Copying devicetree maintainers.
>>>>
>>>> On Thu, Sep 26, 2024 at 09:39:38PM -0700, Guenter Roeck wrote:
>>>>> On Thu, Sep 26, 2024 at 09:14:11PM -0700, Guenter Roeck wrote:
>>>>>> Hi Stephen,
>>>>>>
>>>>>> On Thu, Jul 18, 2024 at 02:05:07PM -0700, Stephen Boyd wrote:
>>>>>>> Test that clks registered with 'struct clk_parent_data' work as
>>>>>>> intended and can find their parents.
>>>>>>>
>>>>>>
>>>>>> When testing this on arm64, I see the error below. The error is only
>>>>>> seen if I boot through efi, i.e., with "-bios QEMU_EFI-aarch64.fd"
>>>>>> qemu parameter.
>>>>>>
>>>>>> Any idea what might cause the problem ?
>>>>>>
>>>>> I noticed that the new overlay tests fail as well, also with "path '/' not
>>>>> found".
>>>>>
>>>>> [Maybe] answering my own question: I think the problem may be that there
>>>>> is no devicetree file and thus no devicetree root when booting through
>>>>> efi (in other words, of_root is NULL). Would it make sense to skip the
>>>>> tests in that case ?
>>>>>
>>>>
>>>> The problem is that of_root is not initialized in arm64 boots if ACPI
>>>> is enabled.
>>>>
>>>>  From arch/arm64/kernel/setup.c:setup_arch():
>>>>
>>>>     if (acpi_disabled)
>>>>         unflatten_device_tree();        // initializes of_root
>>>>
>>>> ACPI is enabled if the system boots from EFI. This also affects
>>>> CONFIG_OF_KUNIT_TEST, which explicitly checks if of_root exists and
>>>> fails the test if it doesn't.
>>>>
>>>> I think those tests need to add a check for this condition, or affected
>>>> machines won't be able to run those unit tests. The obvious solution would
>>>> be to check if of_root is set, but then the associated test case in
>>>> CONFIG_OF_KUNIT_TEST would not make sense.
>>>>
>>>> Any suggestions ?
>>>>
>>>
>>> Would it work if these tests check if acpi_disabled and skip if it isn't
>>> disabled? It might be low overhead condition to check from these tests.
>>>
>>> acpi_disabled is exported:
>>>
>>> arch/arm64/kernel/acpi.c:EXPORT_SYMBOL(acpi_disabled);
>>> arch/loongarch/kernel/acpi.c:EXPORT_SYMBOL(acpi_disabled);
>>> arch/riscv/kernel/acpi.c:EXPORT_SYMBOL(acpi_disabled);
>>> arch/x86/kernel/acpi/boot.c:EXPORT_SYMBOL(acpi_disabled);
>>>
>>
>> I don't think that would work. Looking through the use of acpi_init,
>> I don't think that of_root is always NULL when acpi_init is false; that
>> just happens to be the case on arm64 when booting through efi.
>> However, even arm64 has the following code.
>>
>>          if (acpi_disabled)
>>                  psci_dt_init();
>>          else
>>                  psci_acpi_init();
>>
>> While psci_dt_init() doesn't set of_root, it does try to do a devicetree
>> match. So there must be some other condition where acpi_disabled is set
>> but of_root is set anyway. I just have not found that code path.
>>
> 
> I ended up disabling all affected unit tests for arm64. I'll do the same
> for other architectures if I encounter the problem there as well.
> 
> Unfortunately that includes all clock unit tests because the tests requiring
> devicetree support can not be enabled/disabled separately, but that can't be
> helped and is still better than "mandatory" failures.
> 

I am hoping Stephen will have a solution for this problem. In the meantime,
I will look into this to see if we can find a check that works.

thanks,
-- Shuah

