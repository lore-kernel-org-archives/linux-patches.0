Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327BC23A5
	for <patches@lists.linux.dev>; Tue, 12 Jul 2022 12:32:33 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id v16so10929463wrd.13
        for <patches@lists.linux.dev>; Tue, 12 Jul 2022 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TzUu9/4eWAwyfJe5s1t0yONoD27sPS3zCjo2PMaad0c=;
        b=LyQMDbQIrV+g+jI+he7uBZBC8jr7Ejlx42tIA5H19ff7Cs3u1PgxgOYerIu0INB/Fe
         8SP+5323SDOc+X4kWcatVLXLL5X3WSrCuZMPPQKgmXCUh+9dfKoX9oWySx01EHqlL+cN
         vFUklcbidni9y+6s8b8ioIyqgmal8WGQwIA1SKgfpIsBO3dW4E+1M2Na2Yx6ol6A7Xph
         Lx97rRsHVJSqby6EvsW8UdfjrAKKkgO9YIpnzlrpXJ+uH79BtO5kvNdPZfxat7++ci75
         fkglTu3cSKftH0aVJngnI+3ARNFQYO164aDY7r0ZOe5+h+o5fjiUg5nMFvzebX420vGh
         n6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TzUu9/4eWAwyfJe5s1t0yONoD27sPS3zCjo2PMaad0c=;
        b=PxInnhQknv/w8SFPm7P5V2IHRFJ/GgwUNLH9Gb8X8BQmhVrgs9+55eP7BW7LpYWmME
         +7k7wjMK790/IcWkX7G6p9/1UG5NfSXcIhEdgbD0F8gqGWkRFMekBXTzqWEmaX9WFn2i
         n6eya7v0jbuEEc35IrjNzyIrm9KK7FgTY0n3i28UmYGhJH+ajzAh8NOTBErLFaSs1edz
         FOHF+vMgojtWT91ffz6YzF795Jvzd9Af5t+6kZsQhPgqCHQOdUAEoN2q/5Gl4QZBSJYS
         jbQ7zQfuGBXR1wBNXBTDNrES3riq2Mv86tpfIOvnoe4k+9dTuLB7riWKMEYlt5JTtNhI
         BPSA==
X-Gm-Message-State: AJIora99o0fTO/NsrcbioljUOgkb7Rp0FLXrPgUV4Uo/ArJmeztzGn1Z
	s8poC2FexVfiWwyFKUwPCA==
X-Google-Smtp-Source: AGRyM1vPyd9kChm4NWTNjC+LgqsInZeFZuvuIaKw76waFGmVV3iqtOb7KXtJ3wy6IWxSpZ9sT/Cy0w==
X-Received: by 2002:a05:6000:1688:b0:21d:7b36:926a with SMTP id y8-20020a056000168800b0021d7b36926amr21039555wrd.303.1657629151257;
        Tue, 12 Jul 2022 05:32:31 -0700 (PDT)
Received: from localhost.localdomain ([46.53.253.195])
        by smtp.gmail.com with ESMTPSA id q5-20020adf9dc5000000b0021d928d2388sm8186310wre.85.2022.07.12.05.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:32:30 -0700 (PDT)
Date: Tue, 12 Jul 2022 15:32:27 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Hemment <markhemm@googlemail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH -final] x86/clear_user: Make it faster
Message-ID: <Ys1p27uWqjWlcaa1@localhost.localdomain>
References: <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
 <YrMlVBoDxB21l/kD@zn.tnic>
 <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
 <YrN4DdR9HN0srNWe@zn.tnic>
 <CAHk-=wj_MeMUnKyRDuQTiU1OmQ=gfZVZhcD=G7Uma=1gkKkzxg@mail.gmail.com>
 <YrQ1PPB77PBWyaHs@zn.tnic>
 <YsRuUl24zkhpE3s/@zn.tnic>
 <YsVUvK/zQaIW749P@localhost.localdomain>
 <Ysv8cAa7wcDmQlpm@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ysv8cAa7wcDmQlpm@zn.tnic>

On Mon, Jul 11, 2022 at 12:33:20PM +0200, Borislav Petkov wrote:
> On Wed, Jul 06, 2022 at 12:24:12PM +0300, Alexey Dobriyan wrote:
> > On Tue, Jul 05, 2022 at 07:01:06PM +0200, Borislav Petkov wrote:
> > 
> > > +	asm volatile(
> > > +		"1:\n\t"
> > > +		ALTERNATIVE_3("rep stosb",
> > > +			      "call clear_user_erms",	  ALT_NOT(X86_FEATURE_FSRM),
> > > +			      "call clear_user_rep_good", ALT_NOT(X86_FEATURE_ERMS),
> > > +			      "call clear_user_original", ALT_NOT(X86_FEATURE_REP_GOOD))
> > > +		"2:\n"
> > > +	       _ASM_EXTABLE_UA(1b, 2b)
> > > +	       : "+&c" (size), "+&D" (addr), ASM_CALL_CONSTRAINT
> > > +	       : "a" (0)
> > > +		/* rep_good clobbers %rdx */
> > > +	       : "rdx");
> > 
> > "+c" and "+D" should be enough for 1 instruction assembly?
> 
> I'm looking at
> 
>   e0a96129db57 ("x86: use early clobbers in usercopy*.c")
> 
> which introduced the early clobbers and I'm thinking we want them
> because "this operand is an earlyclobber operand, which is written
> before the instruction is finished using the input operands" and we have
> exception handling.
> 
> But maybe you need to be more verbose as to what you mean exactly...

This is the original code:

-#define __do_strncpy_from_user(dst,src,count,res)                         \
-do {                                                                      \
-       long __d0, __d1, __d2;                                             \
-       might_fault();                                                     \
-       __asm__ __volatile__(                                              \
-               "       testq %1,%1\n"                                     \
-               "       jz 2f\n"                                           \
-               "0:     lodsb\n"                                           \
-               "       stosb\n"                                           \
-               "       testb %%al,%%al\n"                                 \
-               "       jz 1f\n"                                           \
-               "       decq %1\n"                                         \
-               "       jnz 0b\n"                                          \
-               "1:     subq %1,%0\n"                                      \
-               "2:\n"                                                     \
-               ".section .fixup,\"ax\"\n"                                 \
-               "3:     movq %5,%0\n"                                      \
-               "       jmp 2b\n"                                          \
-               ".previous\n"                                              \
-               _ASM_EXTABLE(0b,3b)                                        \
-               : "=&r"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),    \
-                 "=&D" (__d2)                                             \
-               : "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
-               : "memory");                                               \
-} while (0)

I meant to say that earlyclobber is necessary only because the asm body
is more than 1 instruction so there is possibility of writing to some
outputs before all inputs are consumed.

If asm body is 1 insn there is no such possibility at all.
Now "rep stosb" is 1 instruction and two alterantive functions masquarade
as single instruction.
