Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DCF25A359
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 03:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774237700; cv=pass; b=F/Y2tKC+5IYWbJ0ceskfh7xNyAIJaeQZpw8YWB0lWfsxdZ45dhBIKW1lr9Cr0vNCUrDsuuDXMr/XM964NxbVzNKKvD8khpJelcxo8R4VhqHa+fcXTpItRiwGMqB1rJ9pcsSanP4U5uA9fDkjArmRIKu/p89skcC1phyWT3FJcrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774237700; c=relaxed/simple;
	bh=Q0mI2TwYycM5sgLrcd1zuOS4TrakRSO20fAXPQ2Ywts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rTM3QRj4iX+Ygktz5QpBskvDLrJoTZFZl5jo/6Gg76lnM/MOnF5a5DMG5g7bWfkslUfQ6VaEJVLWz5xmkIQJlTY7sH4fzpEVM5w3n+kKxDE4KeDzonmTHJgonq8g5YPGOQSJuFFF3djH8uY6LNFXMed9KvrokQBObMFYYwfkxNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UWAWzpmu; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWAWzpmu"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64c9707fc11so1476352d50.2
        for <patches@lists.linux.dev>; Sun, 22 Mar 2026 20:48:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774237698; cv=none;
        d=google.com; s=arc-20240605;
        b=VAHQOkicKJVytjPDjnH2BnLa2Gzxj3+UeBY8aM13b1+qMTVPzK1eIkL+gVqNsfa7IO
         9UmT+hiDklN2woe15nfPm7SUhiMGTAkdPbxLn5zQeOl+omkIaCaTmaIkFuj74PFyLprS
         SzsvOOLo5ilK/tv/WTTF7Lv7ugtn05Nqqpww/0cM+vmFhtyWDlrDC63PnN129ILZMaqO
         Iyccs4OFYd/gjHtUgx29lSdfZ3b9Yi21LQ/t68678P+zCZM/70/QiGus6M3s1orLA+DL
         OAIFzm1/ExUi2Dy0Dx93RLjIyCcvxLX9PnCc0Npo2yFgCGK4Ubnmy5Ns0pwEZNOe0+aP
         ic5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q0mI2TwYycM5sgLrcd1zuOS4TrakRSO20fAXPQ2Ywts=;
        fh=nsfj3FdICrwZASImvOw0efx1KnKNfhr5VlnfbkKSQKQ=;
        b=RqQc/iVFNMBKKzAyLcfifuuZLYo3w9Rrz8SL2R0F7eZShP/iEU1slpeFmzErFVFRgR
         5AjZRd/DwyFFgytWXg8iC9hCdvmcnjnK2kpZHVWnIrzn1cNJ2KLcyr8Gl1KDR0TCjoty
         UdOVSiLjdp/Z8GTLM+yT8Qyydd1wsOqQSytRQaRqiXEJ2gE4E9KarkbsGfyqyxJThbrK
         8cLOM21ogaOTFqqb73QtpYfNukzebcNU/qnpbOUYdl4Qi1jmQGf9onjjfV/J1Dmgorjm
         lTMzwAjtB5/tQzqUuMhj57gBP+LOjxTKqc6nYBebXPTX3Q6yt94XuI1o8YvD1SPPUFjM
         64qQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774237698; x=1774842498; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0mI2TwYycM5sgLrcd1zuOS4TrakRSO20fAXPQ2Ywts=;
        b=UWAWzpmuY/GBlMMMYgKHC9H4u2MEEKuUoEt6wbJ4naAJBSkMArvBk54nd5o7sS/xMv
         82kzW2aswoTvz1EHC/OFb8pwmjCA2jQb4EQqrishNBz5YQVxJbTCisqcstUcMxBGlxxs
         eBvwecRNQEB+16oFdYV3agQekfZCopCfxO53MQRQGAVWS2g7SC+ZlmuE+MalHdAz4cRM
         BtB1dVcJDb+OpU0gouB49zUV3SVL8MjhHQZQ16PSDJpP7dQhMmZOB5TZOe22VohNegfl
         0oRiad7kzo4CDY60Q9Iqp2F6eCqrVXF88ShtUTVy+WEOIojJWZCmbs7tAy7YEQR9s8TC
         13eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774237698; x=1774842498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q0mI2TwYycM5sgLrcd1zuOS4TrakRSO20fAXPQ2Ywts=;
        b=pLj/zUOD2KYZCrv2gkAY9uoUHy+S975k50yLH4MdLfTRDlrekOIMovOaYYCOaWC//K
         kfdcGC2qUravysyLfQgH3bP6RvC8spg3aPIV2yRn0YZ5A4Pthnyds6cebI6LZwgeX8qo
         hQh000/+KfPc6zWdelHjcKD5WF2zMImhbJxRIbU/lOWHIjtivdgUgD8vymRPmLemu42g
         +bgY/X8wjiIRPJ7N4wZQXbyOcVU+2uZzpn9BCz++qjMD/rC7xfFHkeOgHo/RU1BGYJWy
         7fOmjbQXYQfNZ3l0lq+gOmrCOORkgsWy+KnVDkdpSp37KMhBtN+ilM7f44nnEW+EpJba
         9oOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTMnVI2T9bmXee5XktF3Dph66/r7kcMHtchP4844p77EuKL/ssfGVf4ovGUATsnmZomT48SyOP@lists.linux.dev
