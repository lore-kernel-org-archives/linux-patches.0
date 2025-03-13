Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7101CAA6E
	for <patches@lists.linux.dev>; Thu, 13 Mar 2025 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741892107; cv=none; b=plmUBYdxEvVexCkAiQMREIjRGvGN4DfulMvOoy7IvwKqeATDqYAzWeQTNeS1/Z69UU0tK7USI3vvHRj3jpNGfn5usED4DC6OSh/B8GKJ+M2s6ZEnczf5LaTYahEnIkfL6fAYbSSXKtaVA2bym8ksUa9xkBgkteK54QDizfXtUjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741892107; c=relaxed/simple;
	bh=qXvwKTD2I1uFx9G1b72YzsT0pPXLzjbATobXsUry+ys=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uO25d4vQxg/fww198TjeYYJgMtF9b0v/0RvDUc4ipHtV97d55acT4cQ9me4qGmPYeVExO8PSLe5njmWhkgrKQeC/38eeOCupeDxtS4BddakEpGEb2LiA3nAle7vUKgyWbSqbE11utI3ylSGkF+laRHYgl91WXpGEGRW2ZS9JbYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YUTJLd8x; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YUTJLd8x"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-6f7031ea11cso14340987b3.2
        for <patches@lists.linux.dev>; Thu, 13 Mar 2025 11:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741892105; x=1742496905; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qXvwKTD2I1uFx9G1b72YzsT0pPXLzjbATobXsUry+ys=;
        b=YUTJLd8x+nYf5bkbCUZd10A1CxYR/nGdPNb8UI4gzrYdi+rCFTGlTSGmGAU62hfw7v
         xWbX/4YW70qEYFbTlQqhN5xImAr2r8yLlFuOEwj7I540NkwS+AdxaV13DcWzSfKKItLH
         GjUMycrhsHpHdCVrxcjrKxbxgl/JxpdmVjg/3otqIrxrCszVutjhClMxvuGnvfD4Zq5r
         BuAKuAP6TZHPzuJxGvqRNc8eluT+rCM0di0on+hVH0LTjVVG2JvB0sEcNBVr0GZXllL3
         udmco91fmXohENVvPeIplWleUv2K18t7wXsJNMQang10nWcGtglGWm1Rqt61fAvEAlLx
         eOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741892105; x=1742496905;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qXvwKTD2I1uFx9G1b72YzsT0pPXLzjbATobXsUry+ys=;
        b=InxGq58OZgD5zI66ev8DuRc+t4sUsjgrydEp00PxbmzEjXviMw5BXXHKiFAO6DQ6Bc
         1ZzvK/CGFSnSqMCCvXq/e5wrlQeRu76pkco0KKmo11Mosn72PAN0+OW3e5aV+/EHkh7v
         cdXjtTgqK7l91ytHfhDhXYsOJWymEJtT+4HZ4LiaWm1Qfo5Ar5iX96VxvKJSSOj47c16
         J3rgiE7ciFBBqqnPwMtQcx78DRHbSE8QGzvRp3EFObmEpwsa4/QAbd3TrPxsYZE6zBAC
         ryrbQSMMy31HKqWO5iaZ4QNfajmG4ZtGK13AsRFwDSHyjQ5PBtlqny7jiJ/GKCFJtDvx
         HSZw==
X-Forwarded-Encrypted: i=1; AJvYcCV9FB/4WrTjilAticXgXMI0pX1T7qUetLuER9WrxkuGkydG3M1uoS08cHgn1sLu8erWPhqDC9q8@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9SWxzdVqfAF6bitKTDkZt7zdL+Jflvb9FypO6OE+2lrF5Orec
	Ud2GLiKWsKomQJazWLj/9UDVOueKdCjmoAriZYq+U5tnkziJdUitOMVWl/LbdtwnXk0D3QDK7ae
	CzVu0P8Ld0olHTyOGP8KF1l6pkYk=
X-Gm-Gg: ASbGncvz508oXGGWsEPCTgxnClVYn54tEbp66JrDQTRK0b4ZA6wtFmX2DJ5KgpLXudW
	r1W/hXl8InPwDVzpXtrtnctRk9h07osSwIaaI8Z8cdcR3hKTzRVi12CoNWbj5lqjxqpPaAAj/Cy
	phfOF1owZ09mx8GmC9OrohAk2N
X-Google-Smtp-Source: AGHT+IEKqQWH7dcD6ejG247HSFtsx9xlYEtjwMC6/LTN+1/xsgE1a+3OO4iHGWpOaSpoQwnGnGStkTAfRgQ0xPSa48I=
X-Received: by 2002:a05:690c:7446:b0:6fe:aa66:5d75 with SMTP id
 00721157ae682-6ff41f56827mr10681797b3.10.1741892105454; Thu, 13 Mar 2025
 11:55:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: pk <pkoroau@gmail.com>
Date: Thu, 13 Mar 2025 19:54:52 +0100
X-Gm-Features: AQ5f1Jo1crF904GwTCy7t9ym3SZy2HPEL2AnM4Gp2OSq8JXebw5v5lqXMcN_LJw
Message-ID: <CAMNwjE+6g4j=GDfef1hkrDvu1snaB9e0MhMWJFhZxuLtinrOuQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 458/462] btrfs: bring back the incorrectly removed
 extent buffer lock recursion support
To: stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"

Hi all. I confirm that the patch fixes the issue for me. Thank you very much.
