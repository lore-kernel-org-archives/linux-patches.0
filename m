Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FBF5FDB9
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706022373; cv=none; b=Md5w6oIDZXfbUHmdQUJTpqZoHHEbpljinRVSbm3eTLADom2A/j/sz8ra989G5jy8y12A61jT4NDZtvzUBFekSqhX6n+ctS6sV9jR4YPJFs+TgybUdhcWPpp1z+FFwE0GSdLHFkAcy0A/MYj9xCzd+QITg1qZVeNEb0AAx8WHMRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706022373; c=relaxed/simple;
	bh=Hvxo1xL/yAymti2UB/udHZzJ/RVBSls+IizfWvbqLak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7IzKdIQjRBNV+fqBpTafYrsM1CB1PTtDXm8AEq/y4ZONKbkjwirVLeuvAA54Yzmh9vqbsB0neB/HrIDqwVyJfq/QF/BHWSvS45xgtlKzkVyfLiah/4DCQx/o7BDqdk13L/RRtEovs30sZJPoyqqra0olZhTgIKHeTznWA3VTt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lf1ddRWY; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lf1ddRWY"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d746ce7d13so18590555ad.0
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 07:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706022371; x=1706627171; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Glva58k+YPNkEy53xnJkJEf4Saze9aPKJ5KXvwWKR8=;
        b=lf1ddRWYRBcfOCYK4VDTRchm3V5dhDsA379+9frDmH4dEdiQB4tPgFQisAVdXP+iZ2
         McL8v9WJtYHN558YJY9W/iymUxkIaktIMIPMvUEg+I835BJ5KfNY18sADUzqqOG7zJpK
         fi/7RWHEFQ6x49Xje23tQMEA5IPYw2mliNqkVStXoSZJQXjMSwlwWPvNhbrdQmKtosah
         cklu5y+T1ltVJRQK398YgS9loRyRhI6Hkuw2maaQxGfrAIguuNgMtTX0jOCtoFQWsJ/W
         +Yw5x1A1zkKTfCOiEkv7Z8AKQC9aq7lah8KEapDZVflz5xrzfIFOivv312+K1+/bDYfg
         MaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706022371; x=1706627171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Glva58k+YPNkEy53xnJkJEf4Saze9aPKJ5KXvwWKR8=;
        b=oq6b78ksogeGzCZfB9uBuVJwrDPIESiFfiP+3Ikle9rEEg/iO+q3Ev31HY4TZCCSIA
         Px+dnVO9baAsfZ8CVSdEuUSMWmNS6re1j3MyN0yWUk2eJHdpNsjNZPoy/aT3GLZi0zU0
         AZc/dTiB5mDG2EHHoPUTNx1NDFuXUINxVzvKv1Bh4K1WujmeSQfpMlbaevQfDGoY2hrA
         lYXK9TTGM61N2grCdmjM1lkfr4j06Qe1Z/ayvC3qcIjRL1/6eFp3GapRVtC8Ej7xoijl
         t4Sy95aIb3djM7WxymJ58qRTj+XpiLb31miGKn1pmgePnt0pAkwvq8I6WOkeLXpNG/cP
         OZgA==
X-Gm-Message-State: AOJu0YxbYB4P59c19MfqkR5y97IIL9oK3aMOIeZL13MQkzYc6NKk0hif
	4limGG9OwU6VtzW+WX3nve+FGcUbpezpfNHTeMAYID5R5Zi/IkYLdbw8IXta2KrB5q/cxVz87xK
	M5A==
X-Google-Smtp-Source: AGHT+IFaUu6MulGNobBRg7zVXgcE4Zx+tJD59jwWQePg9cWYYloysGr59cpxq43TgRsCpLZqR0LAmA==
X-Received: by 2002:a17:902:ec8b:b0:1d7:4f89:b107 with SMTP id x11-20020a170902ec8b00b001d74f89b107mr4053062plg.134.1706022370847;
        Tue, 23 Jan 2024 07:06:10 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c25500b001d756bc2396sm3253890plg.192.2024.01.23.07.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 07:06:09 -0800 (PST)
Date: Tue, 23 Jan 2024 15:06:06 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>, Todd Kjos <tkjos@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 167/194] binder: print warnings when detecting oneway
 spamming.
Message-ID: <Za_V3pUCssU9we2u@google.com>
References: <20240122235719.206965081@linuxfoundation.org>
 <20240122235726.366071549@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122235726.366071549@linuxfoundation.org>

On Mon, Jan 22, 2024 at 03:58:17PM -0800, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Martijn Coenen <maco@android.com>
> 
> [ Upstream commit 261e7818f06ec51e488e007f787ccd7e77272918 ]
> 
> The most common cause of the binder transaction buffer filling up is a
> client rapidly firing oneway transactions into a process, before it has
> a chance to handle them. Yet the root cause of this is often hard to
> debug, because either the system or the app will stop, and by that time
> binder debug information we dump in bugreports is no longer relevant.
> 
> This change warns as soon as a process dips below 80% of its oneway
> space (less than 100kB available in the configuration), when any one
> process is responsible for either more than 50 transactions, or more
> than 50% of the oneway space.
> 
> Signed-off-by: Martijn Coenen <maco@android.com>
> Acked-by: Todd Kjos <tkjos@google.com>
> Link: https://lore.kernel.org/r/20200821122544.1277051-1-maco@android.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Stable-dep-of: c6d05e0762ab ("binder: fix unused alloc->free_async_space")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

I think we should drop this patch from the 5.4 stable queue. I assume it
was pulled in as a dependency of patch c6d05e0762ab ("binder: fix unused
alloc->free_async_space"). However, I have instead fixed the conflicts
for that backport here:
https://lore.kernel.org/all/20240122235725.449688589@linuxfoundation.org/

I was not aware that this patch was being backported and now we have the
following missing hunk in this v5.4 series:

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index abff1bafcc43..9b5c4d446efa 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -344,8 +344,7 @@ static bool debug_low_async_space_locked(struct binder_alloc *alloc, int pid)
                        continue;
                if (!buffer->async_transaction)
                        continue;
-               total_alloc_size += binder_alloc_buffer_size(alloc, buffer)
-                       + sizeof(struct binder_buffer);
+               total_alloc_size += binder_alloc_buffer_size(alloc, buffer);
                num_buffers++;
        }


Dropping this patch fixes this problem. After all it doesn't fix
anything so we don't need it here.

Sorry for all the binder backporting mess.

Thanks,
Carlos Llamas
