Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795153501;
	b=zOGcbOPYvGrRh39h+nCKRsHC+qjvdOV63d9/vuysbd7Mt9z399rV1kjMQvDDapNIxjy0
	 fMTAFMPTjdxCxNPKaqB+uYAJprGlabnyvfdKTdw7+IxnTpMuVuAlioQVZcTKnqm9/mi82
	 JwjCVAAniz5MDEv6qH6lLetZ2DBgnfl1nVYzbmhJAhswMqcy5HjuOL3rJGpT+AgTVesqs
	 SEW643zdsQc1ug8w4810M+OpkidGB6Kdqw9P7cZKhHnGDrB8w4AwIbgmoW+x3PBSWjsD/
	 zq2JdsJgUzt3idBsSdcgbR7l+Gw3QF4uYDOFnJa8EZengiLHizhmShq5divHriGvBtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795153501;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QPoif5nu0plubaIDW+mhF1lB/GnbdIfbOY2E6CR1E+I=;
	b=C2aABzJERIPa6lzSimFhyapFrn7AIByNYBVyWAup0AoC+rdSCHxuD1DuBoeXdAXcWzx4
	 QLgr1x/FNZ1ShVYUdyiShmEVa44WW5MA110RACaUQ9fhUsc5SsWedoVmwjVZbVGwH0Ra6
	 Uvv3H4WJH95qtP5HgCG6kxdnYKS0LYDt7O8P22mcWJn5OyWC7+uuiohuF3erv9kNtTmL0
	 PdzGsyaLajMz7UqEGFYpdTdKNJExdt12Ou40+QNOTDoE9V86fi1yTn0D5kYBFlhLoAtLz
	 JcLzy7dhMc0bsyfe3cDkmTL2lFEByYBqwECVqouS+FDaXZRm4OBFbHrNuGj/m9NpuzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2G9Hp3F9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83978606A320;
	Fri, 20 Nov 2026 05:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2G9Hp3F9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BBD1F000C6;
	Fri, 20 Nov 2026 05:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795153501;
	bh=QPoif5nu0plubaIDW+mhF1lB/GnbdIfbOY2E6CR1E+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=2G9Hp3F9/Z7/r/UwAOtgTV/g7Lvid733bUa15bgkHJMZnuKfTfJbWL01iKvezj23n
	 Auuc887Qci6DGiTai/m9drr8IVpnNfOOaV9mf4J5GYS85EnALuBVMwpe+8BmtFP+8T
	 yqfwNTt/maLhWKS3Hi1gcgINajdt5RdLkc6hhVOc=
Date: Fri, 20 Nov 2026 06:44:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 1649/2857] mm/mremap: recheck PUDs under the page
 table lock
Message-ID: <2026112048-scheme-cornstalk-9990@gregkh>
References: <20261118150201.293410965@linuxfoundation.org>
 <20261118150300.709668987@linuxfoundation.org>
 <e5f84697-3459-4f6a-a835-314d128576a0@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5f84697-3459-4f6a-a835-314d128576a0@kernel.org>

On Thu, Nov 19, 2026 at 07:46:43PM +0100, Matthieu Baerts wrote:
> Hi Greg,
> 
> On 18/11/2026 15:44, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: David Hildenbrand (Arm) <david@kernel.org>
> > 
> > [ Upstream commit 402882943dfa8bab5c2bcc66189f9fb2828f248e ]
> > 
> > Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
> > clear a leaf between the lookup and the move. Holding mmap_lock in write
> > mode does not prevent this.
> > 
> > If the zap happens before move_page_tables() tests the entry, an empty
> > PUD can reach move_normal_pud(), where pud_populate() turns it into a
> > present page table entry. If it happens after the test, move_huge_pud()
> > can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
> > warnings on powerpc.
> > 
> > Recheck the source under the page table lock in both helpers. Treat an
> > empty source in move_normal_pud() as a completed move, and use
> > __pud_trans_huge_lock() in move_huge_pud().
> > 
> > In the future we should likely have the code lookup a PUD/PMD lockless
> > once, instead of multiple times, because one of the problematic bits
> > here is the:
> > 
> > 	pud_trans_huge(*old_pud)
> > 
> > Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> > Link: https://patch.msgid.link/20261031-fixes_core-v3-31-d6437171ecc3@kernel.org
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > [ sashal: adjusted context for move helpers using direct vma and old_addr arguments instead of pagetable_move_control ]
> Similar to what I reported on v5.15, our CI also has an issue with this
> one on v6.1:
> 
>   mm/mremap.c: In function 'move_huge_pud':
>   mm/mremap.c:395:19: error: implicit declaration of function '__pud_trans_huge_lock'; did you mean 'pud_trans_huge_lock'? [-Wimplicit-function-declaration]
>     395 |         old_ptl = __pud_trans_huge_lock(old_pud, vma);
>         |                   ^~~~~~~~~~~~~~~~~~~~~
>         |                   pud_trans_huge_lock
>   mm/mremap.c:395:17: error: assignment to 'spinlock_t *' {aka 'struct spinlock *'} from 'int' makes pointer from integer without a cast [-Wint-conversion]
>     395 |         old_ptl = __pud_trans_huge_lock(old_pud, vma);
>         |                 ^
> 
> https://github.com/multipath-tcp/mptcp_net-next/actions/runs/44566582776/job/135709990661#step:9:407
> 

thanks, now dropped from here and 5.15.y

greg k-h
