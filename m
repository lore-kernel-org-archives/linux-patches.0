Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD81DB95E;
	Sun, 24 May 2026 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779636265; cv=none; b=qIFo2KdxvvUh6nxp9cNWPNmOR+BVmegmCCCb3oVjD/d8Z3T3weUNpJq2mwp74vW+FNZnT+gvOD1le4lgFrL/H+K2u4ApXfNPf+3yP1RGeY4XQmIgXK4K/pVHPktY4W6IPqj3M1RPifMW7IUEU9atuiwzKR6iP09p6NnPYCJpM7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779636265; c=relaxed/simple;
	bh=bCmyFjdA4iHIcezigm6L8aV0+RJvDjszZV0U6GoEwxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx/QY7NBwf2uHT5mFL5Xq7q1NNz5H0jv5foR88ggo1ZNdye7hGmMIDGYHPyrdhYE1dDT84bDo1rc0b8Xcvh1st+TFb5zHGACm+o1HbJkW2A4h+rJBu3LfQTKGgfFzjzKleHucLx0CDb3MuQeOg/Fsjp2rGxGN9HcFWNsSuYjS3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHPsiYXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHPsiYXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BA1F00A3C;
	Sun, 24 May 2026 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779636264;
	bh=YVnkto8I5OXMziaCAPLSNc2/SiJXFVDLCRyLCKuVUNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHPsiYXsXTPJ+Ix8OXjSvGV4ncXpsfpk2DgEbzmPmlORIHF9Fn7ZjTUjIUffPTIJX
	 yk8z/AIq4JkNG8JDolt2dcO9dUEL5GgnOzjRjzhGKLS3NEmhaFKXqenrDC/1kAY7j9
	 QzQaHs3NH91yITyPnI5VLL76AsFGuJ/76p/wnnO8P9tbW/0JuwE9qDgstj3XAR/Kp0
	 mg+lXzo4PAiUOGuFagHOPsKjRVtkg1IHGsQUyTQhJcnA6wf1D9dKfBpxKpsu30FzqN
	 vy89MQHg4+1SdUwP5YgNVDzeOOUV46lsGcbrkvEnZy/H6l/SWEBeyoPBKLwPepcli8
	 RSWiHZFppP1vQ==
From: Sasha Levin <sashal@kernel.org>
To: Luis Henriques <luis@igalia.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 6.18 346/957] fuse: new work queue to periodically invalidate expired dentries
Date: Sun, 24 May 2026 11:24:17 -0400
Message-ID: <20260524150046.agent5-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87se7h6pul.fsf@igalia.com>
References: <20260520162134.554764788@linuxfoundation.org> <20260520162142.034488466@linuxfoundation.org> <CAOssrKcqmVW3kJ131tRF3LCJVQUtdRB31B5HENDfpgrq6r=jEA@mail.gmail.com> <20260522123641.rc-drop-ab84ad597386@kernel.org> <87se7h6pul.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Hopefully I got everything correctly, but it would be great if someone
> could double-check.

Applied to pending-6.18, thanks.

-- 
Thanks,
Sasha
