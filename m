Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A4224F0
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584875; cv=none; b=XhzEbOb3fILH/8NY/X6SDxtVUQxKwoylB7qXIsnw03jvelDRfjxGQH/eBZ+CJY/t/iCMyzqXPgZZedEF9rN1f8s4iGXT14L8GQpxbaIh/66lKJTMUQSikrRs9OA3WVB6DyIU6ajPRm1m2QdxhtByZCGjA7a/DiMSVqm24yjXf98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584875; c=relaxed/simple;
	bh=SMUGHU1tlAHroUFUxOTLiqDZd4Tf7fOdjUDfe7xlMgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fi8S/KMb4vYm8aM9wsj0Cmjf0zsNJckz7agBASMPqUuC5ayVJCgm9i4Udj4pzD0GZ92LqgXg9yn1R7wvB6x/sENPm+r8a4riMo2rGrc04qmQjy9x3Gj5zpHV5KncXb5nkfA/WUHpFnrnlvZZu86asviB493/n01Y5y2xxTNkQHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=Q6joBG4X; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="Q6joBG4X"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-6dbc75acbfaso29090497b3.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584871; x=1728189671; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMUGHU1tlAHroUFUxOTLiqDZd4Tf7fOdjUDfe7xlMgs=;
        b=Q6joBG4XO5oMefgADW4zbWkGn9qn0L3W4IOMvVhP0OTcdRAI8w78LWEe5q8SMRItMy
         RCqAyZWUFZL2+JRyWeGw1yXaYQhYiVgKj67RZp4jKiKnwpe6lFDEhSc1umdFlKxK/eg5
         3jHtizNwn/9DyzjS/Sgvsy5HXwT5jyxktVRSNEldzerRBrQX+B1jVwGu5dABzIuPyUoh
         JiWTS5QQoW+XWy/QEWGKL2x44YBK0ZTmAT5MZ7xwVcOPZd2AneMC+XklRwysUs1dySgH
         oWOA7TPoXEspL3qn9KEW/lQNCz0/r003g3Abvbsom4IH2TT4phSkx00impwf6afYxKiI
         0aMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584871; x=1728189671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMUGHU1tlAHroUFUxOTLiqDZd4Tf7fOdjUDfe7xlMgs=;
        b=brLSvbC+mzIDDHvdER/DpfH0wC2oyxJvAGtnaIXFAVR2XR0P4r1wjLYWbgIiUKBEve
         UGNKLOavl50EqVblrzGKVZWm9HL4e1epULgP18nKNK4FgcJFz3+97tR2JaRSdjhMhz48
         I/70RQju4OQqDAhyGpTiuIaKsVrLN/i66D0CZZgQ31nw5Rz4mMXWAclPM5URkhr6gLvL
         kusl1ExL6MV1JRTM0Id/IrrkHickjK0muY9s6BjiShE9UONNzMErAYaG1eEUKXB21ZKd
         +UOTZzAJtEU6IkZXzCFFGU03aWOQnD9Ef5+f7a1LKD5BT9IjWL8fWMh7J+TmeVinZ0uR
         LyuA==
X-Forwarded-Encrypted: i=1; AJvYcCV53KIqb+OeaAcn6StamsNfOysEY117TLI0erdnX7pnMBeATNvyuv5IYhlEgzUNG55eJiSgNGQp@lists.linux.dev
X-Gm-Message-State: AOJu0YyIadQixTkf/5ydIt6kuo0fYZosO3BdURW1Fje9/kOnDNtS6PkW
	D+FZ0RavaTmS9fiev005X1CpP9iUx7joFW8hCjopuBvxvgHkFUyKZGHXrTh6p5TUcl5ywHnAhoZ
	SGYPuLMcQL3KtrzMJBLbiSKGZcKzadScYCXFs7g==
X-Google-Smtp-Source: AGHT+IG8c/QIBgXtt/wcc0S3Qo6phz3DG44MEpR9Z8fgUtflC0qMPw0T/Tm/a2T5GSPU1vgnITgG5tJX/MgDJSwzvC4=
X-Received: by 2002:a05:690c:60c7:b0:6e2:1570:2d3d with SMTP id
 00721157ae682-6e2473b69d0mr63444167b3.0.1727584871504; Sat, 28 Sep 2024
 21:41:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-10-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-10-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:41:00 -0400
Message-ID: <CALNs47sVrMT8n0zmpOsxymkDvE+==s2MXAv+P3oGYmY81cib2w@mail.gmail.com>
Subject: Re: [PATCH 09/19] rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> These few cases, unlike others in the same file, did not need the `allow`=
.
>
> Thus clean them up.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
