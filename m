Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCDC24BBE4
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 22:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762901752; cv=none; b=h/ceya8pjnb9TaqzCzIlGhS4WN36YybwJTj4xW6iaPwlhwv+fLkH6OsiOoABD9xk7/H6B53RTRw8p5dfL+uvX0oj/l60gCqy+V/4xnMA+eLgNZP60RWafp2eULd1J7LpkBOnPaNE+izaBmoXAzdO0io/LQWMoawjjJQbtAEJHZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762901752; c=relaxed/simple;
	bh=no6awPYlNWD2ZDTvcdrXtI2J2BOWdlGtNS+ynn3kOI8=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=loLqoF6QjFThg/I3eSdm2QOkbnq4fGAjMUi2vIMqmniBqh3Gy9jEMY4k9EB+JSh1p5z84+8vtuUWWYDGx1n52DqKK3DQMfcUwlA2mUfPTjdNDZ6EN7+0A3oZtR4TUXMokaMHj8ldmscj16TpgTL9W4RfR11lYKVrvU/uOCntXqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J9NYM13E; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9NYM13E"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3436a328bbbso296709a91.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 14:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762901750; x=1763506550; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WV8SpjyToHnox8eW+EUZvNmanBSrZ2+/14Ld9cc4nK4=;
        b=J9NYM13EK7pHKfDwFU3U58JaxklDAdQQjx8iKsMIMkcinbBF+mxdN8LL+I84TFw0/M
         CIYQKyFu8aWTJ4iOLVleZyJ5DoL6NiiSxk4BWRbBbeDo1ESRjsIpv42WaBfnEEIh0n6Y
         F4XkNgpfo4jLgPC67GrqP/HzH6i4o17K73TeVAwCxk9H95MqKri2+4n2FHyMIJho3trg
         dp9ukzD60Nto1oZ++vByMM6mVE6n60c3DZLDUdp1iV1zDQaRNQzbi49/l4+iHXefCysZ
         pYIhaNA4h5H2fa1z11Ttn24NRsaHbz5+DFCoOBXR4VUeCKW++eijS6rqCD8tcwHpZ1eZ
         8cJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762901750; x=1763506550;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WV8SpjyToHnox8eW+EUZvNmanBSrZ2+/14Ld9cc4nK4=;
        b=FE4ZSe1+3PVDrmBqgFU99eh+332FBx+uKuAKsH0/T4a1cXfyVJjCEoP7+fZEH8Hj1V
         Z5eswLHk+3W3moU9315SLtz9Q/8IWmq+XC6dfPd49jqcVnhbLeb9qbsUOgWbpGJIwETj
         3VMY2kot/S7m4XYcoGy6YQ+ZuJlr5AnKcp4p/tBEDfvpiGVczoYepDMn/J4pd6riBy5m
         VR7Hb/np9BHg6xyQKcIEaada+qtWwGtO6sqVG8AJwnNAlWKBOje3M3Bbk1iuKbS/8CtZ
         iv6kVPPh+cE0Ufm2I+OsbAxA2R+IsUxifFd4NiympzMx52TK2zaV7n5jQlYz8v493ndK
         sfmA==
X-Forwarded-Encrypted: i=1; AJvYcCVEpzWHrDs59yeYNYPq2TKfl3/MxYIxkAqGBZ7Qg9p853k+LNdj1J7B8JEs0ooRxsko22SBkrH6@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3pVRnxCQdIVlUdL1c5a0syYoSiPWR/q7nWb2TmWWd4uD3Q4Qu
	ztBW3a2ZJraRspYoPSm5a6AC1TmvnZaqdHLj/lrFpr8Kq5gG93E5YIm1EAKDuQSU
X-Gm-Gg: ASbGncuHnJJ7Z43DO8u93ZZCO3CmXOWY/8GevFCvk6KuJ5fM2qInAwIAqEgiA91QheN
	PgpFiTuYSSIwz/XAknbK0cVDAaLXSjsgADxZrcAn1dn0m6/ZjDEMKgN3GSmr092/mWA8dBfHHo2
	8X7lfGhL1/l7DXUDGnlY/e08TKAO024V11o77PTov4zvT4LUn84AMytZshgKDZT89wCUAywVl0C
	5/QMo9bvNg9ejH/V/yQhnJgQdeRpXIxhL8VLymUa1ZVG5EoVjacXlTdiXsCiDd4JaDaNDJaJxy7
	kBvzqbe21bn2GZBQe/0rd7RHRbpbWMr9bPjTU8RVR+dETo7/9Mz1RtM4kMFdpf7re46Q7jJamAp
	o0HAd9SuOFzVt3HzXcBA9GJp1Zv6MHC4ALu/D8fMfZR16kV0UUqb6qOh2+L0TAFTfFGbPHAeaKf
	D7Z/Vwo0wDkX1WRUCJJl0R+bUxjR/LygevzsIJM1LNkmUr+gQVDYjV/5KZitFL1o3Z70CGB3Hto
	cE=
X-Google-Smtp-Source: AGHT+IF4OnkRMbd6m4HrTuqN+m+jnjr3E5I1/MHuhkYwY6fxfKQpu9u5zArrBIuDS/wyoE+OqOffGw==
X-Received: by 2002:a17:90b:1b0c:b0:343:7714:4c9e with SMTP id 98e67ed59e1d1-343dddeef91mr1097421a91.2.1762901749896;
        Tue, 11 Nov 2025 14:55:49 -0800 (PST)
Received: from localhost (p5332007-ipxg23901hodogaya.kanagawa.ocn.ne.jp. [180.34.120.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e07156absm214042a91.5.2025.11.11.14.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 14:55:49 -0800 (PST)
Date: Wed, 12 Nov 2025 07:55:34 +0900 (JST)
Message-Id: <20251112.075534.1069241481796218298.fujita.tomonori@gmail.com>
To: miguel.ojeda.sandonis@gmail.com
Cc: fujita.tomonori@gmail.com, ojeda@kernel.org, alex.gaynor@gmail.com,
 tmgross@umich.edu, netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 dakr@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 guillaume1.gomez@gmail.com
Subject: Re: [PATCH 2/3] rust: net: phy: make example buildable
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <CANiq72=_KAgUZ9u5YY-iw7kyA9R1Nv6eNzZqMLSwOLQk6sR7kw@mail.gmail.com>
References: <20251110122223.1677654-2-ojeda@kernel.org>
	<20251111.083413.2270464617525340597.fujita.tomonori@gmail.com>
	<CANiq72=_KAgUZ9u5YY-iw7kyA9R1Nv6eNzZqMLSwOLQk6sR7kw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Tue, 11 Nov 2025 22:02:26 +0100
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

>> I think that some code begin lines with # for use lines in a "#
>> Examples" section, while others do not. Which style is recommended?
> 
> There is no hard rule for all cases -- we typically hide things that
> are not important for the example (e.g. fake `mod bindings` that are
> used to support the example but aren't important and would bloat the
> example or confuse the reader).
> 
> For imports, some people prefer to see them, others don't. Here, for
> instance, it may be interesting to show the paths (e.g. that the
> `Device` is a `net::phy::` one, or where `C22` is coming from), so we
> could unhide it. So up to you!
> 
> So I think the rule is really: if it is something that we think people
> should see to actually understand the example, then we should show it.
> 
> And if it is something that would confuse them more than help, or that
> generally should not be used in real code (like the fake bindings),
> then we should hide it.

Understood, thanks!

Then I don't think that the imports in this example are important so
please add:

Reviewed-by: FUJITA Tomonori <fujita.tomonori@gmail.com>

