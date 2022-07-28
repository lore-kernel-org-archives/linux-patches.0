Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C4137B
	for <patches@lists.linux.dev>; Thu, 28 Jul 2022 11:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659009451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lXdadE5tFLQU4NSWbSKARNnxeWjymRpUklOO5iznGkM=;
	b=iRN18K7mjP9pMLasTpqTFDt4o+6p70ZzpVPpzk882KVquAB5z+hwoDMPU01zqc+DFOf5O7
	NDYrzbgsp5r8JOHDw23uacMTvtecDw2pCzSOihK//R9WKDlFvtQl3/uwSsNPwLxCsLqWp2
	AWQYQ5Z3RXGpw3YPUr5mJZdf4Yb08e8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-Gtz1efWTN1WqT-I5kzNZ0Q-1; Thu, 28 Jul 2022 07:57:28 -0400
X-MC-Unique: Gtz1efWTN1WqT-I5kzNZ0Q-1
Received: by mail-ej1-f71.google.com with SMTP id sa19-20020a1709076d1300b0072f703aef3aso538236ejc.14
        for <patches@lists.linux.dev>; Thu, 28 Jul 2022 04:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lXdadE5tFLQU4NSWbSKARNnxeWjymRpUklOO5iznGkM=;
        b=TC9IX3ZCbK6TsMVWpq/uGAmPeGr1NybhIwt3bAZa4P1ploNR7e45fxJ52/J8+0v9xf
         8od09xPM0wgPmzrPfaaz0NIhSQHSSxUAw7f7WEAjqoWK4cw9dzftwfijdQZ8DeZyOByO
         tH6xJXdEfAWsNq8V91WIP12KyM2ub1IDhh3rZ2SRmnji0lBHVwJ54+WDNhKZdFDpl+8u
         VfPLTmYxMBtmzhqniPf37elLnwCdxIlTr/CKPAWRI8rT2/6K2raInL4tDZOfrbz+NPZy
         XqNhJhcBeX3wHOhtCnCyu+puQbmF7Yn09RsKA+87OMredrue5Z/9xsvKu5NB8BT9VM27
         Xyfg==
X-Gm-Message-State: AJIora8KMdtK+eaY5W8roCNIpGAB1xXg8aFrizKNYdQaDno+YmWb7YPN
	nQukNhiC9wAgAAN/SE8nEyQguf/Bw0g4ZPxDsa9AmybMb1pCjWnC9eyL5vdoV0uuTKZhVD0v51E
	B0Of2dkV1W0YXgnF3qg==
X-Received: by 2002:a17:907:b590:b0:72f:90ba:bef0 with SMTP id qx16-20020a170907b59000b0072f90babef0mr20756565ejc.333.1659009447397;
        Thu, 28 Jul 2022 04:57:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tuXpvxXmwR6QuCBW2oFr9VUVUTxVb5GbohLTgM1ifkzzjiPM+iEnf7FFka48eZWK+hylu/Zg==
X-Received: by 2002:a17:907:b590:b0:72f:90ba:bef0 with SMTP id qx16-20020a170907b59000b0072f90babef0mr20756550ejc.333.1659009446888;
        Thu, 28 Jul 2022 04:57:26 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b0072faba43409sm348039ejn.58.2022.07.28.04.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 04:57:26 -0700 (PDT)
Message-ID: <55368a65-c536-93c7-c501-9f6086e308d2@redhat.com>
Date: Thu, 28 Jul 2022 13:57:25 +0200
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
To: Greg KH <gregkh@linuxfoundation.org>,
 Jithu Joseph <jithu.joseph@intel.com>
Cc: markgross@kernel.org, ashok.raj@intel.com, tony.luck@intel.com,
 ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev
References: <20220710160011.995800-1-jithu.joseph@intel.com>
 <YssFjbveghDLNn4N@kroah.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YssFjbveghDLNn4N@kroah.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/10/22 18:59, Greg KH wrote:
> On Sun, Jul 10, 2022 at 09:00:11AM -0700, Jithu Joseph wrote:
>> Existing implementation limits IFS images to be loaded only from
>> a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.
> 
> That was by design, why is this suddenly not acceptable?
> 
>> But there are situations where there may be multiple scan files
>> that can be run on a particular system stored in /lib/firmware/intel/ifs
> 
> Again, this was by design.
> 
>> E.g.
>> 1. Because test contents are larger than the memory reserved for IFS by BIOS
> 
> What does the BIOS have to do with this?
> 
>> 2. To provide increased test coverage
> 
> Test coverage of what?
> 
>> 3. Custom test files to debug certain specific issues in the field
> 
> Why can't you rename the existing file?
> 
>> Renaming each of these to ff-mm-ss.scan and then loading might be
>> possible in some environments. But on systems where /lib is read-only
>> this is not a practical solution.
> 
> What system puts /lib/ as read-only that you want to have loading
> hardware firmware?  That kind of defeats the security implications of
> having a read-only /lib/, right?
> 
>> Modify the semantics of the driver file
>> /sys/devices/virtual/misc/intel_ifs_0/reload such that,
>> it interprets the input as the filename to be loaded.
> 
> So you are now going to allow any file to be read from the system, in an
> unknown filesystem namespace, by this driver?

@Intel folks to me this is the big blocker which needs to be solved before
we can move forward with figuring out how to allow loading multiple
different sets of test patterns through IFS.

Which in turn is required to remove the broken marking...

How about echoing a suffix to be appended to the default filename to
the reload attribute? This suffix would then need to be sanity checked
to only contain [a-z][0-9] (we don't want '/' but it seems better to
limit this further) to avoid directory traversal attacks. 

(and echoing an empty suffix can be used to force reloading the
default test-patterns after a linux-firmware pkg upgrade)

This way we avoid the allowing user to load an arbitrary file issue.

Greg, would using a suffix appended to the default filename be
acceptable to you as a solution to solving the load arbitrary
file issue?

Also as Greg has mentioned for the next version the commit message
+ ABI docs need to a better job of explaining why support for more
then one set of test patterns per CPU model is necessary.

Since there has been no progress on this I'm going to drop this
as well as the "[PATCH 0/2] Two fixes for IFS" patch series from
my patch queue. Lets continue discussing the userspace API issue
in this thread and then once it is solved please post a v3 patch/series
addressing all the issues.

Regards,

Hans




> How wise is that?  How
> much has this been fuzzed and tested to ensure that it can not now be
> instantly abused by anyone with access to this sysfs file?
> 
> Be aware that most systems have now locked down the ability for
> userspace to pick filenames for stuff like this for good reason.  This
> feels like a step backwards from those protections.  Are you _SURE_ you
> want to do this?
> 
>> diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
>> index 73c8e91cf144..577cee7db86a 100644
>> --- a/drivers/platform/x86/intel/ifs/ifs.h
>> +++ b/drivers/platform/x86/intel/ifs/ifs.h
>> @@ -34,12 +34,13 @@
>>   * socket in a two step process using writes to MSRs to first load the
>>   * SHA hashes for the test. Then the tests themselves. Status MSRs provide
>>   * feedback on the success/failure of these steps. When a new test file
>> - * is installed it can be loaded by writing to the driver reload file::
>> + * is installed it can be loaded by writing the filename to the driver reload file::
>>   *
>> - *   # echo 1 > /sys/devices/virtual/misc/intel_ifs_0/reload
>> + *   # echo mytest > /sys/devices/virtual/misc/intel_ifs_0/reload
>>   *
>> - * Similar to microcode, the current version of the scan tests is stored
>> - * in a fixed location: /lib/firmware/intel/ifs.0/family-model-stepping.scan
>> + * The file will be loaded from /lib/firmware/intel/ifs/mytest
>> + * The default file /lib/firmware/intel/ifs/family-model-stepping.scan
>> + * will be loaded during module insertion.
> 
> So you have a default directory, what happened to your read-only /lib/ ?
> 
> This also does not properly document what the kernel code does.
> 
> {sigh}
> 
> Please do not rush this, it's not acceptable as-is at all.
> 
>> --- a/Documentation/ABI/testing/sysfs-platform-intel-ifs
>> +++ b/Documentation/ABI/testing/sysfs-platform-intel-ifs
>> @@ -35,5 +35,4 @@ What:		/sys/devices/virtual/misc/intel_ifs_<N>/reload
>>  Date:		April 21 2022
>>  KernelVersion:	5.19
>>  Contact:	"Jithu Joseph" <jithu.joseph@intel.com>
>> -Description:	Write "1" (or "y" or "Y") to reload the IFS image from
>> -		/lib/firmware/intel/ifs/ff-mm-ss.scan.
>> +Description:	Write <file_name> to reload the IFS image from /lib/firmware/intel/<file_name>.
> 
> "reload" should not be for specifying the filename, please use a sane
> interface instead of this overloading logic.
> 
> greg k-h
> 

