Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719EC3F0ABD
	for <patches@lists.linux.dev>; Fri, 29 May 2026 21:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780091089; cv=none; b=GZa0STd2AO1FBOQFthRKqnArXiaFLTfLiqJBZ9tXM5BQT+uJJZjtkZ6OClk+eWLnKTRiu+/RJRqVngqYwm9PPKjWPrgMV4YjvU0XPk2FQ8hTiv/+nEe/Xm8HOtHLXTYhBsHDzSFv0uPqBBCc7VLwSyAspvRI7tS10a9uYx4Ai1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780091089; c=relaxed/simple;
	bh=9ztBHi69dTvfIbkPqcEl1msz3Fn7k9rrFW2VNPhV/B0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5PH/5oYH6QwDesNFY3peka2z2S/Fz7xRFAsSlZOf2xalATMEJ1s5i0xgG4HiGwQrq8Ej7BRtA7T1fZQ/V4NgSu2BNajbcPoyEflW/LORPJguPcO6FXwvX76cKwwjaCNAK8Jrx55X9ct0X3KABd7wRAX7YZaSs1WB++uNhb+M8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTGPVMAT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTGPVMAT"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48d146705b4so151410595e9.3
        for <patches@lists.linux.dev>; Fri, 29 May 2026 14:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780091085; x=1780695885; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wclCqKMzu4g1WLNsGWFcKOde7ruW79bP7ckJPFHNnw4=;
        b=KTGPVMATV7d/An7WBYok8xaKOX3ywAmLXHsy/DyIlbqEMXOPicPd2yzGdAE/BfO31H
         X9C96y1mrHFydmXCzEIAnoVEBTCcwN/U9WYJH2ZLPTGbDmq7++NEEKvmYq1IBoK8r5EH
         nsq8p4IcXTXmh/OTjJxkHw6qBcjbPnaofK9uaOARBQkSSMaBgPSoDIRs+G4OvSUG2VD5
         x8LtBhAw67KQ8o+hTmZlrNaKiehJ2QqgWh4X9whnNIKtT/4crL9UJg72q8luhHA36I2Z
         paYhuSNY3Yia+s1qx+TeDZFON0zAG8IWf3v+AN8rwIPPpkEeQTb7r+IdwY2BaoA/Y/IV
         RJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780091085; x=1780695885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wclCqKMzu4g1WLNsGWFcKOde7ruW79bP7ckJPFHNnw4=;
        b=HgtBg9/RttZxPPJNj18he/teCok9zltxZop9wxF0hckCIrLBQb4iJBT8jdHCDEP8xy
         GRgKvuwQ7z6gy9jDuvWQZHMPeyZ8xdkZkGx0Rkg1OzTsNcAy5PB4T0zsdLlyN6r7/Zr4
         s0Mw3fgjWgIPNM0f1kMoxr2kNAO9KhHKUACzXsuJiQgltNiDzeAltDfLxjLlnzQYbi3Q
         IsNF0anz6MM57VoBSHlkQtMhaIZF1SyM81BTeHENWNqKikcblxxujsyWPbJyc4vlcYvi
         SBwAUwM6XmMz4mlFNUjX5eBEgz0vVx+msTN7+9O4aa7BVcCYxXlErO1RAm7VnMg6HlMW
         NjaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8cXBmKKynIMWLNX6MfMtIDckf5/Noe17m2Qf40OR+fiRxSePvofW6F6U0XLOKTvYc+RCRBwWg0@lists.linux.dev
X-Gm-Message-State: AOJu0Yxfe0TegxrdJezrrqPNZBejo/zMsU07nMgyER4WSz4eq49IjowA
	GCLHXKh+o3aO4QQ3IOM+Vh4CbU7VgrscjMHYcJ36l7wUz+JGcx0E0Ead
X-Gm-Gg: Acq92OEOYcwtU0hdxuNTxiRDiTItFqnFJ4xTd10jo5gmKFBe6KCA5Nx4mgfOoqrlkfQ
	T3Yb0zuEwH7Cg5ZJkkk6j/8h3wJIcSirpBaZ2z+5iSJto+WDopp/4+ADB7J8nZ3aZZIO/ctwHGb
	BNCyx/le7Fd56j2AeR9eP+v8expW8WySstGdo4iygLGmxbkdcE+cvrawFTzekK1/QhsCnhgoE9d
	gkN02KrPVzc1VbYXJ8KKoCY6Ks5/HMcEtUmEH+qafo9IUFrLvxzraJcwWNtpMCU4krYrWn72IlZ
	5vhI9ok5ffRhaCLGyyzw3a1FRzPOHEPI4WhptDNA105oLSUiZa3zuhKkz9Axzo+WwWip7FSm8Vq
	/gj8oFKMp8+u5ZJz6MfKfcYn3Gu+NSSc7gtCMge9hLKpV9RqMyrpJmoGLxvkcPtK/X4iUkL/zQ9
	5njLAVn4hgz/PMsF/hGO/rZJ85E1JPo7CSaQM6O618l3+Vjvv7HscgaCt0CXZHiOu1BPqtNItUO
	IiKDitWKw==
