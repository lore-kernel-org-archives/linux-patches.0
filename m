Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017281ADC83
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744121584; cv=none; b=rPdy7OuwzrHjXHh2Ak1+ZsxT0vI5oa3HjTGQcPVzHjYLjbvoRMrlc0+1473nEYOpv/EZvrSXt4tn4NUgdz/jp5RDIR7+wrk8h9rFGLdNInk67k1b3gMyxZe87xbVbvXo0v0b7UGB+DymHhawn7iQc4gOrX3xZPohldpGo0//Ux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744121584; c=relaxed/simple;
	bh=vu5ZtAxXaIPJIu6G6Dc4xF0xOZd140ZczFGd5pI6jlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G8PFyq/no76s/3A3spS4gRqCQCT4MRPRmWeME8YyIKwbM7GKlaurL7v/Z+31bIkFLEHfEsSL4ZYlZEGsyzPu3Xp/fvEGUxAFyKFauwa1WqSNYsJKDjmIQmfhkVHYznRaTzMqJllT4+O99h5SB6KZaOSqumSbpv4xFkPs/bKhyZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LY4KREWJ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LY4KREWJ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3912e4e2033so2569019f8f.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 07:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744121581; x=1744726381; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XYRdpKVYxG72NqGl3LmzcJbX8dW9gD2B/n7NOHyhSaU=;
        b=LY4KREWJIdKxXIIreX+IQEA+maiaHRks9XlXaMj33fPhUTYXxkG59PeGuvopt9rlUN
         ogGrHFfm5IhgxYOyadCVnCglWSn3i22ByDRP7XzTZgZ/vO3hDVPnGh4gdMjkOqgMEHaS
         cdhS/M5S95ariWz4TdhhRzcHlQfkUIeMKpE11VSaltgnXwb3Yi2yqsiDAcqtmTJ7sYdf
         wuv8Rc2Z7IpI1/DIeWLdL6NY7b0l6MV1q2oubJUDbYgY6a24JVad/elAE/FKqA45To5T
         qKXApfVW7f7vHU0OkbQVBT4oDPsO+EK1V5KbEWSyRZ5Z2kYAXy6Vi6foZ37a0h1C5nDq
         202w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744121581; x=1744726381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XYRdpKVYxG72NqGl3LmzcJbX8dW9gD2B/n7NOHyhSaU=;
        b=QM8NZLsZaGtFB7tcOkVJvzhd48dJW58Nt5Uan7wZv+O08vkdfgAcR0KoiG8y9yP4it
         yuSCg0blLmErnTSNsWk9WP3hLf7Oua3X05fVfQ6WnnCg5VoYLbUPkjCkZfo+cECnKgOi
         CTt0fl2v0Tu+y1Ik/W8vHhWdnk66hOPb8b6PoallnjdK5zR3UiNL4SnOjUoZgefo1X3c
         MxkEY7fsyCut3pHtgHdPnUdwZYWpk9n9Rc0GFu/Sm7BSRcbxkSfIcV8U0FZdoqjjDZFP
         +Arwa8NYcvnoZfTF1/YC9Bv+Wjm3Bw4Es2bPelqHlEPNNVBu8CEuyDMIy++fIpMtkmzH
         di4A==
X-Forwarded-Encrypted: i=1; AJvYcCVhBwCZ295TsWY5Ge6aLk8UGMiCWTVZiuqc0RO5eh1ZQ5mSGyc5n7WnaOB52I4hFifmKZt9jeut@lists.linux.dev
X-Gm-Message-State: AOJu0YxELJNjyQXJPx7dwpz0cx5B87MDetxe3IHbsIHQD2wpiDxMnfWq
	ZZ/kkskpL118HIA5a8YtCKoePbX9RRm67OiyA8Hc2y7H2RjHlFTkZGdcVVTFM5VhLgGbDkWTntn
	sZmlZa5yJkg==
X-Google-Smtp-Source: AGHT+IFTqGpEmdkt01UFoNX8g7+m5zMPhGy/7or+G43QMZih2nLy9D/JLVI5c5leGTTikGNxHdrtSeXmhOUigg==
X-Received: from wmgg6.prod.google.com ([2002:a05:600d:6:b0:43d:5828:13ee])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:584c:0:b0:391:43cb:43fa with SMTP id ffacd0b85a97d-39cba93cf0emr14625227f8f.51.1744121581367;
 Tue, 08 Apr 2025 07:13:01 -0700 (PDT)
Date: Tue, 08 Apr 2025 14:12:59 +0000
In-Reply-To: <20250407200508.121357-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407200508.121357-3-vbabka@suse.cz> <20250407200508.121357-4-vbabka@suse.cz>
X-Mailer: aerc 0.20.1-1-g87e37b93d34f
Message-ID: <D91BI0ICWA7L.3P7ILKPYMKGMZ@google.com>
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page allocator
From: Brendan Jackman <jackmanb@google.com>
To: Vlastimil Babka <vbabka@suse.cz>, <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>, 
	<patches@lists.linux.dev>, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon Apr 7, 2025 at 8:05 PM UTC, Vlastimil Babka wrote:
> Add a subsection for the page allocator, including compaction as it's
> crucial for high-order allocations and works together with the
> anti-fragmentation features. Volunteer myself as a reviewer.

Thanks for volunteering and thanks for proposing this update.

> Extra reviewers would be welcome, including/not limited the people I
> Cc'd based on my recollection and get_maintainers --git
> Also if I missed any related file please lmk. Thanks.

If this is a "more the merrier" situation I'd also be happy to be
an R: here:

+R:	Brendan Jackman <jackmanb@google.com>
