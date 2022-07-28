Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7411399
	for <patches@lists.linux.dev>; Thu, 28 Jul 2022 13:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659014283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fk5FapRp0i4FPMzfkyQvl7eHkIhec6Rpn9lH0Vq4Bhg=;
	b=KGvSRsJYB3uKZ6QnDh6B+n5s8E6vro30tWDGFDb61vPmmbo1YmtmntfvEOZ0CByoDmgdsR
	RgLEMfKJg1Ub7KBXr+7+YSR/gl5j796PfUI6y46hT6TgAu5oy4mz5nEZTQFC9FUttZI723
	Z2RkxWMNwpZHrk28JjY4o35RTgEMUMY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-I4YUbLfCPf6YEAU7TWkVKw-1; Thu, 28 Jul 2022 09:18:02 -0400
X-MC-Unique: I4YUbLfCPf6YEAU7TWkVKw-1
Received: by mail-ed1-f69.google.com with SMTP id f13-20020a0564021e8d00b00437a2acb543so1086578edf.7
        for <patches@lists.linux.dev>; Thu, 28 Jul 2022 06:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fk5FapRp0i4FPMzfkyQvl7eHkIhec6Rpn9lH0Vq4Bhg=;
        b=AMg0ANU1nFKTedm0aUi4kq8kYko7mMOtBjsLlnSk//E5W9gyusXmXj+mr7nWdMDYps
         jkcoltEeP7mXCfSDBY/pHbOvo1Wylqjp5i20q+M9qad9WdmPY82YIvw9tdYJhDKq8IZK
         5Z9wdM/Rb4WIMUzTlllX+bhzzygLfR3tRlKvt1MhUIQreuMRh3dIzYviBsW4J137RAU7
         U7p/KWWCPr4ZDoRxeqgKIqISTbDToo2UU84erIaP84xrkXyzVMbZxign2D0ZAacsibaF
         idy9avvASKciqS1Hvv6bQ4xpGKoPofBejNULM4FhDo8J9dhq9+usPyMBiyAY/ia3OCe1
         Rkag==
X-Gm-Message-State: AJIora9k2Z/vH8J8xeW/7vtLdS8HZjyR4ZaG8NJ6Ba4/EAm4r3suNkHC
	Mpk4bJ6wEVDIP4KB03cSLJSiWthRk8mFPxuAlnVcdZGLaW2HWv+2wydTHpHDrT00nEXodvoi1+a
	A2a0eWamhZPREwYYxKA==
X-Received: by 2002:a17:907:a042:b0:72b:4fac:1ddf with SMTP id gz2-20020a170907a04200b0072b4fac1ddfmr21515805ejc.285.1659014281392;
        Thu, 28 Jul 2022 06:18:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vGXrNXTbvMTZXZctdiJca1e8JW/0hf08+ba3J6eNtoT48A4MYDTLKjD2lkDk89kRR8gacvMQ==
X-Received: by 2002:a17:907:a042:b0:72b:4fac:1ddf with SMTP id gz2-20020a170907a04200b0072b4fac1ddfmr21515779ejc.285.1659014280987;
        Thu, 28 Jul 2022 06:18:00 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id b12-20020aa7df8c000000b0043ba0cf5dbasm701916edy.2.2022.07.28.06.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 06:18:00 -0700 (PDT)
Message-ID: <1ea8a38f-538c-43ed-c4dc-bc3722c03489@redhat.com>
Date: Thu, 28 Jul 2022 15:17:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] platform/x86/intel/ifs: Allow non-default names for
 IFS image
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org,
 ashok.raj@intel.com, tony.luck@intel.com, ravi.v.shankar@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev
References: <20220710160011.995800-1-jithu.joseph@intel.com>
 <YssFjbveghDLNn4N@kroah.com>
 <55368a65-c536-93c7-c501-9f6086e308d2@redhat.com>
 <YuJ8Ah37WAHGTJlV@kroah.com>
 <39b47ca8-1d25-0e60-d326-ad627541fe36@redhat.com>
 <YuKIL4QkC25h6RF8@kroah.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YuKIL4QkC25h6RF8@kroah.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/28/22 14:59, Greg KH wrote:
> On Thu, Jul 28, 2022 at 02:52:06PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 7/28/22 14:07, Greg KH wrote:
>>> On Thu, Jul 28, 2022 at 01:57:25PM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 7/10/22 18:59, Greg KH wrote:
>>>>> On Sun, Jul 10, 2022 at 09:00:11AM -0700, Jithu Joseph wrote:
>>>>>> Existing implementation limits IFS images to be loaded only from
>>>>>> a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.
>>>>>
>>>>> That was by design, why is this suddenly not acceptable?
>>>>>
>>>>>> But there are situations where there may be multiple scan files
>>>>>> that can be run on a particular system stored in /lib/firmware/intel/ifs
>>>>>
>>>>> Again, this was by design.
>>>>>
>>>>>> E.g.
>>>>>> 1. Because test contents are larger than the memory reserved for IFS by BIOS
>>>>>
>>>>> What does the BIOS have to do with this?
>>>>>
>>>>>> 2. To provide increased test coverage
>>>>>
>>>>> Test coverage of what?
>>>>>
>>>>>> 3. Custom test files to debug certain specific issues in the field
>>>>>
>>>>> Why can't you rename the existing file?
>>>>>
>>>>>> Renaming each of these to ff-mm-ss.scan and then loading might be
>>>>>> possible in some environments. But on systems where /lib is read-only
>>>>>> this is not a practical solution.
>>>>>
>>>>> What system puts /lib/ as read-only that you want to have loading
>>>>> hardware firmware?  That kind of defeats the security implications of
>>>>> having a read-only /lib/, right?
>>>>>
>>>>>> Modify the semantics of the driver file
>>>>>> /sys/devices/virtual/misc/intel_ifs_0/reload such that,
>>>>>> it interprets the input as the filename to be loaded.
>>>>>
>>>>> So you are now going to allow any file to be read from the system, in an
>>>>> unknown filesystem namespace, by this driver?
>>>>
>>>> @Intel folks to me this is the big blocker which needs to be solved before
>>>> we can move forward with figuring out how to allow loading multiple
>>>> different sets of test patterns through IFS.
>>>>
>>>> Which in turn is required to remove the broken marking...
>>>>
>>>> How about echoing a suffix to be appended to the default filename to
>>>> the reload attribute? This suffix would then need to be sanity checked
>>>> to only contain [a-z][0-9] (we don't want '/' but it seems better to
>>>> limit this further) to avoid directory traversal attacks. 
>>>>
>>>> (and echoing an empty suffix can be used to force reloading the
>>>> default test-patterns after a linux-firmware pkg upgrade)
>>>>
>>>> This way we avoid the allowing user to load an arbitrary file issue.
>>>>
>>>> Greg, would using a suffix appended to the default filename be
>>>> acceptable to you as a solution to solving the load arbitrary
>>>> file issue?
>>>
>>> Not really, a suffix doesn't protect much at all.
>>
>> ?
>>
>> Currently the driver will always load:
>>
>> /lib/firmware/intel/ifs/%02x-%02x-%02x.scan
>>
>> with the "%02x" bits being fixed parts of the CPU model.
>>
>> My suggestion is to make it:
>>
>> /lib/firmware/intel/ifs/%02x-%02x-%02x%s.scan
> 
> Ah, sorry, I skimmed that, you are right, that would be fine.  But still
> odd to ever be needed in a real system.

Ok, good. So Intel folks this seems to be a way to move forward
with this. Please prepare a version 3 using this approach.

>>> This really feels like a "test the product in the factory" type of
>>> option that someone seems to want to do without just renaming the
>>> firmware file.  Why this is unique from all other firmware file loading
>>> in the kernel needs to really be explained here in order to even
>>> consider justifying this type of change.
>>
>> First of all I really wish some of the Intel folks would elaborate
>> more on why multiple test-pattern files are necessary. Ping
>> anyone@intel, you have all been very quiet in this thread which
>> is not helpful (not helpful at all really).
>>
>> Speculating myself as far as I understand IFS is not for factory
>> tests but for testing in the fields since big cloud vendors have
>> found that sometimes there are hard to catch CPU defects which
>> they only find out by running statistics which show that certain
>> tasks only crash when run on machine a, socket b, core c.
> 
> Who knows, Intel doesn't say so we can't really guess :(

Right, for version 3 the commit message and ABI documentation changes
really need to clarify why multiple test-pattern files may be needed
mucy better. If possible please also include 1 or 2 _clear_ examples
of cases where more then 1 test-pattern file may be used.

Regards,

Hans

