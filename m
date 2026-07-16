Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB8377AAD
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 15:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217538; cv=pass; b=SifveqosTcr6HHpp7EvGjbqWpL+Ro0pYDyQKPDRTpGCAGD5N070WwOeaLvKkn0+IAZwjNwuK2uTxbO9Er2uzRARzVswJL1KY5YEDRaoQEK5OlEx0ERqQNgIgcLw0/Me1vaP/GSWbTdL12FKKlId/+Gh1Uif/7Hs0YvgRSOLAElU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217538; c=relaxed/simple;
	bh=gXGE2JTN3iONMX/sxgFMRargYjXfoFWeNgc/EmcHwhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OBYlo2npr5H3fkmTiwre0B9lh6+2LQADJccQOR/VqJP/7L6biWk8KlINlWBqX82cIYs9lWAkeF3iVovHMYhyoE5Vl36UtUA11m4MqwFUHMkQcLsUHqThmXkTSG0/HVl7IUgahC7H/6QqpgiWHlpXI1jbb2MMH381S+mEWflfGqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBSYGDzE; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBSYGDzE"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-385b78b4f9bso522170a91.2
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 08:58:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784217537; cv=none;
        d=google.com; s=arc-20260327;
        b=IpnB5IQXsxXrtALZHvgGoNSHG9VwyFOc32ZncEvUa0lAvaHWyZfgSTr8P+NGMN1T7Y
         XsdnKXSUCouMnZMqsXJKzPJ1nWTA5agF/tV0jIgYA8eKo4oejrTRnfmXb8A+u2TUB0VN
         F0gi5bZHw5IbgjhBBXPACFl7vW2AesOrMHHQ2owetgmEyGFV9B7kCv7UQj0xkG0j8wHK
         pyN1W2t34LBbrzu6fpEBNLyAgH52JGGkdfxoMBA45nOSTu74NFKeqxNVGQP+biGeLiHX
         XI0/b/XjQJLc06pXfuiXIxf53oUIh8xzDNAmTfNHgG9GLnNHcF2e7TBurJFLTOw0Q04q
         p14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bLLvZR8s+bvbiEudcUvS92j1tIu/zyxnG1t5VD57tWk=;
        fh=6bP2yDyUtggbTD13Ly/rIvfggh5eVzMj01UFvmmm++Q=;
        b=NbDfs/3C4Dl78Jry4Q9zJsV18X8MqxKTFadThBsO4QdiV7A3yCK1m4PLPA8brZY95I
         tErErF4UTuosWomGOajGIgKv7LrP+O55HPmUe1kGSIsWU2som54BbQP+HCICXt33/COT
         wUnGQYUaZfBpJJYZPa6Z2UNKMaOyZ3gGMyqD27S5VagilUWAIjQFIr1SGVUweZsPV7Ot
         QxthX+NQPWBNqgAa84Z2++3+uiXBsWk6p2IPXIgR7yrJoAgkUlLf9g8Jzx/nd+8wDZoD
         gzmVSwTIwGUxp6vkjONl5mp6+aeOuJ4seOGnPZSuikk6cFsCJdTOJ/8wE6GEgKQzxoia
         XV4A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784217537; x=1784822337; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bLLvZR8s+bvbiEudcUvS92j1tIu/zyxnG1t5VD57tWk=;
        b=gBSYGDzEIyXvxlvCryUwEBmIcFE8q0eAOyKyz2vGr6vK7vQV5DcHCBmInECpcW4gtQ
         Q3+QeKzw8Wo/Ig1hGULeOYfTpx4FbwTCozhUzRtPT/d6c+57LqltdDctg03d4Qt0r09D
         asMi98XecPlL7B50ESDOvR7i1+ZmP5Rf3y2b/gKA6ps/pnT4utJzEvXU9QqY+1JlYk8b
         /jgC8575qxOfq2iGP4Gk79pjqsiR5FrXb3tfADxSMjxM8qXcsPItdTceAGqVfYhbjJxK
         j5CmvlAPLJ5WtZjtA5sJPVEWxq7aqQSBN6YvzIkmnYNnXp22/28w9m7VEGZO26Nf+0zt
         oG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784217537; x=1784822337;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLLvZR8s+bvbiEudcUvS92j1tIu/zyxnG1t5VD57tWk=;
        b=kHRpNkVANYaTM0OeSdZGfc15YNjE05Gl2CKIBNNSRR4mUZHU8zlR+9Mw80y665FyS1
         RiNI3o1vPp2uBjXnT1s6uV0DdzAXdamDcbKoGUKJL+U1av0vg35f36AJIAWsJV8tUfye
         6viVbbQpEbRO8ZGg1mQ15U1P3MfEDy5fpxFuehtnMhzOJSoXBW75UqAMMe0P+uWmPGsZ
         glQHoePf22WtvJSayKBchw0H7Q7U+aq4A+1snuD4RgbQP4J6vrtcZ/WUQne7gHtnfQOF
         6HCg2N42Y/S96PVw7voJS9GkV83GuMEmyCEr/q5ogN+Ur9hBF8+RoSQW2LeIKZeLaup0
         YcEA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+eC3LUaMblRuu6xLXS1TSTY2vOAkENWp20JR+jAJBOilh4rIw9y+JAgmBFIB+WM0jhQjA0ofl@lists.linux.dev
