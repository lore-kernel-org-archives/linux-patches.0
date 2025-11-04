Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0DD35898;
	Tue,  4 Nov 2025 00:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762216138; cv=none; b=i3J4dsYOklxtGeivm18kl4KgbIvJ7mgf5ipFBu+p3GRR9bAu5xidpPVHvv9SKnAe6HTBxM65OScS8u7+XZH6ijfsi0Yg/u+JNwWVPGeo8nUM8+IhYMdY2CtXfnfzVw38aDD0G6ktHWQ0pNUJsNUXv2uXo4l7diqHmDNac/Q+/O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762216138; c=relaxed/simple;
	bh=tRnh6hweO+RMG4uAocwBUQlrYyZEJFmZtd+kmv+UXAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzgQjtn5o002v9az2QlRUhPGBTCSCXSoFttoOSAgh8cOpUT3+RkaxAO5lSTFaddlpw6MnPAOo3iAnxh3ynHpB6Bw6W4utG2TKbgVZ8/+YNAgXnK1Ts4eCNfM6oAmk3PeFxsNnLNCngDKDVustdr5HCzAUrd4KwaJzAZIrI8B2w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMssr6pb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMssr6pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172CBC4CEE7;
	Tue,  4 Nov 2025 00:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762216138;
	bh=tRnh6hweO+RMG4uAocwBUQlrYyZEJFmZtd+kmv+UXAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nMssr6pb/eeudzEMibe0Ra49in/PvvVe4shsF4JuYaElRnS6HWIpedVQbEk7x+t3b
	 fXISfnt3KIXEu5l4d3wBgCYse9n6WRcjTUKz0cImFoLDTB5NWYFq9J3+ibtMaZohTf
	 XZz8hALd0sKLFcpSHoP32ayDpIkAfyyPskrZyZdP4TQMXcut9iBLiX+CMJAZTrPHRr
	 yqbNHZTVCr16iTwEOLXI9MBm9bZoDKPELyhTB2Ujy8JcNyNZEosFI0CqqwB5ZuvGch
	 vWbzHRi3X14GbMtoau+S8tNQXLiB8+GPYyo4Y0bPAGPlOcsBIChVynSMOZW44hxslx
	 JLTiiZkpbprbw==
Date: Mon, 3 Nov 2025 19:28:56 -0500
From: Sasha Levin <sashal@kernel.org>
To: Icenowy Zheng <uwu@icenowy.me>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Ulf Hansson <ulf.hansson@linaro.org>, fustini@kernel.org,
	guoren@kernel.org, wefu@redhat.com, linux-riscv@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.17] pmdomain: thead: create auxiliary device
 for rebooting
Message-ID: <aQlIyJ5-Tw2qZR4b@laps>
References: <20251009155752.773732-1-sashal@kernel.org>
 <20251009155752.773732-69-sashal@kernel.org>
 <04c400064452a5afa36941a57ea0d620896878f0.camel@icenowy.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04c400064452a5afa36941a57ea0d620896878f0.camel@icenowy.me>

On Fri, Oct 10, 2025 at 12:02:41AM +0800, Icenowy Zheng wrote:
>在 2025-10-09星期四的 11:55 -0400，Sasha Levin写道：
>> From: Icenowy Zheng <uwu@icenowy.me>
>>
>> [ Upstream commit 64581f41f4c4aa1845edeee6bb0c8f2a7103d9aa ]
>
>This commit seems to be not backportable -- it depends on the new
>driver for the auxiliary device.
>
>I suggest not to backport it.

Dropped, thanks!

-- 
Thanks,
Sasha
