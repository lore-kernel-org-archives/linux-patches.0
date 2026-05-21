Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0293D8117;
	Thu, 21 May 2026 12:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368167; cv=none; b=XF2GVZANbfG830wl8uGMwnzLeHpavG+6TCsGdfwcVbSxwiNLkzqJHfxnRBWuqL9ilqwJyWf88MZKkEzPYzo9H8GUkbnQ00Gqr7I0XnKUEsqsKtprqoHTFPdA6OnyEg90dpGJsuqY+dlJV7UTfBYpieaL8/dFZxJKETa7XE3XOQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368167; c=relaxed/simple;
	bh=Rw3BZcniyE7DzTJJpH9sFVm6COcKYi/DQYIpWfRpjAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw3Vo2D0DMPzPWkXncWkevl0xV4IzXgigFUcgnNcG6EXP4PdBl+2zuR9FzFtTYSMUmSZnNGYpnj331tOMjVpLNItKmqyGEGMI8roB/OiLVXrtT5aTjrUyUqWHJPvBWUlmMd69Bg6oev4hKOP84MQPSY3pcR8rnY+elWDPA0KcEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmwdsozH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmwdsozH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109421F00A3B;
	Thu, 21 May 2026 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368165;
	bh=Rw3BZcniyE7DzTJJpH9sFVm6COcKYi/DQYIpWfRpjAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmwdsozHRWEDnL/bKvgFhs0oqS4A3mLRjrwJSnvDsBi4IOcbZ21C9gm6scVBXHzT7
	 2WKB55I8zGlqBeUqk4cvDGuQlD+mrPhYPoLPRNrryY0C9ce1YYcsKdbfy3sqtRoGf7
	 4GuumC0MQDh6qXe8K9ackHDGIvZ2owtgiefaaHxaFTa+dzRW8/UAEBhVzwFzB49I9l
	 LObcNkQd5RNXsp/2tGEw9jMrmPcD2QnMxk0q3bo0dRFVJXyAa2iV0+sMh7nKduJklE
	 O8qjXkGWqpxT5BJqjfo+ScudmPTSzAsT3+QxhpZ0fifs+rN3aMq/Zp/4pV9dcIyoLL
	 EwT4uBrCl5NWA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH 6.18 010/957] erofs: verify metadata accesses for file-backed mounts
Date: Thu, 21 May 2026 08:55:51 -0400
Message-ID: <20260521-erofs-6.18-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ag3txj1lJNTGZQjp@debian>
References: <20260520162134.554764788@linuxfoundation.org> <20260520162134.785057461@linuxfoundation.org> <ag3txj1lJNTGZQjp@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, May 21, 2026 at 01:22:14AM +0800, Gao Xiang wrote:
> Could you please help drop this too, the same reason as:
> https://lore.kernel.org/r/ag3qlMOcTYM2FBUQ@debian
>
> I will address this backport manually later.

Dropped from the 6.18 queue (along with the 7.0 and 6.12 counterparts).
Thanks.

--
Thanks,
Sasha
