Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286762F533E
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760108561; cv=none; b=qpKpuRvNZlqkIR9/6lgcEO6ZWfm50oDrBzD3pz3jaTsDR3zkKpb/IjcXd3g9siUzP60yrEENm849i/7a3ZCU0tpiOxZs62/zUBNXivncU0O2rK1i4UnT275guoW3B8Av9Vp03/W6TH52F5HsxJDvAbHBf8r3DMn8XZ561nNfGiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760108561; c=relaxed/simple;
	bh=lLjhJqbBDQ/a2E91zif4RZ281K6W6HFigWXT0cxbz3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OTeXRCXWQ1HJEVW+Ejq/u48Igoxc6TYCIOtV3pHB3El4NEEUwO8cw1cgQa+sqRLFHiCaFbCwGHxEo9PJujo20veZD8gPLf6u5nNYvfSFGw9Jdl/35N0Lp8JRAtz3I83Hf5b6aekbzRNIZdBWdMRljDWUOLd/SJuC/LqSuo8jbE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WGIN4YIK; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGIN4YIK"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3d50882cc2so414409166b.2
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 08:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760108558; x=1760713358; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLjhJqbBDQ/a2E91zif4RZ281K6W6HFigWXT0cxbz3M=;
        b=WGIN4YIK1joyEkYM55U/1AbD2N7rjG1swepzg62ODZh9yZ7xk0jeofLtpaRRgKqNpB
         1DmpCsoezpZXgpPILZ0j/VS/xViHVLr5bPkuMolouz4NjwEwPtBrbncDPPGA31ODKlLX
         NU8oLQ8q/QPoGRgc0Z1/1wrB8SFIWJyql+fp39ZWidicb+ypQsUyvOnRAUhYmrHjT7sW
         VQ1O0gGJXmDPnBun1/NSiab1VrYk+uzCwlhyt2aOGE9d7zD0Ep2j9Ce5o2F/LRT0wf3J
         92ycqfihestAekfPRUbretopbUlgjQV4nPb784jFz8NB9Jojebdjl0ZMrWrHAXbjncQZ
         IWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108558; x=1760713358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLjhJqbBDQ/a2E91zif4RZ281K6W6HFigWXT0cxbz3M=;
        b=ptQYtzNcyqdyjmGexWOaGZWWF16SMNGwJ31nixit9kmBLMhar7qqNaocmnNYY+MqZU
         7r9gZysLDWBQSC12zqWO1FS838YcvrZIRnUltUPyvc2rgBpre4K/qXvd5tIWxQQ73Foa
         aqHSOrT/44Da2jbvoFhRfkyuPSFB4N2ZDkt3ItFoDW5Fzhwy194KEUU78l9fcP91OmkB
         Om/IsLT+Kujv8TpViT7hPhIlTALrtcktrczDyylpr4TRrn4KVF5z5IlynOKPL5fduAH5
         5O1O5BQ/+fOvjtnVT4njTn+xgHiwLMrz/SafERRTfuVafqepXrhtHJHE08WqnHxTclXy
         o2zA==
X-Forwarded-Encrypted: i=1; AJvYcCVIl+63GqIVvQmztSB0jygyFRvvSpIUuWm7phYA0JNwyH6TQSMtyBSazoBxPMWtUilAbL41pPmj@lists.linux.dev
X-Gm-Message-State: AOJu0Yzi+UuJ6Q8R61DVK26gVR7HlsicpawoVftpxXP06dSz+05CjhZA
	HFcGJiDL+VQaH9ehkBNAxNvYyBNd2JfRmTacrK2LAZ7sKraF/PMZVUNQjQB/IZpAw4hmHTetDe6
	M68vxOb32BO9dce6AY7gkHdo3c4ZeBt0=
X-Gm-Gg: ASbGncsCyYt0iNtm+Uy72hbHfcK/azNMsZY1IJzQVs/IPsa/N5HLyD2mdG11+V3NAen
	54lHoB1qQOETIajvuTVaa4nSpgL05mGVMGebtVItVErrVOM8Bnczfq4BzPEc8O8yK1NdD/ExuKm
	b1CGt0df+Eyh9DB4KGwv1tYOCXXc7mi1ApZyqAKSHjagT0Wv7kQYDRSncrSH1O7io2CFqO50TWj
	HchlzSKErbes6tDYK30cyzDiQ==
X-Google-Smtp-Source: AGHT+IGa/polL6/8Ynsft44cUD0O1NPKwafCC8Smc6nmBnm4TDK7NhR64Y4hIQgBMI+z098vLRzD8f+sU8sdugojvoo=
X-Received: by 2002:a17:906:c104:b0:b04:9ad9:5b29 with SMTP id
 a640c23a62f3a-b50ac5d1e3bmr1407180966b.54.1760108556823; Fri, 10 Oct 2025
 08:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010094047.3111495-1-safinaskar@gmail.com> <20251010094047.3111495-2-safinaskar@gmail.com>
In-Reply-To: <20251010094047.3111495-2-safinaskar@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 10 Oct 2025 18:02:00 +0300
X-Gm-Features: AS18NWAoVP5WYC_07QqSXrvsFY0nBG5PiGs9ESaeN2ZfR7dfSMsKUbHhpVYPARc
Message-ID: <CAHp75VeJM_OoCWDX20FhphRi6e7rG9Z4X6zkjx9vFF12n7Ef7A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] init: remove deprecated "load_ramdisk" and
 "prompt_ramdisk" command line parameters
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Aleksa Sarai <cyphar@cyphar.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Art Nikpal <email2tema@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Rob Landley <rob@landley.net>, Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org, 
	linux-block@vger.kernel.org, initramfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org, 
	Michal Simek <monstr@monstr.eu>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Heiko Carstens <hca@linux.ibm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dave Young <dyoung@redhat.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Jessica Clarke <jrtc27@jrtc27.com>, 
	Nicolas Schichan <nschichan@freebox.fr>, David Disseldorp <ddiss@suse.de>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 12:42=E2=80=AFPM Askar Safin <safinaskar@gmail.com>=
 wrote:
>
> ...which do nothing. They were deprecated (in documentation) in
> 6b99e6e6aa62 ("Documentation/admin-guide: blockdev/ramdisk: remove use of
> "rdev"") and in kernel messages in c8376994c86c ("initrd: remove support
> for multiple floppies")

With all the respect to the work and the series I have noted this:
1) often the last period is missing in the commit messages;
2) in this change it's unclear for how long (years) the feature was
deprecated, i.e. the other patch states that 2020 for something else.
I wonder if this one has the similar order of oldness.

--=20
With Best Regards,
Andy Shevchenko
