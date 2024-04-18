Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5C316D33E
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713455070; cv=none; b=gkPs1dn14QANo0TVp8+thBQxJMxV3HMZsHtBaVZ59sjm1YiVBkF8mVSuRD8j9LG+P37z3LslUB6q7h7HDxkKc6OdkFRezMsDGg934EZAahCpjsK+syyjjNApUDRzhqnKY3oIGbd6M6whglz5IHpoX9NnxA43abOCvM5ekSDOBEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713455070; c=relaxed/simple;
	bh=eW41FDAYitNVnqBwCLv7gIF9iBGx/T1PWewJl/Lc39k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V9ycTdtrnU7Ku4o3zJB2KpQPhsGCV84vUSz0H9kb0ubup+vHSuyPBfhUWTPK4N9K+/AkAfxv+loFnMNSq76sOkq9YtrQ7BNli/EEsda5gjuQr5f4aX2xrnLF1SaCWcFa3f5ZHLWysqOQYjbu6q6p16quSHRooOeaSWut/Z5yc+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zBLG9qh6; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zBLG9qh6"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-34a3e0b31e6so209551f8f.1
        for <patches@lists.linux.dev>; Thu, 18 Apr 2024 08:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713455067; x=1714059867; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UtCAalpEU3sOWMKDUifAwR/7NkFi/BBuronL/FSnyNk=;
        b=zBLG9qh6kYDHDEPMPuvwKNhp0KgWBkP88LkyOu72Gv2VTE7DQTlP2dyoEND4nokzFr
         GVgDGWj4IbxaXj0DXQkJzhivu20g+IzF2irJDlFYqmAJNL5y9IEkvts9j2h+a2YsNhDV
         6eNUpumOCE7Esn2RJz5Nn3rHyMWQ1EyTOnFoNSlOUWCS7g41FAP6EYwl2Lf0tcMPDWpf
         KuwYjUAYc0Bl4uS1os0rhr4OzWaauj3UZ0NjggwzSiiNdTNh8ThrlkUOZBFFrI0aTTBw
         upf2i3+s+EkLdWarBi43n+dnewhF05G4DvZz1Z/ZuK/xq1wli/nu+LXvXE5YGNHMs0Y4
         Ktiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713455067; x=1714059867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtCAalpEU3sOWMKDUifAwR/7NkFi/BBuronL/FSnyNk=;
        b=vCvsidTnu7I50It+Gh99UmPnatu/nJewkPEU3+mPnPbf/ms0OE8WNJh5ON7Op5v2VW
         QZ6gz8KQp0gAmH7+DrWRuhrL9C3CXQdKlCBWnAfQRj8gmVbnzxVIV0LuxuuCgKHy0Loq
         2nE740JLqDRe2TvP54z53BRcS6heVzimxwrC9Giwg+r7Q9BlOU828sdobws25Y+x/6xF
         m7fJ83A33f5q4BL08Pu8lx6LQs7gvDwS6vGgXPtNj7QCE1ARFRIG8JkYBNOAW7dVCKgl
         xURimBSCxUkNmOwPCyR1P4MIFNFdYNgP2chvWcxULLA/Vx9p1H4+zLIwbt70Hago+CTT
         JhdA==
X-Forwarded-Encrypted: i=1; AJvYcCXe9/khHFznqRsEUs2JOXLMxV9bp6eWEV3lAf0+ikhFct9kbQ9HOLruqHSsdeul2P5gaeTayEpuWdpzySxKIEIJpsJN5rbkFQ==
X-Gm-Message-State: AOJu0YzFionax0yWCifwohjWvt9xxYy3dQ3QcVEfUFyHrQ0y1vpFLAYY
	itt8H52DuhVFDGGfRqTMaQCNf45eTsOn0VXkslzjwssy0YgELV3W4HMFl4KFdlqnKPfzd4l9ozV
	1qG2F+yVF+GAFuP/7JZ2IEIOt5YwO8LivcXbq
X-Google-Smtp-Source: AGHT+IH1/hV82bCx1Gv1NIXaALjYWfsTvoaiACaL0kbh8+h0DPYoNJGE2WuAkBJUelNQ/WhcocDOHrc4DjFmQeedIa4=
X-Received: by 2002:a05:6000:912:b0:346:cd6f:40d4 with SMTP id
 cw18-20020a056000091200b00346cd6f40d4mr2059470wrb.59.1713455066857; Thu, 18
 Apr 2024 08:44:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240417-x86-fix-kexec-with-llvm-18-v1-0-5383121e8fb7@kernel.org> <46343CD5-24D6-46BF-92A7-0B0FA0E6937D@alien8.de>
In-Reply-To: <46343CD5-24D6-46BF-92A7-0B0FA0E6937D@alien8.de>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 18 Apr 2024 08:44:12 -0700
Message-ID: <CAKwvOd=3Jrzju++=Ve61=ZdeshxUM=K3-bGMNREnGOQgNw=aag@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86/purgatory: Avoid kexec runtime warning with LLVM 18
To: Borislav Petkov <bp@alien8.de>, Arthur Eubanks <aeubanks@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, morbo@google.com, 
	justinstitt@google.com, song@kernel.org, ribalda@chromium.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	ns <0n-s@users.noreply.github.com>, Fangrui Song <maskray@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 4:15=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
> How much of this silliness should we expect now for other parts of the ke=
rnel?

Looks like ARCH=3Dpowerpc sets -mcmodel=3Dlarge for modules and ARCH=3Dum
does for the whole kernel. So that LLVM change may have implications
for those 2 other architectures.  Not sure we've had any bug reports
or breakage in CI yet, like we have for x86+kexec.

> Can we turn this off?

Maybe we need to revisit
commit e16c2983fba0 ("x86/purgatory: Change compiler flags from
-mcmodel=3Dkernel to -mcmodel=3Dlarge to fix kexec relocation errors")

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3De16c2983fba0fa6763e43ad10916be35e3d8dc05

at least the -mcmodel=3Dkernel addition (since that patch added a few
additional compiler flags that still LGTM).

> Why does llvm enforce .ltext for large code models and why gcc doesn't do=
 that? Why does llvm need to do that, what requirement dictates that?

Google is now at the point where a few binaries running in data
centers are measured in the gigabytes, and attempting to link them may
result in relocation overflows.  From that commit message, it sounds
like they link together object files built with the default code model
and some objects from the larger code model. Putting large code model
data+code in distinct sections is helpful for then being able to place
those further away in an object.  For other architectures, the linker
may insert a veneer/trampoline.  Not sure why that's not used here.

https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html#index-mlarge-data-thres=
hold
makes it sound like GCC may place data larger than a certain threshold
in a new section. Dunno about code (.text) though.

Arthur, you probably happen to know more about code models at this
point than anyone particularly cares to.  The raison d'etre for
e16c2983fba0 was avoiding R_X86_64_32/R_X86_64_32S relocations.  Do
you know if there's another code model that can force R_X86_64_64?  Or
is the large code model the way to go here, with updates to linker
scripts for this new section?

+ Fangrui, Ard, who might know of alternative solutions to
-mcmodel=3Dlarge for e16c2983fba0.

Otherwise, I think the dedicated linker script is the way to go. We
really want tight control over what is or is not in the purgatory
image.
--=20
Thanks,
~Nick Desaulniers
