Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EFF385D6C
	for <patches@lists.linux.dev>; Sat, 30 May 2026 09:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780133309; cv=none; b=tsYHc92tZVB8/iAkWcuAnzFg3uGiJiPJPXp/NWrOj55W6Ybrjnc9z3bmUmsd9z1s1b4Q3g0uTVpViDZQeP+I2SUFCTSaPbcwfdI03+cMqTlmYtJKjXYyOyu1MGUfw/Nf2JfLmt1Jfncbo2R34+gQXTH1lxfiRUf5FrHWLBtuBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780133309; c=relaxed/simple;
	bh=Axu2q9OiQlW7NrUR5/tN+MxVX+YXj5nOsIeGUL7II+w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YTIEeXpMRMUQI/G18QjNU9VSfRdkHduK2Ph/YhHe7Odbq2LFDcQME+Rr5Mbn4otIVdwskuL3u2WiNnnIXlGPggSbWaiWIQCGht4/16K7W9IFVcN0yiM3vCM59JPB4jSuswOJKMmdZuocQIGu0J8eH/EHVLMmwabPN5NEdpRcRiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vwg6w2KH; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vwg6w2KH"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso440266f8f.0
        for <patches@lists.linux.dev>; Sat, 30 May 2026 02:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780133307; x=1780738107; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AVGWNyN/0YK3gFgYNwL3zKk91DjUbWVPzRQNZkauQoA=;
        b=Vwg6w2KHG1XXB8qtAFNE0IjBuvPeK1GU26tXvFOQlu3F5va3Mq9wtfav6haYLB9Ai6
         K//vMhYq0fa6ORQBwPtEgmzFLPvMpr6S5Nokmi85wJp4pCzIYQJK+YfG3n++XQmd1l1L
         CyvdkvSiWosJmDoDLKe1RFUE0X8+Fl+wR+9DImbqabLzCx5YruoF7y35x9kKMgidFsjD
         dTworaONxalCcYYX0uT1q18hY0ameNlwHulRGC6IwPzUy+0pfzM3fY2hJXyzyNH67YBi
         eTyVrSj1jM2i6LS4TdGb74Pfuk9biahP/i/kE7CWWYcsP9cQyBtsOEMFNQxLcQF25GWC
         Ot2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780133307; x=1780738107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AVGWNyN/0YK3gFgYNwL3zKk91DjUbWVPzRQNZkauQoA=;
        b=gPj8rT44vpLQJBLUs0ANVyww9zuso6oDf5CefOSt+tN4pMp7pSaAmmr+ggkpJD3Ej+
         UE7qc6sON+YIoiFJJ0+SzodO+a6V9dK4cJVoPqku1ikW75pNobPx+7HxCZQoESycUzYn
         3SkG/syUTjlp8ZW/qDMm8fO+axMpSjlylNwETdLu4DFowcAK9pZUC8yirugJsXycKCks
         5J9AD4LJBIdSIQS2JJf+trb5OPt46N3xW95dxduGW6xlHPvmFE8pmysFBoXhLNrJwnjR
         W5y82m0rFa4FschLPiqfeTXH1kvt2eQTomenMMxtS+CjmAIo5YdY+SFSFtO8wFsZ3QTR
         3hfw==
X-Forwarded-Encrypted: i=1; AFNElJ/wIe6/R6LTa5XEHNDL4fJUj5aQO8O+8Canv66UWbhfmPDDPNPTMQEzTB8chD62vYcUAuoGSYTW@lists.linux.dev
X-Gm-Message-State: AOJu0YwveHQw3jsTYed8foH45WR+kD+oXGbyE6VCeIUA3CLs9zQ+BpeH
	XMzxv1atcbHUTg/oDfQbg8xxDsDj8A3i3ms8iDzf76gpEK3uNhnaVWyI
