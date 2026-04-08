Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208C381B1C;
	Wed,  8 Apr 2026 22:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775687570; cv=none; b=SBqFeYWit29tupnGWBUJlr/H4/nQRy7yf/URjgL7nRsOOFUO6uiR1PHJ/0wPRUuYpAlIk3hTx32tOW4camPam6vtoS9iJnNdzEVBtF1LpqWW7phCn8cuS4YcVpUNMrzgirGFqGgqvkiHQ/GGaUCriS9XHHwwIkGQQCdEZyivmV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775687570; c=relaxed/simple;
	bh=YU4mhYsg8Y/XXJGN/UlPGRHOuQL9+rEh0B+wM6XR+Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMjYjRJImqH5XubSw0Pgk5pIld/SpkWybSMyNbcIllP1T4C9XxLK5TRFzfonmHOVnQyZnbF4YdB04maa87/Cxej4hhroUvml9VgQWALDkgn3QvDIsiDitfOIu0SaByZ+VTeDRcszkmcpaaGV5GkEByZf3L7FxzMeyn78BKC4bRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdUaiZGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdUaiZGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DB8C19421;
	Wed,  8 Apr 2026 22:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775687570;
	bh=YU4mhYsg8Y/XXJGN/UlPGRHOuQL9+rEh0B+wM6XR+Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sdUaiZGWgmt3mrXb7+SrFbm7HUHd5zfqT2doh0GzFkjH7vsxTjLZB1wttjmYm6NXV
	 QhJYQLHumaF5DElfUsd02dOyhaHlLZeC5xHgvDrlE+rV6YsIthMeSzfio7qtZy4YPc
	 xCnm2a2RBAvPVxs+APsRsoO8kL16UAhw7c5+sjp3utlO/LJa/CuStGwu+Oj4LjSMmp
	 1G14fKEcowb5+Nu+WIxU9QjGbToC4i5E5qVBnCTPhi/93/nbp4oxA28DTPs7lduhXE
	 n9WO4LW49CtCqHGz0hDp0TyU16Yr9Tmdjx7qEsYuZPx8WoxBGihzcD1OrfmjAB1QSN
	 peiv2w77E7qxQ==
Date: Wed, 8 Apr 2026 18:32:48 -0400
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Tugrul Kukul <tugrul.kukul@est.tech>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Pavel Machek (CIP)" <pavel@denx.de>, Ron Economos <re@w6rz.net>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Mark Brown <broonie@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Schneider <pschneider1968@googlemail.com>,
	Alex Williamson <alex@shazbot.org>
Subject: Re: [PATCH 6.6 111/160] vfio: Create vfio_fs_type with inode per
 device
Message-ID: <adbXkABn-NDAvX4S@laps>
References: <20260408175913.177092714@linuxfoundation.org>
 <20260408175917.326372651@linuxfoundation.org>
 <2026040839-around-uplifting-b023@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026040839-around-uplifting-b023@gregkh>