X-Gm-Message-State: AOJu0YwwFh+RBf//uLKCtm3cEPKO9z7pO4IQdEfrmkGWvIClqf/V6jR4
	oEQLU/IWMtlLdfil89AxPegwFNWdaubX3LOidPFsalfpA5aExeRmtR3SC2ngu3/MBOiNriNt4bw
	bt8LeCthO2SVsMZ9VCYHpckHep6Rytp4=
X-Gm-Gg: ATEYQzzDDztKdcNY3S739meoUBmsmMy2h9EFIZhLFVAVN5rSr1TjJtzIkaCMXPApWJe
	7B27jFK8M13CWKxTthj0UsARMfE6PePSHLOY9IGmzzQPTbM+o7wAKWETy/BBEX3FlqRHydjh7V2
	RByRSBOeDLi8q/Suvm4eGeqOoQ8kh1Y3UDULbqCPXfrsOvpLyOHUW7MN086Fpg00cjsOMCKfuGQ
	IJTL0vndOxD4AFBnASCInoLK2cimmKBwMqUUM8X+8/EVG+48LK8lYsdZ2biqnYlPBeBHtiXFCse
	wYI/Kek=
X-Received: by 2002:a05:690e:429b:10b0:64a:ec39:dd4b with SMTP id
 956f58d0204a3-64eaa7deab5mr8770494d50.43.1774237698447; Sun, 22 Mar 2026
 20:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <bd45c86c-e1ea-4995-bb00-df83cc873105@landley.net>
 <20260307032258.2857157-1-safinaskar@gmail.com> <54f06055-c5ca-4b8f-9aed-065755e7c1b2@landley.net>
In-Reply-To: <54f06055-c5ca-4b8f-9aed-065755e7c1b2@landley.net>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 23 Mar 2026 06:47:42 +0300
X-Gm-Features: AQROBzB-PQlqF6OH6A_aRUOwM_KQYLR0utQ15-12H2PLD6u8em4oEuDUzIPNaAM
Message-ID: <CAPnZJGAOPV26Owic+MoMUFaJVoofhLOjfmtVi2fi2GwtrVssYA@mail.gmail.com>
Subject: Re: [PATCH 0/2] init: ensure that /dev/console and /dev/null are
 (nearly) always available in initramfs
To: Rob Landley <rob@landley.net>
Cc: brauner@kernel.org, ddiss@suse.de, initramfs@vger.kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, 
	patches@lists.linux.dev, rdunlap@infradead.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 3:51=E2=80=AFPM Rob Landley <rob@landley.net> wrote=
:
>
> On 3/6/26 21:22, Askar Safin wrote:
> > Rob, I kindly ask you to test this solution to your problems:
> >
> > https://lore.kernel.org/all/CAPnZJGDDonspVK1WxDac2omkLJVX=3D_1Tybn4ne+s=
f3KyaAuofA@mail.gmail.com/
>
> Your earlier suggestion that at some point they fixed the kernel build
> so I can go "/path/to/dir /path/to/file.txt" (which didn't _used_ to
> work, I tested it way back when) would presumably solve my problem
> without kernel patches.

Cool! Please, write me when you actually test this.

--=20
Askar Safin
