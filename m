Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB2C2FFFB5;
	Wed,  7 Jan 2026 11:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767784617; cv=none; b=THUv/zORmPeBJvex3DD20F8HiCCvMdHOSfuCjpMJro0DOXfhaoqmr5IsHmzrSE8D8zSWHlJW4TxmCB7782oSy8q4qmD8f5pZIYfINE0Ew2hT2wmryh0fYgDsMJ4IqPzitOTQDmVaH4pwGmyYzBm0jqhFOboLI0eUziD3qb1D3Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767784617; c=relaxed/simple;
	bh=zyPxBaWuDO7JOrwUP6o2I5tEYFqYHwGqwUBBzMZkGv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POOr+RroJUxKJROzavhp2q/d9ONXywGfQeJXfu7M55wiDU2ANKBnNW92yqvvZfQKrH9gBXdC/5P5R6x44hEqQHlUiQ/h/r9q+BpDhv9yEu9tu+0DPnemPgyqaEGRpNfrVsCK5xK/FIqL7VfOob+dSmkTperI7MoMIvoasePOejw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxK2TzVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxK2TzVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CDEC4CEF7;
	Wed,  7 Jan 2026 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767784617;
	bh=zyPxBaWuDO7JOrwUP6o2I5tEYFqYHwGqwUBBzMZkGv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MxK2TzVZTIYZMDqcc4kb0/Ca4+yD6CrI/9MnM/ElVvwi7QPqAyZgXXKTD9DEsXiV3
	 zIme9OFkV60UNE7U96PGOZgqhkI9HdUWMES7BtIo0zzhn6TdvoXEdMMrwT4UlO/SxA
	 cqqIzVlnblf+5ml1Dh7q0D3GyhCv/9wLKMPW8zwvewcgSigfMCb+q6AV5lh3NDR8eh
	 s916quFjjeTavXgpED028p41+W0LINPpSLUimZ8ZcEv6JjOLfdCCbCVA67RSe8+dqg
	 Tktxdn275WueQOg7n/aHf41FZH6TxtjbsgEGAMVvTw+xBu/Dc1iv1rDLlFsGKvik34
	 6OJ1Wiog4Cf7A==
Date: Wed, 7 Jan 2026 06:16:55 -0500
From: Sasha Levin <sashal@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	kai.vehmanen@linux.intel.com, cezary.rojewski@intel.com,
	ranjani.sridharan@linux.intel.com, rf@opensource.cirrus.com,
	bradynorander@gmail.com
Subject: Re: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer
 legacy driver as fallback
Message-ID: <aV5Ap8TgMEDLucWR@laps>
References: <20251215004145.2760442-1-sashal@kernel.org>
 <20251215004145.2760442-3-sashal@kernel.org>
 <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>

On Tue, Dec 16, 2025 at 02:29:14AM +0300, Askar Safin wrote:
>On Mon, Dec 15, 2025 at 3:41 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit 161a0c617ab172bbcda7ce61803addeb2124dbff ]
>>
>> When config table entries don't match with the device to be probed,
>> currently we fall back to SND_INTEL_DSP_DRIVER_ANY, which means to
>> allow any drivers to bind with it.
>>
>[...]
>>
>> Reported-by: Askar Safin <safinaskar@gmail.com>
>> Closes: https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmail.com/
>> Tested-by: Askar Safin <safinaskar@gmail.com>
>> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Link: https://patch.msgid.link/20251210131553.184404-1-tiwai@suse.de
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Please, backport this to 82d9d54a6c0e .
>82d9d54a6c0e is commit, which introduced "intel-dsp-config.c".

Looks like that commit is already in all trees.

-- 
Thanks,
Sasha
