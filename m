Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEC923DEAC
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733826994; cv=none; b=qqwjzgol8IKkjk9N7CyeOzuEejInq0utz97s5eKoWmwoJMdH+hH0hn9BXkFdU6xoRvhDIpzJlnevkeb+Y6qbjK4dndOCuhnBvLbvrod0x8aY1l84NNAWj5yuIjPbIStq296kQy5FhwLpA9k8qqwfegr36X776d92PxRWG4TDaT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733826994; c=relaxed/simple;
	bh=3jnRyQ7rzt93uh2WnUgyckAZtkPU9OY8jK+ghXc7XcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ag0/jx7SO1Y9J5cLnuCyJCj0R+0yxysMRNHO2bOlblIxfP31hxZ1dESdUwTp0vLuOelHIGfgwrGvIEhIyAJfNDlg4W06Bm11P05XZRcVaSPKk0d5xLtc4n5Kqlif7EnM8Ri0HVbCfT+mQwU5lbjq95rGbHU4QyWFoAeWbxmqFHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=a3p5CJAh; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="a3p5CJAh"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434f74e59c7so22821365e9.3
        for <patches@lists.linux.dev>; Tue, 10 Dec 2024 02:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1733826991; x=1734431791; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sen+IiZX0S+/F0Se18eMG9OtCzCvDpM+sc9hXCEuRWM=;
        b=a3p5CJAhXgDNNBGoqewe34zzdbgqAVqwhHxkC3AaK1izw3Hjlmi/1EEVOG2i0R2vxP
         qFCO+R6kZb6NvriGk6fQd0OV2THhZSKp8Pf7PS6mWJuYaGAfIb4NNfr1N3QgjzkiXHLn
         GyTI+qzdCniA3auS1phjM9SFKDC5rH7A6GT5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733826991; x=1734431791;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sen+IiZX0S+/F0Se18eMG9OtCzCvDpM+sc9hXCEuRWM=;
        b=vJ97IgGyC0ymvtyFlLmL6MNCxZRyY1I5bgj+UQL/Ta2inv+YPDe4s8tDdk56lN7ZGG
         AhF7R+qDqP9LZz5pCrXP2ePhPxR74ovL8jHMPwImTMxUahQqCXGugagvkmX3LIiUOaXO
         mgC52gDv/2CRjpAfxNduLL3o65WQIZBUc9NFhaeZiSJFO1m5p7zjqM3cR6wV2KkkTHm6
         Hb8FNOhAdsiEcSdqUPjrNAL6W1bD2ptU72jF74iSgtY4upiJKBr+JI+moPmCCl2T9nFL
         qNtmEmq6yvKgXA6mB62X7v5saq2395Sp5E9xsZUIDV1q8quj/StuZgllewtvbaHEX/h2
         aIcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW1/GjEqPEuByCaE7L5CQ7JCYEq8KFs7Tu9B1+6tNu06IKXKsyC/LYLwSginTgMvZcR894r3KW@lists.linux.dev
X-Gm-Message-State: AOJu0YzuIraRdWqGXQ4OoKpB8T4wpKmwL83dVZaO1/uF0ceXt1K2fETx
	iZml5KTGGdnB8mlzWeZhMk8TOM9osx9Mx34dtVcg5+irWlSawVJNskII2Fw0jYULszcrK4QCehH
	n9cY=
X-Gm-Gg: ASbGncueidUkP1sBeVFjA/MAw46i/uyEW6uJ0+KYq3KGvxnxS21nKqK/rRKrwESxvTW
	0LclK+GpgH+Kp4/vjdghYpe5GWlzrxjyOnMWFpeRlS8dqTq9osPuFeHjmvFjlKFdN3J/yQsMwRp
	XShzYmoUBw7iQ1lVDGsHNoC/aUNbSEmE2iKrcp3jIF53cYxpKvloOkzUzegXcTjSSkJA5PL+rnL
	exmJPimdg5a0mMcLfwSA8drqBpi3ty8/yBIlkxoT2nfYeKA2awEERhOSuiR+nMhjw==
X-Google-Smtp-Source: AGHT+IEV+bbBMZpk2sUNI7COIVamkfzNEBliCeF2KWN5595ZWc//07H+LLjAmbUId5CayTY1JHx5Ag==
X-Received: by 2002:a05:600c:3b99:b0:434:a781:f5d9 with SMTP id 5b1f17b1804b1-434fff41467mr37221575e9.11.1733826990767;
        Tue, 10 Dec 2024 02:36:30 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38621fbbc08sm15782423f8f.86.2024.12.10.02.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 02:36:30 -0800 (PST)
Date: Tue, 10 Dec 2024 11:36:28 +0100
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] drm/panic: remove spurious empty line to clean warning
Message-ID: <Z1gZrEbqzbf01WhE@phenom.ffwll.local>
Mail-Followup-To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org
References: <20241125233332.697497-1-ojeda@kernel.org>
 <fe2a253c-4b2f-4cb3-b58d-66192044555f@redhat.com>
 <CANiq72=PB=r5UV_ekNGV+yewa7tHic8Gs9RTQo=YcB-Lu_nzNQ@mail.gmail.com>
 <e544c1c7-8b00-46d4-8d13-1303fd88dca3@redhat.com>
 <CANiq72m_b4y6bJJ6sB5gUe+rpa51FXtwpwENQy3zGGMtuFJ3Xg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72m_b4y6bJJ6sB5gUe+rpa51FXtwpwENQy3zGGMtuFJ3Xg@mail.gmail.com>
X-Operating-System: Linux phenom 6.11.6-amd64 

On Tue, Dec 10, 2024 at 12:10:31AM +0100, Miguel Ojeda wrote:
> On Tue, Dec 10, 2024 at 12:05 AM Jocelyn Falempe <jfalempe@redhat.com> wrote:
> >
> > You can merge it through rust-fixes. I have another patch [1] under
> > review that touches this file, but it shouldn't conflict, as the changes
> > are far from this line.
> 
> Sounds good, thanks! (But of course please feel free to merge fixes through DRM)

Yeah I think once rust lands in drm the patches should land through drm
trees, or we'll have a bit of a mess. Of course with rust expert
reviews/acks where needed.
-Sima

> > How do you test clippy, so I can check I won't introduce another warning
> > with this series?
> 
> With `CLIPPY=1`, please see:
> 
>     https://docs.kernel.org/rust/general-information.html#extra-lints
> 
> Cheers,
> Miguel

-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
