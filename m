Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCB52E425F
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756232171; cv=none; b=OpDcOMhR+By8YaCm82Y0z4gsvSve3LNaetf9ogJ2Q09t/XLaNRR5Q9eHYPG3Itg2hXxQ3LN39mgc/zHkDEYbJ/xpnYBoVfj4Ix6AvPl7WGKXNQVxRkKADHWZgUxuqbjKvwfU+zdE4oBC43hLhGTLkroyS9bEwMvcBzc9BRZlJAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756232171; c=relaxed/simple;
	bh=GMRxymhNkZNBWq21//zBGy00Sx7UuiBXmuBQ2vhzYHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePzd1VTdVH0aSo1YeXmrVNavwGwXy2BZYcoR6PNmx2HiLPQycYH6l031y2fZKhTTHv7uRrCWAyoHli2KtiIlCNHVyXbMz28NHIw2Z5XgIMhBXXHT8f5XSUhtepcPyaPrEgSgjta3s0AAnFc191f+SDV8ASGN6umXU+RQbBflnQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G81nHL7K; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G81nHL7K"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3c51f0158d8so4577077f8f.1
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 11:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756232167; x=1756836967; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ovZ5TqxkqtcU6jYMimb1HaGzBaZPG7b1ARCmJyeyr4=;
        b=G81nHL7K/y/Eab1YZkHY3tQe9B9L3xHV+YG/5WGMdgh11gJPcJZVoKi3b3G/ASdcf1
         hA0/X/58V7DhkBCkWOdmPPQOn3jvVqAKnB83SbNfcr8U8J8rALoMcdQDm4w4fE0DoeYO
         saIbFu48Y2nsifqg25FMHc4gzDuVHYcShbjs0FF+An5WC2+3oxhACaGaIL1hj+R1kUNk
         1Lfc2rwdD8vYnwvZrn1DNcdWy6iB7zuaLoOWWo9wH65ZNs76b2XFRDuVABKiELkJh7c3
         t6MnL9XagM3sExu42OQ4kc8WCjGhDQuyNlrc/Kv+79OplEhb4018IF6D+OZY26Sy+p97
         RCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756232167; x=1756836967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ovZ5TqxkqtcU6jYMimb1HaGzBaZPG7b1ARCmJyeyr4=;
        b=FAekRshPGJY6E6S/rkm/QnqoqxpNMnn93haIeZYodN8sk3Yq5TqWhjhhdCmThWrvCz
         IOG2TWqbtcKp9gGrcH2b9SahLI1WuIJEDY+/qaWbbtDQhCuwkPIek65R86NW0/G0nsPz
         zQI9LIYZfs0k+pBprmQaFpr+z/6GpqExA9iug4iKHgDrvjG47MKnX/ewCQQ0JzaZIvD9
         /FcidIRfq1t1/1R6c0nmIevRmpWgL1h5j6WwOwYx4ilTGl0bWhTZQ8J2fvqilUNCVKt2
         vRLbb+znG00gy8ZqZRO4CNkNLOTAObAgIves/AOcEZkX0aNUmoOpD2/8lbVAdMk7bWwz
         VmUw==
X-Forwarded-Encrypted: i=1; AJvYcCW8NpgRvvz3u2QlLmUAfrOo6HbVWW0ZZBS29g2Jmmoq/c52qV51oT9C2REkJBnYEMtM1tilm9Gu@lists.linux.dev
X-Gm-Message-State: AOJu0YzhtdoqSez0v9JRgRjqF1eT7XipkmDrYdF97EnQ5ecLU9ONEEYH
	ixa38lIerQZ9sFxtyv6mibYPl74hng+wrLPswNmVybthzCQ6AijuLUoI
X-Gm-Gg: ASbGncv+Pjo0SJHMIkt4k4/2xQs66TNxNcqFyMY+jEdZ82a8tiFCOChDhRXCzk1UtUJ
	MDf9xPqYkfEAA+GKe4A+XvLQyOr7wddR840wjnzEYOJmgDw+J3e3Tm1iX/moxlz+w03u08W7516
	5BjYDhAHvHSqbtfHC3xy0sxehEhxYRkojYpucafiuY6Fe2oMU15EMK53HrrMgRmgSZIPMXCj1V/
	KEPQKdIiERxoGWfTbNEgEF3bBSIvuZbfUEtzi8h1LR3KR/GiwP2jniBoLPIGKGauSU9p/9V5I3G
	Vl+UZa3bPfynVMrPMkr9HVVIwNpjNygTji+9K+AsUPj6cf9uH0C/cBxJF71EEt5VWNH2YXBAmJZ
	mMfLpKpD54lFBYPeCTbny22H0t6YKuRfBRwM9xqpc/41Jj2beIrnsap8=
X-Google-Smtp-Source: AGHT+IH/FUF9kWusU42/y1qH0umKF6TFuhQ3+OKqODzpuwWg+UIy9zjDK8o4KfQOlwfLjVfzDWJ1/Q==
X-Received: by 2002:a05:6000:4011:b0:3b9:13e4:9693 with SMTP id ffacd0b85a97d-3c5dcc0c457mr12083434f8f.52.1756232166595;
        Tue, 26 Aug 2025 11:16:06 -0700 (PDT)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7116e1483sm17015900f8f.50.2025.08.26.11.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 11:16:05 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 6A01EBE2DE0; Tue, 26 Aug 2025 20:16:04 +0200 (CEST)
