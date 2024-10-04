Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9CB21019E
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728051467; cv=none; b=TL3vZuCKa8znB7l1FCedEiPGiY7pDwhyZfzeK7HHjQEeJew2vDUGOeByHanoH5O8vLgY7ttm91BPFuy2c5QVJPwcUPPIn1M3K2llIQJV/mKZ22dAf0zHlfqubahPGUr0Qftl3xRMRXtJQJ6B2UDVqxFQFLfGpawEHaZMX7Hu4j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728051467; c=relaxed/simple;
	bh=zsE3OLHAGWx+9i8525FiuBbVUGIdrrHEA48nOTpUX+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WGj9d04SxVKs82gyjsvD/iMkkHph3D2EPbyWIqpOM1gBJCpV9XRXbllR4b9Viihd6q1hYcA1VLFsVObQ7HcVvVyH7WXmhscXcMpyDf5DzlpSsKbA5R4vVfDrCCkKnP5tqLGTtDujGIz6Dmyd32u0IGGwArMJio3urotLIcNcPjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1Bj4cBp; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1Bj4cBp"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6e29c50ccbaso20155607b3.2
        for <patches@lists.linux.dev>; Fri, 04 Oct 2024 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728051465; x=1728656265; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNUlLWhszcF1O/g2HmC+fFVclU6SG4kGSBRvhEPUmus=;
        b=k1Bj4cBpxQwCbhpR850p96LNmLOSHyKH6LyOv5Ul8eojLazcEv7U8GwRE/KaPUopyE
         KXgtYavegLmkCW9eaf3K46MWaLn5/bEgkGM2xF8i2hPGX4EZDF7sQLJhUlM6JeVtfnL4
         6aWZ9vSTqsZBmdd5eKDvghbrypfRBsNAt6x7Wl56bn+q98dtoxkBj1Bs9o/4g1UMR4bq
         aUbrd0+Ycu+6MSim5l0PgaaKDPx6S/iMjh/r9OXFvOnJROcLAOFtwygq3lKFtiK6ZQjt
         gz7rlUf1LawEuic+ADqRSHHtebQ4WAiUTutHTTsmnyKeVRpB1+7Kix/uo4W+pQLyli5A
         n5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728051465; x=1728656265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNUlLWhszcF1O/g2HmC+fFVclU6SG4kGSBRvhEPUmus=;
        b=Su3WoeDRdqpT61+iy8jEDM8XcZ7hti8rwNFFMW0l/ONdyBN90iqhTX4w/nsNrKgzWT
         b019KMjnfIrjIsPhbh4z+PyS+vU9U/voa5uRrSrajWittVZZu0hKvbWAJ51ztS91Qqbc
         c1b7N8fkzdCqIZKO2zmXbp2nsnODoG81FJ9f8QSojYb5BBgva+pthlQ01cy9BT77D/qY
         dpZXyuKSZmBIAn86TiBIVN31XsBZNIh4ZQO1sje2GBzkgWLP0KSjONTE6jG5kKsGvby4
         5kkS/AVbdM04V5wNdrB8MEVve8JTKPkNKn5O+AyvHqGZ0wA4X2qga6EHUKq55sJSh2oH
         IkUg==
X-Forwarded-Encrypted: i=1; AJvYcCVeWM5UqVcwotdDbKXB3oF4fMyFXndYt7V+lUU8uN/faEH3WS37uyS4ffjGp78MvhFbKl951kcs@lists.linux.dev
X-Gm-Message-State: AOJu0YyEEeRt9mCqtFJxwwxr26TXUNiOeOXT2TbMk0jdYQ8dHXx4UgHL
	AMb0eiG6nXXdHhUpkLBvIQdHk9CFqfclIOsNFprwmLUuT7DsLMPmaRqbYGSqO0VZfMC88+ORmbZ
	3J6isSfbJFU/MauyVsowBfQSbSpGCNqB319I=
X-Google-Smtp-Source: AGHT+IEB9VVNQ2jOBSVouKS0eBjZgjKxntWY1NMMvCWikKrNo3Z+2Bg2wv2PDY/nA9jG2S33P3rqvAZK3gpxXaclnrU=
X-Received: by 2002:a05:690c:d89:b0:6de:b23:f2c3 with SMTP id
 00721157ae682-6e2c72412bamr28091777b3.7.1728051464719; Fri, 04 Oct 2024
 07:17:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org> <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh> <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com> <2024100420-aflutter-setback-2482@gregkh>
In-Reply-To: <2024100420-aflutter-setback-2482@gregkh>
From: Youzhong Yang <youzhong@gmail.com>
Date: Fri, 4 Oct 2024 10:17:34 -0400
Message-ID: <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chuck Lever III <chuck.lever@oracle.com>, linux-stable <stable@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is 1/4 in the context of Chuck's e-mail reply:

nfsd: add list_head nf_gc to struct nfsd_file
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8e6e2ffa6569a205f1805cbaeca143b556581da6

On Fri, Oct 4, 2024 at 10:10=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Oct 04, 2024 at 10:01:46AM -0400, Youzhong Yang wrote:
> > I applied 2/4, 3/4 and 4/4 on top of kernel 6.6.41 and tested it under
> > our work load, unfortunately leaks occurred. Here is what I got:
> >
> > crash>  p nfsd_file_allocations:a | awk '{print $NF}' | perl -e
> > 'while(<>){ $sum +=3D $_; } print $sum, "\n";'
> > 114664232
> > crash> p nfsd_file_releases:a | awk '{print $NF}' | perl -e
> > 'while(<>){ $sum +=3D $_; } print $sum, "\n";'
> > 114664221
> >
> > So yes, 1/4 is needed for fixing the issue.
>
> What exactly is 1/4?  For where?
>
> Sorry, top posting loses all context :(
>
> greg k-h
