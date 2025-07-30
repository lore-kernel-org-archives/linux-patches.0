Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D251531E3;
	Wed, 30 Jul 2025 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753881603; cv=none; b=GjkZZEU1YcC8oB6s0soZ1loNbtt+rQfiGARVWXXxzl7TqhX5QftUySpCbzJIR1wrTnnO3PF7OOPo8cfQhKanIM1hrBCbO6hhOkaC5ftwirmTz+iftelfioAa1j3yEk/OzBWv1M64bU/FCQJeY0zZju+pgTDZC4iQD9EHkeSHyS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753881603; c=relaxed/simple;
	bh=cOO1xhRqZ8XZW6yqb6BZzWz/lptf3wacbOSwwmrYTuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrKLxcrOO3z36X7vU2xxuNiBKl23N+/YTHm2t8n4sLulleoDrYmN91MlFyAGh+6pz+wrazdxHix4oMPBDryIONLKq6jZ0YxPFoHJYwS80CAQmv2wQYvdK8ORGe7clB6p8HsOi4md7C8sHpz2ncCQv2tInoHMXoPOp3hJtkhFkRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfSDoW1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfSDoW1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37633C4CEE7;
	Wed, 30 Jul 2025 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753881602;
	bh=cOO1xhRqZ8XZW6yqb6BZzWz/lptf3wacbOSwwmrYTuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YfSDoW1jPucwD+cjfbmUf38swxuoayr4/wTnG3dN5IX0OoXIonPGWp3+tDTQjVTR7
	 AeSE1mHW4V4KtlLArMVbZfEHT1Y2oH6bb4CItIRgX2ISlHw3JsMrci/G7+rgLBwfwO
	 V2Jy0Q6kdrPyM20rXBxDhdYeJdWStdhtnRW2/KMAQMZQ0w4SAmTVnDIbN3hUp+d2/H
	 uM65tFZnnhtoVWOZ/sLcyIZxCAV8PrYtg3cnIqS6jLBm0U2fdhmEX1ncXL/u+cKqOx
	 5DAWpQdEAtb17+PlTPc28yavLWTQ60uuPgL74jJ6M160oi4++z6uqLnsHWRnDjWHTH
	 wOUZiFsBWBzmg==
Message-ID: <ca886ee3-3c26-403e-bba7-33eddd5eb96a@kernel.org>
Date: Wed, 30 Jul 2025 15:19:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] rust: drm: fix `srctree/` links
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250730130716.3278285-1-ojeda@kernel.org>
 <20250730130716.3278285-3-ojeda@kernel.org>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20250730130716.3278285-3-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 3:07 PM, Miguel Ojeda wrote:
> These `srctree/` links pointed inside `linux/`, but they are directly
> under `drm/`.
> 
> Thus fix them.
> 
> This cleans a future warning that will check our `srctree/` links.
> 
> Fixes: a98a73be9ee9 ("rust: drm: file: Add File abstraction")
> Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
> Fixes: 07c9016085f9 ("rust: drm: add driver abstractions")
> Fixes: 1e4b8896c0f3 ("rust: drm: add device abstraction")
> Fixes: 9a69570682b1 ("rust: drm: ioctl: Add DRM ioctl abstraction")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Good catch!

Acked-by: Danilo Krummrich <dakr@kernel.org>
