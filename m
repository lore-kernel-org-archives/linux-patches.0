Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220C334DCCD;
	Mon, 31 Aug 2026 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140372; cv=none; b=r208QrLiHGsf4pEeIHaRkLt46flXwSBr4+so27ug903Q852WuqMvMS6nSva2kmg2qd3apJQLSadQoKCzJxpYQkjQ3y6qPD4Pdyjg/hD0smiIsOMjw7znHE1D1AH7zX2T9SO2C79CXGSKfM+7wtQN5Qt4IU3g5h3PFwvdM+42vuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140372; c=relaxed/simple;
	bh=e0DtKaib/dqflCBCNPSnfabwmo3F4P4i6IDKsjFJHzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSt6Qmfu3H11xbX7hGkItSQBb4dFz272wugnkFE6pe0DDatrEWSXR7uVrbu9k7sEOakJAPm5Zb48wu9SMEVArfcojdNNH1ZcmMGezzB2QWMJyubBS4hKCn/VbfI+5esUQcg1XnmN3RP5t6wOYpl8yHfMGhe4gZRrEXzQbWjWxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lseQFHtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lseQFHtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D2A1F00A3D;
	Mon, 31 Aug 2026 01:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140370;
	bh=AXzxwZEePmxAU8ce+D+tC30ri9yvBz/Z0RUHEmTiAz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lseQFHttj9IPzhpLGMEex2TXm1OYAVkKeNDy2NbFo0EYjkeoP0xbaTakj9o16Dnm8
	 FnbwTXVxKMuvp7GzLEZ9ZX1zZTypGDXTnBumEzfTHCAJAoRPWrydF+11QeAKHtq2cP
	 mNmSS9d++8pvIsYW8fz+XGcGatvIsCKrczf/1DcXCu49OFVUdiAYo5VDRAdkPhqVDP
	 LmvYCj0kMPEROueUTJ1FUIUTC2kEAE155nip3C6L0/qRkipfIUH+sI1QjdQRJC3W+/
	 bkuX013EqUQ/YtE9arJY1j/ttieCVN+xbyY8vyQ0Z5kiHZEzpBS3uffN60VcIst8dv
	 Ssa4VlAcLJ//w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 303/456] ALSA: pcm: wake linked drain waiters on unlink
Date: Sun, 30 Aug 2026 21:39:13 -0400
Message-ID: <20260830195200.0008-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <337d72a0-c301-409a-b2fb-fa4432602af8@oracle.com>
References: <337d72a0-c301-409a-b2fb-fa4432602af8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I ran an AI-assisted backport review of 3035bb784cea and checked the
> finding against 5.15.y. The new unlink wakeup depends on a wait-entry
> lifecycle fix that is missing from this branch.

Queued for 5.15, thanks. Also picked up 9b1dbd69ba6f and the two
prerequisites - 5.15 was missing all three.

-- 
Thanks,
Sasha