X-Gm-Gg: Acq92OFv8Vsq2+/Y4XLm0SXkgVkKb2FE58Lkbq7AZj4BhOXfuNMYlvi5DN6BYBbIfNm
	EwAied5cYgk03cECc9IRzRXkLvt8/x1bewR5+GAjALlWu3MgkknSNPmtADlwqxlqsXr5igVWN+B
	XTTN68nlqG7pKmieXoQCl00Qo1BpLRejyChImaq7aPMY7EyCtVwKXIbakmZzN4xC3lXoeSsxSjQ
	7len+F/JLursHx7JFSRjEGmkwO2VVu/DTVW9ph52r8IvSWKUTWyxE0NdGdJb20MOG5RH279NlG2
	VCU8hIdQmd1rzB1unghZWT1H6svP2g1FdEHJSH8KH/clN0lSq/lbMRX/su3DL1mwm4PhThCpXK8
	GCFYjxxf7XMyPfQLFxDbeiaXTDKyOx73KVXpfdJvVjkEh1FdrXoe4iO6U9SJZmwJDNRyDGIBKky
	PMc8CFqvFDllswzdK0sqrrBssyHjDKkgZLFUox2JFbEwTLDI14+tGJLj3OXhuYkVG+eCsbP+k=
X-Received: by 2002:a05:600c:3147:b0:48f:e230:80a3 with SMTP id 5b1f17b1804b1-490a297304bmr47960185e9.33.1780133306950;
        Sat, 30 May 2026 02:28:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c09acd3sm30659185e9.4.2026.05.30.02.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 02:28:26 -0700 (PDT)
Date: Sat, 30 May 2026 10:28:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org, Mark Bloch
 <mbloch@nvidia.com>, netdev@vger.kernel.org, Saeed Mahameed
 <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 06/11] selftests: Fix arm64 IO barriers to match
 kernel
Message-ID: <20260530102824.65ceb098@pumpkin>
In-Reply-To: <20260529224442.11d7320d@pumpkin>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
	<6-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
	<ahiFxtmspbETiqWw@google.com>
	<20260529134947.GA128816@nvidia.com>
	<20260529175516.06d5788f@pumpkin>
	<20260529192933.GD3195266@nvidia.com>
	<20260529224442.11d7320d@pumpkin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 May 2026 22:44:42 +0100
David Laight <david.laight.linux@gmail.com> wrote:

> On Fri, 29 May 2026 16:29:34 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, May 29, 2026 at 05:55:16PM +0100, David Laight wrote:  
...
> > I can't say, this is copied from the kernel and Will made it:
> > 
> >     arm64: io: Ensure calls to delay routines are ordered against prior readX()
> >     
> >     A relatively standard idiom for ensuring that a pair of MMIO writes to a
> >     device arrive at that device with a specified minimum delay between them
> >     is as follows:
> >     
> >             writel_relaxed(42, dev_base + CTL1);
> >             readl(dev_base + CTL1);
> >             udelay(10);
> >             writel_relaxed(42, dev_base + CTL2);
> >     
> >     the intention being that the read-back from the device will push the
> >     prior write to CTL1, and the udelay will hold up the write to CTL1 until
> >     at least 10us have elapsed.
> >     
> >     Unfortunately, on arm64 where the underlying delay loop is implemented
> >     as a read of the architected counter, the CPU does not guarantee
> >     ordering from the readl() to the delay loop and therefore the delay loop
> >     could in theory be speculated and not provide the desired interval
> >     between the two writes.
> >     
> >     Fix this in a similar manner to PowerPC by introducing a dummy control
> >     dependency on the output of readX() which, combined with the ISB in the
> >     read of the architected counter, guarantees that a subsequent delay loop
> >     can not be executed until the readX() has returned its result.  
> 
> Hmmm...
> 
> Ok so there is some subtlety with the read of the counter that might
> make it all work.
> 
> It is better to make the delay loop have a data dependency on the result
> of the readl().
> Something like:
> 	u32 z = 0;
> 	OPTIMIZER_HIDE_VAR(z);
> 	writel_relaxed(42, dev_base + CTL1);
> 	udelay(10 + (z & readl(dev_base + CTL1)));
> 	writel_relaxed(42, dev_base + CTL2);
> That avoids the potentially mispredicted branch and only adds instructions
> when a delay follows.
> That sequence is safe for all cpu and doesn't cost much for cpu (like x86)
> where it (probably) isn't needed (maybe unless you patch the scale for udelay
> into the code so there are no memory reads, just code).
> 
> Probably best refactored as udelay_depends(10, readl(dev_base + CTL1)).
> Or maybe udelay_after().

Sleeping on it, all the code can be put in udelay().
You just need a read memory barrier, followed by a memory read (of anywhere
'hot') and then use a data dependency (as above) from the second read
into the delay loop.

-- David

