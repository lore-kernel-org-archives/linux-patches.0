Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DB88C01
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 16:14:05 +0000 (UTC)
Date: Wed, 22 Mar 2023 16:13:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1679501628; x=1679760828;
	bh=a54horzX9GTM8oYX6semc4zWAv4b31nzPVtBi3QGcEI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=J45mMpX6SBGBiJxfW9dOSDDVHtKgLzxu4P61MYxCjsyH0Sai34uuhJu4ISu5pMLar
	 EpTICbZlIoITFHCqLUN+sYVFT45k/ao0bWcWn6YyMDC7/3glV9Uy3YW1yxBOkL3/6Q
	 j6k3tOUZlgnW2nUyFjFpTRdqGSIswmM5htF/r+zp72w4oJCJ49ZUvW3UAdFKom5jFG
	 3sht9n4Ibshvhne/zC5BOR5/3dUNnAAJuMScuvc6drDsgdCK7V+hrIgwIdP+a6yOjg
	 KzvD1NqRJaZPV+UvbSGJZFzjI8eveUWyNswAQCAezliKPcxZcKSTYAvMPas3cmemYh
	 Hiv8qUYAoqyxg==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 0/5] Rust pin-init API for pinned initialization of structs
Message-ID: <0e9686f2-f30c-89be-0505-fb36f1c0a5c5@proton.me>
In-Reply-To: <20230321194934.908891-1-y86-dev@protonmail.com>
References: <20230321194934.908891-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> Link: https://github.com/y86-dev/linux.git patch/pinned-init-v1 [5]I sent=
 the wrong branch, the correct branch is `patch/pinned-init-v2`.

Cheers,
Benno

