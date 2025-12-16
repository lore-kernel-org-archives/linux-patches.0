Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03335965
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765903852; cv=none; b=mrHkW6m6s5ZQmeQ6kQ6bLgpwFMDY2K9alxtvFSjbN0M7mCZdpOzj6bVKFDutroZdPpQx3wQ36dACuaGKG8dr794W5BXEPUDdqD8BwsUXt2A3LU4VLhNG1AhnQyyMrgbHcHMgv2+2qdPkUo9P+fAmPq5YLd9mMq1dxBNzLwe4wII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765903852; c=relaxed/simple;
	bh=Smh/tQsIRGlbZAi61bfDmFse5QSWYx5lREMDcGg9uHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UknvVeU7t5GUSjaXSWmj3LJJ1PXjXkFcsrh86nZnwhEXWYXRzMmoj0+Vt7EKl9mO8iCsP9g9twK2Rdb0qYzGXh4uY3pmyHQkDOWxtVCrW7stwJyjoPWNOUP8qoJdheEOBK7dIo8oK5D94a3uxIP0KNUdB2y+UP9VqB/vvx6VnO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=H6G0XP4f; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="H6G0XP4f"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so4543344b3a.1
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 08:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1765903850; x=1766508650; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6+nRXGAT6SHTmSU3/EOsL2PBk8Hk81U76K8Jyll95c=;
        b=H6G0XP4f08NmqB5Tf29BuGWCcFW+ac0Lwp8FWLy4ZrSfGP0XnMVSxwpO8Dqowp54FT
         juvmwqUeMGeJMY5hqoY45hkyUsNzRSnvwHqgb/97A+bGcU96s/9z+J1WCHpSC3JLH4Kn
         4VRfpHH0qGYIbSFd/HO49gc6Dym2E5iB4YFxa1wTKwzhW8/p7wpjEnZ2GSeEW6HVKHtv
         II0ZU1N13VIjyd7Bl7VcufUxQ4ces/ZfSg7SFjOF1/HAtdwfPyWHdR/W2xEMlRpwpgIo
         VvfuUTS8m91c7pZ3FUQCym+EwhWpT/SPBSz3O/2TSxsusEiV3zd0auWUMA7BAdx12DhB
         dmyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765903850; x=1766508650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6+nRXGAT6SHTmSU3/EOsL2PBk8Hk81U76K8Jyll95c=;
        b=kbZpOYTkIO9WoIud7imnu1LHfJ5Q7woj69UrTHdi7HvrA0E2ri81UcYjrBSl46G708
         co8z3ICDYmn4l2eeLQoQge4PRrNcPiuhuV31n3C1c0ar1M3hFJqDFO/3cq/JKOeI1kvd
         b/TwOYM9BP8iyMWt65cuCUUwU23u7dvWdPBO3a3OWgZVmpxJ7o5NxZ1grJnqzjXjgSPI
         +efT0nodCnfWwC3fS9n0EstTQ0o3G0kiz0ZfoLcVK7bvtTXN287DSWfEo/Rh143+GtDO
         QPk21PR+GYht0qUJi+pg1pWa9v3xuVN/mYWWV6nJoesBWwgLYzU2XWzE7s2HKQiGhqCn
         u6Ng==
X-Forwarded-Encrypted: i=1; AJvYcCU5SCpMKtdUeL44HxnxrZOLSaGTg0mfd29EaXizNHQoA1vk/QzIzPFMBBrvagl1/0IOadq++INM@lists.linux.dev
X-Gm-Message-State: AOJu0YyUTS9OIy1MYWUi2T5ZwPQ/mZRjt2FDclVuZHT1ziUsRRd3HrD/
	QyI4YOIFBNGArWqWs8mMg4s33Ex8mc+bPFl6RwnngvhYZ/uvEdtIV9q9Htj4BS5LJw==
X-Gm-Gg: AY/fxX6KxlXDBJop//KhC5P/YHZM+kI/oQTbQUpDAmeoPEk5ohMJMVl1JryOx6T4BCU
	egFlBloaYOUS6sk/cgem6/NuD0kL+tq4KvLtowyJyHW1Ck94lK5rEw0Rlg15L4LUMdWHLDdhjgg
	qhHXUKo7FzYWsuIV8ZTO9qlAcnFHBoD5Trm6x0komNBlGXMkhWqo6+tlyvNdLnjvPSsv7brO1Ih
	WGkXky1p8MfdwCoDLJYLfcJIaBomqut8thEI7zniu27nDq/OQ1wP5DbOV2qSe7JexDgC2ij+g/c
	pd5uyYdytnhYiSJZDxTsD9frlCCsVe6Tr/KENSzGPdhDaheZ7MP5NqOLioG12NrLUUX3pAbye8B
	UZJBDmFohtwnEqtpB82FpA2HS8mishxYQyRxT3WPZWkE2PiwUBQ6NIIFSLkcjDT4uZsrQXPQvmD
	IzGCZJAik+juSdJoUc1NpjCDbsNYHcY0tH
X-Google-Smtp-Source: AGHT+IHg9Xzw4Y9VGKpJnu03g96Os3VcwZ/ZN0WjT5o4NrajdDsvndCrJsPtMVIHfYWTuO1svkiW0w==
X-Received: by 2002:a05:7022:f511:b0:11b:9386:a3c3 with SMTP id a92af1059eb24-11f34c395a3mr9496061c88.46.1765903849986;
        Tue, 16 Dec 2025 08:50:49 -0800 (PST)
Received: from gmail.com (ip72-200-102-19.tc.ph.cox.net. [72.200.102.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2b46f5sm53469100c88.5.2025.12.16.08.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:50:49 -0800 (PST)
Date: Tue, 16 Dec 2025 09:50:48 -0700
From: Will Rosenberg <whrosenb@asu.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 240/354] kernfs: fix memory leak of kernfs_iattrs in
 __kernfs_new_node
Message-ID: <aUGN6G0v6bi8joVR@gmail.com>
References: <20251216111320.896758933@linuxfoundation.org>
 <20251216111329.608256836@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111329.608256836@linuxfoundation.org>

On Tue, Dec 16, 2025 at 12:13:27PM +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

Please see https://lkml.org/lkml/2025/12/16/1248.
