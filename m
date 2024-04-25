Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0FF5B697
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 20:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077347; cv=none; b=KQKp5Q9ei6qiaroVDW7UxK4mK0d3vwP8G3outkc4qgSz11kHNHvzox7coJ9R1O8doUYRrTjvmE6mWKpcKfa2zx041DO9oI74XAycSQs14d00WwIYkXHwNOjNHxSUegqla68XJJHSNR5I4SLOPzifEycz+m9ytGuqc4GKmcShEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077347; c=relaxed/simple;
	bh=bCiSpeEajhHeA3ZWzQjdXp4dGEPuM9XZsenh7JoVOkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UmCvcoDuoB+GkN99gFCbsvz/WXtgSCCwFXCMAs248IhIZlUNg+oQUin/gslX+GGIvQiY/95Nnr387Hf9TqjA7b8z1l/Mu3qJx8bkANEQXQ1K/OUm0HIP+BG2sSBgt7kVCStNInfhN8nsWkt/7FNRTknJPtLl2aPOzbImlc5OXAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMJBnkB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMJBnkB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021BAC32781
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714077347;
	bh=bCiSpeEajhHeA3ZWzQjdXp4dGEPuM9XZsenh7JoVOkM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cMJBnkB0xuPUAztL5bdOA2MPWFd+gixqRvNwcrDdFio6t8yQR6gqbKIfAhETHj3Qv
	 kPBtuVp+L2itSJLsYISZuRufwA4jBt4VGgeqqlWYZbHwDSkV63/wxYpa1ibby6/4mU
	 PkO2YkkwX6lYMirtOKARsI7h3YLTE7vF/CISPDiwvTpqvcSqDZe9iSj94YIM0ztK0C
	 tXujfgFirjT1p3q529XL/nusjWCsoVhVLUzuaHT2bfkCfpQafDEBiYM3I0F6o5fHPM
	 YmCN7Q5wE3DXn2t2c2RsKnM9jigvwD0EEJnciTLSDy3ZVYpNhYFKXLtsrZla0cwqi3
	 1l2aQlt5yqbnQ==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2db13ca0363so22488321fa.3
        for <patches@lists.linux.dev>; Thu, 25 Apr 2024 13:35:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVJGUolBzYQJ9oeJ+1RUp1+uiegaGEwUO9PrSZbl75hFRwxCUe7U1PQXDb7SvjQlJs+MvzoaEg5K0mjKgsm9rZKjkbew/QAXg==
X-Gm-Message-State: AOJu0Yw/F7GM7l4A36HBNz9etlzh1IyHHx2yE0rH0M1LAeKLTOOfRMhx
	gIlNn+CaFBgspIbVwJHnhUwEN8rYUuiOU5unO8lAncfv4vaYCG/T95anbhG5AG4xaxygp4SlXgm
	Gahho68rJwvBwetL/MtC+iVDnqQ==
X-Google-Smtp-Source: AGHT+IH0jiWIh0gTBhNm2YA98qh5jrinfKFsibAguPX98MIifI5V5pnmVMwPJxq9jBukg3E5QxvEmCk36DlAbIM05Uo=
X-Received: by 2002:a2e:a286:0:b0:2d4:5370:5e8a with SMTP id
 k6-20020a2ea286000000b002d453705e8amr335215lja.22.1714077345322; Thu, 25 Apr
 2024 13:35:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213853.356988651@linuxfoundation.org> <20240423213855.436093838@linuxfoundation.org>
In-Reply-To: <20240423213855.436093838@linuxfoundation.org>
From: Rob Herring <robh@kernel.org>
Date: Thu, 25 Apr 2024 15:35:32 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJHa4j5p8V_wkWFf6G4Xem5P9X+2vK5p0DYbBShXLdM4Q@mail.gmail.com>
Message-ID: <CAL_JsqJHa4j5p8V_wkWFf6G4Xem5P9X+2vK5p0DYbBShXLdM4Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 068/141] ARM: davinci: Drop unused includes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 4:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.

This doesn't seem like something needed for stable. Are the hundreds
of other commits like this going too?

Rob
