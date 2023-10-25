Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DA1180
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 00:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIfhg1R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B67EC433C7;
	Wed, 25 Oct 2023 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698192749;
	bh=bA96xsObOn318WvHN3mETfnfCPJHO/rY6j1wJ8ZDbt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIfhg1R9osxf6Nsb/wJNktEZJQaE7o2tfWoX36gd3usjvtLIvUsQRw1+bLrHIXqE9
	 Y/MEiM9pYB3ZRdFyvlKAE3sYKux+RdknhbKkRdUr5MV4J1I6PF1JuCbffwE0rnQz/f
	 mZkqjIQvR0A4qexjAnOWFAi/YSuKmk4a6Ase4PgTmlxHaJO0bNR681HM0XQE2BOzF0
	 TDOG2mJ2nwIYTJFoDmAf+EcC9X9n5/jFzqohss/gaJMbfdkaghkVHI4eIiisUwkROJ
	 EqZ5aAwErFkcq6Th+r+4pRTU4Tav/xpxG0wPxP69eDilXfqlc+WIwkFXocwV+Yo4FR
	 YQ2lrWlpsQHNw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Date: Wed, 25 Oct 2023 02:12:18 +0200
Message-ID: <20231025001218.376633-1-ojeda@kernel.org>
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For Rust, build tested and booted to see the minimal and printing Rust
samples output in the kernel log. Also checked that `rustdoc`'s docs
rendered as expected given the patches included in this set:

Tested-by: Miguel Ojeda <ojeda@kernel.org> # Rust

Cheers,
Miguel
