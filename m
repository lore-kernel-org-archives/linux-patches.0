Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B666E496D34;
	Wed, 14 Oct 2026 22:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017210; cv=none; b=pOt7CTE2m4W80K+CYl3ksOfOZbQPm1+risgsj+YGUoA+uMarsDbf8DC53B9NByke3LoI9tVh5xR+7iO49MzAp5h9cGkuK+K+Nb5KaVOIoYqPAAgnK8z92PM/B0QWXq+tk4hiu9dirs72ATeqWKJskJ7uRpBojnli/NZ7AlBkhco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017210; c=relaxed/simple;
	bh=tQRqRwdFgoeqASr6IH5OhCDdFLEujCaol5Syfj9mulY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1sdvIfqJhgxKjTYaZ+Xo8Kf7Rg8EZh+V4DH9Hp0WTDF9br7qZ8msn8D3I3El4ZnSq9G8CPl4TNGG8KBSqnG+yVkCHTZvL+orMFAUpGrvwnIxHW2gLLOCOtjg59TbESz484UtfYOpGZ/U483ocXJtHfEYU3mnv1ZMIPxD/KarGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoDQmAQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoDQmAQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2C11F000C5;
	Wed, 14 Oct 2026 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017209;
	bh=clhZx8VQEm/ley6VcNffFEBiV68nhEDG7XCezyxYKQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoDQmAQ2kr74y8tOcjHyN9y6NBJC5/9/hFZBPpxg06WuqElX9xgO6D5vMKSd8huKL
	 7LHCF2xYmhI9HI5pfleGfi8FNc7jVvjHFbh/sea/oOkGC3Jf1PfDkIWw7eV/Ta+WrH
	 PUB2VZ3OBU6+SvkjH5iD6Qsm/B/Cy8F7NvuAmxgjppktCPoGz/AELNK4WgTNf9byUs
	 Dtkzjn4csCUfqMrK2UvmNkXCTiDqHzDJF9cbCvsd00L5kCnABBSYqiYaVWefHTuF2w
	 sERsllj/YAwMkbalFekZmF+yMCxme4Gfl4aUj3viXWBsYcHctUD+rOB2P04EpNkz6R
	 Ala2eUshuteyA==
From: Sasha Levin <sashal@kernel.org>
To: Peter Schneider <pschneider1968@googlemail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
Date: Wed, 14 Oct 2026 18:33:22 -0400
Message-ID: <20261014213019.rc-reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <628066be-fc84-492c-8b03-1aedaefad4ca@googlemail.com>
References: <20261014123820.008483134@linuxfoundation.org> <628066be-fc84-492c-8b03-1aedaefad4ca@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Oct 14, 2026 at 09:34:32PM +0200, Peter Schneider wrote:
> [   83.881266] Driver 'ses' needs updating - please use bus_type methods
>
> That patch was "scsi: core: sysfs: Make use of bus callbacks", and it is now in here again?! Was this intended?

Thanks for catching this. I've dropped it from the 6.18 queue again, together with the rest of the bus-callbacks chain (4 patches in total):

  - scsi: core: Pass a struct scsi_driver to scsi_{,un}register_driver()
  - scsi: core: sysfs: Make use of bus callbacks
  - scsi: sd: Convert to SCSI bus methods
  - scsi: sd: Move the sd_remove() function definition

"scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails" stays in the queue.

-- 
Thanks,
Sasha
