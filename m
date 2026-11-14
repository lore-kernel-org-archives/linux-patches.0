Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616764;
	b=g7VUeshkb8UwwQkVGR7SN6I4+KT5CL2r6LxUYnsVpI+znkBkiOlGvytI7knIQ/YggOSX
	 WUcuTPwygm6+QaPIQOtM3K20dIo0NWZ5IeybAIUnzJ44Mdulnh18sw/BJigTtMsZY+Eip
	 FHTQ/jtM1w+XcryOozrPVeD8yHVSnQTWJJkSonRNoXELUl9Yi1nv2Hsph2tCKp6r0JgT4
	 RpEUO09rA3AtIoEWSAMxyi5T2wLUneEQZVKiZZe/qvPuAvsQwxHG1uCMJNj80E7ONES8J
	 ahop3/zXQ/dUDJhZ+kL48cIwODaT/FY3WbXaX5pSbGoHuWstF+42kwk1VQys+CpqlNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TR03HYANH3JxjEWewr/Ab8mbFLXagZ4CIuGxSt6TVjM=;
	b=sp8PjIElOfSyTZzNo6Gsi0lrvVqFx2+xw+rj/aprPZXT1G5igiGsGk6pExYydF3Fge2D
	 /trwE8D9VgD2GVqIctQwDDrSRLnDqtBAed4DPt52BjXKCYDFsgkyIYZTJHdTafnN8TUXN
	 PTyMcMxjBrbeoy9+NpPI9Hy12ItKl6srPvNnvpuKzJE58J/SMo82fMk/yNeMzqJcwFk1f
	 8dmSJBCACsE+8K4s1Fuus3atfATG2q4o/l32vDPlHP9M3gkDfDR0XZXAep+lE5cJboyTv
	 H4oeRTxaoK1GmLzMfAb3WzR3FaXQtTCN700u6GgP4MW3RIqXBjZvknKXOaYwLJoIX2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZXJ2vJR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28489606A329;
	Sat, 14 Nov 2026 00:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZXJ2vJR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0B51F000C4;
	Sat, 14 Nov 2026 00:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794616763;
	bh=TR03HYANH3JxjEWewr/Ab8mbFLXagZ4CIuGxSt6TVjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZXJ2vJRLbnEG/8DsfpS1WuvlhpDqKP5Ad7yHWSwzESZK0n3LldVDoj2CztwVoCBh
	 WTyP444vnzXJIHBKOWers+5ZvvFHF0FcSQqh1ztHVQEnRDIYzGQ7Fsld0tRoOkG+md
	 qMjOIFLT9TK9QF3l3iksNJzcJp1Vcv7aCWz13sEtAz2rq6sqNqdCrHH4YAPoOQDDX/
	 V/liyDsiVNmhpiNwMmSQjiHF+gNZ+/mPG2yZwcEyUbOYevaxMdRiUuSG15wINfKhFc
	 KcK+hIAcFVniTfpSyuSxGJFzfwl9hM1tMKtU8cX6G7+1T7DKRhIXJEwi0gI0gCSYQN
	 8uBXHdzKeJP3A==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: 4ncienth@gmail.com,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	corbet@lwn.net,
	david@kernel.org,
	jannh@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	sashal@kernel.org,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Sat, 14 Nov 2026 01:39:12 +0100
Message-ID: <20261114003912.82206-1-ojeda@kernel.org>
In-Reply-To: <20261113153812.408825269@linuxfoundation.org>
References: <20261113153812.408825269@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Nov 2026 10:52:47 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> @@ -589,6 +593,16 @@ static inline void vma_end_write_all(struct mm_struct *mm)
>  {
>  	mmap_assert_write_locked(mm);
>  	mm_lock_seqcount_end(mm);
> +
> +	/*
> +	 * VMA seqcounts are not updated on unlock, so once the mm seqcount has
> +	 * wrapped, any VMA still carrying a sequence number from before the
> +	 * wrap would satisfy __is_vma_write_locked() when that number comes
> +	 * round again, and readers would not be excluded. Reset every VMA's
> +	 * seqcount so that no stale value survives the wrap.
> +	 */
> +	if (unlikely(!mm->mm_lock_seq.sequence))
> +		__mm_reset_vma_seqcounts(mm);
>  }

In a UM ~defconfig build with LLVM:

    In file included from arch/um/kernel/asm-offsets.c:8:
    In file included from ./include/linux/audit.h:13:
    In file included from ./include/linux/ptrace.h:10:
    In file included from ./include/linux/pid_namespace.h:7:
    In file included from ./include/linux/mm.h:18:
    ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
      604 |         if (unlikely(!mm->mm_lock_seq.sequence))
          |                       ~~  ^
    ./include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
       77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
          |

That exists only under `CONFIG_PER_VMA_LOCK` (commit 47e725702b0b ("mm:
make per-VMA locks available universally") from Dave's series was not
backported).

I hope this helps!

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org

Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>

Cheers,
Miguel
