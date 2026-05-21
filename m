Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0303F6C53
	for <patches@lists.linux.dev>; Thu, 21 May 2026 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370837; cv=none; b=RIuWiQPI3QBLkzRF3YIhxYhnyGB7VqGyC7D0PPjG75JsyoBmo4f0ch1Z5QB5cmjwEXxlACPgkazXYam37St+++NIMZGfnENR1Tz9nMHcwfHhN560eCWTy3Z6hY2mVSXNfNiygN/5D+Zngi3YcOgl7kGzPWKPScmMl8cbFtBoRU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370837; c=relaxed/simple;
	bh=lgt6bZGowrk+/hgFO04EGKXbDtatCeP4h9JOVGEXa8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVv7r+VlPkN0sgIeCVWDDTe7MFgzVsv59R/CYhrjNSgysFYFpYLGPqHWMjks64KSQCAf6Lz2zMzN3OZTc9sebIr9nGH2wplld5CLn1A1eoYhrnGxI8OIKpLlaZn2llRkPpiC6+sT54lWsLXX4gBxr5KFDkJtz4xrt4Jx0wrZqh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/bA2osu; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/bA2osu"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43eb05b1875so3446437f8f.3
        for <patches@lists.linux.dev>; Thu, 21 May 2026 06:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779370833; x=1779975633; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6pliLjQCX38qV7kmxGlug+pl/y15gveH2ePBs5elqDA=;
        b=N/bA2osu+WfOO/ehhcdm+ozt3MY4rkBA+P8CcVYRCDQKSJuAXaTOhBlHeX5riePLbC
         l6wKz/oiaS+Vw7z3z4fonIXkiUBRBFh4zkJMTtbc+21Mfz4pnmJQvv0YfE2Awuh1YDMw
         2gpujIuDWjbpGcDvJWtci+cNQh5x3NZcdOEEhlUlnMm9/ozv7Aqg6IMd7H737RX3n3c7
         X7bQjRbeuEvHJZeu2ZUg+nASrDH3elCeoSexzzfBJpIjGdIJtmRyvWZ2URGcj4szEGCh
         2VscVaNYmJCM/pAkt7C6ECob9feR9djKcAVlEPUp1/WTgc4GPCJHncxw7FI2UFz/uPVD
         VQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779370833; x=1779975633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pliLjQCX38qV7kmxGlug+pl/y15gveH2ePBs5elqDA=;
        b=C4qS2LztppBpQgrwvl3sa3xK6PYkxylCQskUkVfY2f6XqMN+nFpT7Y8pQQOiBH5cef
         PEyczJMl1GyplwVUxZQKdkAnWRjzwbdf8zeXJserpujyeAsRVO4uvTL5hC9JwUK3+ppg
         2ZHFYUdbGqm1Qsp+NhojqyX7+1JZtn37SQYg0vj29kHsiL7dvTreSEVcJ7ROHdgJa51w
         VKKKbT93ACdxdXqJ53yrkKA1u+f1cKhZ4Nc5gYOdCoD+sulsdkWWzmMQDLcZdPu7UcJN
         bTV/xM08z0jyKBDNRUg2SRNPWYM8MCQT15I0uKkp5kTlLUNfshb5Eqft4Upra9cv5N3T
         A0Sg==
X-Forwarded-Encrypted: i=1; AFNElJ/6NMNezSs3fyEWdj04sKa2cjPxBYmBKPr9uv6MDfY2rdB/Cn3CFmqelkzummT7KNbCoLbGzBPQ@lists.linux.dev
X-Gm-Message-State: AOJu0YwF5HRZC7J42TZqw2V96RTHNAMKPE67vv1iINMjumKXAfwS50wF
	C2kPNptlzelTnJ+jy5z72Z2NPA4CYDUv62up3FO3K6Y+bXs0PesNhxT/
X-Gm-Gg: Acq92OGKJ0BX7yuOBQFlWMvy9YsV3C67uFEan/h+u/T7sZykurgNOU5ZMz94WWw71t+
	/PTX4CrrCdMfFqIL+riYlMAE631uHQGtyDHQBDfL1lrE7dZxgWf/acgy3ZQWK8boPoKC92UNeuI
	8paWsQKMYvprwB2K6BKdSykvaJmsXNF9xRXdfu4z9YXuIWwSal0Eb9A974VCcfOJDktvXEAn2cv
	x3s2R+ZnBLczUGzFTytgm79cjCGUex6wJCX3qdfe5RMAwf4OLhxwbZ7PxS7/NGWd5tEKF8Mrigs
	whKEJ+a5g3X3lJD/z/ecH0ap4E3swpRouNlqakTQq5Yzc1vQSOcgbvDijL2UI/adTxyP1UnT+oZ
	29GAbfnNr/6IvVALL4QXxxzt5stuhgPfq2yvQjA6FyVnIGOTccjIKYGUtJ3tT0i4OsgyseVJ/J4
	JVtjsWTe6MKT1wBx+R/mP/X2KvrUMEH/yWlOVmwzMbr5shoV9RoloaMBDQ3MImBhmWvuMHY3/Qj
	e66Akci+2LP1EDEvcrDhvOf2YViPGuzxtVIYCsEOEeQyYPNS3U8RtVJAVcsLkHxcScBoRD/TQVq
	z/vR2DsSjp8QYLheY5TT9skC92bxFyOtn8z2ho+T8vxkJ/mCraV1
