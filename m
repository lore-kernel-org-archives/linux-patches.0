Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E62264CA
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770812150; cv=none; b=Xd3icOFHU1/5jt37a/EkOpyVmlDT4RbN26PMPWrErYgoVpmbfW9Gwo88sX6/wNa9T8+FJ3pTBIeIi3CDyPCHmze+LG9uVO1VajV4TS0uVD2Y3qSl+VCQJpRgiZFaOLA+c2DF9nUfAbv3zQK6cXpT/kEumVIPfS1rITtJkrnNu9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770812150; c=relaxed/simple;
	bh=zwtrR6VDQqRfiGwabJda0K6rC6Ytzxc2xzn9PKLh8Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=URFZqCKIqn8CCVE6fYD9jxUJhyQXHlOR+GqLDcMHtCJuM4Y43BmnR290bwRzW/e70E/7SxjhIBHq1hUg7+tebFxCMwHlexJhiMNKpVXZJHcvFgCi8hOXsZZWX18iHl8DqNP8vXee6R2lLd27sICsRD0f3yWaLmAYTHEXHHWXD78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1G0rf5/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1G0rf5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770812148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EpzX+ghvAFNjZ7ZxVYHEPBHpEaI5GQyf0hEL4AV2dRE=;
	b=e1G0rf5/O1yaPQISB6E/KAYA+e1HdIu9/pxvu5u41ZltuGD3MPVWG/s4K9S3ooYzzW0Wky
	i25CKgPJislCLr7R4p7AeJpWsdhfTWUav8cWUSQK03jtMHxZvp2lR5UXg2qgymbS0oHpB1
	+Duky4w/ixsJxwWYsuVOVkOinZcOVkE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-XWyFB1VNPwuY_PwK99_3_A-1; Wed, 11 Feb 2026 07:15:47 -0500
X-MC-Unique: XWyFB1VNPwuY_PwK99_3_A-1
X-Mimecast-MFC-AGG-ID: XWyFB1VNPwuY_PwK99_3_A_1770812146
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so44478325e9.2
        for <patches@lists.linux.dev>; Wed, 11 Feb 2026 04:15:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770812145; x=1771416945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpzX+ghvAFNjZ7ZxVYHEPBHpEaI5GQyf0hEL4AV2dRE=;
        b=L3dsITIfjAGmbfdGZq6Rwones54SpKNN3fA4Xtdjbfpx8j2IazmsDDIs1Ixjw2bkay
         R7TX3dFdonYKnUhOK3fxwYmHBsxHOLjq3h7NPpzUjbu+KzutI7RdXO6eHYYFA+ks+Pqg
         KAJcYchHGlydwPY14QnXVWhhAATXPwrLQKEeohkmiB1SXH65qjrEFUFb9L0Yv4pDOK0p
         lWWhu09S24cbjEDtCDSKUItl8pBiRbe55MzWRNUF0Z43lKqn5i0V5JAWq4I+c7QaSWjr
         L3f1rs97B+wz6eI6DMQ19T2ATa4/dZt9Is16tA8zyFdg/vsP2iRDyHO0tZfkrjePlKY+
         //pw==
X-Forwarded-Encrypted: i=1; AJvYcCUsB+qMPUKvZdhP0J7NhqPS4nB1nI1x29e2IFu7vsEgWf/CdrVCBUUzPXlLOI+P0OTfyhJwD2kM@lists.linux.dev
X-Gm-Message-State: AOJu0YxnDvfevawywfOFVZUjs+8PuUejE5xoZ8r9K8zS7wGgFmUKwEmu
	zLvcm5MwwBYkeoSUN1rEaGd5RMcBiLtKLz7TmbW8Co0WBeW90y7X1IeNJBy2yf7g3SS0az1F/iG
	h64p3Zm1+/aa7IYJ4rsgfGxPICH4A2JbWmXb1CwZyISkyEv6+FlmeVfUjv5O9R8qy/4s=
