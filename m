Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98FB139A
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657460553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkcPV7/dDAo74iwNPvy+Tipbk+Gf9tQDRsUYdJh426Y=;
	b=GtfMtxqihCtyxtXaQTvTTgMwJzDBUCXJuIha7KT5/Q1gFJz+H1TeSmB24i4JjKKVKB9nGb
	2SVMJo/0LTaubeK0gIBNqsUBm6zZcOL7pTuMsT2oqjX+K5AN7w1fv70zeZMcrh1d29ZVYd
	pOOZEc3z4/8pbvEdxEcs/2nnlgJCJRo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-jH6ijQ7cPw2Pi4Z9Zr0vUQ-1; Sun, 10 Jul 2022 09:42:31 -0400
X-MC-Unique: jH6ijQ7cPw2Pi4Z9Zr0vUQ-1
Received: by mail-ed1-f69.google.com with SMTP id b15-20020a056402278f00b0043acaf76f8dso1165575ede.21
        for <patches@lists.linux.dev>; Sun, 10 Jul 2022 06:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dkcPV7/dDAo74iwNPvy+Tipbk+Gf9tQDRsUYdJh426Y=;
        b=MhWzGxuhyzPY4Mn7DZcpG8dat2CC1Lqde0oJ5y3hNbyQQ+tZT4zUQtq7w40IDD80U7
         9q9+iPGoCKN9g864xKTw9qrvCrgtgIKkgGcVnfaZp5Q9gY9mSE99XsH3scQmHUX484yZ
         KPm5DNEoqtMCWIpLKHfu8mOsqav2gQlLhjaMcifJmG8ajzh30Con54+5McBFGBj/9Mlo
         egW1fhNG9+rA0lZQQGijDAuBjEviV2on0IbB3SoY5I+nNwo+bfAizAzKIkP+be/1fCQS
         uGgPndzbkEIslaah3IokWGj//qyNTSsSYzf7+hu8vR6yedqFaXgjjkGjaTsHqxR8xTuz
         aPwg==
X-Gm-Message-State: AJIora/9KzJyWAukINK01dCC0hSrTzEgzYAh9e9NNCsse4Mz9AsBka89
	BnHvvHS4XyBtrtMz8XKIZlQwq/hl3KU4lVtqJI9ijs5Jw/QNKc0ggcUpyGrfxf0pvjdHUTEcwEL
	UFjZDLGL9EU4XYmmWyw==
X-Received: by 2002:a17:907:3f04:b0:6e8:4b0e:438d with SMTP id hq4-20020a1709073f0400b006e84b0e438dmr13581254ejc.391.1657460550763;
        Sun, 10 Jul 2022 06:42:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1svmqxCX2ITCcvCA7vC19DbM5OIrd7wuJAlVS+WPuiC8Uu/GJgKTbbecfYAFgbb8+B8UAEk0w==
X-Received: by 2002:a17:907:3f04:b0:6e8:4b0e:438d with SMTP id hq4-20020a1709073f0400b006e84b0e438dmr13581237ejc.391.1657460550495;
        Sun, 10 Jul 2022 06:42:30 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id w20-20020a056402071400b0043a87e6196esm2760529edx.6.2022.07.10.06.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 06:42:29 -0700 (PDT)
Message-ID: <79eae42f-50ca-c23c-9fd0-8c356b2d3783@redhat.com>
Date: Sun, 10 Jul 2022 15:42:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] platform/x86/intel/ifs: Allow non-default names for IFS
 image
To: Greg KH <gregkh@linuxfoundation.org>,
 "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: markgross@kernel.org, ashok.raj@intel.com, tony.luck@intel.com,
 ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev
References: <20220708151938.986530-1-jithu.joseph@intel.com>
 <YshNAh6awfPFmxzU@kroah.com> <33a6193e-1084-ae5f-1f80-232274f71bd0@intel.com>
 <Ysqm1BRbCTtWfAcW@kroah.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <Ysqm1BRbCTtWfAcW@kroah.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/10/22 12:15, Greg KH wrote:
> On Fri, Jul 08, 2022 at 11:34:40AM -0700, Joseph, Jithu wrote:
>>
>>
>> On 7/8/2022 8:28 AM, Greg KH wrote:
>>> On Fri, Jul 08, 2022 at 08:19:38AM -0700, Jithu Joseph wrote:
>>>> Existing implementation limits IFS image to be loaded only from
>>>> a default file-name (ff-mm-ss.scan).
>>>>
>>
>>>
>>> Ick, but now what namespace are you saying that path is in?  If you need
>>> debugging stuff, then put the api/interface in debugfs and use it there,
>>> don't overload the existing sysfs api to do something different here.
>>
>> The namespace related confusion could be because, the original commit message
>> was not using full path-names. The below write-up tries to be more clear on this
>>
>> Existing implementation limits IFS images to be loaded only from
>> a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.
>>
>> But there are situations where there may be multiple scan files
>> that can be run on a particular system stored in /lib/firmware/intel/ifs
>>
>> E.g.
>> 1. Because test contents are larger than the memory reserved for IFS by BIOS
>> 2. To provide increased test coverage
>> 3. Custom test files to debug certain specific issues in the field
>>
>> Renaming each of these to ff-mm-ss.scan and then loading might be
>> possible in some environments. But on systems where /lib is read-only
>> this is not a practical solution.
>>
>> Extend the semantics of the driver /sys/devices/virtual/misc/intel_ifs_0/reload
>> file:
>>
>>   Writing "1" remains the legacy behavior to load from the default
>>   ff-mm-ss.scan file.
>>
>>   Writing some other string is interpreted as a filename in
>>   /lib/firmware/intel/ifs to be loaded instead of the default file.
> 
> Ick, you are overloading an existing sysfs file to do different things
> based on random stuff.  This is a brand-new api that you are already
> messing with in crazy ways.  Why not just revert the whole thing and
> start over as obviously this was not tested well with real devices.
> 
> And what is wrong with a firmware file called '1'?  :)

Actually the Intel IFS stuff has landed in 5.19-rc# so it is
a bit late(ish) for dropping it now.

But I do agree overloading the reload attribute is ugly,
why not just add a new /sys/devices/virtual/misc/intel_ifs_0/filename
rw sysfs attribute and use that to allow the user to specify a
filename to load different from the default one. Then to load the
<whatever> test firmware the user can do:

echo "<whatever>" > /sys/devices/virtual/misc/intel_ifs_0/filename
echo > /sys/devices/virtual/misc/intel_ifs_0/reload

that seems much cleaner to me ?

Regards,

Hans

