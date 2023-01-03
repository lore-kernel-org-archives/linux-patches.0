Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9746120E4
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 10:15:16 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id u28so38311718edd.10
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 02:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dg4Iem/pwcu+hGrCWyFWcE0w0rA2DwqUcHLBcyuPeUc=;
        b=mjSbDBWx33CYMdnRAunBxjnUpsQB8NQEfdMQgMgMOMnsSL2cUgoBYVoV1sYAg2p0Zp
         50bdUMAQBKLBJKw+RQJGTYGVqDzPzYZoE6hNmGb1i5zXPIqLNykLk0p2pGnXFlik/t2C
         grRyHKq4PBadLvD2l5ItwXVsIA7HCKuk/+WfMEbq9F2aNiw017v28VGfTtFG/2AijMda
         veJ+wuzLKcZk3E2ifzeaHUw7UfbUh+7nT4Zs3CJDmhcZ4JEJ4e2YINxHe0YL51HMrGSZ
         OByncrEr9GdapTEhGBNp8zuujYcX/U+gUYtkegXnSM1hjbSRkh4T4NVSekJxNWP8fRt8
         fBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dg4Iem/pwcu+hGrCWyFWcE0w0rA2DwqUcHLBcyuPeUc=;
        b=VLr+O3yysVqmuGRNMhpMz2/n3FDjghHnyALZ5k0Te5zmshg1MXlQpT73Le20zRZcYi
         SnXEIP1k28eoR2wDj6Rzrpo4GsjfE4GPV7B+DFA7Jmio6A8gIeuTdxMEz8uS2VL7BoDt
         FTmg3iggz3Ut1V0ppcQpZYf07CMZo61XC0sVOApy5j4h5dbJnr0AKKedSZxsb3y5O+c5
         tEECUdptYbeF5PHGSKNfJKsjyEQRD1Ks+I04mKKWRUHExXIeT0sgW+hIPFET0n7H3FJv
         l9KFwraxnkNeUjuTZSKrDpcteXLTOM7BDSKJcH1hm+G7LbctE+U9ZJSFG6/Jn9ra35VB
         iTSg==
X-Gm-Message-State: AFqh2koAXBFKmmWAGJNmqglCPRGzPdu5IGMNj5gVIL3flgP8WjPW3C2M
	7FepWFgd2Y/75R17A8IJK7s=
X-Google-Smtp-Source: AMrXdXvGHahoAqytki6ZL5OVZWOTmKsQ+1eCtyz/+vLkr9dsT6hcqNhYr+klb25nfwe/d8ifvVVIMw==
X-Received: by 2002:a05:6402:d5c:b0:461:68e4:15cc with SMTP id ec28-20020a0564020d5c00b0046168e415ccmr34746439edb.9.1672740914735;
        Tue, 03 Jan 2023 02:15:14 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id r7-20020a170906280700b007b27aefc578sm13853448ejc.126.2023.01.03.02.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:15:14 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 3 Jan 2023 11:15:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/kexec: fix double vfree of image->elf_headers
Message-ID: <Y7QAMIu6j6Y6m8vV@gmail.com>
References: <20230102103917.20987-1-vbabka@suse.cz>
 <d6e965ca-a568-5193-20a0-19b1c9b42ca2@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e965ca-a568-5193-20a0-19b1c9b42ca2@suse.cz>


* Vlastimil Babka <vbabka@suse.cz> wrote:

> On 1/2/23 11:39, Vlastimil Babka wrote:
> > An investigation of a "Trying to vfree() nonexistent vm area" bug
> > occurring in arch_kimage_file_post_load_cleanup() doing a
> > vfree(image->elf_headers) in our 5.14-based kernel yielded the following
> > double vfree() scenario, also present in mainline:
> > 
> > SYSCALL_DEFINE5(kexec_file_load)
> >   kimage_file_alloc_init()
> >     kimage_file_prepare_segments()
> >       arch_kexec_kernel_image_probe()
> >         kexec_image_load_default()
> >           kexec_bzImage64_ops.load()
> >             bzImage64_load()
> >               crash_load_segments()
> >                 prepare_elf_headers(image, &kbuf.buffer, &kbuf.bufsz);
> >                 image->elf_headers = kbuf.buffer;
> > 		ret = kexec_add_buffer(&kbuf);
> > 		if (ret) vfree((void *)image->elf_headers); // first vfree()
> >       if (ret) kimage_file_post_load_cleanup()
> >         vfree(image->elf_headers);                          // second vfree()
> > 
> > AFAICS the scenario is possible since v5.19 commit b3e34a47f989
> > ("x86/kexec: fix memory leak of elf header buffer") that was marked for
> > stable and also was backported to our kernel.
> > 
> > Fix the problem by setting the pointer to NULL after the first vfree().
> > Also set elf_headers_sz to 0, as kimage_file_post_load_cleanup() does.
> > 
> > Fixes: b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer")
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Baoquan He <bhe@redhat.com>
> > Cc: Dave Young <dyoung@redhat.com>
> > Cc: <stable@vger.kernel.org>
> 
> Takashi told me he sent a slightly different fix already in November:
> https://lore.kernel.org/all/20221122115122.13937-1-tiwai@suse.de/
> 
> Seems it wasn't picked up? You might pick his then, as Baoquan acked it, and
> it's removing code, not adding it.

Thanks, indeed we missed that fix - Boris picked up that version in 
tip:x86/urgent, via:

   d00dd2f2645d ("x86/kexec: Fix double-free of elf header buffer")

	Ingo
