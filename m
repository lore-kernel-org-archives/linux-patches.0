Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114009;
	b=eEhTlsDYMNsOsrrKiET+/GCZdzAjqEMjc7kCYTIX6/j0uVX7WRhNbPsr/FIMeg2K/SsD
	 mTV2DPyZBG0yw77fmcxNMh1LBun9xeWKaCYxYxPhpCqGkyinKQhZXN7C9uDTiFrfiMnCS
	 qCjAwwhwWy9lu9M0sqLk/M1VVkxgfj7IK1/gMivL7etuaVpyoETCabqSaMhkjS3eM2sJY
	 EDmgBxKywFAHCQmd5THg/T3Kb7JQK3bWjcfq/kEcUVsPUVvQaDkvmoRtBYBpPmrg8XQm9
	 Ym2wNlV77uQJyr2NijC2wdJ+0rH2QVDQZcgD8dvc5+0JhP3zBtmmwUU325S3vpoqjBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114009;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=17nSu4oCnI9EKB0f3S0cCLEfWg/WYeKxC2nHokdNeaw=;
	b=ZDRpLyJCbeuh0mN6/ApmzBCae8bCTYD5bl9sR9bdF1Wzl5t4lt1Vx1HCVFXNicBBgjlM
	 GpYNjclgbyQgQ9NECwZXbuFyJZxN4YhtqsF8MD3gCpgQGlKuaEK3JI4z35hz+m3XCNuTB
	 5d/m2VJYK7afgizs/nBpaIVNIhoJY3KacK0OAaTDgGvDClnmNoKijY6BRJvx88aVH4ofX
	 xuhWFy4cSZlLORI2/h0voyc0v+uePGW/Iro1/DkHvchpleA6sYrV0DYuRxP+fUUrykZLX
	 gyrlzkSGywWHRiZ6BP2JbSs81USS2No9zdsJaUUiJhfgyryvabjIuV30P6vo5YhuQOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nm26n6KJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E699606A324;
	Thu, 19 Nov 2026 18:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nm26n6KJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B915A1F000C5;
	Thu, 19 Nov 2026 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795114008;
	bh=17nSu4oCnI9EKB0f3S0cCLEfWg/WYeKxC2nHokdNeaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nm26n6KJC++pWSBnb08WDCHWeqwCfJHKKBm81ioLILgarFJJr5zwUnNVD7K9+rqLm
	 Mf8uYKlsjtoqqlfv2gatTdW2IUQJnr6/Ujf3seylUMGNdOkqnyxh+qrTWPcU8+CB35
	 2X116uSNGfutg7hae7+D5sNZI/OW/n+XOwI6pRvk4SAH85pi/ArhpMj3FEsm2g+cfF
	 8HYETWuRUbhgIm9/EWyux6huyf0XoeX3X7zkzb31UuWaPEI/RM7ueX/hrYwGWi53gl
	 mVgwyD4sQ16xxcPFYEPeGNwCvWYTfaQX9yoBoMUTrkUgz0EHOnN5eoqJIsrvTsB3bg
	 jKX91A4FZaypg==
Message-ID: <e5f84697-3459-4f6a-a835-314d128576a0@kernel.org>
Date: Thu, 19 Nov 2026 19:46:43 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.1 1649/2857] mm/mremap: recheck PUDs under the page
 table lock
Content-Language: fr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Lance Yang
 <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20261118150201.293410965@linuxfoundation.org>
 <20261118150300.709668987@linuxfoundation.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20261118150300.709668987@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On 18/11/2026 15:44, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: David Hildenbrand (Arm) <david@kernel.org>
> 
> [ Upstream commit 402882943dfa8bab5c2bcc66189f9fb2828f248e ]
> 
> Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
> clear a leaf between the lookup and the move. Holding mmap_lock in write
> mode does not prevent this.
> 
> If the zap happens before move_page_tables() tests the entry, an empty
> PUD can reach move_normal_pud(), where pud_populate() turns it into a
> present page table entry. If it happens after the test, move_huge_pud()
> can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
> warnings on powerpc.
> 
> Recheck the source under the page table lock in both helpers. Treat an
> empty source in move_normal_pud() as a completed move, and use
> __pud_trans_huge_lock() in move_huge_pud().
> 
> In the future we should likely have the code lookup a PUD/PMD lockless
> once, instead of multiple times, because one of the problematic bits
> here is the:
> 
> 	pud_trans_huge(*old_pud)
> 
> Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Link: https://patch.msgid.link/20261031-fixes_core-v3-31-d6437171ecc3@kernel.org
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> [ sashal: adjusted context for move helpers using direct vma and old_addr arguments instead of pagetable_move_control ]
Similar to what I reported on v5.15, our CI also has an issue with this
one on v6.1:

  mm/mremap.c: In function 'move_huge_pud':
  mm/mremap.c:395:19: error: implicit declaration of function '__pud_trans_huge_lock'; did you mean 'pud_trans_huge_lock'? [-Wimplicit-function-declaration]
    395 |         old_ptl = __pud_trans_huge_lock(old_pud, vma);
        |                   ^~~~~~~~~~~~~~~~~~~~~
        |                   pud_trans_huge_lock
  mm/mremap.c:395:17: error: assignment to 'spinlock_t *' {aka 'struct spinlock *'} from 'int' makes pointer from integer without a cast [-Wint-conversion]
    395 |         old_ptl = __pud_trans_huge_lock(old_pud, vma);
        |                 ^

https://github.com/multipath-tcp/mptcp_net-next/actions/runs/44566582776/job/135709990661#step:9:407

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

