Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B328F1E7660;
	Mon,  1 Jun 2026 02:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279906; cv=none; b=k07IH+SOQAc70c/kqvfk/OHhBKA5gT/PsFfxIEQS8NumfKLTNzxOzs1P1YeZQvfbE66ifU6B66jT0HLaepb5Xr+2ZPxLInvIU86uQj8W4lC8Seon+ssmDXBtL7h/ApsxZLu5DU18RwJ78uigzKFrLZtO5Ro4ZA0BETQRVlboPLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279906; c=relaxed/simple;
	bh=8gEHiQfL1w6bsJ0dI8NRlpnbasTjOI1zjqmceCac9Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWCyvBSd3IEwd4b/YlJL8SiWSmaTDwA6Z5Hmjn8NqzMNvUE5xEidKjj38/FlGoNkHAXqXVg8DEIKBLJ/AVjuRMCdQuMplTQ98RaLLtVarRkGNGDbKYZhhsIiXWn+OPLaS/AsybYZ/8O66NE0gtI3QBBkZ6huX6sDFggp8Hzl5eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XW5xSMKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XW5xSMKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E041F00893;
	Mon,  1 Jun 2026 02:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279905;
	bh=nb7+Fj9UNrgVsO+cZppHOZerZQY9HyaZJ+JhMP8sluE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XW5xSMKIQQiAaZldNW+z9uq1IZUpYEyWbC7a+yCprPqciy0QmSja4utV3MI5ltJW0
	 4Su+a5g9r30vdeMpj5QRf5qO2xmGrBwZR3pqPJpFgITLN7b/oTyU5SPUgmmrkiy/Fg
	 cKqsIFxDI4ulIIoRnYXBxk4KluLj8XSpVNAh7C5FRr0WfGCGxMER3VZ2Al259hNtn2
	 Y9wyYx6wEk/S/kkS+BJd0jvVns8hCMz+n/cDnpEPTqM4TVA5IN672gHAN3u3gmogZO
	 H+/bRzRaEAOjHZtAFwXScgctRUaZBh99fTgAVlyD6fbQ938IJKvSVFlB2RyyP7GfJl
	 wj8TTo/371VHQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 114/589] arm64: dts: imx8mq-librem5: Dont mark buck3 as always on
Date: Sun, 31 May 2026 22:11:28 -0400
Message-ID: <20260601015500.rc-imx8mq-buck3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b7871589afa5bc3668b07550b9e8b69b3a6c15dd.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160227.753209120@linuxfoundation.org> <b7871589afa5bc3668b07550b9e8b69b3a6c15dd.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 16:19 +0200, Ben Hutchings wrote:
> But not for all hardware revisions.  We need commit a362b0cc94d4 "arm64:
> dts: imx8mq-librem5-r3: Mark buck3 as always on" on top of this.

That commit is already backported to 5.10.y (as e5da8b37ce34d), so this
is safe to keep as-is. Thanks!

--
Thanks,
Sasha