On Wed, Apr 08, 2026 at 09:44:13PM +0200, Greg Kroah-Hartman wrote:
>On Wed, Apr 08, 2026 at 08:03:18PM +0200, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Alex Williamson <alex.williamson@redhat.com>
>>
>> commit b7c5e64fecfa88764791679cca4786ac65de739e upstream.
>>
>> By linking all the device fds we provide to userspace to an
>> address space through a new pseudo fs, we can use tools like
>> unmap_mapping_range() to zap all vmas associated with a device.
>>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Link: https://lore.kernel.org/r/20240530045236.1005864-2-alex.williamson@redhat.com
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
>> Signed-off-by: Tugrul Kukul <tugrul.kukul@est.tech>
>> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
>> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
>> Tested-by: Ron Economos <re@w6rz.net>
>> Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
>> Tested-by: Mark Brown <broonie@kernel.org>
>> Tested-by: Conor Dooley <conor.dooley@microchip.com>
>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>> Tested-by: Peter Schneider <pschneider1968@googlemail.com>
>> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
>> Acked-by: Alex Williamson <alex@shazbot.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Sasha, something went odd with your scripts to pull all of these names
>in as "tested-by", right?  The original commit did not say that :(

Argh... I switched to using b4 to pick up backports that folks send on the
mailing list. Looks like it picks up trailers from unrelated messages...

$ b4 am 20260402161311.63484-2-tugrul.kukul@est.tech
Looking up https://lore.kernel.org/all/20260402161311.63484-2-tugrul.kukul@est.tech/
Grabbing thread from lore.kernel.org/all/20260402161311.63484-2-tugrul.kukul@est.tech/t.mbox.gz
Breaking thread to remove parents of 20260402161311.63484-1-tugrul.kukul@est.tech
Analyzing 7 messages in the thread
Looking for additional code-review trailers on lore.kernel.org
Analyzing 423 code-review messages
Checking attestation on all messages, may take a moment...
---
   ✓ [PATCH 1/4] vfio: Create vfio_fs_type with inode per device
     + Tested-by: Jon Hunter <jonathanh@nvidia.com> (✓ DKIM/nvidia.com)
     + Tested-by: Pavel Machek (CIP) <pavel@denx.de>
     + Tested-by: Shuah Khan <skhan@linuxfoundation.org> (✗ DKIM/linuxfoundation.org)
     + Tested-by: Peter Schneider <pschneider1968@googlemail.com> (✗ DKIM/googlemail.com)
     + Tested-by: Ron Economos <re@w6rz.net> (✗ DKIM/w6rz.net)
     + Tested-by: Conor Dooley <conor.dooley@microchip.com> (✓ DKIM/kernel.org)
     + Tested-by: Florian Fainelli <florian.fainelli@broadcom.com> (✗ DKIM/gmail.com)
     + Tested-by: Justin M. Forbes <jforbes@fedoraproject.org> (✗ DKIM/linuxtx.org)
     + Tested-by: Mark Brown <broonie@kernel.org> (✓ DKIM/kernel.org)
     + Reviewed-by: Alex Williamson <alex.williamson@redhat.com> (✓ DKIM/redhat.com)
     + Acked-by: Alex Williamson <alex@shazbot.org> (✓ DKIM/shazbot.org)
   ✓ [PATCH 2/4] vfio/pci: Use unmap_mapping_range()
     + Acked-by: Alex Williamson <alex@shazbot.org> (✓ DKIM/shazbot.org)
   ✓ [PATCH 3/4] vfio/pci: Insert full vma on mmap'd MMIO fault
     + Tested-by: Jon Hunter <jonathanh@nvidia.com> (✓ DKIM/nvidia.com)
     + Tested-by: Pavel Machek (CIP) <pavel@denx.de>
     + Tested-by: Shuah Khan <skhan@linuxfoundation.org> (✗ DKIM/linuxfoundation.org)
     + Tested-by: Peter Schneider <pschneider1968@googlemail.com> (✗ DKIM/googlemail.com)
     + Tested-by: Ron Economos <re@w6rz.net> (✗ DKIM/w6rz.net)
     + Tested-by: Conor Dooley <conor.dooley@microchip.com> (✓ DKIM/kernel.org)
     + Tested-by: Florian Fainelli <florian.fainelli@broadcom.com> (✗ DKIM/gmail.com)
     + Tested-by: Justin M. Forbes <jforbes@fedoraproject.org> (✗ DKIM/linuxtx.org)
     + Tested-by: Mark Brown <broonie@kernel.org> (✓ DKIM/kernel.org)
     + Reviewed-by: Alex Williamson <alex.williamson@redhat.com> (✓ DKIM/redhat.com)
     + Acked-by: Alex Williamson <alex@shazbot.org> (✓ DKIM/shazbot.org)
   ✓ [PATCH 4/4] fork: defer linking file vma until vma is fully initialized
     + Acked-by: Alex Williamson <alex@shazbot.org> (✓ DKIM/shazbot.org)
   ---
   ✓ Signed: DKIM/est.tech
---
Total patches: 4

Let me investigate if this is a bug or whether I should be passing something to
b4 to make it not do that.

-- 
Thanks,
Sasha
