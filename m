Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8868C3E1225;
	Fri, 29 May 2026 12:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780058651; cv=none; b=fg2QQDEd9MyX9/8lmwqfQTvmtPq+54JGRdTGs6u4Ih5b+St0sXPgF4kFgmX0CIm9KUYstxCWF4nQRasvgfwUjf6X0uzjKvkN1ZQC5w4ZLzCOJRyDOXMNl23whXsukh4bQSljFpH9jhb249w8oQh8LR4uvfGwlXqA+6oRaXoYLe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780058651; c=relaxed/simple;
	bh=5S9XX1w5jtOy6zLol9okjIWGMPqpVRkiJiA1cY2oHas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kq+IIsdMY1jzPyZBpLKzXsbnPsFwaJD/P5r+BhnidlXJmKo+FLibkZTkTFrVd9ezpH4HKFTlxUCrGP7zClP67ZyUuGask/wlV9Po19GLQREzdF3PzMPE3V1SzOlRn2AVxQORQHi81EqsvvOrOwxd+qu8hdfwP+JU4pr6FJLgeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uaj0x1xt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uaj0x1xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453241F0089F;
	Fri, 29 May 2026 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780058650;
	bh=5S9XX1w5jtOy6zLol9okjIWGMPqpVRkiJiA1cY2oHas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uaj0x1xtRu0GIRO8y1iUmHPQJh57sLUi1JoGcMpRqUI6wYKJjstOyM1MLLjH3Rruc
	 IT/bynl4mRuZvMfPlMQSeq5O+vzOhL0kELAE+gXXK6oeLnfCVoYmKDbrIWuMaaBBPi
	 l+TDNw/0yfXLSrTufv0Mv83XJOZ2XIc1Z5jXv8Cl1r9YIZd1wU29oWO42SRErONJ5n
	 4u7e4PJ+B4Jyl2+9uMTqCsSFEVAZJdKSI6thir1A6jxwSvJYSZT8pX5Y1iMSv9Lei9
	 e3bnb+qttJ5AQmOPxNgwC0GQ6lWQyJcBFRbGb6HleVURfrsE5CbW+LmuIJpXHTeyQ3
	 sQDgqn1IppB0w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [PATCH 7.0 284/461] net: shaper: reject handle IDs exceeding internal bit-width
Date: Fri, 29 May 2026 08:44:02 -0400
Message-ID: <20260529120000.shaper-rc-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d66f5c95-ebc0-4c53-9852-f73c790363f7@leemhuis.info>
References: <20260528194646.819809818@linuxfoundation.org> <20260528194655.415018028@linuxfoundation.org> <d66f5c95-ebc0-4c53-9852-f73c790363f7@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, May 29, 2026 at 06:23:04AM +0200, Thorsten Leemhuis wrote:
> This causes a error for me when building ynl.
>
> It can be fixed by reverting this patch from the stable-rc queue or by
> applying fbf5df34a4dbcd ("tools: ynl: add scope qualifier for
> definitions") [v7.1-rc4] (preceding patch from the same patch series)

Thanks Thorsten. Dropped from the 7.0 and 6.18 queues.

--
Thanks,
Sasha
