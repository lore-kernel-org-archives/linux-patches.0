Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C760518633
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727559164; cv=none; b=SkLIWuio7Ck16lMLMza6VpRr6jUqD2AWft3y/RqMTwXQ8I+rUkmFdb5XoDka5CBEe1B4CmmGep97iamSmd7lXTwvBV0XhcJjSWsBjv5VaSPsoHYavIAQs+BnIrLBT5w+ROfeggDMpzgcZqO3X2Vv4nxtTPHlAMP/MKwMAMShquo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727559164; c=relaxed/simple;
	bh=J6dwjekvHhc6lard0YJQTOrwb5C5Bq/heygrtrluqeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TQbNHblZKoaHGn2qT9qm1sZ2ZZk9bgl5cdb5L5A70cvu1mdOQ5Dz3+gjFZGDquXV4Hn6OHXOnrDwlDud7Q0ik0jGgpplJUP5MFdyB70BAlN4B89znyNhGi8oChbTU10tQbyYDcN19LdTWyg0v6BTwGMZ/Y3QJuYHPYBjm544E2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHVvX0gf; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHVvX0gf"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-206bd1c6ccdso30126805ad.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 14:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727559161; x=1728163961; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=YP5C5sb9/S1CBp32rgGNh9i41OJdRJponvkLQNw/TMU=;
        b=AHVvX0gfuyZ+N4jq74eCsvHta0Uej+xpmOaZ0yheZGGA2k364fob586vL8O34J/Pu8
         gWJjR10NbiVLE+b1gHw0ZXDpXBogeYs5nTpUN7n/LeMoFdDyuL8KLm26K+bvuVY1EdmY
         VceR9KQfaofvkcQKDNEnoKXnp0y0VZ8LQPDLvztp7KZT+SiVkR/xawKJaq6gg3c8CKTZ
         3PUYdz2H9ifRccm2breNKU9PuG6IvwuhFDAf0r861OE1sKtDhZ7Rtu9AWcqKiyNk9gs+
         GaHz9cQmvIIdxx6UZxYD1EtXIZjOGCaFwJuQpXcwGGu5dUYi294QKVcQonlvFXfjg5+B
         0DkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727559161; x=1728163961;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YP5C5sb9/S1CBp32rgGNh9i41OJdRJponvkLQNw/TMU=;
        b=sZceqCDwjd570f2iLeYH0C1l6yZjyngaQ5G3bAslEuJfPCrQMsCxTsuJxSDBEHgKKH
         wYTD4xFqh4+EY7XUxPa5CkpyA8abO/VVBuCwM4TjmgUSsWvkBhtfOuFiaKPEnh8XoCoQ
         Ko5B+Odqec0fcRbEaL+1dTy3sEDuEB8NcYKqm7w+j7maMvLrv4ipBJPpGud0K4Tb16bS
         GrqarUAgv/Bb4S3Q+7XIt7I008KaR7qJzm7AYqLmLg51TYwSSQUTkLf+ODCrLhqDCgLi
         iLOqAn3QMV3dvqpQ0FkdUaDzgVu3TCnPLYsh6xvzAvwiijhEQ7+ddzlqIVhaNXad9PF/
         eqGQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1i8XmsLxmn1xaFgKNvOb+jeEdzgzESFyxbqRoltHEtJSaQvu6jUjlL+30bTvUZSd8OLnb9s4/@lists.linux.dev
X-Gm-Message-State: AOJu0Ywa//ZcQz78+JJ6ORv8uTNTHkmFpYHsRawUrk4fEePHKcwv4SV9
	Cs795hv4z4iDEKyMARLtIO5p96tASRjna4w4hOSbbl3rBUDwkudp
X-Google-Smtp-Source: AGHT+IEmTwzDUx5UTP7lyRpx6IWQLxeALqPfM6iu19eYnPcKfIhjmZz3c91oAC2kwc/XZa2m5HlO+A==
X-Received: by 2002:a17:902:d550:b0:206:96bf:b0cf with SMTP id d9443c01a7336-20b367098c9mr114156025ad.0.1727559159621;
        Sat, 28 Sep 2024 14:32:39 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37d6717fsm31078535ad.14.2024.09.28.14.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 14:32:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f5f1c42d-77c0-48c7-ac52-3d4a3b5c2b47@roeck-us.net>
Date: Sat, 28 Sep 2024 14:32:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/8] clk: Add KUnit tests for clks registered with
 struct clk_parent_data
To: Shuah Khan <skhan@linuxfoundation.org>, Stephen Boyd <sboyd@kernel.org>
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
 Geert Uytterhoeven <geert+renesas@glider.be>
References: <20240718210513.3801024-1-sboyd@kernel.org>
 <20240718210513.3801024-9-sboyd@kernel.org>
 <6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net>
 <a339ec8c-38f6-425a-94d1-ad69b5ddbd88@roeck-us.net>
 <dcd8894f-1eb6-4b5c-9e6f-f6e584c601d2@roeck-us.net>
 <6f5a5b5f-71a7-4ed3-8cb3-d930bbce599b@linuxfoundation.org>
 <ba88a29c-f05e-4ca3-82d1-0a634613caee@roeck-us.net>
 <4216b852-11a2-41ae-bb01-5f9b578ee41b@roeck-us.net>
 <879831a8-2039-4cdb-bce2-aefdeb7ab25f@linuxfoundation.org>
 <da260b77-2ecb-4486-90cb-6db456d381ef@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <da260b77-2ecb-4486-90cb-6db456d381ef@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/28/24 12:27, Shuah Khan wrote:
> On 9/28/24 11:54, Shuah Khan wrote:
>> On 9/28/24 11:31, Guenter Roeck wrote:
>>> On 9/27/24 17:08, Guenter Roeck wrote:
>>>> On 9/27/24 13:45, Shuah Khan wrote:
>>>>> On 9/27/24 10:19, Guenter Roeck wrote:
>>>>>> Copying devicetree maintainers.
>>>>>>
>>>>>> On Thu, Sep 26, 2024 at 09:39:38PM -0700, Guenter Roeck wrote:
>>>>>>> On Thu, Sep 26, 2024 at 09:14:11PM -0700, Guenter Roeck wrote:
>>>>>>>> Hi Stephen,
>>>>>>>>
>>>>>>>> On Thu, Jul 18, 2024 at 02:05:07PM -0700, Stephen Boyd wrote:
>>>>>>>>> Test that clks registered with 'struct clk_parent_data' work as
>>>>>>>>> intended and can find their parents.
>>>>>>>>>
>>>>>>>>
>>>>>>>> When testing this on arm64, I see the error below. The error is only
>>>>>>>> seen if I boot through efi, i.e., with "-bios QEMU_EFI-aarch64.fd"
>>>>>>>> qemu parameter.
>>>>>>>>
>>>>>>>> Any idea what might cause the problem ?
>>>>>>>>
>>>>>>> I noticed that the new overlay tests fail as well, also with "path '/' not
>>>>>>> found".
>>>>>>>
>>>>>>> [Maybe] answering my own question: I think the problem may be that there
>>>>>>> is no devicetree file and thus no devicetree root when booting through
>>>>>>> efi (in other words, of_root is NULL). Would it make sense to skip the
>>>>>>> tests in that case ?
>>>>>>>
>>>>>>
>>>>>> The problem is that of_root is not initialized in arm64 boots if ACPI
>>>>>> is enabled.
>>>>>>
>>>>>>  From arch/arm64/kernel/setup.c:setup_arch():
>>>>>>
>>>>>>     if (acpi_disabled)
>>>>>>         unflatten_device_tree();        // initializes of_root
>>>>>>
>>>>>> ACPI is enabled if the system boots from EFI. This also affects
>>>>>> CONFIG_OF_KUNIT_TEST, which explicitly checks if of_root exists and
>>>>>> fails the test if it doesn't.
>>>>>>
>>>>>> I think those tests need to add a check for this condition, or affected
>>>>>> machines won't be able to run those unit tests. The obvious solution would
>>>>>> be to check if of_root is set, but then the associated test case in
>>>>>> CONFIG_OF_KUNIT_TEST would not make sense.
>>>>>>
>>>>>> Any suggestions ?
>>>>>>
>>>>>
>>>>> Would it work if these tests check if acpi_disabled and skip if it isn't
>>>>> disabled? It might be low overhead condition to check from these tests.
>>>>>
>>>>> acpi_disabled is exported:
>>>>>
>>>>> arch/arm64/kernel/acpi.c:EXPORT_SYMBOL(acpi_disabled);
>>>>> arch/loongarch/kernel/acpi.c:EXPORT_SYMBOL(acpi_disabled);
>>>>> arch/riscv/kernel/acpi.c:EXPORT_SYMBOL(acpi_disabled);
>>>>> arch/x86/kernel/acpi/boot.c:EXPORT_SYMBOL(acpi_disabled);
>>>>>
>>>>
>>>> I don't think that would work. Looking through the use of acpi_init,
>>>> I don't think that of_root is always NULL when acpi_init is false; that
>>>> just happens to be the case on arm64 when booting through efi.
>>>> However, even arm64 has the following code.
>>>>
>>>>          if (acpi_disabled)
>>>>                  psci_dt_init();
>>>>          else
>>>>                  psci_acpi_init();
>>>>
>>>> While psci_dt_init() doesn't set of_root, it does try to do a devicetree
>>>> match. So there must be some other condition where acpi_disabled is set
>>>> but of_root is set anyway. I just have not found that code path.
>>>>
>>>
>>> I ended up disabling all affected unit tests for arm64. I'll do the same
>>> for other architectures if I encounter the problem there as well.
>>>
>>> Unfortunately that includes all clock unit tests because the tests requiring
>>> devicetree support can not be enabled/disabled separately, but that can't be
>>> helped and is still better than "mandatory" failures.
>>>
>>
> 
> of_root is set in drivers/of/pdt.c when it creates the root node.
> This could be a definitive test for kunit tests that depend on
> devicetree support.
> 

That is not always the case, including arm64. It is primarily set in
unflatten_devicetree(), which is not called on arm64 unless acpi_is disabled
(see above).

> It is an exported symbol. drivers/of/base.c exports it.
> 

Yes, checking if of_root is NULL and skipping the test in that case might help,
but then there is the of_dtb_root_node_populates_of_root unit test which
explicitly fails if of_root is NULL. The comment describing the test is

/*
  * Test that the 'of_root' global variable is always populated when DT code is
  * enabled. Remove this test once of_root is removed from global access.
  */

The devicetree unit test code explicitly assumes that of_root is set if
CONFIG_OF_EARLY_FLATTREE is enabled, but that is not always the case
(again, of_root is NULL on arm64 unless acpi is disabled).

Guenter

