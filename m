Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C95B3AFB06
	for <patches@lists.linux.dev>; Tue, 15 Sep 2026 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508133; cv=none; b=YFqC8asJwwhl0D+eMXDBoeYhHQekhqVvslqAfrCsAHvGEGHMftHqBnD9bAT9/nvfphzu2sNPzONCET2tzdcAfymcgWOrhGAA3aFGOWrAqn/baMPnQ/4LwCbNpf/BqdJcEPRSu9jeF+U+x9R5FIL1PWjAEJrAo5A6AwkN6Zq/EkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508133; c=relaxed/simple;
	bh=o7h3INURFTfXK6QgTDQq4IGKVSWPwgcwVnzFukZs7QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKUT4SMQ4+gv3wqpRliURb7pGkzuJW/OHmDOLpLgqhX6LV9iPTZmxnwnKOESnJHzy0my6/sQuTRcT3bZ1kxJO0QUq6s0vskThVqmuVT0qqa+Gy2iUyngd7aaUB9OcDMcvSppSHGe+OiXWjtEGWHAC1nkK2bWKoQz3r0XwBEwXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=monAFqPZ; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="monAFqPZ"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f89so89310f8f.3
        for <patches@lists.linux.dev>; Tue, 15 Sep 2026 14:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789508130; x=1790112930; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lIdvdTzoCaqdSuezaWsjFH+gv+z5XekzXwYZss6OlpQ=;
        b=monAFqPZd+b/FIPRapeXw8Ta/oGs5I+H/oZhC3CaFrbTsf/2u3I5bjXmXKhNvnS2Kg
         7D65Yf+qVk+pUH5RMya1S0yqGyAMcOkA/D+FuHGu41UrqOLkIX5V4JCImLFOsN13qdrl
         jptl1NQ9lE+aVQY1XH9TfawkgLwt1SzXchJYAjyAGjNw/LFf7t6rfnii9qWWBIntn+yE
         LUrPkMqbvq68imGdX1rhhOnFcdY98cwlLZQp3Gf6JqcaIvy7XMYhsFWxQHSXjZ2r4Jqy
         mlNpap8oHUi4sO4Zy6qI+8Yc/TsrzjWPwUZb/tuvKUMZXx5CXqaGWj6PV7niPR/SQ9qY
         /m5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789508130; x=1790112930;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lIdvdTzoCaqdSuezaWsjFH+gv+z5XekzXwYZss6OlpQ=;
        b=BiGTo+T1NLMqFYfY7wT1fO22fFa88sb+nApLtlxNCT4hY8O7C27/JgBBQLGTp6ndr0
         2jSm/hMNB4rDqtjLJ9inMvd3arqTuJlAmeQSljORNSDjXK8vVoXx6sSO00VyRnOxapDl
         GJnLQAvFYJ4H9AxwfH21jRvmEXCPb2XcHYbSmgxdD0epoKx+wt/WW6IzrxKXadD+E/Na
         hz1HJ2o2kPwY5MP1izp5AUI7n1OkBYNlhQEvZ/IHgGEq1PD1whcdIUCStgiO/l5FlB9k
         yVxvHE0pmf96he7zzMIZ+k/k0u1jULo9HMov/VYaR0BMwCH49MlRMJxQBwLMquYwiS3O
         DVfg==
X-Forwarded-Encrypted: i=1; AKwUvByOsny27E3fl2MTjEOC+qa/yqIt8xYWVjaLP2tK01NTwpCASjN8HfOdU9n2JE7ZdzYCZdx1q9YE@lists.linux.dev
X-Gm-Message-State: AFuF++lykak5lCBHkxkAnLnX5mrHTdUhx9zoYNenLIwys12n/0G9nxiw
	mwCm4PqssFWOWYXZRRDrrv8Ka/6syE+O4jPPGgHTcWG6iGFBr9WRGc88
X-Gm-Gg: AYBFou3C0UlyDlpSsDLJW0BKZnG4Z8NwJamKzMoT9wdd7d0aS0RIc+7tdj6WeCgBfoo
	L/VRmH6Awy37pH3GGE5PipMdkUEUYupwjfAcNnOsLfVojy/MbKjbvu2zL6d6oRKz5QJwuol7ntF
	2Zsv1GxCXSVzMBmb0SOsSR74CDN0QDbPC2yq5FLNqZQJdhvG1F4y28uutlUpymMGrPwsTFWIITh
	oaperPx6VB3+3p0GpcF3f2sqGmuekyY86ohZGK+5AlTVLwW2hdzoRUaIZkmo+OfXPwz5LmsPO7y
	c/0Du7BRXa5NcNyrCQjqSuQ/jYRiSNl54z7BiFTZLg57jtrZ+ue4KBVzx37K8GiuiaQfKJUinMV
	Z37HjAs+8xuDPH1liXGRllJtzTH1nJMnKDgOcHgkgkldMtldWrVdn8pxtDWrQ626nOAfq77fTxx
	AvJT3eT2saS65qVB6oOs4Iy7ST0RMrLGNMyVw/+0u/PQ3+iujcCfnA6s0vSEgpvaX2nnJ8cll5x
	uSCblpQDBmeNO4GEJVuXs9H7ch2dQJHVcRRfo4kg8Lc4p22eGivm2na8/1IW8gzj1VfJkiK1iC8
	vZxUVCH8j3uzXKMzhDR7vHLJk04Qr97t9jDoi0045TuwNR91Yeg2af5XmdjM8JNLqcZvVmg=
X-Received: by 2002:a05:6000:4383:b0:487:8ec:1fc with SMTP id ffacd0b85a97d-4870cf09c40mr288821f8f.12.1789508129738;
        Tue, 15 Sep 2026 14:35:29 -0700 (PDT)
Received: from MBP-von-Karl (dynamic-2a02-3100-afd5-c801-ec9e-1a2a-2fc8-3f88.310.pool.telefonica.de. [2a02:3100:afd5:c801:ec9e:1a2a:2fc8:3f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf344fcsm2047321f8f.26.2026.09.15.14.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 14:35:28 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:35:27 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, Edward Adam Davis <eadavis@qq.com>, 
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>, syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and
 release
Message-ID: <aqm57oNzuXR8EvN-@gmail.com>
References: <20260913202907.3100-1-kmehltretter@gmail.com>
 <daily-reply-0008-re-l2cap-recv-cb-deadlock@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daily-reply-0008-re-l2cap-recv-cb-deadlock@kernel.org>

On Mon, Sep 14, 2026 at 10:03:24PM +0100, Sasha Levin wrote:
> > Please hold this patch unless the applicable L2CAP hunks from upstream
> > commit f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock") can also be
> > included.
> 
> Separately, while looking at this: both 5.15 and 5.10 carry c531e63871c0
> ("Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()") without
> its prerequisite, so l2cap_conless_channel() calls l2cap_chan_unlock() on a
> mutex it never acquired.
> 

Good point regarding the unbalanced locking.

I believe a backport of the applicable L2CAP hunks from f1a8f402f13f also
fixes what you found in l2cap_conless_channel(). I will test and submit
that for 5.15.y and 5.10.y soon.

Thanks,
Karl
