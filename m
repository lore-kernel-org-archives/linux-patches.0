Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4661D6195;
	Mon,  1 Jun 2026 02:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279904; cv=none; b=b3CetlJkoThB/OiJ1hFR3MCcKK7vJnlouwqC5zTcJDORmOC4sToPrYYCgpqRD/xAR2M8Jx5a6+IM5+EsR/OWVrfH81s364Qckri9UvoNOfQtBky14hkEbHeP2MBFgnaIFhpiSqdT0jxaLr80qBdszU9h1VSm37DYMbArpZ6QQjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279904; c=relaxed/simple;
	bh=noOQkJnS+kg34w2ENAmCIlJr3+QtzCUphiZ1LEJl6po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIj1n446zHcrHX2YzaJQe+Hs0mocUIvNB2Le+Sd1wHJfz2cWttvaCXKnMsmU8Qt5EuUvNnSI6CvWlRi+gp6t8822ff7B7RmLm7UQjxM0zzrHHyZwAP/jkHuZ0Sw3ioOHA49jItvuzmQJXSmKBgY7vdL2U340Jy9djktK8woG/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXbnbrhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXbnbrhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8361F00898;
	Mon,  1 Jun 2026 02:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279903;
	bh=68fFO6mi8JqVvDJQNtAA6f/QnBMPze0eEJmwSNSLukg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXbnbrhzhAIILPQE5Xi8UD4zzyVhbxlw/sCMXKE6EiKJ52+VL02zleIv1DSN/v2ot
	 qmk/FJDQIa+p5qCodEE1zcbJTF+VE2DFKGq48mKJDUHjLH5kzu8ILynVV1Jepw0hed
	 7BoLrju3ehk/EIiPS55Nr5Wgg/+yrQYYGZ5szNPqOzEkQcjXB0TvwlCpVQaC5iW4xB
	 dzaBikBlQtbdaI3Fodv2bMbWhOH0le0sIxh751Sp/7pwQwu1a4zhKrTXaKCOvaFg7M
	 O3WO/D89nfcNocwHoZG+6Ayhn9JFwoG0jwxFcYZCMgB7n8WDduIENYLft1MiKl+BS5
	 3Ug1yilQ7kDsw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Angel4005 <ooara1337@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ron Economos <re@w6rz.net>,
	"Pavel Machek (CIP)" <pavel@nabladev.com>,
	Brett A C Sheffield <bacs@librecast.net>,
	Mark Brown <broonie@kernel.org>,
	Peter Schneider <pschneider1968@googlemail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Vijayendra Suman <vijayendra.suman@oracle.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	"Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 5.10 072/589] media: uvcvideo: Use heuristic to find stream entity
Date: Sun, 31 May 2026 22:11:26 -0400
Message-ID: <20260601015021.rc-uvcvideo-heuristic@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <136f03aa6f51bdfecc786e5278f5fd03b4a6966e.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160226.496219768@linuxfoundation.org> <136f03aa6f51bdfecc786e5278f5fd03b4a6966e.camel@decadent.org.uk> <5e2ac444-451c-4220-8013-0e6382b5f165@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 12:53 +0200, Ben Hutchings wrote:
> This doesn't properly fix the problem.  Commit 3d9f32e02c2e "media:
> uvcvideo: Create an ID namespace for streaming output terminals" (which
> reverts this) needs to be applied on top.

Rather than carry the heuristic and then layer the namespace rework on top
in 5.10 only, I've dropped this together with its regression source
0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id
UVC_INVALID_ENTITY_ID") from the 5.10 queue. That mirrors what 3d9f32e02c2e
does upstream (it reverts the heuristic), and avoids exposing the
0e2ee70291e6 regression that would otherwise enter 5.10 in the same batch.

Barry K. Nathan wrote:
> Comparing this patch to the corresponding patches that went into
> 5.15.203/6.1.169/6.6.117/6.12.58/6.17.8, I believe these Tested-by tags
> may be incorrect.

You're right that the tag set on the 5.10 backport was over-attributed
relative to the other branches; since the patch is being dropped this is
now moot. Thanks to you both for the review.

--
Thanks,
Sasha
