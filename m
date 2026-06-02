Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5458392C47;
	Tue,  2 Jun 2026 18:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424514; cv=none; b=W0HewqoCu7bpjNJ6aKZwswXY1F/7CzA5OBHdUqDUSOLzGGnti7b+0CbGRlryhZ1krrtX2zh+/heuxFtk7jGWVC2Uj8bR1NzllE4LueFxiA62kA/K66slpwFDoKq17mmJSz5U7Ul8ZT+lEReThiGaySVQO7ZHurpzgh+om4WsosE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424514; c=relaxed/simple;
	bh=LnjFp/8BEVHPTPjHpfI9+wUYjQg7IoAdMbzSaJlBS+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbI4onYDaFqBsVI8yHY/GByZXDK+krrt+crvhQbesZo7MsKRjoP8a6HZg+lFEpQxMvNp6Cu7OpBBNtCsFVzYCQcrQOUx4T8l+q4BHmPmqLIDQ0sX89ara2qHfmyMQVZXc00RmfjXEzTz7oaYxgEZNsuCe+rOSdJAOBaX46b8ClI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSV1iIzB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSV1iIzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D0B1F0089B;
	Tue,  2 Jun 2026 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780424511;
	bh=LnjFp/8BEVHPTPjHpfI9+wUYjQg7IoAdMbzSaJlBS+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSV1iIzBiGm1P5Vn/do1Jjsv7PMR9pTXiTiNYk4dUKA9TectMP4IiM6CaBfvDp1Zm
	 3HcXNwjohFOYBYl0PGusLWq5ztX27QSLtu2OyRtdzRHfxpmMAKyZ4QtIKCo/5kGOk8
	 wxml5ArvL325o9eY5G5N7sK9ougNbPo+RaOTt+cHzuwLIIqeopyoTEznVbU1qeLlFH
	 QoprLngMs9o7Lmn0ecIx3xmRvdkUlWtQNtSSnxIcYWl5osoAXsCuOmb6OH63p6QlZy
	 e0ew+0CrDd+6CZDgmQXlDDVCODxFkwzAQTNXcutEqDVZVuohUyI6PuWrqj6ZEG5JLQ
	 2uGfSpkfaZnpg==
From: Sasha Levin <sashal@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ashutosh Desai <ashutoshdesai993@gmail.com>
Subject: Re: [PATCH 5.10 274/589] drm/gem: Fix inconsistent plane dimension calculation in drm_gem_fb_init_with_funcs()
Date: Tue,  2 Jun 2026 14:21:28 -0400
Message-ID: <20260602180900.drm-gem-prereq-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <edea6d36625f362c3fcaed6bd251a02827081a1d.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160232.175451425@linuxfoundation.org> <edea6d36625f362c3fcaed6bd251a02827081a1d.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jun 01, 2026 at 09:46:20PM +0200, Ben Hutchings wrote:
> Without the prerequisite f2f455981a34 "drm: Remove plane hsub/vsub
> alignment requirement for core helpers" the queued fix is a no-op.

Good catch. I've now queued the prerequisite from mainline (f2f455981a34)
to 6.6.y, 6.1.y and 5.15.y, so the queued fix is effective there.

Thanks,
Sasha
