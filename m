Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C1E46EF8C;
	Wed, 22 Jul 2026 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738610; cv=none; b=sh69Tk1zHCg9KDPZ2vGDOZakBG1QfNc0s9fxPSNoMVEYbcGbu+rQWW3umpewZlrLcUC3mEfKvqdqLdbBdZV7eXn3lw5fLxJ6IRBIJQbseHvUUhU0CZqlsUT0Th3oGYh3qCgYxnY5KYoU2lY+Tqgz6jY2dGepMLq458VXdck2t8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738610; c=relaxed/simple;
	bh=PCaKAkZCi6VLBJ7GIGZ/uXAzNAhUndP3S1I7o6q9wgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfKS92vW9qAq0+tuTrsYBevjd/gd9wpwek8qRJHxExMAJ7UQ1ab6VHCbeGtGJOoOjWJeVLdSJUXyybsNvqqkyIUyovOm7O7ZlEFVpIuDqWGTWxU6yubjsrcCsKCwPO9Ikoo08ANPFWgB+G0Z6uXQZUhV8zgoWmzkRBWISglV8nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgfPi4Yb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgfPi4Yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FB01F00A3D;
	Wed, 22 Jul 2026 16:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738604;
	bh=qja6fm2Yzpe13zoY5Emzsal+7bx+ZhIaFSD7fqiEopI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgfPi4YbpLfLmBC5GVw/9emWiNGLVixj8x9LygSHmZiJjWO3+iNUR2nbHvACuVNcy
	 PHn32UD6KzaEL3r3S9rx3AM6ZOlmrfwK0ip0QxNXtJGQIbtWXCQRfAZAtAkQArFZWc
	 rO6uXYdhVdx0t5cFbGLXxjhCLPLyKT5hbOExGZ2kC4rGVL/Sivktz5nBaNY0LFQTM8
	 8VexexCPw2uJMhSoWve2QLO1nXr80GtZO1qMyu2hyv0dkwondOWkbXXeoT/Yo6Bxw9
	 5KdUud0daAcABjvhOCWlcGxt0qh64nYEJ+EkVOH6Y57tedy8W9rE03F+N8bzpg1iRE
	 NFuSG/RIa/Q+A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.1 0898/2077] gpib: cb7210: Fix region leak when request_irq fails
Date: Wed, 22 Jul 2026 12:43:13 -0400
Message-ID: <20260722113503.rc-reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <26425ef4-454f-4087-98ec-d045247242d8@kernel.org>
References: <20260721152552.646164743@linuxfoundation.org> <20260721152614.000907002@linuxfoundation.org> <26425ef4-454f-4087-98ec-d045247242d8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 22, 2026 at 07:09:20AM +0200, Jiri Slaby wrote:
> This was reverted upstream by:
> 285ecb7d9e1b Revert "gpib: cb7210: Fix region leak when request_irq fails"

For 7.1 Greg already queued the upstream revert, so the fix and the
revert cancel out there and both stay in the queue.

The same broken fix was also still queued for 6.18 (as a backport of
the sibling commit 2eae90a457ba, which upstream likewise reverted via
05d5d79440c2) - dropped it from the 6.18 queue. Both upstream commits
are now recorded in our dropped-commits list so they don't get picked
up again.

Thanks for the report.

-- 
Thanks,
Sasha
