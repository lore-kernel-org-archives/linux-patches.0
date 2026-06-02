Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1643955ED;
	Tue,  2 Jun 2026 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424512; cv=none; b=cf4N7VhnWNtrTqVe0IdEns7UQ3O5QnVak1vwHrswB7XQUeS+WYR6No9c3IXfO6XcZXo3Cc61mI4dcA4y64XC5TBy+hIDxjyhaHizcTz6S+ssz149LjuGID+Wk6iHxyFW1txM0IZbnhbYCDTHBrOdWsInP/g8ylTvfyWLsRz3TUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424512; c=relaxed/simple;
	bh=rdJIW0U5Hms6fz0Svui8c485jp1wx/M0jcmFovht9I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpQG1TvnazOP8+XVTzuCfAZtZRn08MMPgjRpDiwm+qeV2VNnC0EXJ79eii9S0y/0e9fRb4sxHxxeOHgT9EE0RYbVIzTT+asJRDRGbYtlJAGR8eDOXGX4mJ4XB39Y2brx6arIKCJ+Qy+XWTRqNDgaTbAmqVkU5rfsw6eZiIe4fe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knAsFlV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knAsFlV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319631F00898;
	Tue,  2 Jun 2026 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780424509;
	bh=rdJIW0U5Hms6fz0Svui8c485jp1wx/M0jcmFovht9I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knAsFlV0bIy5Phc1zoCI/HeMTCcv6QRmuYpk5UABYdqYXggNiKMCjBeAFQEMnTVp5
	 Y/igctu0uYIBe9UGSz5xm+1xI3WQZ9sVIWccTv9AFCBpS+Fn3mGBOgsA+2RGs92ssu
	 1/yCUeaPSW3wlCRa4o2hUPBCWFVVR5zGGFJ6vx3VgV0H5WdB6c97zFs9Dlr0vImN4O
	 M8HozrAqSpu7Rk8XiRkL01TachkvX1Ckh1xs9Oe4AY2B27oCw91SoBqrCskadgzMr9
	 2WIUgb7oSOy1vPar5YbjIcDi69U8H0kNR/8ky/4ASlB5wLouZbTBYJEidKU11/dSLp
	 4Z1q714TJo17A==
From: Sasha Levin <sashal@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 5.10 027/589] xfrm: Wait for RCU readers during policy netns exit
Date: Tue,  2 Jun 2026 14:21:26 -0400
Message-ID: <20260602180900.xfrm-pre-exit-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <56652caf63e8db874a3ebd761ec134c003d4986c.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160225.295450347@linuxfoundation.org> <56652caf63e8db874a3ebd761ec134c003d4986c.camel@decadent.org.uk> <20260601015021.rc-xfrm-netns-exit@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jun 01, 2026 at 03:50:21AM +0200, Ben Hutchings wrote:
> This is broken - it needs commit 3e5241731847 "xfrm: move policy_bydst
> RCU sync from per-netns .exit to .pre_exit" as a further fix.

Now queued from mainline (3e52417318473782) together with the original
commit for 7.0.y, 6.18.y and 6.12.y.

--
Thanks,
Sasha
