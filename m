Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9164F35C69F;
	Fri, 18 Sep 2026 00:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692788; cv=none; b=TAb+f+n6BGVO2V0S5icFmnwunJG1WMRx9DYa0hTMznxEzWyAL8Rrlelh2zrMwbkaigC8M+fyEGQfDEaGgJfh/YaXMvbQcfVC9DER5cNH/PjNWbTUDLwzUNlRcK3v66wSPB+DSaKprY1ZUoQx/RX0i9VYegxmEI70bRiRuSGydEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692788; c=relaxed/simple;
	bh=1M4TT5FfSNylW6NJxXIwyulp5HjOu1Gw9N3H3GROsoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp1mxDfWyXAFVruRktqjA78jizDlwJfutnyh7+sxh+cDekVpmyWdVltjRvkiZFX7VLppaD/vyeSc47ScBRJFkBVKX6gEPr1/IAk0KlfJGz0Fon4/7km1AgSIIy2YMUmSaeh4sAEIGNSDmwF3i7lFHO4EeGRQR1fvaesZTxEgl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtCTScdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtCTScdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3D61F00898;
	Fri, 18 Sep 2026 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692786;
	bh=yrUUK/NiLZbholfyCSl7Lbm+Gg3lShP9JnIx31YmB04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtCTScdOuur9bXkpaPpKAZ7EqE2sY0mt79yUBtc8QiGbvhWdGQzf+t6VmJS4R7ySA
	 ryMjR8gkObptYW9+uv2YSMtFaREa+n7hEdsrCg3b4YfpQNg0sa4dWJLxglWU9Wpxwg
	 964Joyqj3v0d7aQNtkmp6fQK8aMXcgBE/3YCd3Zud4oj2A2ftNCWVIpmvc4El8CwFD
	 TW82orL1ueeVHQlCPU8OV+h7ferckFKugPw9RoJ31dwoWjLS3cyaA89+VainLgZIMy
	 3bRsdqcD6yLmpLIi7oeUYYYDHycY6fcqJIRB/LR0U4ooJPMA7ZXIJ1pXLqV++kMeyr
	 JoHEJI8GJgqVQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	Maximilian Heyne <mheyne@amazon.de>
Subject: Re: [PATCH 6.12.y] selftests/landlock: Add missing connect(minimal AF_UNSPEC) test
Date: Thu, 17 Sep 2026 20:52:40 -0400
Message-ID: <2026-09-17-daily-reply-0013-landlock-connect-af-unspec@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d8432a4caf806783199dc5cde1dae2751719dda9.1789655724.git.mic@digikod.net>
References: <d8432a4caf806783199dc5cde1dae2751719dda9.1789655724.git.mic@digikod.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit 6685201ebfacff0c889bcd569181fa6e8af5575e ]
>
> connect_variant(unspec_any0) is called twice. Both calls end
> up in connect_variant_addrlen() with an address length of
> get_addrlen(minimal=false).

Queued for 6.18 and 6.12, thanks.

-- 
Thanks,
Sasha
