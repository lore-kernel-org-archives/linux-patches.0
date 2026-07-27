Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497503CFF4C;
	Mon, 27 Jul 2026 22:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785190800; cv=none; b=NEhrsVQv3Ij3W7mL4JzEHoec2a6gX4ziZLCZQSJGkd4Y4eQMZCkP3/xY6ZfkbRNYl7qyvcpGV/ffJ7kKOnIFwgFFpfoPrl2OcTkSlf8028n4zswXXk0FnnSpSCosHvDJ07gAJtKXUS3s+ISJBJN+vHr5rLDvmL/gczLFu9hrqSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785190800; c=relaxed/simple;
	bh=gvTVxci4t8QfNmv2JF3/+So+HP+x7tvYOiGmseRES4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tkcx1TQSdwwOAut75EAKRSOGRPVLyOrTiwZaZf6LPeGsVm6zGNyBpZLsl1O4ZbvmFwe7vV0MBMEzcWGCqn0jXUJrS+W7ipO4C3GskeWaa4DCByjECufLaHjYUT4lN2IlH7I/KF6vf5FN6OgsPMwOhxpxBRR9+yQ8upofq/pJLiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEZkQLjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEZkQLjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60EC1F00A3F;
	Mon, 27 Jul 2026 22:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785190799;
	bh=1dukqPrqxIjiLYEw4biR/CMOXcRIHL2hDaISx6uTEG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEZkQLjIM+D4dezA6LsRWG7eLNcAbJGwzMXPWZ2yEN7tFhKklaEKfQW4CHZudlGwS
	 6U+0s+6JC25SUrwi4gE6Kbh4Sm9EWsbYvxO2I4roC/xqAMKlC46scL+JhHlbEfL6Ei
	 G2Kyl6DIT8g5kKkvu0VKDn0Wpca8sk8zOF9yUAEBfhfntu3HvOVRopAc9CaqAyhluf
	 EceFgemiQ2trPlZLLjP2WBs0x7HihEtFWk6nW/5/04u3oe3I0JcYW/8VZDoEfIXcd1
	 /WQywWFRmO5ly7U/Wv7/M2GEwGV2HWOzJblR4jF+9EcIcw2vjSZvS2+ueIz5zYTpT7
	 JtbI2GaePIAWA==
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
Date: Mon, 27 Jul 2026 18:19:44 -0400
Message-ID: <20260727202413.stable-0011@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b7e82885-cb8c-4caf-ae0e-1494ad94ac9e@oracle.com>
References: <b7e82885-cb8c-4caf-ae0e-1494ad94ac9e@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jul 26, 2026 at 08:57:22PM +0530, Harshit Mogalapalli wrote:
>But this is also a documentation patch which is not really adding a
>functional value and with this being incorrectly backported, should we
>just revert this ? Particularly asking this because it is a doc-only
>patch and not really a prerequisite that would help other patches.

Okay, makes sense.

I've queued a revert of it on every branch that took it: 5.15, 6.1, 6.6,
6.12, 6.18 and 7.1. 5.10 never picked it up, so nothing to do there.

-- 
Thanks,
Sasha
