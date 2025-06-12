Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF6221421D
	for <patches@lists.linux.dev>; Thu, 12 Jun 2025 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716125; cv=none; b=jGbtDJpuXHwrmGBXCWQWg93xBqDogEc52srGZqVv1R1687Pcol7umG3XblVB0nNChn0AxRJuH7imLyhV994qyAOsHP9jxmDXHitK2AJIcEZZdzlutN5xpRchYAAjsXiU3fgPB2HiXfFE+WnyBb9tNq3uC5UeLkjPKIdwfQcPTF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716125; c=relaxed/simple;
	bh=lBKwX+O4KVOXGA24/5v8NW34dV1xfHAYop5k9y6dES4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVcsp/gKDuvzbnf3oRchqQ5FByK7obm6dDfUaEI0vy3ORJOXSbwADMFfxwolKaL7ufpeTSJmNoSCfti+CW0YdPc46dezDi12bwIfz0kxIGPIpL/XswOqG1ODazln4rdvvtZmHZK1SFUbIp9Y92zljUXbPotnk+SViMPpRc1perA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8gH6a9t; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8gH6a9t"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a5257748e1so498674f8f.2
        for <patches@lists.linux.dev>; Thu, 12 Jun 2025 01:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749716122; x=1750320922; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OiHYNuRdA2z6F+JZ9jDJ84+PdVEDalxdRBrZuRPl1B8=;
        b=m8gH6a9tD1ptcBeV6VO9lSWc/Cz6duwUUEnkkBmUjC1QbuChPh27nNU4yjFVsnhzuI
         68F1o8KbzSzF0V3fCZtdjFBpi+5n7QItcFHh2uhmJU3StvDDOTjzAuYiM7/3c6FvZB1l
         e06GRh1rwKL6bVBwyZOkk8eWg3DQGB9DnLXDO7u73E12lWH/debfAvKjFrgOBHvGbpej
         Onawir7o044+URv083YIYKBE4wou5T1BzJBErhfiJvQ2bASSDNWgZ9G4I3gHvXH9WGTV
         YVzBVF2mdmxtGUi3SEeoK4Z4pMUtr34hCDwlYxMWdfKloPONIaCudjEh/rUp6aNKKKdL
         vsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749716122; x=1750320922;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OiHYNuRdA2z6F+JZ9jDJ84+PdVEDalxdRBrZuRPl1B8=;
        b=nhrDB0UnItH6PulYdEQfPW6yujfWZbE5KnL9HgFffqxGwUu3H8pV/nnc0ezu4kBIXj
         cdEzhu0FtHRrbnvwH3QquwudCHwqYzSrc0+cezpvF3w5deKzE0y+ngMcFTQgYBbmVfTV
         BdP2mK1KL3EGFQFsmNFF01osABXcf5ULFnvw6OdmbrHITn6c0wXewseZY+VHoFHLHzCj
         ZfxQe9KZ/0MQi7BPfVzPukndDixHoygmJ5N5AKZtYoYqZz2d43Dc17NEWBW2YetT00Tw
         WlMZcFOeL+nBWtbDX0QaSgRr7Rv6C0T9FfwQRlj/YpCZH6Csz8RK121fKcygI1Fggn2C
         dD8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVS45v8Iid3vaud1f2N8r81BLX3tzS0TLhUcKq5uKSb3eRVoVqWV3/sVrWuvmxvNmDV4iOMzI2P@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0YerzxbfprKKNEfixpG+VHqCbzdt9ErmbGcyBT6xGNhFODdwX
	D1JbuDzYECr6gTgYiN3WIErzw5xZed4fJXEbg8x1tIq7765M9NjfVxbs
X-Gm-Gg: ASbGncv4Q5xcJGPHai1Vdte4duH5w4utuymfpuczUrq5OcAUKZDrLW19ZHAttSm8rmX
	9ri6YOr5hQ/BJOWFP6EHsv51NwrIFpS/GSL9PLA/hm6jNbgaRE2Q8l8iX97zABIAgdgNLFx6CcA
	sxyXGDBzg1nD9d/Ar604fzILZDGlqvazBIc1VSOCqUlGxXS5QDFSddliw0YqZiDPeoIoWVgNtAa
	7t2qjJ0MwRgoEae5SiA0XZ7rZSwkCjqQCr0iwlP8kNdo1QGJGMsqKPyCBH7B5d8OnJ5ZIBsQwca
	d8nu9G/ib2x3LSIcy67tdYaqJVjAVjl+Amq2Knvmx4oOBtRQ1Aj21HWZt3ZHBJHGxE+gZSLF8om
	zgRURBltke6b8QEI=
