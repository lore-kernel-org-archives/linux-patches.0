Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9717BB5
	for <patches@lists.linux.dev>; Sun, 25 Feb 2024 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708878222; cv=none; b=NnrSS0BnJo3psy87beuVXj1ufG7LPogus46mHZqu3S9dcWDzeYjUEkXH+OXNdzq6imZHQw2XQT4tt5SEKGmhNchjculdEut98itqaAzG48XiDsgWxwXK7vCAQlEoB3JesZ2rN8a4UAuwE7UVXE/hHlp0wem86Gyczv3nkYC8b2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708878222; c=relaxed/simple;
	bh=LaigAbcADJ+dK0KzyX1kDd8eEpJpqVoPfgc/erPe1mM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fJRJ/Fh4VBklSF9SwBpfIfl0Iu/az9FsA2qiWtESN9AGqYozcmFJwcc2WbWKtfCEfngcnnVE5l1GV9jlD3+J21bSNzRyJw0g6Yo9Xiafo6q0Or6egPEixFrU2o7KyeVFNruy8qB1w2li6HoWKVxi1Mo/B9IUI07CB82bvR5Cquo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCKy4srK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCKy4srK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708878220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gEvjBAUJeAAT4LjTg60EE6mIK+bI32dp7aAGjL49dA4=;
	b=eCKy4srK7SAa5L19ItS1P5oDjuXNm3Z6Ig+CohLHDw9O3xoV3Toa+XInn1uUFBNUk9mlGp
	fAjbYnGiVuUfM2oPmn/4wa6l5R0EjoMKHFMSOw/iHcX/q/CPqv7VSFdPTjkWP6aE+/Iokr
	+sgrZXJRYyjvyc2+DkGOLcIDorKFIF4=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-t2Wt6svkNLO8qIPl2VtEeA-1; Sun, 25 Feb 2024 11:23:35 -0500
X-MC-Unique: t2Wt6svkNLO8qIPl2VtEeA-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-59fdfc539aeso1584476eaf.0
        for <patches@lists.linux.dev>; Sun, 25 Feb 2024 08:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708878214; x=1709483014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEvjBAUJeAAT4LjTg60EE6mIK+bI32dp7aAGjL49dA4=;
        b=RsJyuX/FYo0JKOlSkAkIjxzYfw75wubQtnd/Tpxpi5UjJ80/hzvlKuolSNNB9OsVxX
         3h0iErLx4gAqizosYm9UbdKkkHf1qnD2gVJIMnY+ylXNPhEsVPiNWc4jHDsUOFhV6+he
         YVyIJudsfkCH66xVPkKPVrQsUst8yRrGBwvxQHqLkhSQN84hUO1KL+uKTwWqgVcE2dMa
         mj/z0sUvMcHNJhBBxEqCDRaK4ZcnrEhnerKNPuPRnwmgCarQanfeqdYCIJL+MKIknFXf
         XOZaWLRUFRP4GszZn/B7fmEb2NJ53qTJxJpZdPJMArMFK9RW2StdiCYGwsuPpZGZggkz
         0LKg==
X-Forwarded-Encrypted: i=1; AJvYcCVumfbKmwEBdQGpanobfdYZYdZduwqTDZALQWFf59806Nn4Q0G0dwIAtWXEG3zr2WNmIdJwN+ur+887d26j/AjSHHjtQZ6CnQ==
X-Gm-Message-State: AOJu0Yz70LpjAPPaFGNghv2EAyFlbfXdXFem0ovL4AK3ZTFYt95vwSHK
	o/Z31VEtnEt3+6dLtnAd2YJlOE4JU/q3gk7MvjN7nDsSvcNiVD/P2fY7rPmSe6SE8Fne8fpkqz3
	ytMZ5N5qfIC6KIO+vBopAydzRi/91YORqqdqDD4UDA/dvAxA8lgIkm8Q=
X-Received: by 2002:a05:6358:89f:b0:17b:6171:adab with SMTP id m31-20020a056358089f00b0017b6171adabmr6105379rwj.1.1708878214729;
        Sun, 25 Feb 2024 08:23:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLWqbRFV/lo5uRx+niwsDYaf3gj/dBLpYEFSQ6YUzFAmNj+KTGCNSHzPLbH22v7CIDVz38gA==
X-Received: by 2002:a05:6358:89f:b0:17b:6171:adab with SMTP id m31-20020a056358089f00b0017b6171adabmr6105363rwj.1.1708878214412;
        Sun, 25 Feb 2024 08:23:34 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9-20020a631d09000000b005df58c83e89sm2523823pgd.84.2024.02.25.08.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 08:23:34 -0800 (PST)
Date: Mon, 26 Feb 2024 00:23:29 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH fstests] common/config: fix CANON_DEVS=yes when file does
 not exist
Message-ID: <20240225162329.ax3zvbs3c3fgrqcg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240214174209.3284958-1-mcgrof@kernel.org>
 <20240215145422.2e12bb9b@echidna>
 <Zc5O07ug7e4HVmKD@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Zc5O07ug7e4HVmKD@bombadil.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 15, 2024 at 09:50:11AM -0800, Luis Chamberlain wrote:
> On Thu, Feb 15, 2024 at 02:54:22PM +1100, David Disseldorp wrote:
> > On Wed, 14 Feb 2024 09:42:08 -0800, Luis Chamberlain wrote:
> > 
> > > CANON_DEVS=yes allows you to use symlinks for devices, so fstests
> > > resolves them back to the real backind device. The iteration for
> > > resolving the backind device works obviously if you have the file
> > 
> > s/backind/backing
> 
> Zorro, can you do the minor edit?

Sure, will do that.

> 
> > > present, but if one was not present there is a parsing error. Fix
> > > this parsing error introduced by a0c36009103b8 ("fstests: add helper
> > > to canonicalize devices used to enable persistent disks").
> > > 
> > > Fixes: a0c36009103b8 ("fstests: add helper to canonicalize devices used to enable persistent disks"
> > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > 
> > Reviewed-by: David Disseldorp <ddiss@suse.de>
> 
> Thanks!
> 
>   Luis
> 