X-Gm-Message-State: AOJu0YyX1P5hXOppyDaodw3UL37Ntx9PJ4U2ftleduSElEsML7moZJWu
	nCpa0O4fou5wZ+/zDHEu87k2UbBSqbtj/sxJCulrH6G/Sbo26CwWTQnkZ5EAg4BgvikM54r4b3d
	HgIodBnMHeh4SdoBpGCPRgyusEjNCMQVxeosQ
X-Gm-Gg: AfdE7cmPRZR49KasfcLIhmhzh2+n6PGQdOQwuoUNY7Ido+wk/2TaPXfhY6Jy2rbBHcq
	GhcKuK+HP71POiI+OGgyWmw+EkvU6uB519SielyGZeS8pab6AdpybfULxChD7LZciBmxV8yfxeg
	8FH4cecyOXMjLg+9nWi1+2q00bbovn5/T6FwAcsLTLvYoSvFdeza/VKSbCmMpDOBRBMyuJ1Z/2a
	DR26kRY1JcKPtSQ04LYdu1MBbdSTc66mAas1GAsBhMhGMt6QjpcwyFwcmQfUfk/A3VEOJFFwP2n
	CXA6xDuFpKgh7QK72LFdGSNoa94n2iN+tqzoK3OOyvonu6jHhMPYiVa3Vj0av1Cqn46h2zh/MGZ
	dTw==
X-Received: by 2002:a17:90a:7344:b0:38e:549:9e04 with SMTP id
 98e67ed59e1d1-38e05499eeamr7440803a91.1.1784217536632; Thu, 16 Jul 2026
 08:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260716133047.772246337@linuxfoundation.org> <20260716133048.240591252@linuxfoundation.org>
In-Reply-To: <20260716133048.240591252@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 16 Jul 2026 17:58:42 +0200
X-Gm-Features: AUfX_mylqLCMHtYaCdsdSeRtFykT7QKzo4AElgdPbIx5g0i3WLsKPDPqmzR86l4
Message-ID: <CANiq72nR1X9Mb614koFqALMJLf39K6wXsUcF1WegM26UNg99Aw@mail.gmail.com>
Subject: Re: [PATCH 7.1 021/518] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 3:36=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> [ - Adjusted Cc: stable@ as discussed.
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>   - Added comment with link to the PR, similar to what we did in commit
>     ac35b5580ace ("rust: arm64: set uwtable llvm module flag for
>     CONFIG_UNWIND_TABLES").
>
>     - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Something strange happened here... :)

It seems your SoB got interleaved with my [ ] comment.

Cheers,
Miguel
