Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9218E2580CA
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504063; cv=none; b=cUea0ONGxw5abwxkYOytRvdXGyg+LU3yomU9Gl/BczmkdaFOIeUB8AmX58DDXqA1xZmJfK/AhCtU21OBt2xfLgAiJ5HXEHZu5GmBZV4NaCRo7q6ZcDWElTJI7liuC/DKJcxwoXbtfc74Pc01LBo5pmnvEYVXiwjW9PTwkFc0d8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504063; c=relaxed/simple;
	bh=WkbnkSN/9C9x5BAWT4GOvXy3evb45ZMcjMYvY/vr8qY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9Z42KhP6lE/RaTT24vpTKI/TpYzye0zgcOqoVClwocci4U0NBjMKFXMKdomMQ0iXVEmni4Jg+lFqrEWdj2g4mQLWZ8LpQ3dGB0xqx7YnbMBTgsfnSvL0bSGah+r2303UCi+d8xuBtlEXb8oUEmJR8y1hRp+1WSXT8nPbOCiHCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AsLKOMNc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AsLKOMNc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752504060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLXKhg1K3xQXwvyv6fgRzq/1onAkTRUAFhWSI1xTzJI=;
	b=AsLKOMNc1nzTrnR6o36SQJEqEXeK/+GHNCA7HtEquTq3nyxBW3qMPpETpW+tISqOYBNV0z
	Nn5O8Zy4HzRBGeGigrOEIBIIG61MX8EY+jbxjduCZyZGP+mVT1r0+/ZQ7Bwh4iVFtXml/t
	DZAnGwtCYNJ2cvc4cmY+hXs+9nU52jQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-FIB8YQboOA6GILc-q8LiRA-1; Mon, 14 Jul 2025 10:40:59 -0400
X-MC-Unique: FIB8YQboOA6GILc-q8LiRA-1
X-Mimecast-MFC-AGG-ID: FIB8YQboOA6GILc-q8LiRA_1752504058
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ade5b98537dso499874966b.2
        for <patches@lists.linux.dev>; Mon, 14 Jul 2025 07:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752504057; x=1753108857;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aLXKhg1K3xQXwvyv6fgRzq/1onAkTRUAFhWSI1xTzJI=;
        b=XxcqHxnX+DRFmQUETEF14XRbE4mbdhZBk9hq+bXrVeKPR3MdZ7pg3o09ISvNzizTTQ
         rFwoGnxuFkYANC2erAk+CPUN1IsZS0BUiVF0UrNNQBQuBMqy61kFOwm9at4BmC/2d+7y
         UPXgLL1axBunLJFmMKvUNn7NSIm+JsAsSaHTJ9IPMo7RwlueNmzdeaUM6QrNQ8GdgaI6
         MnA3MP8vVzMLdOra0mKVDyTWwm5PSJmtSaxfeF6Vk1w40vBF1Mee+9kvpC8HVCLbWDCV
         Qs4MdnC+KYs7qadGWpStCXHdXrwrpxvvzabReh6JzqjlkbHXE9pgrAA2ge/47zvdcsCt
         JX4g==
X-Forwarded-Encrypted: i=1; AJvYcCWNIYWCpwoHA8rGhP2s4ew8UNbR4GvbvcO9ajl9H1dbXq0GsY+PZ8VV9WEJodOR89CC5yFh9QDI@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8Le8OPfrtPF0AQzuHafDUFKxSnTF7szoRdAgUHe8TjgneWUbm
	ss+P2ze5Q6xjz/TrHrwb4LRbPt8Hjnwhx8Hh9+IjNCAkpSychQCP/DtSUwO86Ftblo3UI1BrPM+
	te8/VYAxYRFZo9V59IgFXfnqdL4WZLgZYLK0ZquhpFbbOCP54ciFv38tglxo=
X-Gm-Gg: ASbGncsOWqT+XZWmcX7sbHl41f4LDzMSFgSQSX/cODP+MsM+pTV5yVBJufgFRcVc7Ez
	hHo1Jw+8YgDlwEpXR2qYF6Z1FhZSIkBNRHv/fOFuTQlRaJ2h2B4ZXUpGHvIn2s9Es6F/1hsrvM8
	6o1a+vOon4JHRtDNYuIcw+evXr79OIwnFUn1sVzR3KANbNQ6s26PA+SbxlVOWLS2L04gzZf2jpH
	BM91DK7Z+2wSUk0Czmvj888t6S9Y+ftytXfGI+36UQfdKCKkaci+o18XQDcfsU850zyTUq/GreL
	3n1B8W0QelYf1NzphepQk7yRjeqaqDT5zZF2a4ekBFyt
X-Received: by 2002:a17:907:3d44:b0:ae3:ab68:4d7a with SMTP id a640c23a62f3a-ae6fbed8219mr1633105666b.25.1752504057154;
        Mon, 14 Jul 2025 07:40:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHucm1YdLEC7W2MqVgXeYA2wsn4X0D/6ulvdMPDsK2hXL50tiQScU0+GEvdxz/6WUq3kW52KA==