X-Gm-Gg: AZuq6aJ04LRmr5b8j+YVwBSVRMC0jmD/QoobhMdytvUrNacoFBd/0dcup9TcnjSPT2f
	Eyu4owQbiff3z2JQIwt2CiTV6CyXbHgt8ANhS07jphwSpUudV88U5R9NOdvhYcPWv0C0RBZD4oC
	0J6XTf5ZpyWJ5Jz37VXoGBgPgjHUiT4CwbGcyW/GLXycwVtfA9oiHjauVtRS2PupWai+MT6dhhn
	6gn8Q+LMMw7THVRNdIaIE40yU+gVKV7Fcz2t3LKX9Flxivk0yljrgj/MzuFosbb0at63+UnX7MR
	0nd73XmaGlz4dFbi//CaDtX6iG5ecewrgjyosfaIoLUCR2yoF4FxU8aMaCJ9O40+wjP2y/nQXqD
	Rf1EX7xQ6K9+hZzLFUcIfCUd0sOeQYphNape5j8zF5MRnGmd05zXNqbsznDSe4lr1eIQgX5Y=
X-Received: by 2002:a05:600c:c4a8:b0:47d:3ead:7440 with SMTP id 5b1f17b1804b1-4835b979c30mr31799965e9.32.1770812144642;
        Wed, 11 Feb 2026 04:15:44 -0800 (PST)
X-Received: by 2002:a05:600c:c4a8:b0:47d:3ead:7440 with SMTP id 5b1f17b1804b1-4835b979c30mr31799315e9.32.1770812144089;
        Wed, 11 Feb 2026 04:15:44 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835a5bf1efsm37289995e9.0.2026.02.11.04.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 04:15:43 -0800 (PST)
Date: Wed, 11 Feb 2026 13:15:39 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Korsnes <johan.korsnes@remarkable.no>, stable@vger.kernel.org, 
	patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>, 
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 094/169] vsock/test: fix seqpacket message bounds
 test
Message-ID: <aYxyYLI9IjI5VxCp@sgarzare-redhat>
References: <20260128145334.006287341@linuxfoundation.org>
 <20260128145337.388867288@linuxfoundation.org>
 <61627e8a-6998-4138-a174-d7fd257db93e@remarkable.no>
 <aYw9N_Ido_FZzblw@sgarzare-redhat>
 <cc9bcfe1-4667-4a33-b370-1f3912f0adca@remarkable.no>
 <2026021103-gusto-karaoke-6c60@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2026021103-gusto-karaoke-6c60@gregkh>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: suX4iC30IyGuQvqDqMJcemAzhcsKUSX-JY7rTZUjmP8_1770812146
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Wed, Feb 11, 2026 at 12:37:20PM +0100, Greg Kroah-Hartman wrote:
>On Wed, Feb 11, 2026 at 09:58:08AM +0100, Johan Korsnes wrote:
>> On 11/02/2026 09:30, Stefano Garzarella wrote:
>> > On Wed, Feb 11, 2026 at 08:50:11AM +0100, Johan Korsnes wrote:

[...]

>> >> Hi Greg,
>> >>
>> >> This patch causes build failure as the setsockopt_ull_check() function
>> >> does not seem to be defined in the 6.12 tree.
>> >
>> > I guess just when you build vsock_test, right?
>> >
>>
>> Correct. I should have specified that.
>>
>> > BTW to fix that we should backport commit 86814d8ffd55 ("vsock/test:
>> > verify socket options after setting them").
>> >
>> > I tried to cherry-pick it on current linux-6.12.y and apply clean.
>> >
>>
>> I can confirm it builds fine after cherry-picking that commit.
>>
>> Kind regards,
>> Johan
>>
>> > Greg, let me know if I should send a proper patch for 6.12.
>
>Great!  Can you send a proper patch for 6.12.y for this?

Done, I discovered that a similar issue is also in 6.6.y so I sent a fix 
also for that tree:
- 6.12.y: 
   https://lore.kernel.org/stable/20260211115948.108140-1-sgarzare@redhat.com/
- 6.6.y: 
   https://lore.kernel.org/stable/20260211121135.116071-1-sgarzare@redhat.com/

Thanks,
Stefano