X-Received: by 2002:a05:600c:41c7:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-490a293e0c2mr13857975e9.21.1780091084768;
        Fri, 29 May 2026 14:44:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c0aecdfsm22172265e9.13.2026.05.29.14.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 14:44:44 -0700 (PDT)
Date: Fri, 29 May 2026 22:44:42 +0100
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
Message-ID: <20260529224442.11d7320d@pumpkin>
In-Reply-To: <20260529192933.GD3195266@nvidia.com>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
	<6-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
	<ahiFxtmspbETiqWw@google.com>
	<20260529134947.GA128816@nvidia.com>
	<20260529175516.06d5788f@pumpkin>
	<20260529192933.GD3195266@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 May 2026 16:29:34 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, May 29, 2026 at 05:55:16PM +0100, David Laight wrote:
> > On Fri, 29 May 2026 10:49:47 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Thu, May 28, 2026 at 06:13:26PM +0000, David Matlack wrote:
> > >   
> > > > Let's put these in tools/arch/arm64/include/asm/io.h so that the tools
> > > > headers are more aligned with the kernel headers, and so that the arm64
> > > > io.h overrides are done in the same way as the x86 overrides in
> > > > tools/arch/x86/include/asm/io.h.
> > > > 
> > > > Something like this (untested):    
> > > 
> > > Okay, the disassembly says it works:
> > > 
> > >     1db8:       ca080108        eor     x8, x8, x8
> > >     1dbc:       b5000008        cbnz    x8, 1dbc <readl+0x58>
> > >     1dc0:       f9000fe8        str     x8, [sp, #24]  
> > 
> > That looks strange, I suspect the C didn't match any usual pattern.
> > Normally 'tmp' would get thrown away and 'v' would get kept.
> > But you seem to have discarded 'v' and written 'tmp' to stack.  
> 
> Oh interesting the optimizer isn't turned on for selftest builds. So
> the str is dutifully writing tmp to the stack. Another register has
> the actual value.

I've never seen any point testing with compilation options that are
different from those used in a final/release build.
Otherwise you aren't testing what you are going to release.
This is particularly true for badly written code that might be
relying on uninitialised stack (etc).

> 
> > I'm probably being stupid again, but how does that work?
> > The cpu can speculate straight through the control dependency into
> > the following instructions.
> > An 'eor x1, x8, x8' may not even have a data-dependency on x8.
> > (Most x86 cpus just generate a zero for the equivalent instruction.)  
> 
> I can't say, this is copied from the kernel and Will made it:
> 
>     arm64: io: Ensure calls to delay routines are ordered against prior readX()
>     
>     A relatively standard idiom for ensuring that a pair of MMIO writes to a
>     device arrive at that device with a specified minimum delay between them
>     is as follows:
>     
>             writel_relaxed(42, dev_base + CTL1);
>             readl(dev_base + CTL1);
>             udelay(10);
>             writel_relaxed(42, dev_base + CTL2);
>     
>     the intention being that the read-back from the device will push the
>     prior write to CTL1, and the udelay will hold up the write to CTL1 until
>     at least 10us have elapsed.
>     
>     Unfortunately, on arm64 where the underlying delay loop is implemented
>     as a read of the architected counter, the CPU does not guarantee
>     ordering from the readl() to the delay loop and therefore the delay loop
>     could in theory be speculated and not provide the desired interval
>     between the two writes.
>     
>     Fix this in a similar manner to PowerPC by introducing a dummy control
>     dependency on the output of readX() which, combined with the ISB in the
>     read of the architected counter, guarantees that a subsequent delay loop
>     can not be executed until the readX() has returned its result.

Hmmm...

Ok so there is some subtlety with the read of the counter that might
make it all work.

It is better to make the delay loop have a data dependency on the result
of the readl().
Something like:
	u32 z = 0;
	OPTIMIZER_HIDE_VAR(z);
	writel_relaxed(42, dev_base + CTL1);
	udelay(10 + (z & readl(dev_base + CTL1)));
	writel_relaxed(42, dev_base + CTL2);
That avoids the potentially mispredicted branch and only adds instructions
when a delay follows.
That sequence is safe for all cpu and doesn't cost much for cpu (like x86)
where it (probably) isn't needed (maybe unless you patch the scale for udelay
into the code so there are no memory reads, just code).

Probably best refactored as udelay_depends(10, readl(dev_base + CTL1)).
Or maybe udelay_after().

-- David

>     
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Cc: Arnd Bergmann <arnd@arndb.de>
>     Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Jason

