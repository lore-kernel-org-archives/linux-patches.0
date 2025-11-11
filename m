Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B0E24BBEE
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762869542; cv=none; b=gLyESlZolzBhe7PH8+bzx89ZXvDXKrMKFbRbmZL6dXURQM+3jLErAcJbhogtwMZlUXz2JkfLh22GQ6KBagB+lr9G4p/ZwKBuzZGhOFLd/3fgnliAiuQVYHtJE2/G1ntaIm022w3dIyZ7nnS5CqtujKMK2VivR+v5sBh3yGW4b4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762869542; c=relaxed/simple;
	bh=hRUmzVbCzzL89fOTZQBAaUfGAwTMnx1MK/93dcHh+is=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cfA7CG8ijWuDP4Hv9GZLVzFm6I+F7DuIIeYpHl5Mbv28qm1jFFHiobVWzFgDFThbCcDb7Wl54C/IrizlMEVOqVBlOwt9tE4YYTUqyT+i4EKo3jNhfDrMfWSAQxZFpHxszYeHy1enIIo72Lpl41vxiTVnIUDz0QX4Z2SAKOntZUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmPydQCb; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmPydQCb"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297cf964774so4855775ad.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 05:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762869540; x=1763474340; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRUmzVbCzzL89fOTZQBAaUfGAwTMnx1MK/93dcHh+is=;
        b=HmPydQCb9QVz3GIw2R413bv4c3Lt2IS1cjD1BEmj7EJu8Blo2A/gmkvS6LaBpLxfbX
         TzYBq/Rlu6uW/tWhBTm9HOCE3Q+etwJvS9ZbK08UsqlUb1MCe30wcx4AuKC9TbegiRms
         mt6tfqZg2Giu0XymQ6yXt2rjJ6DowO33Nbeh+NfATeq5VcPs+dvgvIa1DITFcdGMfrzj
         uZIiaJYvVOOxyzZLd11g/uugwexvAvpM46uqPIVKH128xzXNrzO4QQftBML5T4wtuYTS
         C129yeu3jvuqnmlhWoKrXWVnufW348pFDn+vId+UH4q13hvhUz3CVNpM27XKvDfofKaz
         fnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762869540; x=1763474340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hRUmzVbCzzL89fOTZQBAaUfGAwTMnx1MK/93dcHh+is=;
        b=uBbcN0Ie/47L7J1/Rz+GyngtKUYV0k0GjJjQnFPM+5LvFsURl0G/bCUOTBApdmsUPR
         cdQ9Hr7BQuOYMMCzIckSz6T7rzUWlo65odRPD6teqbW6N7saC0TRjnW+9DToxLV34Zcr
         qKP9ULV6H4kCocux/yAtkSR1HidS/jZdJb9jDCmD0qLRMzdMFn4F1xF31FOeAY/5iHia
         /hST/TZ0eWcuqSJgglCnyIzTXCn5d7sH/hdFOe0coreaQl5u47TMWzXhYJh3qYRsJSkm
         sxvehhBLPm9tjBpB/fKYRh8x9BXtwYaP3MvfceJNFT0EwoXqeN7R7O4f3a48ryKRw5yb
         5lqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRzltF9kBPqSs/Zf3ZAIX5qf6gUTnmx7OH7PUVipZK7OB4a+5wiHiB9olBJM3yoa2R4NhBtK4C@lists.linux.dev
X-Gm-Message-State: AOJu0YwvNv9DswXz8Qy5DGN4r2PaSU0aUjWxUpYOu8ZWZTVHTYm4XOH+
	mu0NjVsbE3WvURXMAbjEF10IFJpTPHShKQPtMy3pvmUDN5OzVm+tacTEaVsc5F3QBiB+AoLGKKU
	euocUtEfDaCKU4JRQfqROFWqJImnxmSo=
X-Gm-Gg: ASbGncuvxUvC/YSd40xFovA/l0Vl1iCp9qiVFo5UjSyTwzim69V233VR88BU6F0bHh9
	RoDVy0iSsBPiPx/txIHgy49/mN1uumh6onv34ES4XNNaAWwFn7fygP/rgT9KugkEFBfOLLzj9/S
	NmT0/oxm+5PboYiJC9tKnpo0oRQAkcILzYBd37njtkuYbRym0Q/Pp4AIGlrm60Jjfs9aSgAqRS6
	1ScDBNvFyw4C57V4V/VuTuKLqxNXhQIuqeTHXnY63tP/AHxeYzrySF63IeqsQCSaPso+lu7sNw7
	68oLPJdpglxSPBZEJjZQqxEgFuapvfp9X9ESs8TDNkWoIUjpr/j/CqqNFabv8HC7MwaRZKQOvfJ
	P0FUfOP+8qo4S+w==
X-Google-Smtp-Source: AGHT+IHYXxM/I5GaOybb6g1yecFYohV3zCOa1VEm8f2yGvBo9rJ8osfE6aj7FDf3tvSiEZ9Z9+sidUs9ZqMaIBw6rqE=
X-Received: by 2002:a17:902:d48f:b0:295:54cd:d2e2 with SMTP id
 d9443c01a7336-297e4d096a4mr91553105ad.0.1762869539841; Tue, 11 Nov 2025
 05:58:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
In-Reply-To: <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 11 Nov 2025 14:58:47 +0100
X-Gm-Features: AWmQ_bmjChoTwnLfQhUmk8zTDZP6XuF3N7zYh0KKb3TDMGl3YRN3n87n4dAkPXU
Message-ID: <CANiq72kaoYYMq+ghFsa+YrRbTE13M2TrtOMwAK1eV1Sk9tEQzg@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 2:54=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> I will send a couple other fixes to Linus this week, so if nobody
> shouts, I will be picking this one.

Of course, if someone else (thanks Haiyue!) wants to give tag or two,
I can still pick those up, and that would be very welcome.

Cheers,
Miguel
