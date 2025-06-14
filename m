Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2101C8601
	for <patches@lists.linux.dev>; Sat, 14 Jun 2025 04:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749875407; cv=none; b=ClDLyMVvys+/ELVWEI/ZpL1O7942R1zUa14vfweEXjUgEZkiWOBSweq1f3yNmbYlK48Gil5H+gvYTWFxB0iiCiXkul+qNpPMr8MT96AdJDO+uonuYq5pbVTn8zYTpz+kUT/SsI5/OH3J+bTwwt5ME3i+BjcBGb4lYPouybIJkrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749875407; c=relaxed/simple;
	bh=XNGM7hbzMffKhpfxMTQ3F/J1yS9Q30hS8zYBljaE3r4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6Ypi5gMmgkqD5oEsYXOviJbCKa1BKEwmOULxGs9cO4Kv1MAksWFPwHLxWQMaYoCfSfBeQrogQeG7x3Ci07LEBUPC7Wnpd4JnaXnkguDWLQYzPqIhtmo6Tf28e7lwpPQjKlp4WHcIiTOjmjS4aqG9T86G34zsm/m7Uaow4ZuVhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QzvSjfPs; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QzvSjfPs"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3a365a6804eso1840063f8f.3
        for <patches@lists.linux.dev>; Fri, 13 Jun 2025 21:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1749875404; x=1750480204; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3UyMkex9gWKrcutLitVneuFUOREOl7zIrZSd0dvQp3g=;
        b=QzvSjfPsWwekPLD2ZkfTGOR9AXCpQaxEpgDhWgE3mbJBgAdEPIdYCW8Lb4qIG5ejjy
         oTUiKhvrQAHrok2+DQUxbAKucs2Gyp45EmRhvyyE+K2Ra5txJG7yP189LVCPz1GEdGUg
         Llfl0X4LGWzqLQECkBMYzPkt08wrD5z/X3zy63q3DiBXSRj+7M6xyO97e1Ths938aEuP
         dae/uS0qKI0diny4uAhBHzBX4d37bK/kfN9e4AW1vUT1P1IGr0MdJlKYZBObKrbzcJ7D
         q4lhDOK++oCb8n8SzAi1IYIw0DF+PpZteIndCyLkz00K+MJAQz3RB6MC74iqESofxVqR
         sR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749875404; x=1750480204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UyMkex9gWKrcutLitVneuFUOREOl7zIrZSd0dvQp3g=;
        b=RDHht/UXkJYMNd5bG7TR5F5Z1qZd2FS55QwjVOHAIEvtB2R7L+AvSVrrPBXxmblCsr
         oStN0oaDxWIUq4nN8bzZR5P/mRn4K5+EFRJesTSqAIC0sYTSjKJFMyvF3cPJTNoZ6H3k
         np4EZmhudSdFFte/fkBDA2Bj32zHCpoNFrI/G/ygrsT/HBcbh0a43Nec8r25brhUywP+
         yl6JBu+MxJRNBqAtl2zczUtkyueP7HrZihdtYNTdRbJniCPp9+e7j6ZCiwsF7sM6gCr9
         tEzDca5rBEymrQZDPgL1hXQ3H9qy5zk52QsXHEbOLbhE6WBSZPj/XyCKkilvQO4qEqZL
         vo/g==
X-Gm-Message-State: AOJu0Yyl2ToDN9IwDnBpAbsHG3yuhLB/0Mgu7imNRoChYy/0FsiB/S+X
	8zBV+y6RA0c5I/9s8YXxqsPP5xpTLUvBaHZ8YEUb6sunRacL1mrw9oWZ7A7h8RL+m+4=
X-Gm-Gg: ASbGncuvYv04p1rRyyYGxwMhXUE/2Jyo6HQZ6mje7GTBHPBneoNPR1+X9kJ5fogCCRy
	cd2FWnnisS9L+bd/yQ4PNh4WCYPiEksjjcJyiBbtHbQoxK4KLDab+AkuCt/6J7yGquWXhdXMceP
	hdvJzWXf3CBMTgz3VKMa+A6fBD5CK6iPYsgz6Jie7xoo0Uzd9UodQqs+pVb0/HYh+Rs3tpm6+tp
	O8cCCbPiNVp9CvnJ5QbS9cAjTsN9YNjWE/m8kYtmunwKvsvFyCTwEp3a4rOTWjGk7G5UOKmX2nU
	k+tjSk7tQIdnUSwERxs7rHM+/83XxSQWQhrIgOx1dtH94gwO4ReV/WcC
