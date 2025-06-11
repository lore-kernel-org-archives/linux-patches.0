Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3438479
	for <patches@lists.linux.dev>; Wed, 11 Jun 2025 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749645172; cv=none; b=I9z6hsTf+pkWmNu1X2EXZ4SgQnKtgojuhEMAc2MRVZS3JT5OTubqflMwNVdBbf6iXkYuLERwuhJTvVNH9XBlkFcD43E0nMsVaou0v3Et+OAP0NuGQWgf61XVV/m0asYIUUREvapXtRpjOedd67dunaCx3BmSOwsQEdVvTGFib8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749645172; c=relaxed/simple;
	bh=xXbDETXV9P2TQ8Hk+RzVJWyGilwzx00rjuV1wn6moq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDJITZcPrQHZaLJXqhDXR81Shq9YeChrojhkP9QDyVSzKdohqZZumshobfWmxy+6G8xTu3rWvCw4bIMtIhPHXRA/6LoJhxhZ3j4lWkTv6Pnfp3NoiGYdyXg9irsYVxre4fVoEC20vCFI7bdLHdEJ4zYuUtheHaMj1L6OYusl4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0d/gfxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0d/gfxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EBAC4CEEE;
	Wed, 11 Jun 2025 12:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749645172;
	bh=xXbDETXV9P2TQ8Hk+RzVJWyGilwzx00rjuV1wn6moq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0d/gfxYNjYe31j14wN9yQ1ULGLtkhrWESjrT5n1XQceSpyDXxps0B85mo90Z05uR
	 fKxwO37ChBB5CSk7kB14TgjEiePw49jCLtLjw6Wucp1SQ96xVyOIS89j7neIs2f3Pv
	 IGG9dIaDSa1nz8PLJ3zFOJGhjiO6kjqsBXqZ+ULTCNEWZvAMhLriTVVgDjHezjoOpr
	 zAxgjx+tZ5Tfqa7RYg59IeUbKu0RLO0jG8vABN2QGBp/uouZwcC1JrLGg2/XGSlVpL
	 z4+QF9KJetR7gmBTLnI/69uElmFuwAkUfWp8S+PMIGP9oOfd0x7+axAVKR4ic+QGXh
	 aWXO8AH2aeACg==
From: Maxime Ripard <mripard@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>,
	dri-devel@lists.freedesktop.org,
	patches@lists.linux.dev
Subject: Re: [PATCH drm-misc-fixes] drm/sitronix: st7571-i2c: Select VIDEOMODE_HELPERS
Date: Wed, 11 Jun 2025 14:32:47 +0200
Message-ID: <174964516465.47655.6350077670059712740.b4-ty@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250610-drm-st7571-i2c-select-videomode-helpers-v1-1-d30b50ff6e64@kernel.org>
References: <20250610-drm-st7571-i2c-select-videomode-helpers-v1-1-d30b50ff6e64@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 10 Jun 2025 12:40:38 -0700, Nathan Chancellor wrote:
> This driver requires of_get_display_timing() from
> CONFIG_VIDEOMODE_HELPERS but does not select it. If no other driver
> selects it, there will be a failure from the linker if the driver is
> built in or modpost if it is a module.
> 
>   ERROR: modpost: "of_get_display_timing" [drivers/gpu/drm/sitronix/st7571-i2c.ko] undefined!
> 
> [...]

Applied to misc/kernel.git (drm-misc-fixes).

Thanks!
Maxime
