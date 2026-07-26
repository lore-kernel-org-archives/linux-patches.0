Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C68531AA9B;
	Sun, 26 Jul 2026 12:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067511; cv=none; b=ds1P4Cd/mkxxVaK4FU7S/oLnpRiMwejFcOn8YhOwZMkSXLMSqk5e/P57aap3nTAHCUUz0201sGRUBoTNEi/0cY4mdmz+H/6mxcf/0XzxHofLUwMTIGsNRPtpV8jXg5GEbwFuk7AVi9wxfv9eT1sYIUPomZhQL0GV7KcNj/WNo24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067511; c=relaxed/simple;
	bh=p0NintpkwuT6uW6wiyrjMufXH/HtS/070ewzaVAZCxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apgeg34Z8OZ6vKbVfDQToGWGHEso4Mp8ihnjzRsSAHVjXUuPEWRaTAgidb5wJCvlJJGh4RubXmjphgFwShWlI0auvvmAgaunfUsN1AOv2/RAMh04Lr5R6e+WTDGg8GJ2tG0IloNaXo5sGKwvo4LR6BkbDdmy64SFi+AbKlLPR6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQD/0DpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQD/0DpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB1F1F000E9;
	Sun, 26 Jul 2026 12:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067510;
	bh=o5Ujc7ay7eT7tA1pAnDWUFx8gMbzba78pJTfMPykI7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQD/0DpTbp5wGaWV0+JOgibGevkY/tCFS+4gS/ZVld0OjpOutUdpAbI+eCv/IRMEM
	 cfg3Q8fvazOwM+wNsYbH/u3LhIX7mptbMHh5EeN6Lj3AeEmbffSqhQ0kEXRMIUkc2u
	 hKHiRC+hMH4cUdvKLbiWLIwaKBI7rtNzfdKzTrsggCvi0wQiXaQZ0S8ZXALAGtgo2R
	 0HNpS6tp1eLEn9UzoLsPNOHevS0qaSHSpUNEdyb/NH1FqouekQqvF5tUD0s1Da38Dv
	 r7V6dfRF86TUesiYlpBN7LRU6XMGQzOOdHBN9rqz4juwcEWpmc2iMb+AQhqtr/kbST
	 OHxL6VPiHNJ2g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0454/1276] drm/amd/display: Add missing kdoc for ALLM parameters
Date: Sun, 26 Jul 2026 08:04:51 -0400
Message-ID: <20260725192000.stable-0012@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f3983301-c8db-4071-839c-d153b7e0efbc@oracle.com>
References: <f3983301-c8db-4071-839c-d153b7e0efbc@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I would suggest dropping afefa5685cec from 6.12.y. Also this is a
> documentation patch and not a stable-dep [...] so lets drop this.

You're right that on these trees mod_build_hf_vsif_infopacket() still
takes only (stream, info_packet), so the added ALLMEnabled/ALLMValue
kdoc documents two parameters that don't exist and trips W=1. That said,
it's a documentation-only change with no functional effect, and the same
backport is queued on 7.1/6.18/6.6/6.1/5.15 too. I'd rather leave it in
place and accept the cosmetic W=1 note than churn a doc patch across six
trees. Thanks for flagging it.

-- 
Thanks,
Sasha