X-Google-Smtp-Source: AGHT+IEMTpDP3L2lj4VyrQ5EbeDIvTfzZ44zSGT6lzrokTIqEWCgQGUu8OSQ5ScRV3QFtV3wZkj1fA==
X-Received: by 2002:a05:6000:240e:b0:3a5:2875:f986 with SMTP id ffacd0b85a97d-3a572874a1cmr2022636f8f.44.1749875403734;
        Fri, 13 Jun 2025 21:30:03 -0700 (PDT)
Received: from u94a ([2401:e180:8d23:7dd3:95f2:880a:1c89:3ec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365deb887csm22950965ad.192.2025.06.13.21.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 21:30:03 -0700 (PDT)
Date: Sat, 14 Jun 2025 12:29:53 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Martin KaFai Lau <martin.lau@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, daniel@iogearbox.net, 
	andrii@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.15 068/118] bpf: Add
 bpf_rbtree_{root,left,right} kfunc
Message-ID: <avgg2fdgpdm4mwb375zwnqjvtgugwtgw73a2zkx5ybmvvixifo@mlhxcnm4y7ac>
References: <20250604005049.4147522-1-sashal@kernel.org>
 <20250604005049.4147522-68-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604005049.4147522-68-sashal@kernel.org>

On Tue, Jun 03, 2025 at 08:49:59PM -0400, Sasha Levin wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> [ Upstream commit 9e3e66c553f705de51707c7ddc7f35ce159a8ef1 ]
> 
> In a bpf fq implementation that is much closer to the kernel fq,
> it will need to traverse the rbtree:
> https://lore.kernel.org/bpf/20250418224652.105998-13-martin.lau@linux.dev/
> 
...
> 
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> Link: https://lore.kernel.org/r/20250506015857.817950-4-martin.lau@linux.dev
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> NO This commit should not be backported to stable kernel trees. Here's
> my extensive analysis: ## Primary Reason: New Feature Addition This
> commit adds three new kfunc functions (`bpf_rbtree_root`,
> `bpf_rbtree_left`, `bpf_rbtree_right`) to the BPF rbtree API. These are
> entirely new capabilities that enable rbtree traversal functionality
> that did not exist before. ## Specific Code Analysis ### 1. New Function
> Implementations ```c __bpf_kfunc struct bpf_rb_node
> *bpf_rbtree_root(struct bpf_rb_root *root) { struct rb_root_cached *r =
> (struct rb_root_cached *)root; return (struct bpf_rb_node
> *)r->rb_root.rb_node; } __bpf_kfunc struct bpf_rb_node
> *bpf_rbtree_left(struct bpf_rb_root *root, struct bpf_rb_node *node) {
> struct bpf_rb_node_kern *node_internal = (struct bpf_rb_node_kern
> *)node; if (READ_ONCE(node_internal->owner) != root) return NULL; return
> (struct bpf_rb_node *)node_internal->rb_node.rb_left; } __bpf_kfunc
> struct bpf_rb_node *bpf_rbtree_right(struct bpf_rb_root *root, struct
> bpf_rb_node *node) { struct bpf_rb_node_kern *node_internal = (struct
> bpf_rb_node_kern *)node; if (READ_ONCE(node_internal->owner) != root)
> return NULL; return (struct bpf_rb_node
> *)node_internal->rb_node.rb_right; } ``` These are completely new
> functions that extend the BPF API surface, which is characteristic of
> feature additions rather than bug fixes. ### 2. Verifier Infrastructure
> Expansion The commit adds these new functions to multiple verifier
> tables: ```c enum special_kfunc_type { // ... existing entries ...
> KF_bpf_rbtree_root, KF_bpf_rbtree_left, KF_bpf_rbtree_right, // ... }
> BTF_SET_START(special_kfunc_set) // ... existing entries ...
> BTF_ID(func, bpf_rbtree_root) BTF_ID(func, bpf_rbtree_left) BTF_ID(func,
> bpf_rbtree_right) BTF_SET_END(special_kfunc_set) ``` This systematic
> addition to verifier infrastructure demonstrates this is an API
> expansion, not a fix. ### 3. Enhanced Function Classification Logic ```c
> static bool is_bpf_rbtree_api_kfunc(u32 btf_id) { return btf_id ==
> special_kfunc_list[KF_bpf_rbtree_add_impl] || btf_id ==
> special_kfunc_list[KF_bpf_rbtree_remove] || btf_id ==
> special_kfunc_list[KF_bpf_rbtree_first] || + btf_id ==
> special_kfunc_list[KF_bpf_rbtree_root] || + btf_id ==
> special_kfunc_list[KF_bpf_rbtree_left] || + btf_id ==
> special_kfunc_list[KF_bpf_rbtree_right]; } ``` The functions are being
> added to existing classification systems, expanding the API scope. ###
> 4. New Argument Validation Logic ```c static bool
> check_kfunc_is_graph_node_api(struct bpf_verifier_env *env, enum
> btf_field_type node_field_type, u32 kfunc_btf_id) { // ... existing
> logic ... case BPF_RB_NODE: ret = (kfunc_btf_id ==
> special_kfunc_list[KF_bpf_rbtree_remove] || kfunc_btf_id ==
> special_kfunc_list[KF_bpf_rbtree_add_impl] || + kfunc_btf_id ==
> special_kfunc_list[KF_bpf_rbtree_left] || + kfunc_btf_id ==
> special_kfunc_list[KF_bpf_rbtree_right]); break; } ``` This adds new
> argument validation paths for the new functions. ## Comparison with
> Similar Commits Looking at the historical examples: - **Similar Commit
> #1 (YES)**: Added basic rbtree kfuncs - this was part of the
> foundational rbtree infrastructure - **Similar Commit #2 (YES)**: Added
> argument support for rbtree types - essential for the basic
> functionality - **Similar Commit #3 (NO)**: Added function declarations
> to test headers - clearly test infrastructure - **Similar Commit #4
> (NO)**: Added special verifier handling - complex new feature logic -
> **Similar Commit #5 (YES)**: Added basic BTF support for rbtree types -
> foundational infrastructure ## Use Case Analysis The commit message
> describes a complex use case for implementing a Fair Queuing (FQ)
> algorithm that requires traversal capabilities. This is clearly an
> advanced feature for specialized networking applications, not a bug fix
> for existing functionality. ## Risk Assessment Adding new kfuncs carries
> several risks: 1. **API Stability**: New functions become part of the
> stable ABI 2. **Complexity**: Introduces new code paths in verifier
> logic 3. **Testing**: New functionality may not have complete test
> coverage in stable kernels 4. **Dependencies**: May rely on other recent
> changes not present in stable trees ## Conclusion This commit represents
> a clear feature addition that extends the BPF rbtree API with new
> traversal capabilities. ...

Hi Sasha,

Any reason this patch is included despite your tooling suggest _not_
taking the patch into stable?

> It does not fix any existing bugs or address
> critical issues. The functionality is designed for advanced use cases
> and represents an expansion of the BPF programming model rather than
> maintenance of existing capabilities. Following stable tree guidelines,
> this should remain in mainline development kernels and not be backported
> to stable releases.

I don't see a Stable-dep-of tag, so it seem more likely that this patch
was accidentally selected.

Also could you have the tooling's decision log better formatted? In it's
current form it cannot be easily read. 

Thanks,
Shung-Hsi Yu

>  kernel/bpf/helpers.c  | 30 ++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 22 ++++++++++++++++++----
>  2 files changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index a71aa4cb85fae..6a55198c2d9ad 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -2367,6 +2367,33 @@ __bpf_kfunc struct bpf_rb_node *bpf_rbtree_first(struct bpf_rb_root *root)
>  	return (struct bpf_rb_node *)rb_first_cached(r);
>  }
>  
> +__bpf_kfunc struct bpf_rb_node *bpf_rbtree_root(struct bpf_rb_root *root)
> +{
> +	struct rb_root_cached *r = (struct rb_root_cached *)root;
> +
> +	return (struct bpf_rb_node *)r->rb_root.rb_node;
> +}
> +
...
