Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D282D456296
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 13:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218646; cv=pass; b=tPRTk7tzUjjN1GzvJni5fwHjvV5/4PpA4STegsaZ0n36eV9myWS2AnupxwGT9c2ARJcSHfEv8bmxHX6eEaSTKOGgS12jUSXApB1QVe+ROSBqkbrXwqnbmzID2e5bYNWGeeHh9Gz56oNiKzJGPOS+fVQ4k8SXFKtB7N9a4OkqgxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218646; c=relaxed/simple;
	bh=b3BuLr4nksiuTdGGbza0+L/t26x7/BGw9nuugk+E24I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i8tOtSsVGvf2lJz2JCkxrWlwVqmym9TEIDEXacaBkX2fbXLEVJ1c0f/4L1oexwVj30YNedfdr9o2hacMdr9cuJ1RVIIVT5tBhv6hKkP+yxiLO2HQWs4OTcsGBVbMeAWJ4EafYO9FgXLPHRToGCcTz9FObeZRy1ou8v/WON2XTWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HoQyhE1J; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HoQyhE1J"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d715f4a587so25352355ad.2
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 06:10:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789218644; cv=none;
        d=google.com; s=arc-20260327;
        b=a5xHpFuLF0+pkyowQtn9Wb5fZtHxkgVBpXebaPnR9y4cyvsZAW8k5Lf8XrMOMlIhMr
         MNxpt+nUHB3UODYvF3Xb8VmLGxnboreQ0AgS/MdAai+44yhr78Xgsl1bHqhog1K6btjV
         oNbsiPzUMg+dD0RzyQsU+a8eys0vl9VIE7EbH7d/mRWMBHAyGPgTW6YjdPA6fzQc8VzR
         AFXJjYMUjbsPvUIwPHVp17dTT9uqtKVuNyWzm4hG9Sbzr4Tj212lE4xHQ8ji8DfFyQSv
         Cjt3xi7Yk85CCVZfR2FV/s2Wa2WCglzQLg4gKCX9tM1xjCVRd5k5afPyJFr22vveFZwX
         CbgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b3BuLr4nksiuTdGGbza0+L/t26x7/BGw9nuugk+E24I=;
        fh=04VH9cbA/3j6Cf928kaGKAz3fi5CFdHDQxrC3lCZ9NY=;
        b=M/kBIC0c1md5giOqKJAUrQnUj75y++J0dGryHAee0+9l0cvpw7gSMX7XjmnV0u2DeV
         OlQCkUsVrpcSdpH7huOIgjW0UHgMhjuFEujiXZ0QM7GXuQnhBmhAfc5fabQhce8AjpVK
         BLuGwMfvG1gng2hAlVuHdG9nF580aHCxN7hWC95DJF/UfxEeFXS2wtR0MW/8V7xQwXtS
         vYAXwb1u0C2eoJFY2mZqyRhTee+QzVb5Vfxp4AIhjp6uYmeQVeICybmjEEqgWhFDZQqM
         YIEtJe5nU7agX4A4aUx2EjCtQRpnApYLcKcMBAVfWxLsoCSeLHT9COUPK5rDrUooj/CI
         gD2w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789218644; x=1789823444; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b3BuLr4nksiuTdGGbza0+L/t26x7/BGw9nuugk+E24I=;
        b=HoQyhE1JmVIS2Tw5Azh1ku3HUU1qSr3rsx9xmvnvws13Ydtnt/wHmD/3mRxjldd0zk
         ZqsWsfgmvYULVVopjd276TIno+d6WwwFX7wj26YaI3ZfJi+sLBdJHmCHgG2vPL623M39
         Ao1RyQeQIUNAvHminMoysUlT/ssvX94rLzav6XtmGdzuR3i5NZ12ZoQgqOxZkvTkR59J
         NSJQcx8m/qZgvmT+ehDlz7nqAO6Y+/iiysXFkv0jlTDRv+QYo2IkkpsCaWKVe/njb8al
         taUCGtabmVEfWtS483nZrK+wWKPRLsQpJAN8yNBQJUz7OdbmMZkCFPyr0KVSEN0gwhJi
         B9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789218644; x=1789823444;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b3BuLr4nksiuTdGGbza0+L/t26x7/BGw9nuugk+E24I=;
        b=BXDvhcQppYnajxZxbeQ9OlMVsPx1A0GQt8x3NuIZg0wOblOVGYwElrBxCRXJIryrnq
         blvB1I+xeZnU6jgGE0Ng9H0WAUqkkFWYxQRES1NkM8S1A7Uhw/3h1W/0noGlTiyYz6A9
         8VjMuHesYipyPtm3O1DcRC5g8nP50BP8IMYg0oUewIbEVqZRzf4C5plgeErVRpXr6QiE
         Gk0LxwyODqJLTX+BmrlVT0D4J2AfbF4ruggkrSnvOJKLi8CgcsH27ubUpoI7iVgmsLBd
         fFnRlyrXyLrVAoedtVgfY8qlPGGy8x67aqG3C+eZC2bPOh5k/HnqwFGoZuwt2s/WHRWH
         fIMg==
