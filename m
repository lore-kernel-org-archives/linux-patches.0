Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDA222DFB0
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130617; cv=none; b=U9BOX55CTG5zTyM1NnFOScfg+QduKHLE8Rlq72o8gWJ8omaDlmiM41vMW2N/s2rR6se84uEkAJRoErhttghrrbJgNI1cVSPZ15urJGKn3dsVM6FqLIfjnP/A+sTFsdD/y0jo7gcWuBLG565vFLB3zqjqtYm/NsbCKtlK78RBJg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130617; c=relaxed/simple;
	bh=EMGJL06zBcH8/bK3L8ffU+XphSEbrqEm5rUSMYBj7/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qVO8G7yF5dWYQNtSYxUsg2wzfdsVvJeEdLnUT5lBDClRIirUCpu6TNmFHbkpDsMKcvieHhXTJG8kZRAtfvsxHwXW6LbYC6uecycE3KCyrRC5UEjjDAv+NDLC5u5KeI7JlnLuvQbnNmO9pljxc8brlCRECz2ZlV6TPT1h0Sb/EYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IeStblSo; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IeStblSo"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-47681dba807so260811cf.1
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744130614; x=1744735414; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FiKiNCaVFv2Cyr7Q7f6YrTxmfWsn+IwY5nbyf35odU=;
        b=IeStblSo3jBwFDinw7rndl2MMeJMC6gYYXRE9AvrmslnsW2dNanlVBVDOHqacp9wyp
         aIkCIJSaldRDuF4QFqlwW9JGElTZLiIlFe0YlJSce/gTawmK8+TlbQGOgY2Da2P5qige
         M0G/HO65TQ5+s/ZZxnTslmkKj1e+s72SgN8i8tGuuygxQVDoTVJQMI0Rl33/HM3kO4oU
         7td115e2yUA1WO+MmZAHRxMH9emVtuhpVOQWfqGbzIl+xrtjxLpAVRjuV2GYaVt4yhOM
         ftvSPbk5Oi0bpPlNZoftGizjV2A9463fc/OnXdNdkDDGBxlghN9hjOhspgFAVKC39F7W
         +9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744130614; x=1744735414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1FiKiNCaVFv2Cyr7Q7f6YrTxmfWsn+IwY5nbyf35odU=;
        b=caKtkvP8+HCj8xKCQxDd1ZDdqQMipyp6UrzgNSKqauaZrbCo9/+qvOk+k+6ECgFcSE
         LE/XMALVer5WC2t0Y93uT8Ceu2AnwrgEr7k0BGQYS0sh0AcmyEF4Y3bDA79pbWWY2sUB
         WQI5Q1TH2/Rt8AiDpRcLsd4f268BxYWfYVZAsj8p8B2uGcEXQrWYLzBkDV5YU3uscwSL
         bHvMkFo8aY38nEvI5ii0XZ1OjIDrLJQPokmomgqhRsIuaBdjLTGidXLYVEqAPURgBCi4
         yfy56fgKSNIrk5a32Ad9muNfajsNzBtK5bE/BOuXx30o9Rd9YrqJfAyI3MJtWUZuqHJP
         OsnA==
X-Forwarded-Encrypted: i=1; AJvYcCXl/YpQmeTduEaEJqV6djnO1kgwmJDG5iaAocsPPMAcqOAtJzED6M4mdqHEX9S05xMwmYquwgGh@lists.linux.dev
X-Gm-Message-State: AOJu0YwAKzzgELWN0uZq9h+/LK17eWzoVfGXPWlu01goFAVlzL9rF7kE
	+dcL77rR115eECl0ntvYrDrYfqoLCp9TO/Se35t9O28bu7NZh7FWCbtEzJKbUG9gp94l1NoXLk4
	3B3tn57gbZz8TMEM6R/9Eok9t7nXpwLNYKyyP
X-Gm-Gg: ASbGncsEMITzp3UWS4fIkGtILEJ3SGZ97iXMEEVsH/SbpAM05qB6kGKaqMyXZfNNr40
	UKZBPL7zwTbpK93xJ41ot+kjb6Z6WpU02n6zh9Ly7jpuoIU8OIkpQiPcLV9wmHwtCg2Re50Frtc
	hwRxbBucMiqXLnCaEbdrnOd211IkxseKa80vmMW7Dp5cc6BQrBMuOHEaGVmfwQFSFKLdk=
X-Google-Smtp-Source: AGHT+IHUWQvLcrCIeytX8WdQFcIxjeAwfPlwbo7B6E6aJQhKTc0WFzSxKyLGGdC974vlRDvFfaEJkQN1B0nRXBOv2FI=
X-Received: by 2002:a05:622a:198e:b0:477:86aa:8829 with SMTP id
 d75a77b69052e-47956216f1cmr3920371cf.3.1744130614272; Tue, 08 Apr 2025
 09:43:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250407200508.121357-3-vbabka@suse.cz> <20250407200508.121357-4-vbabka@suse.cz>
 <D91BI0ICWA7L.3P7ILKPYMKGMZ@google.com>
In-Reply-To: <D91BI0ICWA7L.3P7ILKPYMKGMZ@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 8 Apr 2025 09:43:23 -0700
X-Gm-Features: ATxdqUGBt28o8ERjPE6GWLD7R0zA_rTTTrRVJtvv2fQ4PNvjAZyr1xF_AaXtqn8
Message-ID: <CAJuCfpEgFTvfAgfrsks_gSTLNfDF0Ehf5tX6FLPwj4piPPC60g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page allocator
To: Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mel Gorman <mgorman@techsingularity.net>, 
	Michal Hocko <mhocko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 7:13=E2=80=AFAM Brendan Jackman <jackmanb@google.com=
> wrote:
>
> On Mon Apr 7, 2025 at 8:05 PM UTC, Vlastimil Babka wrote:
> > Add a subsection for the page allocator, including compaction as it's
> > crucial for high-order allocations and works together with the
> > anti-fragmentation features. Volunteer myself as a reviewer.
>
> Thanks for volunteering and thanks for proposing this update.
>
> > Extra reviewers would be welcome, including/not limited the people I
> > Cc'd based on my recollection and get_maintainers --git
> > Also if I missed any related file please lmk. Thanks.
>
> If this is a "more the merrier" situation I'd also be happy to be
> an R: here:
>
> +R:     Brendan Jackman <jackmanb@google.com>

Same here.

+R:     Suren Baghdasaryan <surenb@google.com>

Thanks Vlastimil!