X-Received: by 2002:a17:907:3d44:b0:ae3:ab68:4d7a with SMTP id a640c23a62f3a-ae6fbed8219mr1633096866b.25.1752504055640;
        Mon, 14 Jul 2025 07:40:55 -0700 (PDT)
Received: from [10.40.98.122] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7e91a0bsm827763966b.7.2025.07.14.07.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 07:40:55 -0700 (PDT)
Message-ID: <afeadd0a-d341-46ee-9634-01c5122b416a@redhat.com>
Date: Mon, 14 Jul 2025 16:40:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 087150] Input atkbd - skip ATKBD_CMD_GETID in
 translated mode
To: Wang Hai <wanghai38@huawei.com>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
 patches@lists.linux.dev, yesh25@mail2.sysu.edu.cn, mail@gurevit.ch,
 egori@altlinux.org, anton@cpp.in, dmitry.torokhov@gmail.com,
 sashal@kernel.org
References: <456b5d9c-f72a-4bfe-a72a-b5cc0f15eb70@huawei.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <456b5d9c-f72a-4bfe-a72a-b5cc0f15eb70@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -6eISUOlUgh8w7E44HzcLqemgLKHxZTgxjEjHyRRZHY_1752504058
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 14-Jul-25 15:49, Wang Hai wrote:
> 
> 
> On 1970/1/1 8:00,  wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>>  From Hans de Goede hdegoede@redhat.com
>>
>> [ Upstream commit 936e4d49ecbc8c404790504386e1422b599dec39 ]
>>
>> There have been multiple reports of keyboard issues on recent laptop models
>> which can be worked around by setting i8042.dumbkbd, with the downside
>> being this breaks the capslock LED.
>>
>> It seems that these issues are caused by recent laptops getting confused by
>> ATKBD_CMD_GETID. Rather then adding and endless growing list of quirks for
>> this, just skip ATKBD_CMD_GETID alltogether on laptops in translated mode.
>>
>> The main goal of sending ATKBD_CMD_GETID is to skip binding to ps2
>> micetouchpads and those are never used in translated mode.
>>
>> Examples of laptop models which benefit from skipping ATKBD_CMD_GETID
>>
>>   HP Laptop 15s-fq2xxx, HP laptop 15s-fq4xxx and HP Laptop 15-dy2xxx
>>    models the kbd stops working for the first 2 - 5 minutes after boot
>>    (waiting for EC watchdog reset)
>>
>>   On HP Spectre x360 13-aw2xxx atkbd fails to probe the keyboard
>>
>>   At least 9 different Lenovo models have issues with ATKBD_CMD_GETID, see
>>    httpsgithub.comyescallopatkbd-nogetid
>>
>> This has been tested on
>>
>> 1. A MSI B550M PRO-VDH WIFI desktop, where the i8042 controller is not
>>     in translated mode when no keyboard is plugged in and with a ps2 kbd
>>     a AT Translated Set 2 keyboard devinputevent# node shows up
>>
>> 2. A Lenovo ThinkPad X1 Yoga gen 8 (always has a translated set 2 keyboard)
>>
>> Reported-by Shang Ye yesh25@mail2.sysu.edu.cn
>> Closes httpslore.kernel.orglinux-input886D6167733841AE+20231017135318.11142-1-yesh25@mail2.sysu.edu.cn
>> Closes httpsgithub.comyescallopatkbd-nogetid
>> Reported-by gurevitch mail@gurevit.ch
>> Closes httpslore.kernel.orglinux-input2iAJTwqZV6lQs26cTb38RNYqxvsink6SRmrZ5h0cBUSuf9NT0tZTsf9fEAbbto2maavHJEOP8GA1evlKa6xjKOsaskDhtJWxjcnrgPigzVo=@gurevit.ch
>> Reported-by Egor Ignatov egori@altlinux.org
>> Closes httpslore.kernel.orgall20210609073333.8425-1-egori@altlinux.org
>> Reported-by Anton Zhilyaev anton@cpp.in
>> Closes httpslore.kernel.orglinux-input20210201160336.16008-1-anton@cpp.in
>> Closes httpsbugzilla.redhat.comshow_bug.cgiid=2086156
>> Signed-off-by Hans de Goede hdegoede@redhat.com
>> Link httpslore.kernel.orgr20231115174625.7462-1-hdegoede@redhat.com
>> Signed-off-by Dmitry Torokhov dmitry.torokhov@gmail.com
>> Signed-off-by Sasha Levin sashal@kernel.org
>> ---
> 
> Hi, Hans
> 
> I noticed there's a subsequent bugfix [1] for this patch, but it hasn't been merged into the stable-6.6 branch. Based on the bugfix description, the issue should exist there as well. Would you like this patch to be merged into the stable-6.6 branch?"
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9cf6e24c9fbf17e52de9fff07f12be7565ea6d61

Yes, if you can submit that patch for inclusion into the 6.6 stable branch
that would be good.

Regards,

Hans

