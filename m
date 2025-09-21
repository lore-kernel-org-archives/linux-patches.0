Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E83245019
	for <patches@lists.linux.dev>; Sun, 21 Sep 2025 09:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758446888; cv=none; b=IV8wDCV0Efu46+2OKu40tjIQKEXsIKwSJFufhp2pnniRmHYruGnGg5kUZcQ8QeD38SlEA/dxIciPUsZrmgQ3hMjk3Itj1Jc+JC7mpyH5jxDBo7SxBCEjYQ0mUIDNhFReCedBfYfySOfiL6e7JhZM0V21dWDjA0EKq4Ok0pqZtCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758446888; c=relaxed/simple;
	bh=EtvX6spi3ViWv5XUhchmyhouze8VNd54v4OZj5G0rRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNKxLDUZVJH/cqk3UfHII65tGPrKmK5j2ChEpWuvnKzjZXQwrBT2Z27aO6kQ03vnSVuUKjx8wd+lMWxG5u4iLVFC6nOHBmr41MmqLBrMmRixEi1OAfxKWjNAehDW2YG7VF3Mx1iiB+l+XT8yzHb8pFFdkE9AX0MU0tAb3ZZpuno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cfbjtaas; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cfbjtaas"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-267fa729a63so6468215ad.3
        for <patches@lists.linux.dev>; Sun, 21 Sep 2025 02:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758446886; x=1759051686; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtvX6spi3ViWv5XUhchmyhouze8VNd54v4OZj5G0rRs=;
        b=Cfbjtaas6+tC5n3Hg9PmgxXZwa020JMPbgXHdbH6Wg9Qs/eHr5s4x+oyQHZAFAC+4Z
         /t4dLOT4rTK8AwM7YV9UrrZZoj9Vb1Gaphap3tP9O3Ow295LA90B3zl8wzvZusSHAYO+
         YYyZCrXoqWtBF9spb8eSlhu8GR5X5aOR+/OJLZr8kgD/11Yjwa3DM/g4r96Q71CSpnd+
         EM7r8Tcen4ucxoZkaSSrw9mQDwLip70I+nsZ/bdizLPOZjqtbi2xWvhVFSwzrqNhBmNF
         Zf+wqKsM8vOS4NWWDaGGyiWHbZEJMGGvMkBhDijNy3mdnHyg8mrXDHnfh5msoKP33dK3
         dY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758446886; x=1759051686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtvX6spi3ViWv5XUhchmyhouze8VNd54v4OZj5G0rRs=;
        b=kc+v8wjs2Qk59pOb3+pu65SgnmYXQEHjRwlPVqCZ3a8jSg/xznJ2+1Mb98eP4PpEDt
         hl1Q7RpY1Tm88/kt9SPF6oySzIMV6VBTleQgmF6d2+867WrHmk+KfG1aEiriEx+w3sze
         NIDNm8njpnXFYqQ34+FA2wDTb6Ax77SeuUEbb+Krhs2k03RPGPnZCuoCIzCsHn5TTRqD
         I3o91RG0vs/oIeVuXNJrW8ebL3LZP6XxatLq+6c0CzMnoX0iYw2ee1AF2iYwUZ9zZMKl
         8g71QPfNGs2pi+talnSA1v1TCQcooDci4SYK+EmWQLwbIHI4PUpOvU3HOKlq/oF6Oukb
         pXJw==
X-Forwarded-Encrypted: i=1; AJvYcCXcXJy5g3gPp7aifZ485ZkF2sbRqp36TxW341bZu6ysIY9jqL8OkL9vhfokbk8Ed9zLY4R+B9GR@lists.linux.dev
X-Gm-Message-State: AOJu0YytPDraBQLyrylYNsjrhctvL2OjVGyXCuYr/l1LWW/cPg1ykg3v
	Zdntn6oo949A3q2QSxaDnqkcR4LVCJr34+rJW3R4X6VdLcpb3UyIotVWrY5HDmJSZnCyf3uBS7d
	hUrh9i+BKQE0c3nEYh26GUX9M3wrNyF0=
X-Gm-Gg: ASbGncvRPrBU6ZsA7aoQpdFWJuqw/riNYoSuXy8+QcXSL0W3aCaelw9YGmt+BGB9Era
	WNpIJmpQG6oeQLQ2gvJ/GRO6v3O0SKKDMX9B4JYegp16DC8tPOsBgHUkHtB0OtVLoCHGoAOXRlA
	68/2yl8LayfSOX75PY2WyntrSboPd2+vfK3PlTPyAxTahEzrbswLY8x6F4JWclJGRgIj9Y7K48E
	8vRuhqdgJbCujHaObGsRXEiSUA+fFowrbK5VZgqEOvRsg3kOzmhWJ85FZRQBh/FzD5vVW4hHI3r
	SADC6eQzN0cBcDuPYyna8xBTTg==
X-Google-Smtp-Source: AGHT+IF+Dy0mlMIwczvjkrGSGBlKSHADOTMAlhPepZLysPmcUI5cC7xm/X9KEYN0oiR+8lSYpv07g4tim48igZ6n/UI=
X-Received: by 2002:a17:903:60f:b0:269:af66:5e70 with SMTP id
 d9443c01a7336-269ba53ab71mr45154625ad.9.1758446886509; Sun, 21 Sep 2025
 02:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250910140212.997771-1-ojeda@kernel.org>
In-Reply-To: <20250910140212.997771-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 21 Sep 2025 11:27:52 +0200
X-Gm-Features: AS18NWAoOU3I-I-O4oc7FCAYxbAppgw72ctHtbKu_NpY6kqn7EZ9tMfGQmUs_fs
Message-ID: <CANiq72kB5hCC9A9bXEx489E+SMMFcFMiJB68NHA7megz2aG5HA@mail.gmail.com>
Subject: Re: [PATCH] rust: maple_tree: fix intra-doc link
To: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 4:02=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Andrew: as usual, please feel free to rebase if that is what you
> normally do, of course. This was in next-20250910. Thanks!

(Somehow I didn't Cc akpm -- doing it now.)

Could this be picked up? It blocks generation of docs for linux-next. Thank=
s!

By the way, there was a rebase -- the tag should now be:

Fixes: 6a25c101c7a2 ("rust: maple_tree: add MapleTree")

Cheers,
Miguel
