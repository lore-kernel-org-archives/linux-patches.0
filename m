Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845CA30DEB8;
	Thu, 22 Jan 2026 05:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061059; cv=none; b=L6XDvTqmhAirWFRuUwPHstS/Z2mvB8cbbUTEomdhYlxWQ7KIP0BhXU9hFoQeUfrhhotjIc7LrFyXeol7NTr1QLCUin8hOdrNW41K+7O4v5Y2b/bHSW6A48EHHujN75k0LRLWnOVRYqJ9Pe7KiPdWzSmdUJK2xDnmTw6ye+bDNxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061059; c=relaxed/simple;
	bh=Bb74xsoEZKYOuZmvjORZ1FhqK8uLhgEkpy61Bk9sPpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Svpo+anXKUo+mOdNyHhSPrF4m+lXTafvwYPpZ4KKqB8fOBJfnJBE8c3RKYNfnraM4R8Lcc6GnNtXcjlQpjmr3La6m/kJwhiOIpD3HcEi0UEtd7jVqtxIZt41L4S+hCGq2unL73OHB+++WjoCWd7RlsNeQYXnIXFInW2WcJ3e9Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQT50A0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQT50A0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F432C116C6;
	Thu, 22 Jan 2026 05:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769061059;
	bh=Bb74xsoEZKYOuZmvjORZ1FhqK8uLhgEkpy61Bk9sPpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQT50A0HzpXu80ghRZZYelxtd/x8OyQziz+nioon3gfvXf/92qBBs57lGczIfxtNA
	 C6ZQfIMH4c+6BUPQAqn1Xu2/iUktBrJTujXyhiRRNVhwQagSmOcgIfnpE4q1uvYf4j
	 xt64t25jqsSHzJ139EUionCY/xuxvrkEQjt7ISO0A/MJdRIf/BSU8SGZDK5LGihs/s
	 Vt8FCi5UM5+WExEbbH7h10iDtUAg/jf6L/b3ExxAB7dm0vZ9i6IZmtX3LiO6zu8b60
	 5hQINwr6heezx7iSRJGD899SPOEXy76PsOwYOhF1Iu00+puGDLCEbVMmhvc8K53lkA
	 sYNiR0Ul22QNg==
From: Miguel Ojeda <ojeda@kernel.org>
To: nathan@kernel.org
Cc: dri-devel@lists.freedesktop.org,
	jesszhan0024@gmail.com,
	justinstitt@google.com,
	llvm@lists.linux.dev,
	maarten.lankhorst@linux.intel.com,
	morbo@google.com,
	mripard@kernel.org,
	neil.armstrong@linaro.org,
	nick.desaulniers+lkml@gmail.com,
	patches@lists.linux.dev,
	tzimmermann@suse.de,
	yelangyan@huaqin.corp-partner.google.com
Subject: Re: [PATCH] drm/panel: ilitek-ili9882t: Remove duplicate initializers in tianma_il79900a_dsc
Date: Thu, 22 Jan 2026 06:50:50 +0100
Message-ID: <20260122055050.139154-1-ojeda@kernel.org>
In-Reply-To: <20260114-panel-ilitek-ili9882t-fix-override-init-v1-1-1d69a2b096df@kernel.org>
References: <20260114-panel-ilitek-ili9882t-fix-override-init-v1-1-1d69a2b096df@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Jan 2026 13:43:31 -0700 Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
>
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:95:16: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>      95 |         .vbr_enable = 0,

(...coming from https://lore.kernel.org/all/CANiq72mRp62foTCstQxYhVBdh6y_W27wEjWSRX9_kqShuueaSQ@mail.gmail.com/)

Yeah, I am also hitting this -- it would be nice to clean it soon.

Thanks Nathan!

Cheers,
Miguel
