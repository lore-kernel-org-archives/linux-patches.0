Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F91D1300
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878366; cv=none; b=tZMvjF+rp9WeMtWaUN3fahkJcr5kRBHUJoe50iQVlcnAOuy8szAY+Hy/lAQq/WhPLrRbxT3VJCT8fdV2KBq5MRKjEzrLa65dcS3kXntO6AptbGldZFVdhcnPCGFaWdyqytTwa5Hg/CR5lqJsGvdBb71AbutjNYswFpmYtHDgwlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878366; c=relaxed/simple;
	bh=WZNZWR8PAJ7rcNRr0luQIreWcIo/NJ+TNCYGucATcqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kkr75Fi3M6+p4I7/OcM65N1dvbdsfEJI0qf6+prCePYUGKoJSsGHDO/gOiyDL+68Hk2dM0YzTIAK3nTvM+eYP9+3t0mKYAwd06dlSe8hRSGjgyZz/QnuWJUKl9v73rNk5yBOpQSwZojisVsz0rhrGHh+KHBvR994QSNW37UdmHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G4tCxRzn; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4tCxRzn"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e25d380b464so5829789276.2
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 07:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727878364; x=1728483164; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYUL+R6ZwmGNZ5hFEprKY1nHV3Bj9gxb2dqTmv+1DgE=;
        b=G4tCxRzndx9KHMUefgRS8LKU8xbhKUnGZSOP0Re1644QISfTImFBF6SvOODIj8Xm/f
         liF2DnMsRkFkG4j+lddxULm0fqMn6eGSDyR/hmGRW+IJKKgrFGJ+pJh2ZlhQjqteuuff
         QCrzc2PAnSEMJbx9f31+uow+l/W3qyyfahPXOM7MNyUo8VMShT+NVfUzYVl57oVqZLtc
         sRVi2KrqfMGnMcs+3T3m3L8eU4/xaGgsNfAEqKsSpRQxJeWo9poyu0TEE9Eef6OTilLB
         m+1VUDWqlBHd0h4/XFWpUvmykyuvQQ0UxBVDa0E8/GZV+LzPV3WV9dDhSsDojz1H2SHr
         DoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727878364; x=1728483164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYUL+R6ZwmGNZ5hFEprKY1nHV3Bj9gxb2dqTmv+1DgE=;
        b=O+jYV2wbZsUewZTe9pqaG91aAyANPvbJ4ITafBa0o+kNiENZNchp6NCh2fwri8uKBO
         CktQvYmCNIxyKxM1AzMQHUG6o+BmRrpZD23TPGCDPgapqgP/uxJI4Izn68VtIWXdvAan
         v1YlAw6pmBamhEhqNeVcVlCKgLkb2rX2pksnPfZ6ph9TCC65qsnk/LK3vvbgAhNH6X5t
         HD1dTFDJyOgrOq5TjgB2gtQl5rCRFqvaRzKlUFoVq5TGk0a9amt/jkNlwweOflWhRhPF
         lRf97fEgB3YrRgXlznzKHE5WnJhSbfhc3CHLbEeH2LkS73GzGEKCvtTitTB5NNpk04+v
         Q+rA==
X-Forwarded-Encrypted: i=1; AJvYcCVBycud+PsPVcBSIx1gSL7jcLEBx/J6RMyPjZPrnQLduf1yVt2+VDwMRbS5ZfEb/9pIsfz01yIs@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8PU/J8WIpgqdRwJ1PSq22l0I20T5ICHyxgqwNfQK0OIOAf/4p
	eAryn0DK+NbSLl/N0+QXgoDbjDSCXG30Wg+FERJ3nPpOYQ8Fb+1buELQwWhXdJSL5z9LnJB+OdQ
	5TCFhA/j6zharVsM/h1+gWb4LhZk=
X-Google-Smtp-Source: AGHT+IGko3RG5jLjXuXWqCg7C28LBR5vxeznyQ+uBLd78nTmkdYpiggka2aMVA91vpHO23oFYPRyXkgERnILAXSRns0=
X-Received: by 2002:a05:690c:6187:b0:6db:e55a:1c88 with SMTP id
 00721157ae682-6e2a2e1bb87mr32120917b3.23.1727878363736; Wed, 02 Oct 2024
 07:12:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org> <20241002125838.303136061@linuxfoundation.org>
In-Reply-To: <20241002125838.303136061@linuxfoundation.org>
From: Youzhong Yang <youzhong@gmail.com>
Date: Wed, 2 Oct 2024 10:12:32 -0400
Message-ID: <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My understanding is that the following 4 commits together fix the leaking i=
ssue:

nfsd: add list_head nf_gc to struct nfsd_file
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8e6e2ffa6569a205f1805cbaeca143b556581da6

nfsd: fix refcount leak when file is unhashed after being found
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8a7926176378460e0d91e02b03f0ff20a8709a60

nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D81a95c2b1d605743220f28db04b8da13a65c4059

nfsd: count nfsd_file allocations
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D700bb4ff912f954345286e065ff145753a1d5bbe

The first two are essential but it's better to have the last two commits to=
o.

On Wed, Oct 2, 2024 at 9:38=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.11-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Jeff Layton <jlayton@kernel.org>
>
> [ Upstream commit 8a7926176378460e0d91e02b03f0ff20a8709a60 ]
>
> If we wait_for_construction and find that the file is no longer hashed,
> and we're going to retry the open, the old nfsd_file reference is
> currently leaked. Put the reference before retrying.
>
> Fixes: c6593366c0bf ("nfsd: don't kill nfsd_files because of lease break =
error")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Tested-by: Youzhong Yang <youzhong@gmail.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/nfsd/filecache.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> index f09d96ff20652..e2e248032bfd0 100644
> --- a/fs/nfsd/filecache.c
> +++ b/fs/nfsd/filecache.c
> @@ -1049,6 +1049,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct=
 svc_fh *fhp,
>                         status =3D nfserr_jukebox;
>                         goto construction_err;
>                 }
> +               nfsd_file_put(nf);
>                 open_retry =3D false;
>                 fh_put(fhp);
>                 goto retry;
> --
> 2.43.0
>
>
>
