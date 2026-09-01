Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B364CCDC5;
	Tue,  1 Sep 2026 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265527; cv=none; b=B2TsMFl+Gpzs2wem3hCdzzcePeACU6MtrXogBwUKqGdFSjDTzWiA3lGwgPOEIu4fo63B/ZO06WjhIJRxsVBm21M3ZF4G29WcT22FFJKpPV3c44rdhIs966JnfyN/WJgiHHrk6kYA3anShGCARt0PuyUFk5FYMPXhlauvepfv2C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265527; c=relaxed/simple;
	bh=4IT0e53vdKg8DoidJleZubCDnXmOll6uM0ya06C1pDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdynqR7VPH5DepqoQMtjGuP4s2B9XJ9Gy/Qho0yYvnAEbnH03lTPWWEOvng+xlrWtmnF8pV+a1juAcNj9Lc5uomD8q+zqCxa9oYltapHlg0iHB1Bz08Hcr6m4hTafLX78yS462EqYnObnE5jdQDxUCFNzF3evSHAw1R0QCw6TF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fP6bsjTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fP6bsjTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28631F000E9;
	Tue,  1 Sep 2026 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788265526;
	bh=ZKTfk6o+sjkFieRI3P9B65Uk8wz7nCHWN8E2lxxqUN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fP6bsjTcxybLBnuIyxtU5gsatkWR8hv8BncXvBwzFnIdu5urr6VoVwugMX49wSe9h
	 Sp7+m/q0KU9IETk5Wg+PSUzZOC4BsxWB5NTynXLusDXii9ta814k22PhvZ25BuvH/o
	 scu12GyS3MhetMJHhFtqCko23SMrKOPBQwYoekM/EQU9C168zR7Ptjll2NToJ3mZQ4
	 gYsbOhEJ25nrsDXIRdjsOyzHdBD6BPRhkxGq0aXOlwuMoOuT8jBU7mNG2RTOcSZ+Vg
	 SsCv4S+y6Jt2xyhG324kPRyLHknjr0HQYg6yRMi7JAwdeZ/mjLfGRyeabZnz7R/c1/
	 m+zuoKVaWelbg==
Date: Tue, 1 Sep 2026 08:25:24 -0400
From: Sasha Levin <sashal@kernel.org>
To: Philipp Oster <philipp-oster.05@outlook.de>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Philipp Oster <philippdev5396@outlook.de>,
	Takashi Iwai <tiwai@suse.de>, shenghao-ding@ti.com, kevin-lu@ti.com,
	baojun.xu@ti.com, sen@ti.com, perex@perex.cz, tiwai@suse.com,
	linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] ALSA: hda/tas2781: clear cali_data.total_sz
 when calibration read fails
Message-ID: <apbENGUBsZmMcR_-@laps>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-380-sashal@kernel.org>
 <GV0P278MB17776D742D3B76BD758F8A8FB1A92@GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <GV0P278MB17776D742D3B76BD758F8A8FB1A92@GV0P278MB1777.CHEP278.PROD.OUTLOOK.COM>

On Mon, Aug 31, 2026 at 09:32:37PM +0200, Philipp Oster wrote:
>Author here — the backport looks correct to me, please take it.

Ack, thanks!

-- 
Thanks,
Sasha
