Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7D137757
	for <patches@lists.linux.dev>; Mon, 15 Apr 2024 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713204565; cv=none; b=AbyWsJisZZ52w5KOllBWqkRPbb74Yfp+IY2ltTtF3zdL7BbjLgsfrQUyUgACNiBuZD/i3mnV5yIs6ABkKaycS0frNH4Yx5GVvOroNDp94LUkqqYMa+1duIZ14aFhnzrE3LSPFirbbhDMoZS/fTJRFLVwFjjh3cw+9GMfqlO6+Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713204565; c=relaxed/simple;
	bh=eb7RuqxydoFas47SsFIwZX7CmFPluv80e4R8SoHBr5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XfPdijfg9KbL5yjicVyvPqLRVNvN1vwTUaWwl8aCR2Z8JM+4eHOM6mOTyR4kWI0g87u6Oh1BSMddNPLWRfaD4aacnxSeq5Pe1GJK22eTY2tMXv6p2jpya4p6j90P48EtoHwXCVhPa/en4jvFEA1O6BqzD08ON9ADZk9vWrs5gZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ezOXDcud; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ezOXDcud"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e4f341330fso28781535ad.0
        for <patches@lists.linux.dev>; Mon, 15 Apr 2024 11:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1713204563; x=1713809363; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZkTZc6XkL8FeYCjPFrO6bTJgIQx6kLh5TdHD7a6mqxs=;
        b=ezOXDcud4gaTtZ/W+lNLDieBIi6Yg2n2+VaJHvh33p2SY4THsBWL4ycT/7L529W25X
         OchQV8JT4U5O5NJcSQz7VoQCYZ7MAhlLot0zYXGDkNx9oZCJ871jmVCioRHABykMg0BG
         7d647Davu4jUPWsoQfd4IribFQMufbOu7FZLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713204563; x=1713809363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZkTZc6XkL8FeYCjPFrO6bTJgIQx6kLh5TdHD7a6mqxs=;
        b=reRcbXXYj1MSuAvWPEBzI6kkABKw+vsBAJlNKIE9Uy/tMmyLipNomn0hZoirrb+dQb
         wSKa+MIDarSFt3SDiZyjTfrpN/JagbuHrI8Yfr+gQbwrNdMQ3UM3DgjrHWXYtJVNTXVr
         TV1HA7u8mJV+OAebtgxJtdiql3x+bZsEfbiQf+k6bvWx4lWO6maDCfJt1X2SBl20Kzew
         P8CXkO7Au8goPXklSdfTY+CdzsjQNCB0PlO21cYcCVQFeig82EOX0LVK4uA0hNL7yNId
         iwVDLOzawWENb49nq5mV9H+17lAwlOnaZsQMO860NLFz+b0VGPHzu5mNxNJ8v3Cc8e27
         a3JQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjke0Jl0EtxnTveSkA72uTbSvrlj6pg8D2GYOdY60q0cB2e72bDliJi7Jk9XrGwU9TrZrLLxceFzDln/5zU3TdBKFcSOyzKA==
X-Gm-Message-State: AOJu0YxJYdtxwdIVs30N4Qzv9bQy3PUPTkXMA6+MgVRwzaWMwds7bytQ
	HAnZ2Gzi9IbRSFbzU5f4anea4eVzbByeOJVDO4K7jwWRJ0E6tZ8GdZK5cfKH/A==
X-Google-Smtp-Source: AGHT+IEe6B6Ws6berlSTBcbjruG3i3BTWWCbetQgyGWw3sCNk24j27rJc7E8j3Ld5qUo912GTxv16Q==
X-Received: by 2002:a17:902:9a4b:b0:1e5:5c8c:67ec with SMTP id x11-20020a1709029a4b00b001e55c8c67ecmr8090687plv.5.1713204562991;
        Mon, 15 Apr 2024 11:09:22 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id jz5-20020a170903430500b001e41f1dda43sm8263797plb.75.2024.04.15.11.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 11:09:22 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	gustavoars@kernel.org,
	justinstitt@google.com,
	linux-hardening@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/2] configs/hardening: Some fixes for UBSAN
Date: Mon, 15 Apr 2024 11:09:19 -0700
Message-Id: <171320455703.253555.575256453738819068.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
References: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 11 Apr 2024 11:11:05 -0700, Nathan Chancellor wrote:
> This series was spurred by a couple of recent UBSAN reports in our
> continuous integration that appear to be related to
> CONFIG_UBSAN_SIGNED_WRAP (which gets enabled with hardening.config due
> to 'default UBSAN'), as they only appear with clang-19 and newer:
> 
>   https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/8646488985/job/23709324479#step:6:500
>   https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/8646488985/job/23709330815#step:6:651
> 
> [...]

Applied to for-next/hardening, thanks!

[1/2] configs/hardening: Fix disabling UBSAN configurations
      https://git.kernel.org/kees/c/e048d668f296
[2/2] configs/hardening: Disable CONFIG_UBSAN_SIGNED_WRAP
      https://git.kernel.org/kees/c/7fcb91d94e89

Take care,

-- 
Kees Cook

