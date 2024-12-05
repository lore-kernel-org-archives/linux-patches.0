Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F5B15E90
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 04:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373353; cv=none; b=M3fQrmEJHTYbhxRb1JNIMQf6+SIAs+vFXCWlh5NJOHyp4rNRWYknuVDaVXeSfZ8KWlveM4iEd0D+KhiaPIp4bX4v77Qi4qcz4OxH8icTnjMHgSYjhMe+a9n98SOMjTt/5t98MRwC9rsZD4LaDC1YYZ14dYAqkNiExjOX4ML59/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373353; c=relaxed/simple;
	bh=uiNNXseuROWmgCpz6MHoHMtZaYwfpO53Yy2y0pgRuUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwERj/1yDMA9ASrpu69xN9FdDmK/3SbRqgDvBmZ9WVZ6U5rqpa8iWJ/9PLKFbUqAxwEi2Nty7do9Lt3CHcKrZ2Iz06yyRq+WiPGo7eB6cYqsEDZ5V2enedwsJUgK3v5sVjYM7XK5AktqNu2/oStvG6Q+AAdXKKYvD1CDvgp5ox0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPIdnbKC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPIdnbKC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733373349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0toYV7O5m7SIQhioF5KP2treLFyuAZomjZkcJd8tQOM=;
	b=UPIdnbKCE5Nlu33Vho9D4asc7RnccKoo4mf//GGZGJ5INaCkvzBDYo3wAwxHgP4ZcPJpJr
	y3geszLFyTzgGHmiCU1VbsDp6pDllUMzlc3t76nTPDuFP6EdTr5QtQdyFLREhLB8ljmlG6
	qksq1G+Zwn+JQ5wuWcE4EJGRw/MTv8s=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-aN93IFyROzKkZSpYLm0x4g-1; Wed, 04 Dec 2024 23:35:47 -0500
X-MC-Unique: aN93IFyROzKkZSpYLm0x4g-1
X-Mimecast-MFC-AGG-ID: aN93IFyROzKkZSpYLm0x4g
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a7de3ab182so9842655ab.1
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 20:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733373347; x=1733978147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0toYV7O5m7SIQhioF5KP2treLFyuAZomjZkcJd8tQOM=;
        b=XcPKnSs/BCYX7kzfg5X/kfkBGdn9Zm7Qi+5Wvlga+ziTsMzgSQeotg571PN7uaqu8U
         1hbXHahLJw8wmu+Qw1yNUW0Izrc5qUEN0Hk/ERtZYMnjOjpoHWXQWDAF3NzBTi+31G8I
         TKeJPVqpnSpC27wiupXTVg373lmd47NrynMO/gEEQjCTyngE7LNvI3CDgM85rCda7X1X
         dVwXVmiQCmpGyuLopLc4htsllYgOAXXEkSL9qCF6UCT1iVizTzd8une9RNU5gnbhVsOB
         XEMaqS0ZsEABd55Voc9YHKZENxl64bxF/BBEquZWbWvig34Wx+1FQ8UyvPX9RIrCefFi
         +3aw==
X-Forwarded-Encrypted: i=1; AJvYcCWIuVmpt5RD9cFHJVPRXZLxO5y88nZHDB13VaUfS4Ev+rJMeDiXfqbjCuyaaH59C1SeJS18asgA@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/H02zPBZpbtSEpF4jHxL+qZSfQq2fNeWSDovBfB4jdSA0AhdH
	hwMTmquCojyRECUUYBhrHCtwdSmlLmBlen8Qn0Ai+rhI042y3Y6HlKM/2I81/NgPzfNPFgkND1B
	JZ6YxE8rSAqyqdW1asbiWqTBzE2XvtHHLcFNYWXx/216gQKabphqp3uw=
X-Gm-Gg: ASbGncu3PRVjA26/NBmef3X34d1sNn1IDULYD5Jl5KqPVaJEb4/lOYNOwtOBO0lqZH/
	0HAsOzSdb25L772zPwz6aW1icvu5zFOUgr7Nm7uOeOYJGT5rLkK7HEIhpBJ1INa1G6n9G7ihpfK
	h5IofGkep9a2xh18+V7gRCZmDpax6EYJ0NwQ7soSJvyHWc19EkMBuaxsrYprq0chTjsVgs01jU1
	sXIwIcY3qmVjep1Hd8UmJndhlyKZCcHXXHgs3HofrphrdvAe6FedUHaZA1O2/N4phUAa3kKD3B1
	c5Spa166sES0
X-Received: by 2002:a05:6e02:350b:b0:3a7:fe8c:b012 with SMTP id e9e14a558f8ab-3a7fe8cb0damr84155195ab.18.1733373347030;
        Wed, 04 Dec 2024 20:35:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHC8qtYhZohMTLDB//11ZaFrpRsOUaLt9pecqfj3xsswKrVgp4ixwyQVtzcB3lFYfmEB8DAVQ==
X-Received: by 2002:a05:6e02:350b:b0:3a7:fe8c:b012 with SMTP id e9e14a558f8ab-3a7fe8cb0damr84155035ab.18.1733373346753;
        Wed, 04 Dec 2024 20:35:46 -0800 (PST)
Received: from [10.0.0.214] (97-116-181-73.mpls.qwest.net. [97.116.181.73])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a808da2623sm2186565ab.22.2024.12.04.20.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 20:35:46 -0800 (PST)
Message-ID: <0272e083-8915-407a-9d7f-0c1a253c32d7@redhat.com>
Date: Wed, 4 Dec 2024 22:35:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] common/config: use modprobe -w when supported
To: Luis Chamberlain <mcgrof@kernel.org>, patches@lists.linux.dev,
 fstests@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, gost.dev@samsung.com
References: <20241205002624.3420504-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20241205002624.3420504-1-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vsa-3GFv71QxL0oAUabypstdpAJNxU24KI0VR4nRaDs_1733373347
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/24 6:26 PM, Luis Chamberlain wrote:
> Eric, I saw you mentioning on IRC you didn't understand *why*
> the patient module remover was added. Even though I thought the
> commit log explained it, let me summarize again: fix tons of
> flaky tests which assume module removal is being done correctly.
> It is not and fixing this is a module specific issue like with
> scsi_debug as documented in the commit log bugzilla references.
> So any sane test suite thing relying on module removal should use
> something like modprobe -w <timeout-in-ms>.

Well, I was having a sad because the upshot of all of that was
that when xfs was not removable at all because it was the root
filesystem, the end result was something like this:

    --- tests/xfs/435.out	2024-11-21 05:13:04.000000000 -0500
    +++ /var/lib/xfstests/results//xfs/435.out.bad	2024-11-21 05:14:47.949206141 -0500
    @@ -3,3 +3,4 @@
     Create a many-block file
     Remount to check recovery
     See if we leak
    +custom patient module removal for xfs timed out waiting for refcnt to become 0 using timeout of 50

which is kind of nonsense, but that probably has more to do with
the test not realizing /before it starts/ that the module cannot
be removed and it should not even try.

Darrick fixed that with:

[PATCH 2/2] xfs/43[4-6]: implement impatient module reloading

but it's starting to feel like a bit of a complex house of cards
by now. We might need a more robust framework for determining whether
a module is removable /at all/ before we decide to wait patiently
for a thing that cannot ever happen?

-Eric

