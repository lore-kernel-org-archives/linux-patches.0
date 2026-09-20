Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34162BEFF5;
	Sun, 20 Sep 2026 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865236; cv=none; b=VqpbVkKwiMA0ft0rA6MpGoh+tWCcITN8XauhtD+JXomCtMiwz7MtejQXmqIPz/eU6W6qlNlofWb28zhe+Mbe1tlMs7exIOgBarvdQIpZTQuargxNkYzYCJIcmm6Ri/M8x4EE8HHxR+5KQq5YJTJA9RaJHZSDdoMC5cHFSgIhHOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865236; c=relaxed/simple;
	bh=UNil576wy3YqGC+OdBXatPlqFMMQukaIVLhF8dcClUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+WY7VenGeCOowrAJ9QcMCpqcr03Pmxxus6FBe2tPPwf7H7A1SYAC5f9QGZJR2URgZtzAI3dnOuy8PJY50b9ycvPJs9+P2qsVLYtye7wJAAXs0s/nGOZpKlNVVl9afIhmmD63O60G18qHw/1eaZTHM7eTIXdkHRZ6GILnrSVTYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vi5BU9IV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vi5BU9IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6981F00899;
	Sun, 20 Sep 2026 00:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865235;
	bh=HmkVbGbiU415KSP1X7ovgxUDjspcyWllQez03V06yA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vi5BU9IV8RZeaiVH4p3AgDU33tcIA7l6jIWpf3Untac+ircDgZqlcmocPhcNTH+9r
	 vnOJwFxCIW/3R/oeueK+3k58yBYfPNGQoSzRGsR1WRG4aehXfT/gGhNecoH2gHz21I
	 IVL1x1uTwlJ8KbmIHAJ7Ic219y4hBC7MVuf2Od7yUaVsDP0qH2V72DT92Taw3QJD09
	 oZrjVZXko6TZ71dKqQOWcgQce4LO4koQBe/rDRqPGq85+IcgoHD8D6s5zylL/X9M4G
	 yFNuLFmSVn9lKO304prrqn/XX3UmFeSpHEBFSpsFg3SNkF+zz2ftRYiOh+Jg1sLUsk
	 SZRdcm43GnAvQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0464/1102] Revert "ACPI: processor: Update cpuidle driver check in __acpi_processor_start()"
Date: Sat, 19 Sep 2026 20:47:06 -0400
Message-ID: <20260920000825.2-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <88102a69-41bd-4520-8819-668b99721a67@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org> <20260917151551.337920984@linuxfoundation.org> <88102a69-41bd-4520-8819-668b99721a67@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 07:56:20PM +0530, Harshit Mogalapalli wrote:
> The one-line revert matches upstream fbf04215d996, but upstream applied
> it only after:
>
> 43ff36c4a5a574ee83b4b0d3f3d74f09a3a8c2d3
> ("Revert "ACPI: processor: idle: Optimize ACPI idle driver
> registration"")
[...]
> so maybe we should drop this ?

Dropped from the 6.12 and 6.6 queues, thanks.

-- 
Thanks,
Sasha
