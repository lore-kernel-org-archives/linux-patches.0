Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E462574
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678959803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P76DINGwLN3jYPnTLgFDgnOUdVkQEqE2bdfQVbKORjo=;
	b=CW8Hb7A3PmQquu+P/KDZ4pYwcuZW0thW2QrTpaAQdYq5zYEkZYZUckq7TgcHEGyiyiYG8M
	BhMgv7Vte9i9tMVe6XOs8vk7ecuUjMk/FTy/8uCAi0SzGOp1Hhzz2FgomG1QGvlZTvmopc
	IbAwfmOZTZ6zEopq0TuyhvKdbqh7JWE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-8W2s9kOkN2-EEfJZnxa6HA-1; Thu, 16 Mar 2023 05:43:20 -0400
X-MC-Unique: 8W2s9kOkN2-EEfJZnxa6HA-1
Received: by mail-ed1-f69.google.com with SMTP id q13-20020a5085cd000000b004af50de0bcfso2239728edh.15
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 02:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678959799;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P76DINGwLN3jYPnTLgFDgnOUdVkQEqE2bdfQVbKORjo=;
        b=jO1iaXkO2f3C0Fen61wXJT0TdtMvywHXY+Kqo53P4FYllSQk+FquDJSxxGtc1NLicm
         xoVdt4p1DNayw5xgmI7rEflQkylP+4gzgSZiOObi4SglkJlSm4EIyXZuJX2V7WIYibxO
         PVSMX31f07nID1sJNMGZA2LfV1wZA0QinzWDaPN7tXforEuKuaHR8nXaXtToeQ765fvx
         IMU5gYPGHfZ4Edj2V3+btqHqv+HOtcp4X5Yvt5OQwcpi0lu7fnQVB5kRUfgTA3asjEj/
         JqTOMttWAzaw+jxKnEEP4iF9kXR5v2IPoQ4Dt7GfSJidjKAIooeJ4T+miL9Igb66Q0Gw
         hZVA==
X-Gm-Message-State: AO0yUKUUXZl6OwNqqsNg4ry7TwBmLnhVc9YG0L5NZEklK/QJlie6rR08
	EkrafIKBuTXkCW8OwUhVu+rgZku7SOYZGIL1AiL0enau0PAaC9xUx7Pb+6l6bzZ/vJfWoSu4CHL
	8aRfux+PMrohntzwI0g==
X-Received: by 2002:a17:907:c508:b0:92c:6fbf:28 with SMTP id tq8-20020a170907c50800b0092c6fbf0028mr11131718ejc.64.1678959799130;
        Thu, 16 Mar 2023 02:43:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set9ABacgIfpMNu8b5pxHf2TkCJA8LMCLwd2GIJtR06o8lF73WzUup/jJcRknqUbwOk8DJbXvqw==
X-Received: by 2002:a17:907:c508:b0:92c:6fbf:28 with SMTP id tq8-20020a170907c50800b0092c6fbf0028mr11131697ejc.64.1678959798893;
        Thu, 16 Mar 2023 02:43:18 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id e23-20020a170906375700b008cff300cf47sm3603646ejc.72.2023.03.16.02.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 02:43:18 -0700 (PDT)
Message-ID: <fc45ace6-546c-59cd-016d-906b6bcb1831@redhat.com>
Date: Thu, 16 Mar 2023 10:43:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/8] platform/x86/intel/ifs: Reorganize driver data
To: "Joseph, Jithu" <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230301015942.462799-2-jithu.joseph@intel.com>
 <a6ae936e-effd-3794-e6fb-11b33a4d6eb1@redhat.com>
 <2ae25756-7403-ad5f-548a-50e633040bf9@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <2ae25756-7403-ad5f-548a-50e633040bf9@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/13/23 22:34, Joseph, Jithu wrote:
> 
> 
> On 3/13/2023 7:46 AM, Hans de Goede wrote:
>> Hi Jithu,
>>
>> On 3/1/23 02:59, Jithu Joseph wrote:
> 
>>>  
>>> +struct ifs_const_data {
>>> +	int	integrity_cap_bit;
>>> +	int	test_num;
>>> +};
>>> +
>>
>> This is a description of the specific capabilties / bits of
>> the IFS on e.g. Saphire Rapids, so please name this appropriately
>> for example:
>>
>> struct ifs_hw_caps  {
>> 	int	integrity_cap_bit;
>> 	int	test_num;
>> };
> 
> This can be renamed to ifs_test_caps as it holds test specific fields.

Ack.

>>
>> You got this exactly the wrong way around, there should be a single
>>
>> static const struct ifs_hw_caps saphire_rapids_caps = {
>> 	.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
>> 	.test_num = 0,
>> };
>>
>> And then struct ifs_device { } should have a "const struct ifs_hw_caps *hw_caps"
>> which gets initialized to point to &saphire_rapids_caps. So that your const
>> data is actually const.
>>
>> Where as since the r/w data's lifetime is couple to the misc-device lifetime
>> there is no need to dynamically allocate it just keep that embedded, so that
>> together you get:
> 
> Noted 
> 
>>
>> struct ifs_device {
>> 	const struct ifs_hw_caps *hw_caps;
>> 	struct ifs_data data;
>> 	struct miscdevice misc;
>> };
>>
> 
> The initialization portion, taking into account your suggestion above, translates to:

Yes, assuming we go with 1 ifs_device per test type.

Regards,

Hans


> static const struct ifs_test_caps scan_test = {
> 	.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
> 	.test_num = IFS_TYPE_SAF,
> };
> 
> static const struct ifs_test_caps array_test = {
> 	.integrity_cap_bit = MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT,
> 	.test_num = IFS_TYPE_ARRAY_BIST,
> };
> 
> static struct ifs_device ifs_devices[] = {
> 	[IFS_TYPE_SAF] = {
> 		.test_caps = &scan_test,
> 		.misc = {
> 			.name = "intel_ifs_0",
> 			.minor = MISC_DYNAMIC_MINOR,
> 			.groups = plat_ifs_groups,
> 		},
> 	},
> 	[IFS_TYPE_ARRAY_BIST] = {
> 		.test_caps = &array_test,
> 		.misc = {
> 			.name = "intel_ifs_1",
> 			.minor = MISC_DYNAMIC_MINOR,
> 			.groups = plat_ifs_array_groups,
> 		},
> 	},
> };
> 
> Jithu
> 

