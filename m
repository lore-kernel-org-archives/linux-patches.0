Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30277233923;
	Sat,  8 Aug 2026 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786187439; cv=none; b=Xlx53o5qUDvPCQGoZQZnqWk01zGJovuWyMf6uXMdV3KkM1ELFrecPUk1WoNofZrsDnjceizNZzixWECrF0Fsmi3EbUqGzZV2WvNS4FVmTw5pwfMJAdw49g1NVDM9mAYAvHVCDlmC65RjaRFFVThkupxR5B3NMp0szGIF0wnk8IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786187439; c=relaxed/simple;
	bh=uEjvPysZ6vUUGaTTzgP9nZLW2fbGRyAHaDCHPIa+NXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyWEXEDPnzqVNYCvoecQfgDPKrDPc33a7vaga6hy0+Fi5LNjENLfx6Kcb1YXLRxDSkNN7bs9TcBWGQm04Wmapuyqe80l1nx074czkmNsh2kqg05oSW/CXgr2N/v7S8b8bm5rXvhNrkC3Ixb+iwev5rqEz1sIBOR6eruDiLIpXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlkeoaP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlkeoaP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F051F000E9;
	Sat,  8 Aug 2026 11:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786187437;
	bh=NqVOkkyfKao6CI8AqAr6nVsWUo9tpXZBfVbFLMbVOmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlkeoaP5BRgG27Ld2tZLm86rznX0a4JncnoSscTrCgLU5fzeFCRmzO+q//lBUtVSE
	 jKXYVVGTfFWhFgfoyLXedauCe7iiL8/ybJXXt92m3yUzwbEk6NVuvgbyyiI5AvZWdh
	 6Ed7u2dn4bY2r+z475XIlJem07Q/srQFD3w/zGzqeCUOoSjEi29gGUuZdJT/45phCL
	 sjqChAcFJNCYbOZazAyoZb46zc2SyYjI4pMVW1T2kC5ngDu7Ht0RcasMjFvOsazrgc
	 8CRp+ovLG0xDWFVS8g2CjEYKDu8SndrlW7qrh8+1R0Z4z+IUBnq9P2RYQaQRLCoOv6
	 F0/sw8EsASKIQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	bot@kernelci.org,
	kernelci-results@groups.io
Subject: Re: [PATCH 6.12 289/337] mm/slab: prevent unbounded recursion in free path with new kmalloc type
Date: Sat,  8 Aug 2026 07:10:33 -0400
Message-ID: <20260808030732.GA9608581@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807180245.GA4067747@ax162>
References: <20260807143418.516897842@linuxfoundation.org> <20260807143424.797445703@linuxfoundation.org> <20260807180245.GA4067747@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Aug 07, 2026 at 11:02:45AM -0700, Nathan Chancellor wrote:
>   linux/mm/slab.h:572:24: error: duplicate 'inline' declaration specifier [-Werror,-Wduplicate-decl-specifier]
>     572 | static __always_inline inline bool need_kmalloc_no_objext(void)
> 
> The 'inline' should be dropped, as '__always_inline' includes 'inline'
> already.

Fixed in the queue - I dropped the redundant 'inline' and kept
'__always_inline', so the 6.12 backport now reads:

  static __always_inline bool need_kmalloc_no_objext(void)

-- 
Thanks,
Sasha
