Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B891A3AB0;
	Thu, 15 Oct 2026 00:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022937; cv=none; b=rOWrgJppLaP6sJ2EmyRYd1SWCdankkWfQ53vGdZsuF9DziyCI4iT4jGmO8jJARGW/hiORRxTXh3+NJPQTqKKyzXuia47HpZoYAKvKniiwbOPmT/6ctMf8dXId8ksMMwIYZf0jpgj5KJtney41qOyy6SbbRBIIMFtadBw1Bj+M5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022937; c=relaxed/simple;
	bh=KY9ncHneXC0YgdbeQksEoEB92NKY7/gfwNoVtVtqqcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPRgp3aDMgv8o+yB8RPQbCsA+wFTKWaTwRrUvemtLsfeeX+Zt/onhaGYVHjgcS2GqGG30X3j0cCDEo6AHBZGmMQ2jpGUORmUiERpu4gQ8RkgF8xQY5ouV/ea7IebaFv/OhIJnLSLRzNRKwLKeBmJO2/3TSDmGmz5eeqUrdHzE/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/xaepha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/xaepha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B0F1F000C4;
	Thu, 15 Oct 2026 00:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022935;
	bh=fKrZgkBrdziZ40JLxaQYNDsoBVCIzpRLHyzShanQino=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/xaephauRn9Ug/Wx+NUhmlhkPc8rDqu4ewf3IKf8dTGjhvY5CKW7bEYQLe3VXdms
	 n+rS2J8JUnkCoChZF3fDxJgx2md/kDRlrzPlKaIHrRgI21d+688Lhv7dGVzpJBDut3
	 IdqIfhpA7iJYSauVUmATM+plPfBT4+KXRTpghv14Ur52/s3XyJfxaXUzTRVNEXjwIM
	 J7UQwW8zzZiDuKppRTgSS9QBWX16Q5ted5q7L8f/6KGt9jIynHsANu/qdeiqKLcdMv
	 7axooJ4h0q0Bb+4rY6srjVu1Gt4lem8wYUjGDx3r4FHsPvYJm76Ezj2OCzYYM65JWz
	 4N8lvqVO+iVAg==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Daniel Salmun <salmundani@gmail.com>,
	=?utf-8?q?Rapha=C3=ABl_Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 6.12 130/497] Input: synaptics - limit T440p InterTouch quirk to LEN0036
Date: Wed, 14 Oct 2026 20:08:43 -0400
Message-ID: <2d3bf713f9e7457f884f1908@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8868e018-3be3-4de1-a066-5bcdf7aaf124@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112910.975677311@linuxfoundation.org> <8868e018-3be3-4de1-a066-5bcdf7aaf124@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> An earlier allowlist match can succeed while this second match fails,
> allowing board 2722/LEN0036 to reach SMBus setup. The parent rejected

Keeping this one in the queue. The kstrndup() failure only matters on board
2722, and only under allocation failure, so c1df7e4e4951 is not needed.

-- 
Thanks,
Sasha
