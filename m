Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F041E210198
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728050519; cv=none; b=h58lBSii4vVOM561Bz86C8H0s/J3b+L1xXX8jSsvK58MrImPPFZqgB7R+rY5rqix5KmyuY2kZC3OrI1LfWVUFQBdsNOyChmz7SFs0jtfwub6fCQwy0ESbK6IjM3RxIi3rTiUSwxNTyf5doolOxluNWZ5J3jVjT5g9cAKAAWqy2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728050519; c=relaxed/simple;
	bh=dXmPelvRHfc4ZdMEj6b9JoK02MhCYD5JgsYCtP+dG9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BrvABUfrF8fYVwzijgYPXhISw0tKvczauxyEU3ycHmAQ6lvAuJEguoZ6L3LRTI9OyiAuKuZRnJ1a6r69I+rG3yOy37oOOkIbtA2AmEX+bZPpYi+fAWeEiOWHGRDydvlsOHFwHGr1RcW5tdxpqZDoxmmKmnHtfcAlxFOflqgUWSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxYEtKG6; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxYEtKG6"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6db836c6bd7so20665067b3.3
        for <patches@lists.linux.dev>; Fri, 04 Oct 2024 07:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728050517; x=1728655317; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IDoNwvuEcJDkjxQtbxhmslZMIhdEHCkCDz1zdzIYfs=;
        b=gxYEtKG6b78r/qvNlVei3jw+vvDaw+oy7hB9HtOW6L1gxcKtWOHJHBoZJbAdFV1o2g
         3oRLNkjYAN7Pep8+tyQaHqab8aTwFIZcjSSFzfmI1+91yowSX8L4c7MSrJ0AeOLDPo5k
         aV4RAfDIL0b9VnZ3Py8/tyrIrUP7frLZNB9j914D8pE4Dz6ZcA8sYd8LVuVauQPBPdmP
         fBA/I5iQYj0dNAHJhWsf5um/jEdRITFstFG5nFolCOi84AeTbKfQxUMCTc/QXZiu56E/
         CsiAp3GC+LXbGjswg4rJPRR5eAD9huxHFI3DlHhdAWCaZo4znOfw2MPZ1XtYhUrL8gF9
         DCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728050517; x=1728655317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IDoNwvuEcJDkjxQtbxhmslZMIhdEHCkCDz1zdzIYfs=;
        b=XGI1tKZrnSljs/J7ZD5gmyTR+iLW51Xs7t4b2ZOgcOiwtMhz5aZt6WryJIMpni0zHP
         0EJxY91LhveiVQSeKDnvhnLSOu1L5D9ScSp7d2ehhneO50ywDltzWRMgS2V/p5h/ntv9
         Hn5Q0iftIpGo0BT446xhVaYq1SJWDCUzFuJZ4gBOAt3XM73cH2T1sx/zD7X6m5cscjND
         NHTkwS5kz6nOELAcvwLF1SUkfwegRabgDiK6bj5OrnXnKFUL9hRUQJm0Mq9Onp+d40yC
         exb/LFWIFc8pocsehvDq3SL2ih0q0fSoyaNjkdyZQC50iGV8yr/rIpFQ28Jhgy5ylAnq
         q3Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWbDyFR1hEWWDLrCWQMaZ2TqHmPZpSm+hT+qxcg7Ps5SZIaDnLUXunmgleUQ+sGeeD552aAg5HW@lists.linux.dev
X-Gm-Message-State: AOJu0YzcY06A0D6LI0bCLLLj9A2zRkGJtvvIwZZTFB80Ph+ZBRVFe/P+
	DZZoSfBwi3K6tSmFR9ZCUhT0wpgQJlTAohDEq4TDKvjGt4E8RuQ77pdWEDRtfg51L+5zkkar/fs
	JDUHJIMohgSqzsdcnwgDNj62qML4=
X-Google-Smtp-Source: AGHT+IEOZSDXtUb4SwraSXLmqD5CN+sFVIywEw54MGjfxhmQC74TaW9av8nXD50wicpjGifw/NMkhtmleLyaL9ZPHYI=
X-Received: by 2002:a05:690c:6f11:b0:6e2:ada7:ab89 with SMTP id
 00721157ae682-6e2c7036be1mr31002097b3.26.1728050516758; Fri, 04 Oct 2024
 07:01:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org> <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh> <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
In-Reply-To: <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
From: Youzhong Yang <youzhong@gmail.com>
Date: Fri, 4 Oct 2024 10:01:46 -0400
Message-ID: <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-stable <stable@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I applied 2/4, 3/4 and 4/4 on top of kernel 6.6.41 and tested it under
our work load, unfortunately leaks occurred. Here is what I got:

crash>  p nfsd_file_allocations:a | awk '{print $NF}' | perl -e
'while(<>){ $sum +=3D $_; } print $sum, "\n";'
114664232
crash> p nfsd_file_releases:a | awk '{print $NF}' | perl -e
'while(<>){ $sum +=3D $_; } print $sum, "\n";'
114664221

So yes, 1/4 is needed for fixing the issue.

On Thu, Oct 3, 2024 at 9:54=E2=80=AFAM Chuck Lever III <chuck.lever@oracle.=
com> wrote:
>
>
>
> > On Oct 3, 2024, at 3:19=E2=80=AFAM, Greg Kroah-Hartman <gregkh@linuxfou=
ndation.org> wrote:
> >
> > On Wed, Oct 02, 2024 at 10:12:32AM -0400, Youzhong Yang wrote:
> >> My understanding is that the following 4 commits together fix the leak=
ing issue:
> >>
> >> nfsd: add list_head nf_gc to struct nfsd_file
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D8e6e2ffa6569a205f1805cbaeca143b556581da6
> >>
> >> nfsd: fix refcount leak when file is unhashed after being found
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D8a7926176378460e0d91e02b03f0ff20a8709a60
> >>
> >> nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D81a95c2b1d605743220f28db04b8da13a65c4059
> >>
> >> nfsd: count nfsd_file allocations
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D700bb4ff912f954345286e065ff145753a1d5bbe
> >>
> >> The first two are essential but it's better to have the last two commi=
ts too.
> >
> > So right now only the 2nd and 3rd are in the tree, do we really need th=
e
> > others as well?  And if so, why were none of these marked for a stable
> > inclusion?
>
> IMO 1/4 and 4/4 are not needed in stable, and that's
> why we marked them that way.
>
>
> --
> Chuck Lever
>
>
