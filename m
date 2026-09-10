Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA93133F8B2;
	Thu, 10 Sep 2026 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047638; cv=none; b=L7Q11ocwkARYLeCth54jdCI7x9ewSNs3AuKuNebCMQvEgXJ3hC06QE2zNGui5LWbUOLIjrfxKsB+HvWyF+vJBQxrOVDD3QRudFaIPC8ksj0vCT53OOZr+FBzZ7cCfNYDWk7yfgy+K8JW89PxEln3lYzo9h5t0A9GgkB4IgIPSqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047638; c=relaxed/simple;
	bh=Wndg/OekUBAHDUV1wKH5osghl3luSsZoezZxqe2CDog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFh+PaSLq8xl9HmollWQPLdwHiqJ3dRCY/aZ+odhU3SCbhVKjnaF7FJ7Qlef1BckOgBGo+BOD3yWuTrbrYkkd517a4uluSAxz2XsxPu+mJKlruQSIpaOXih56FmWJIx9qHV9lYrkD7dY0KaxoyRJxaS529RfYoPj2v/SqcAOiig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKYR47Bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKYR47Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143001F000FF;
	Thu, 10 Sep 2026 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047636;
	bh=+wsI05yCc4ED7lik9D7qKVErkDFfbmHUG5aTlATVDPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKYR47BgW6x8xl77C0vePULPho9eKpU0kw16m9VjNodVWEa1WCMpnuV1uVmra5qbj
	 O1nMh0jxjYqCrwoDVqkks7QtWAKTFtLbLU2iHBzx0P4A1CiTjOsfYxfGoXYrLIiChC
	 OM8fUvsxHkQt20Ew3+0k297NZYhiB9FCCsJpl+JuOh3yZgSUYjkbSksgjFEjTQSOyR
	 hbVwaYXMdx9WPH79U2WuRKJEgf3LDoslrnmz4TmUOEvZ+EqPj64ld0ivFCXXgbhv+6
	 bY+2IWo8zHwixpVRCYMdt8ByUlAhcYiRbxQU1peYNp6SIvpVgonN1KoHz+Yb0WXVQX
	 sbnqZIE5K7dFg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	aliceryhl@google.com,
	boris.brezillon@collabora.com,
	dakr@kernel.org,
	markus.probst@posteo.de,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	driver-core@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 445/583] rust: devres: fix race condition due to nesting
Date: Thu, 10 Sep 2026 09:40:30 -0400
Message-ID: <20260910133106.e65151f6d60b@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910010310.429807-1-ojeda@kernel.org>
References: <20260909134253.387396612@linuxfoundation.org> <20260910010310.429807-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The compiler complains here:
>
>     error[E0277]: the trait bound `impl pin_init::PinInit
> [...]

Dropped both offending commits from 6.18, thanks!

-- 
Thanks,
Sasha
