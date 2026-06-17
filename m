Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8723A3D300F
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693165; cv=none; b=JufZzNfRpG30fjyjErBWDOz0T+7ko08CsM65c3ZA5PUMrIu3sqO7CJ+8ExB1k6/ydVojZQir96R4buDwJ754qBVo3p4r1nwrQZruXSqJpefE5Zo31BjfLeq9zr5VA0DXQ459q0YwJKhgs4jbLnpadGy/BAWJ1m68QW7yh2NDn0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693165; c=relaxed/simple;
	bh=DoHyOXb44cEyFyqCcOZbdpPmjWaqhtS2t6SyiBCeGuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ILkzgZBCs1BSXLKrfOLp5S9nr+VOHGBVnyi0g+DguqVjaf+cO9jniH/HisIGRN8eGqQEjhvr1KF9cK4C1jri838o5ShDU7oO8luOUk4A7E+VbYEnz30zT4CqNDYM8PcWcKrofsQ9WtdGp2zK7QMhzMq3G5QkWtZLMJRlVn9UxiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dhcCxcYT; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dhcCxcYT"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45fe59255beso3157870f8f.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 03:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781693163; x=1782297963; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ArPXWKSoKZlKEVktoEQrEi4JptJyJihdjMkeBwI/mo=;
        b=dhcCxcYT2UMfLBWQ8m4UbyP0bHAa72rOXqR56QrVPuCfUh+6zGSBZS44lg/Nfv9MMn
         AK26ruZL+ZegPDRpWHB1ZhWALXwT78HzjLupuFtGo27STq7lDvsSLWESc1TrxDf73h/g
         rACXW3rXUF55g3v11LVudI7rImJTusOq3exfA8e0LL19vXvGnhsg+5Hk+vu9tRcyMbio
         gWlEcOjs0assJ2fld/HGQKkT+5Uky7oGWRxNH62vylXiyrrd02Hh8w/QPifI+olEl3NK
         j/0GOOtCpa/5eytc5HnzYHhfpZEQi4YfDAmkmgK+7WP+fRMTGBDE7m/gIHTUtFSgS7pr
         6ASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781693163; x=1782297963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ArPXWKSoKZlKEVktoEQrEi4JptJyJihdjMkeBwI/mo=;
        b=a/EAOrWXOnGfc7z3pA++ZlKlz/tc4QKDXwAnbGFpMqjBZrzWPOlcjZx9BWvQQL/WY7
         6FTLXFUOqwaJW4jtnWI83MO81HiJWnjRrtn7TR+uFs33IO91vZ+IWrPCgQPrcSR1PmSM
         cFx2sohQuZhgCEB8xUkGzqdvT/GmY3FUDV5IT7x92qWf3tUJ3C4iA/ZFXdo6b0NWU156
         vOPxm+4/1FV1SuvEmcRTfQfc54XFLEAf5rEpR3423n7dteHHYVerEzQFO00VfVgDBOu1
         FO7hwZpNLoDdyPHJSKeGwJ3TQQX5LbyiqFE3XTsZdJlps88Jq1CeEffb8yAh9h9Fz/me
         1lGA==
X-Forwarded-Encrypted: i=1; AFNElJ9DkH4D/fAn1OldbPU/tAfMDSyDotutDCjU4O+wwbvpWXC/6JHLf4MUxzBNnUxjYIxpZYBldA0h@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo1Ym9xHlljx4kTkJsWhZqJBxA8rlrQJlpZot4U4+ygRP8lVUZ
	oBK0yZmwKX2jqDDncKzDUdN0mmEw0h67UUVy00FVc2bMOOADlUmz4M3D
X-Gm-Gg: AfdE7clWe/Bhmn5Ef1cN4oB+CKY2KtCJfsi7EIBU5sr1M3ZSm3i9Nh2rmRipmDGWrAx
	Uc65CC0F+XjP1oqZ21r9W2QewU7BJL7rJ8QbHECuPHs7K52kgTuAq2CHRfYEy8HU6W70gCorJVn
	kspye25dEFTEzvgGycBfXAGiOVq2zTB3da9/bTvUwuvxMs4m0YF7KZsQm5HRWDJzC/dr5ODq+dA
	iGeBvZxbXcop9xGa4aZ5o0VnNpOPJX9xiLXp8/dg+1YJi1MD0yXuJYjQ1sSxhqZN/m+igv1HOul
	OY7nbyXByVwC/gj+0mFwq0yEpfqefSXkSPAXPS4cYaUiwbYdhoKDs2VwoXOUBiIzujklNK+C4ok
	CjL4aNFLGkp5BJTnrbyXpuwJVqOeOmPya6n3MFSPOl+ju5b4O6lCoYOwFM2GKevmL/cyRqmleIj
	yQwTrAYvqBuHpJ25gkJtyfvkC+/o018YNYilFLxpCtoHUhL5FHRRZoO1SuhTXziFhcyuz9ZcAkF
	ZlVAFYkNhAzoCGPQjBToTbc/PDmDvvuGICAEt7oRSZu3g+vRYuKjc4SJIH2Z6JKBYx13HaX9UjV
	q/6XjKj3T0rBNGRBT1f1CwGP4p8ti8k=
X-Received: by 2002:a5d:424e:0:b0:45e:8547:f21e with SMTP id ffacd0b85a97d-46241d60255mr4193090f8f.36.1781693162804;
        Wed, 17 Jun 2026 03:46:02 -0700 (PDT)
Received: from mail.gmail.com (2a01cb0889497e00e0cbb4a619790abb.ipv6.abo.wanadoo.fr. [2a01:cb08:8949:7e00:e0cb:b4a6:1979:abb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0d70sm53282324f8f.19.2026.06.17.03.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:46:02 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:46:00 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev, John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 054/522] selftests/bpf: add generic BPF program
 tester-loader
Message-ID: <ajJ66F3oNlhqhKAv@mail.gmail.com>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145128.305073045@linuxfoundation.org>
 <b6b679743c2383b5a367c5d72404b056dfebf080.camel@decadent.org.uk>
 <2026061719-danger-ensure-f276@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026061719-danger-ensure-f276@gregkh>

On Wed, Jun 17, 2026 at 01:53:29PM +0530, Greg Kroah-Hartman wrote:
> On Wed, Jun 17, 2026 at 10:01:56AM +0200, Ben Hutchings wrote:
> > On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Andrii Nakryiko <andrii@kernel.org>
> > > 
> > > [ Upstream commit 537c3f66eac137a02ec50a40219d2da6597e5dc9 ]
> > [...]
> > 
> > There seems to be a fix needed on top of this: commit f00bb757ed63
> > "selftests/bpf: fix to avoid __msg tag de-duplication by clang".
> 
> I tried it, but it didn't apply at all :(

I think it's fine if we skip this additional fix. As mentioned in the
commit message, it only affected one test and that test isn't present in
v6.1. In general, BPF selftests are not very likely to have identical
expected messages because we often include the instruction index in
there. And it would indeed not apply without backporting a few
additional commits. Anyway, thanks Ben for double checking!

> 
> thanks,
> 
> greg k-h
