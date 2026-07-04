Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E89371D11;
	Sat,  4 Jul 2026 02:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130744; cv=none; b=m6Z0TXg2W57SjNh3Z4j/OdJkzyA+4maKVmG/xg43PlJQW5UBCFiOLRDcSxERmSigpQcd96Ps2XJg7T8xX7Lxvrdb5NviFcXrjK3x1zYYnD2E/aZxiMcf/6TOTocivKEnjTIKqnlynLOuXY5WIhqFgs3pGw45UviUfk4ytiPO33g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130744; c=relaxed/simple;
	bh=Qt4Xp09dL773RVreQY8Jqawj3O/gz/+3BRcJ8dIWvxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmdOqIFhC8ZPOxUg784J4mNSaDo3QMkE7zhya2kHYOL8jms/DRh5e4WtPO0GEe/gax8tWN4XYBo0zfozOAclRjcGaQ9HpzfrEwVNhdN+ws4ThNoeXH2P0eCpsdjo5pMt61SDAo6p8KZz8uSxgMhPXum1ydACU3r8Rk/8m3gfvdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leUcpbIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leUcpbIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AC61F00A3E;
	Sat,  4 Jul 2026 02:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130743;
	bh=8rXstIs9JnkJhpz7D60JzTKXc0uvzlaqrZCNA0Eg4S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leUcpbICIQSM/cHBd5Uy1T6rCRTCLleR710ZBMycSUikbvxq+QefqKinMEWA5okf7
	 22SCRazRdm2GfWopujCUKAJTaYZSCn3ckN3xsS5ujNyDHHNgwy2GFQDmZyPdysC+LT
	 z+OKoRO47hgWmSAUbQYPe2nVrzE/v+J+1gZwIB7ROb+D26KKWfj9vkvswC43zBGbGm
	 CFrPOYAI3JxyoJeyZV6pVQs/ms/pxkDmmRr0qP41AKrS7fxaXmM0dprwODNLPzESWD
	 n2LrBC7L9V2PblvQJMC/1MqVHHe64885Rkz9m1qSUlImtUtVT1Yo6sDKQYxMTQRVB0
	 pf4FBjGOlKNLw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.18 044/108] block: invalidate cached plug timestamp after task switch
Date: Fri,  3 Jul 2026 22:05:09 -0400
Message-ID: <2026070315-stable-reply-0015@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703123236.3139759-1-usama.arif@linux.dev>
References: <20260703123236.3139759-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 03, 2026 at 05:32:35AM -0700, Usama Arif wrote:
> It looks like this patch was backported, but the preceding patch [1]
> in the series was not bacported to the stable branches. Both this and its
> prerequisite have the same Fixes tag.
> Not having the prerequisite will result in a NULL derefernce.
> Could we please add [1] to the stable branches?

Now queued the prerequisite fd38b75c4b43 ("kernel/fork: clear PF_BLOCK_TS
in copy_process()") for 7.1.y, 6.18.y, and 6.12.y, thanks!

-- 
Thanks,
Sasha
