Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754A22D9ED
	for <patches@lists.linux.dev>; Sun, 16 Nov 2025 17:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763314512; cv=none; b=s7CcCbEAqeQTOVvp8LikR8oEdnd75FhelTRg2aAKvtSyzmuMz/z1odOcx/jSdrHfwVrakoGzW3NoSknZ42PZqA8ZP7uzNRsnGjdgIGu849kjOVarS8JqwxP16ukHef8C//27ZAmxIW4DNm40/NQtxI1Y5Kn6bQcJFsKjjX0NALk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763314512; c=relaxed/simple;
	bh=AiR7OWq5QjeEgBUIqgeKnAZ6M4zzo1z1vhctNrbqZf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGQWof0j5n+ftV04poffoGzMjQFPZtzLy3OohWcZw6P912dDE0MRIaiB6LCff4VQQAWcrFHwVWErRm5dBMvN4zHe/92i3uGWi5+X4ER5JwBk2BxQmq0YG7UM+qNl0BXd4spTVE4eZBjXyaQpwZFpDQohKt3HTF7hhh8RtVZqtEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8vxQBrZ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8vxQBrZ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so421355b3a.2
        for <patches@lists.linux.dev>; Sun, 16 Nov 2025 09:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763314510; x=1763919310; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iZr69Y/IYH+8F2xEe3zTPCB4P+4tO2XHZu6fh52qnG0=;
        b=m8vxQBrZnUoSTo19ezq9xqcYFQdtUssgt6aOUiM0oNpm2jYxPJrCTRqAGBaQZt7Ctm
         6hRZG0jLFAr2Si+XGy0jrjwos0pVn92lcNI1YRhSv9wM4EJYjjPQ8sAH7J3F8dLg8xon
         EUdW91c0AUwo0+ApzNtRJQgpQ4zr7N6QaqUkrH6WZI68H98iFF2PU21wcWGKgqDuVLP+
         Ve2Rz/Z+Ea6YcOrPp8k+9z2Q/0uo7/cStMRUmD5REuEaWCG+w++SNu8jBe7wKTONGZsp
         Jfh7DxITAW8aeCrvKdpj9hEhvYBZ+92q4qKsVBvmdsBEDOJ16g9gjlbJtWt+oX3RXWoB
         WabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763314510; x=1763919310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZr69Y/IYH+8F2xEe3zTPCB4P+4tO2XHZu6fh52qnG0=;
        b=kJ9EbmMFiy9iQMDfgR3V6keachYDcxUCWZDo3Y7L3L7TlrSErItMKCalyF52czg5QL
         ndXD89sptfNejZK6HdfkeN9QtI6iMvEslFnkVQA0uledPoT6abiTt+qoKZ4rfpclLIPj
         w5H1p4e3nM03NS7DuzHEUJU0tseawTeG53zfrgkvtZBnPU/hMlFODHl/XVTiUL8WX/XC
         1Ey503F2aUFhBYAvfbcK9OFyhEr2YGvLLw5wqjoGvvmLakAbwS6W+5oZc+r1Q5HnGXS+
         uhNkMwecHlG9P81OXBDPxxckMs6NwUyETZjRcKAOU/hQ3tn5d71kgwWEDRNNuRGgkYJz
         SIGA==
X-Forwarded-Encrypted: i=1; AJvYcCVF71/fGmVJghf7W5WaLeo02g75mMv2Xqu7iU3dtAIfSXNvN5MbhwpE9qNU2/G9lGIov1ne5RNn@lists.linux.dev
X-Gm-Message-State: AOJu0YxpCshOwBOLFUQRRQtvv5A6mV08ig17aP2JbxJdQ3MGge8LptGa
	Xi9CqVHyfbBeGWOpdrhdczWA4eoBEBXAq8cUbp5ChSYxOJJyJBo3nqf5
X-Gm-Gg: ASbGncvorFu8QXS3G/0/w+NBd4FIcTFSFudfPOW5UmUczacy4u42RUtaZR8igZwOJzX
	SxVG9ctS0/Z5l0RB2GqDFoZV9jFh7Z5QimaLEGF0Kl44OHJLI0/sL+YDpEqgJmnQf9fcYY4tTe8
	UXTwyDB1HKJYACj+V8NEEk0IK3ms8MFY6ivR8TeZOTphcX8aIDvvebuWoTvHX4hJbxoKwb41Exg
	l6hICt/21rQGEvPI6DT2NqH1VTi3458q+ZzEJ/kkpICrMOl8BFezmwDhyIL2oR7JHS4ljpzY/X9
	I2bZSP/IYPlxDIYn4a/1sJhsQNlLFqRq6rTMnPJHKZu6r820wx6qhhx6ufudHyCbiQljeBjjkxk
	Kj9ju0p/f6lOhqanWYV+cofulOBedXQbzExBi5NPOqUWRqhOx8liJN+5ujNPCb3GH7ZHpV+M=
X-Google-Smtp-Source: AGHT+IHZx+LWvH3AN1QAO1ITLruzr3q4nEqQXQ6Wi4v007TJw/jpt/Bn24++1pcywXys8MEofPX8Zg==
X-Received: by 2002:a05:6a21:9991:b0:35d:cc9a:8bc2 with SMTP id adf61e73a8af0-35dcc9a8deemr4612188637.31.1763314510342;
        Sun, 16 Nov 2025 09:35:10 -0800 (PST)
Received: from x1 ([184.3.238.16])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc375081bf8sm9973615a12.24.2025.11.16.09.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 09:35:09 -0800 (PST)
Date: Sun, 16 Nov 2025 09:35:07 -0800
From: Drew Fustini <pdp7pdp7@gmail.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <aRoLSz6or2UK4tDu@x1>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>

On Wed, Oct 29, 2025 at 09:20:43AM -0700, Tony Luck wrote:
> Patches based on v6.18-rc3
[snip]
> 
> Background
> ----------
> On Intel systems that support per-RMID telemetry monitoring each logical
> processor keeps a local count for various events. When the
> MSR_IA32_PQR_ASSOC.RMID value for the logical processor changes (or when a
> two millisecond counter expires) these event counts are transmitted to
> an event aggregator on the same package as the processor together with
> the current RMID value. The event counters are reset to zero to begin
> counting again.

Do you have any suggestion of which Xeon parts I should be looking for
if I want to try out this feature?

I'm looking at bare metal hosting providers for an Intel server that I
can try out features like SNC and this. I look up the parts on ARK but
it shows yes/no for RDT which is not very specific. I'm hoping to do
something better than just hoping cpuinfo has what I want once the
machine is provisioned :)

Thanks,
Drew