X-Received: by 2002:a05:6000:4027:b0:45b:d891:4ef1 with SMTP id ffacd0b85a97d-45ea3beccb2mr4601148f8f.34.1779370833098;
        Thu, 21 May 2026 06:40:33 -0700 (PDT)
Received: from mail.gmail.com (2a01cb0889497e00f2ad02214c8b26a8.ipv6.abo.wanadoo.fr. [2a01:cb08:8949:7e00:f2ad:221:4c8b:26a8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eaa7cd815sm4355733f8f.6.2026.05.21.06.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:40:32 -0700 (PDT)
Date: Thu, 21 May 2026 15:40:30 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Jon Hunter <jonathanh@nvidia.com>, Chen Yu <yu.c.chen@intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: Re: [PATCH 6.18 046/957] sched/topology: Fix sched_domain_span()
Message-ID: <ag8LTnOjVcrKlUs0@mail.gmail.com>
References: <20260520162134.554764788@linuxfoundation.org>
 <20260520162135.557884097@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520162135.557884097@linuxfoundation.org>

On Wed, May 20, 2026 at 06:08:49PM +0200, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.

No objection, but commit aacee214d5763 ("selftests/bpf: Remove
test_access_variable_array") will also need to be backported or the BPF
selftests fail with:

  progs/test_access_variable_array.c:14:13: error: no member named 'span' in 'struct sched_domain'
    CLNG-BPF [test_progs] test_check_mtu.bpf.o
     14 |         span = sd->span[0];
        |                ~~  ^

> 
> ------------------
> 
> From: Peter Zijlstra <peterz@infradead.org>
> 
> [ Upstream commit e379dce8af11d8d6040b4348316a499bfd174bfb ]
> 
> Commit 8e8e23dea43e ("sched/topology: Compute sd_weight considering
> cpuset partitions") ends up relying on the fact that structure
> initialization should not touch the flexible array.
> 
> However, the official GCC specification for "Arrays of Length Zero"
> [*] says:
> 
>   Although the size of a zero-length array is zero, an array member of
>   this kind may increase the size of the enclosing type as a result of
>   tail padding.
> 
> Additionally, structure initialization will zero tail padding. With
> the end result that since offsetof(*type, member) < sizeof(*type),
> array initialization will clobber the flex array.
> 
> Luckily, the way flexible array sizes are calculated is:
> 
>   sizeof(*type) + count * sizeof(*type->member)
> 
> This means we have the complete size of the flex array *outside* of
> sizeof(*type), so use that instead of relying on the broken flex array
> definition.
> 
> [*] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> 
> Fixes: 8e8e23dea43e ("sched/topology: Compute sd_weight considering cpuset partitions")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Debugged-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://patch.msgid.link/20260323093627.GY3738010@noisy.programming.kicks-ass.net
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/sched/topology.h | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
> index 45c0022b91ced..6f8a4ae860da8 100644
> --- a/include/linux/sched/topology.h
> +++ b/include/linux/sched/topology.h
> @@ -141,18 +141,30 @@ struct sched_domain {
>  
>  	unsigned int span_weight;
>  	/*
> -	 * Span of all CPUs in this domain.
> +	 * See sched_domain_span(), on why flex arrays are broken.
>  	 *
> -	 * NOTE: this field is variable length. (Allocated dynamically
> -	 * by attaching extra space to the end of the structure,
> -	 * depending on how many CPUs the kernel has booted up with)
> -	 */
>  	unsigned long span[];
> +	 */
>  };
>  
>  static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
>  {
> -	return to_cpumask(sd->span);
> +	/*
> +	 * Turns out that C flexible arrays are fundamentally broken since it
> +	 * is allowed for offsetof(*sd, span) < sizeof(*sd), this means that
> +	 * structure initialzation *sd = { ... }; which writes every byte
> +	 * inside sizeof(*type), will over-write the start of the flexible
> +	 * array.
> +	 *
> +	 * Luckily, the way we allocate sched_domain is by:
> +	 *
> +	 *   sizeof(*sd) + cpumask_size()
> +	 *
> +	 * this means that we have sufficient space for the whole flex array
> +	 * *outside* of sizeof(*sd). So use that, and avoid using sd->span.
> +	 */
> +	unsigned long *bitmap = (void *)sd + sizeof(*sd);
> +	return to_cpumask(bitmap);
>  }
>  
>  extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> -- 
> 2.53.0
> 
> 
> 
