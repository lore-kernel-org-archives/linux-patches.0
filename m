Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB5A22CBD8;
	Fri, 30 May 2025 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748614129; cv=none; b=GsrKFBdKMptUWiNMU3/Xf/O7webV9GmTZ6iCUhdNQvGg00R/OzOUmPuSKJEtEkZK+cD6gsWSCwPVX4IkJKH4MEeim0/GmBPyjBiTijabvVi+YYrBxpcvEL2jIx6vAD096z7nz+ZVhOuSKXokfrcqUkcD15h8kKM5rb3bqFW1GFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748614129; c=relaxed/simple;
	bh=A+iI0vq/JOmDu2pzasQSsZWIOm/xnCxfUdR3mMqlSro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZAJp4DRZhwFHYHOIkUsBTnIi9qo4ovuhCUjQLHDGANy0r44hzKaqpTr6fsm7GV4P9FI4FTwpMyGmHT8yQC5Mzhdk+cTtP4lPjgH8MpqB6UHXAkwQeh1DHYvUIoJvAD+sntNLlHsxSd1oYRo5+JTa2fOR/Z1aic/i9UPggDCHZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgtmADgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgtmADgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2E4C4CEE9;
	Fri, 30 May 2025 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748614128;
	bh=A+iI0vq/JOmDu2pzasQSsZWIOm/xnCxfUdR3mMqlSro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgtmADgRTolqC4IYKhDP55Yz8MZKav/lPGB/miFmXLc3tPLYEIu3jK05gRBpCrnN5
	 T2/qwh10g957J5CE9gNP8jhSYOK5GRjN6KNix5NQaWP+8hTqrWwqGbsd0OFAAy5kpw
	 c6hx1Ib7+iVw2En2MiM685ufSuL8UHUd5SS0I3gk=
Date: Fri, 30 May 2025 16:08:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>, Kate Hsuan <hpa@redhat.com>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 645/783] HID: Kconfig: Add LEDS_CLASS_MULTICOLOR
 dependency to HID_LOGITECH
Message-ID: <2025053022-crudeness-coasting-4a35@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162539.405868106@linuxfoundation.org>
 <27b9765e-c757-41c7-9cbe-fe1c915fdf2b@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27b9765e-c757-41c7-9cbe-fe1c915fdf2b@web.de>

On Fri, May 30, 2025 at 03:44:22PM +0200, Jörg-Volker Peetz wrote:
> With 6.14.9 (maybe patch "HID: Kconfig: Add LEDS_CLASS_MULTICOLOR dependency
> to HID_LOGITECH") something with the configuration of "Special HID drivers"
> for "Logitech devices" goes wrong:
> 
> using the attached kernel config from 6.14.8 an doing a `make oldconfig` all
> configuration for Logitech devices is removed from the new `.config`. Also,
> in `make nconfig` the entry "Logitech devices" vanished from `Device Drivers
> -> HID bus support -> Special HID drivers`.

Did you enable LEDS_CLASS and LEDS_CLASS_MULTICOLOR?

thanks,

greg k-h
