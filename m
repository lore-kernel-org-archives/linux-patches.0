Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA87B380FFF;
	Sun,  5 Jul 2026 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783259524; cv=none; b=jeguGgXDYR0BrS5ZnA1HMMGp1MreIIII9XAVxssfH2cqGJGNUFcso/XgREcCP28FJiJCQWorBkjD1Hl9Fi8cXL/Bdri/EiiagBU6RvKFigAvjQzb8hOBJvjz/SqpQ3fIn4PlV1ilFpehWSLiGNvG/qk5FRMcc4Yc60ubT8fTCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783259524; c=relaxed/simple;
	bh=eYN10jhbU5tCn6/5Y8XDLGmsMOh7RtmASvrbY3HjSOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMC6TMYxRGHP1rz7aAgYImHZ7v5/qqcI2V47juFQpbykdhyVxKHpqmh5Rs54wzhWHsIp1Dfwv+fNQ9rsLwhc0vYMe30jcYYravxCfmVo7gg8BIGOcDO9+oDLWx3YRnt86aU84pcM7SM3+mwh789hZG6MyBlc7Tvnk+V1bPG/eGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+murOkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+murOkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05511F00A3A;
	Sun,  5 Jul 2026 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783259522;
	bh=15RhclRZeDRYeGdfjiwjjHFHg3rWOilE646fxYJgUCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+murOkDxCQvRfegRMdjqXhvzeSuWmah5DyE5/7UcE5fL5CB+Zxl2aTYQ/F6bkiAt
	 kFT7Aigh32hMi+6OZHpdoiUFulb4VZK1M/YY7GMt1MSzcRpzzwTxiMuwxyS2VD2LG5
	 IB9MJsg6zRmx7pp+OVs37RNMB8fHYazLKg40XrzBnHKctnmN3HZkGmiN/GDRlWIP5R
	 1/5CiSs90IRDl0X7pYntVUepQYGS4jFkKGPVKJV0pHSQlTW8aa32pL7ZH4i/ib5oE6
	 rNyfj03uWSZOHJ8zamggXJRbj8tiMajnEEeD7zV8J4NjNiWAM5hyogK63/Tfoi05a6
	 rfsyKpxOVg+Gw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 11/96] slimbus: qcom-ngd-ctrl: Register callbacks after creating the ngd
Date: Sun,  5 Jul 2026 09:51:57 -0400
Message-ID: <2026070416-stable-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6359da4c14e0b4c6ffa068407a42c07e56ef9c5c.camel@decadent.org.uk>
References: <6359da4c14e0b4c6ffa068407a42c07e56ef9c5c.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2026-07-03 at 23:16 +0200, Ben Hutchings wrote:
> No objections, but this is missing from 5.15, 6.1, and 6.6.

Queued for 6.6, 6.1, and 5.15 (along with its prerequisites from the
same series), thanks.

-- 
Thanks,
Sasha