Date: Tue, 26 Aug 2025 20:16:04 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 6.6 028/587] fs: Prevent file descriptor table
 allocations exceeding INT_MAX
Message-ID: <aK355BFz6ErdVI7j@eldamar.lan>
References: <20250826110952.942403671@linuxfoundation.org>
 <20250826110953.666871765@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826110953.666871765@linuxfoundation.org>

Hi Greg,

On Tue, Aug 26, 2025 at 01:02:57PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sasha Levin <sashal@kernel.org>
> 
> commit 04a2c4b4511d186b0fce685da21085a5d4acd370 upstream.
> 
> When sysctl_nr_open is set to a very high value (for example, 1073741816
> as set by systemd), processes attempting to use file descriptors near
> the limit can trigger massive memory allocation attempts that exceed
> INT_MAX, resulting in a WARNING in mm/slub.c:
> 
>   WARNING: CPU: 0 PID: 44 at mm/slub.c:5027 __kvmalloc_node_noprof+0x21a/0x288
> 
> This happens because kvmalloc_array() and kvmalloc() check if the
> requested size exceeds INT_MAX and emit a warning when the allocation is
> not flagged with __GFP_NOWARN.
> 
> Specifically, when nr_open is set to 1073741816 (0x3ffffff8) and a
> process calls dup2(oldfd, 1073741880), the kernel attempts to allocate:
> - File descriptor array: 1073741880 * 8 bytes = 8,589,935,040 bytes
> - Multiple bitmaps: ~400MB
> - Total allocation size: > 8GB (exceeding INT_MAX = 2,147,483,647)
> 
> Reproducer:
> 1. Set /proc/sys/fs/nr_open to 1073741816:
>    # echo 1073741816 > /proc/sys/fs/nr_open
> 
> 2. Run a program that uses a high file descriptor:
>    #include <unistd.h>
>    #include <sys/resource.h>
> 
>    int main() {
>        struct rlimit rlim = {1073741824, 1073741824};
>        setrlimit(RLIMIT_NOFILE, &rlim);
>        dup2(2, 1073741880);  // Triggers the warning
>        return 0;
>    }
> 
> 3. Observe WARNING in dmesg at mm/slub.c:5027
> 
> systemd commit a8b627a introduced automatic bumping of fs.nr_open to the
> maximum possible value. The rationale was that systems with memory
> control groups (memcg) no longer need separate file descriptor limits
> since memory is properly accounted. However, this change overlooked
> that:
> 
> 1. The kernel's allocation functions still enforce INT_MAX as a maximum
>    size regardless of memcg accounting
> 2. Programs and tests that legitimately test file descriptor limits can
>    inadvertently trigger massive allocations
> 3. The resulting allocations (>8GB) are impractical and will always fail
> 
> systemd's algorithm starts with INT_MAX and keeps halving the value
> until the kernel accepts it. On most systems, this results in nr_open
> being set to 1073741816 (0x3ffffff8), which is just under 1GB of file
> descriptors.
> 
> While processes rarely use file descriptors near this limit in normal
> operation, certain selftests (like
> tools/testing/selftests/core/unshare_test.c) and programs that test file
> descriptor limits can trigger this issue.
> 
> Fix this by adding a check in alloc_fdtable() to ensure the requested
> allocation size does not exceed INT_MAX. This causes the operation to
> fail with -EMFILE instead of triggering a kernel warning and avoids the
> impractical >8GB memory allocation request.
> 
> Fixes: 9cfe015aa424 ("get rid of NR_OPEN and introduce a sysctl_nr_open")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Link: https://lore.kernel.org/20250629074021.1038845-1-sashal@kernel.org
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/file.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -126,6 +126,21 @@ static struct fdtable * alloc_fdtable(un
>  	if (unlikely(nr > sysctl_nr_open))
>  		nr = ((sysctl_nr_open - 1) | (BITS_PER_LONG - 1)) + 1;
>  
> +	/*
> +	 * Check if the allocation size would exceed INT_MAX. kvmalloc_array()
> +	 * and kvmalloc() will warn if the allocation size is greater than
> +	 * INT_MAX, as filp_cachep objects are not __GFP_NOWARN.
> +	 *
> +	 * This can happen when sysctl_nr_open is set to a very high value and
> +	 * a process tries to use a file descriptor near that limit. For example,
> +	 * if sysctl_nr_open is set to 1073741816 (0x3ffffff8) - which is what
> +	 * systemd typically sets it to - then trying to use a file descriptor
> +	 * close to that value will require allocating a file descriptor table
> +	 * that exceeds 8GB in size.
> +	 */
> +	if (unlikely(nr > INT_MAX / sizeof(struct file *)))
> +		return ERR_PTR(-EMFILE);
> +
>  	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL_ACCOUNT);
>  	if (!fdt)
>  		goto out;

I see you picked this commit for the current stable series, but TTBOMK
this introduces a regression as it was as well present in 6.12.43:

https://lore.kernel.org/regressions/20250825152725.43133-1-zcgao@amazon.com/

and the current 6.12.44 contains a followup. If I'm not mistaken Sasha
has picked up 1d3b4bec3ce5 ("alloc_fdtable(): change calling
conventions.") to fix that.

So unless I'm wrong, if you pick up 04a2c4b4511d ("fs: Prevent file
descriptor table allocations exceeding INT_MAX"), then as well
1d3b4bec3ce5 ("alloc_fdtable(): change calling conventions.")  is
needed.

Regards,
Salvatore