X-Google-Smtp-Source: AGHT+IH5/CAlJBqc1ga1W7RgZTMPvmkXjPxsssJzU8PYoPDM/J1IVq8a5BwS6dwgsq26AWjjqagJfA==
X-Received: by 2002:a05:6000:220f:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3a561349f32mr1597702f8f.27.1749716121746;
        Thu, 12 Jun 2025 01:15:21 -0700 (PDT)
Received: from localhost (v2202307203666234413.quicksrv.de. [45.83.104.137])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a561b65ab2sm1257570f8f.96.2025.06.12.01.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 01:15:21 -0700 (PDT)
Date: Thu, 12 Jun 2025 11:15:09 +0300
From: Ahmed Salem <x0rw3ll@gmail.com>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Collin Funk <collin.funk1@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 6.15 05/34] ACPICA: Apply ACPI_NONSTRING in more places
Message-ID: <3nobung2ragvykho52thb2pouxgjatmh5cjtc2vh3aro72lkk4@bp45zihoq6v5>
References: <87ecvpcypw.fsf@gmail.com>
 <5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org>

Hi all,

On 25/06/12 09:23AM, Jiri Slaby wrote:
> On 12. 06. 25, 7:31, Collin Funk wrote:
> > Hi Greg,
> > 
> > Sorry for the exta mail. Accidently put CC emails in the subject...
> > 
> > > --- a/tools/power/acpi/tools/acpidump/apfiles.c
> > > +++ b/tools/power/acpi/tools/acpidump/apfiles.c
> > > @@ -103,7 +103,7 @@ int ap_open_output_file(char *pathname)
> > >   int ap_write_to_binary_file(struct acpi_table_header *table, u32 instance)
> > >   {
> > > -	char filename[ACPI_NAMESEG_SIZE + 16];
> > > +	char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
> > >   	char instance_str[16];
> > >   	ACPI_FILE file;
> > >   	acpi_size actual;
> > 
> > This one seems incorrect, as I was alerted to by the following warning:
> > 
> >      apfiles.c: In function ‘ap_write_to_binary_file’:
> >      apfiles.c:137:9: warning: ‘__builtin_strlen’ argument 1 declared attribute ‘nonstring’ [-Wstringop-overread]
> >        137 |         strcat(filename, FILE_SUFFIX_BINARY_TABLE);
> >            |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >      apfiles.c:106:14: note: argument ‘filename’ declared here
> >        106 |         char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
> >            |              ^~~~~~~~
> > 

Thank you so much, Collin, for shedding light on this issue!

This is now reverted in upstream ACPICA commit a6ee09c ("acpidump: drop
ACPI_NONSTRING attribute from FileName") [1], and pending merge.

> > The 'strcat' function is only well defined on NUL-terminated
> > strings. Also, there is a line of code:
> > 
> >      filename[ACPI_NAMESEG_SIZE] = 0;
> > 
> > That also makes me think it is a string.
> 
> Ugh, indeed.
> 
> FTR this is about 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in more
> places").
> 
> To me neither the above, nor struct acpi_db_execute_walk's:
>   char name_seg[ACPI_NAMESEG_SIZE + 1] ACPI_NONSTRING;
> is correct in the commit.
> 
> This is broken in upstream/-next too.
> 
> thanks,
> -- 
> js
> suse labs

Thank you so much, Jiri, for the attention to the other issue.

The above issue is now reverted in upstream ACPICA commit 4623b33
("Debugger: drop ACPI_NONSTRING attribute from NameSeg") [2], and pending
merge.

Rafael, the upstream PR [3] is ready. My apologies to
everyone, and thank you so much for the review and efforts!

Link: https://github.com/acpica/acpica/pull/1029/commits/a6ee09c [1]
Link: https://github.com/acpica/acpica/pull/1029/commits/4623b33 [2]
Link: https://github.com/acpica/acpica/pull/1029 [3]

--
Best regards,
Ahmed Salem
