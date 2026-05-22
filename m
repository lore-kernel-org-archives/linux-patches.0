Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFD939DBDF;
	Fri, 22 May 2026 13:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455561; cv=none; b=QZ958GULR8MlID/GUbwtOHi36Sg8lVbcXbcvCIVTvy6rHym8JtXcW83Z9bx4k4hrQrzTJQWMF0lldi3RviycWEA+IuoV3ohquNy3vDzv3zlmuDnPzc9Yeqoib1p0Ovyu/BTjL7tdvWMOG2RflXpIHhcYQuF1GzOFrJfg1b1CD3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455561; c=relaxed/simple;
	bh=qZlXcp2FMSX4eFyArqwAC4vZ730OFDvZrN+MAyaMbE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YD/swPlDF+GHP3H8shejfeEQ2kNymH5/KzDr/t3RXxspMk87ifgLgMBegFkGk3o4JMMUd02GEYdI0N7Ut8QMiSRFOP1VL1785fVoTvscA6Lkj4JiPK4D0rhd8i74gZFIKxeZXUMfnnrLH4NIXOmay+LK9aRxVqHazL04xij5d+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3e8y0WZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3e8y0WZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37501F000E9;
	Fri, 22 May 2026 13:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455560;
	bh=qZlXcp2FMSX4eFyArqwAC4vZ730OFDvZrN+MAyaMbE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3e8y0WZqzVql1aQmV4KI0rBhSw1Eg1zLpCZLOzG+rqbKkiPyczNYYvrLOvutihPF
	 qhuKYwDP5zgHWbZdXFNNCp5BCA0Eblqxha1Y8UcsLpsIpwRL56c8XLTrm4jyQdSHMR
	 DuXzLSv4Ol21RP9EZeHKGBduKMsdNc7zL73b2vYUCxuDm/gGCMI1Vdr7uJPHJfzivt
	 H2mOMHcvJ5itv2pDpBOa65EQnh5LJ4mdgbGahAkH7h40buy/fVy1UBWXH8nY0gNL0y
	 NkjCQMMG9nRy3LUvYtj4QjzL2X8bHjvliI2RiOOUKvHEy0FmbRVzLReoRySW4YyTkH
	 Dd6Q6698FGNSw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH 7.0 0446/1146] fuse: fix premature writetrhough request for large folio
Date: Fri, 22 May 2026 09:12:25 -0400
Message-ID: <20260522123641.rc-drop-5223e0470e7b@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAJnrk1bWJfT5hswsJ3X5HMZ=XLz5MO3pYXg6WkuYYvZ6ccS0Nw@mail.gmail.com>
References: <20260520162148.390695140@linuxfoundation.org> <20260520162158.293493405@linuxfoundation.org> <CAJnrk1bWJfT5hswsJ3X5HMZ=XLz5MO3pYXg6WkuYYvZ6ccS0Nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 20, 2026 at 11:03:05AM -0700, Joanne Koong wrote:
> I don't think this is needed for 7.0-stable or 6.18-stable as the bug
> isn't triggerable until large folios are enabled, which fuse doesn't
> support yet [1].

Dropped from the 7.0 and 6.18 queues, thanks.

--
Thanks,
Sasha
