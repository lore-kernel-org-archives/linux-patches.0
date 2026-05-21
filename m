Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FD33C4B91;
	Thu, 21 May 2026 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368160; cv=none; b=O9EQWzwoIxRLqvlHb3GO6goYIKAnqtU6PoKsq8nnPn4mgCNP/INtmeWlTzRRORGpUWWkU1x7aUX6G4ZY9HadVN0qlxQUBlV1LN+xhDXjI0Fub1rhiKEeoLQ4GLgH9kbELI0hCNcTDEOSiwUNZzwbFRCXuaRbiUsUmp/iOzCbzic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368160; c=relaxed/simple;
	bh=h7y49oAoNyaJGwFbk81lO5j4Awtt1+a5Y31hu8q79Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWDQIOaJWcLll8bqT0tnfrxKYio7zyUYXD/CIaBHqZNOyZ4Jh2P6osCyps87ik42hyNilwn+9gBFdDlbro0sxQYJTFLC3NzY097Jo7pJOEwXHqtEX7urYzfNwLBBMJGqvLQF67ShuEOmuxpf7ZgNN0Ct9BWMgGbYK8FMYt3rlLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIsVqu27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIsVqu27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665291F00A3C;
	Thu, 21 May 2026 12:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368159;
	bh=9odIMI3Qq+x/G6bpfb/WsqxkweTo4HfY6UhIwpzOPOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIsVqu273ia3kn+IeXmzBfHW+vEZMxnsfh77gcKEhx5HdE2Gk/+6YONC1kA0glPoR
	 igqxNMfQsBSMXPJkcZOtYJ4gH2t0Qb9tPzD+DqWaQw/JV8fv7ZOh03rz5gpPMtvCzS
	 AZa0dvxYKwxfVM+BXll9fFuXgD7dpfZ8MMa/SIXAsTjKdivPQW1MmnfGsLuuNYdAoO
	 yX2hNNBJ8b0fUMqoF0I3DBSmYUxrd4o7A0D5XbzcyOpSLBTti+bh6tGa0yS9NnYcXm
	 AZK9ciyq7bxwkjNJr2aKlVe4G8QyTwh4UiLwv6o0gQakibV3ncQOPHSrYZz/GRvNH8
	 rz7Ui57QiOQeQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 6.12 354/666] libbpf: Stringify errno in log messages in libbpf.c
Date: Thu, 21 May 2026 08:55:47 -0400
Message-ID: <20260521-libbpf-stringify-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ag4vSWzIUCsRlpKv@eldamar.lan>
References: <20260520162111.222830634@linuxfoundation.org> <20260520162118.906982302@linuxfoundation.org> <ag4vSWzIUCsRlpKv@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, May 21, 2026 at 12:01:45AM +0200, Salvatore Bonaccorso wrote:
> This commit caused a build failure while testing 6.12.91-rc1 to
> prepare it for Debian:
> [...]
> libbpf.c:1538:76: error: implicit declaration of function 'errstr';
> did you mean 'strstr'? [-Werror=implicit-function-declaration]

Dropped from the 6.12 queue along with its two dep-of companions:

  - libbpf: Stringify errno in log messages in libbpf.c
  - libbpf: Prevent double close and leak of btf objects
  - libbpf: Change log level of btf loading error message

The errstr() helper would need a larger libbpf refactor (c68b6fdc3600
and its prerequisites) to come along, which doesn't apply cleanly.
Thanks for the report.

--
Thanks,
Sasha