X-Forwarded-Encrypted: i=1; AKwUvByPnaj+0GDHfeU01DDTddLi8WtEG+6VqpSYkdpmzsjQ3OBUPbjA1ryXLf/LjRGI4tv82csJ0RAT@lists.linux.dev
X-Gm-Message-State: AFuF++meFkVnnwKtG0zBjRFNLKxZgHz27gLprU44+Qam8hqeg8BuMkTM
	+lB65VIXizMsz1mtS4b94TsjiIc0ontUJB/ZXKws8isM+KbtSJ1B8tLyfH+ckYWkJYEl8cf6S2H
	atTf1AkTjQfM/+ndn1IuR12S2oX6HcjA=
X-Gm-Gg: AYBFou24enm8OVfm1ZGQuS9PztdvX+MxPdzNS6/MrVu8LDi0b/Y1ZimDtT5K2vzSseo
	/SMr/AA8G21m7OxTWw8loDFO6vkZPxDqkl7lcO9YxKo1q12tLR1XO+JAqmUX3FQGh1C8SLVmLN3
	hKu0yYzT8ZI7yiXEzVVjOrq76kBPz4Q0e+GRh54Xu8qCnKbiSuK+Kq1f2Py7PeevmTMTMpuUEhv
	Pg6bTdADIGLgC53qzoG4nLYdAQ5kk94qtDybIbF1M9NKjoWLodm/ZFMkN5+93oUJ9e8Cs7QV/Bt
	eFTpjReVvjUIVCa68r9BccYCt/HEi5sY8ORDTwE2lBnl/n5RpSDnCHvtRUTOzgURqqkFyMQtLQ=
	=
X-Received: by 2002:a17:903:198e:b0:2bf:dd0:c8b1 with SMTP id
 d9443c01a7336-2dd29ffa6b4mr172203635ad.0.1789218644005; Sat, 12 Sep 2026
 06:10:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260912065648.999753832@linuxfoundation.org> <20260912065657.541103882@linuxfoundation.org>
In-Reply-To: <20260912065657.541103882@linuxfoundation.org>
From: Yee Li <seven.yi.lee@gmail.com>
Date: Sat, 12 Sep 2026 21:10:01 +0800
X-Gm-Features: AcwNN1Vk9KvM0MoUqi-HCq56xMnk-5e8FkCUOTA2kTsLggWab9zKiXk997gdL4I
Message-ID: <CALX8JfSjnAd6bY8zBCHuG=_+f4JiVCrhT+sW4DPEpUM6+5LF-w@mail.gmail.com>
Subject: Re: [PATCH 7.2 0368/1815] iommufd/selftest: Fix dmabuf leak in iommufd_test_dmabuf_get()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Jason Gunthorpe <jgg@nvidia.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

Success path return rc was changed to return 0.

Please refer,
https://lore.kernel.org/linux-iommu/20260902085414.549830-1-qinyuntan@linux.alibaba.com/
