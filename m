Received: from wfhigh7-smtp.messagingengine.com (wfhigh7-smtp.messagingengine.com [64.147.123.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844D03D552
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 08:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712045951; cv=none; b=hEUpviUISUiZqp8S3XmMBZdazWXxqNtYj24bHz4KFgNHkI+fEyjZrugS5wXZAtFjlVlkxZxuC7Hd/uXzZYyGVqi+8/13lBnEHcSTATvLTa8fh8Z9cYH636hAqno7SKp9Yk7GrUw5AjgyrDhdhaPvKVs7bshJ7hT5g8iecNqyPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712045951; c=relaxed/simple;
	bh=hUSe/ZzPXtdo6I1JciZQzogzafIhalDt/gckhld+CG8=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=YnEI5MT+wHKkcEL3tmwOAsue+hPyjJglnxopGiqecBzY7AOENrvYu5gYHOUHvRq4suorZ2kupvrLKMd4RDunJihqgKxh5GJp5eRFKZ+UOTATLkNiA84kZj/p7jYSLqEmBi4i0abA4RFjywDXmarvinyzmmdAYla3GoKxGbZu9j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=qrWbYszj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OrYdw0Oz; arc=none smtp.client-ip=64.147.123.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="qrWbYszj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OrYdw0Oz"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id B3AB118000EA;
	Tue,  2 Apr 2024 04:19:07 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 02 Apr 2024 04:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1712045947; x=1712132347; bh=82uhAIT7d+
	hEIkE/Im/lXrix8+p5YrsV9BVER62xRjE=; b=qrWbYszjpE/02QDrFmopJVd/LX
	vWju+vqFuNQgrWNYrSLSgMRZXwh0Kzx8j8nPFk3UXzJRJHFo1aX2ckPJ3PrdY9dM
	AJ8et+2nlTmt0tEoF4dFTLi7H7TWOnksyPh3M415HBB55LeOAGSxJpoRu8X7aWGO
	DTVVsCQhGLa+0OmndQgMAH7lHq+sXf2UUcvXhJsd3DRro1V/6OhBTl3xxuZLJ6kx
	Y3TB+y6AU+4ZWczBVVIqDkRSHCIjM53FvCVPwKXlWwTnLGpAOKuIDpLGRMNL8Z0g
	MbFNk4q4cFudtHZqz0+Ay7/bdnmO/YID5Hwr8ePHasgYDJHiV5pnjn0ZO9pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1712045947; x=1712132347; bh=82uhAIT7d+hEIkE/Im/lXrix8+p5
	YrsV9BVER62xRjE=; b=OrYdw0Ozo+sTRXFgKDuUsfWtGM0BrI/O2aapIY6BTxjb
	I9LHOWUvZGv7or9aYXXfUnS/Yxa59p98fiL8skpr+Gb7dwqMb9XY7y/WGcl0yF16
	3vbHS/0czjBPrSP/pC9DXkQbJpKWq7vb1+l+59aHVXFvfuduu6IDXGElkL6Zz7B5
	bc8S4XdQ6ScCr+9KHaTmVP+O8n7vKHejWm6i6LXuj6ijVgwE6IuTa7AOJDqSMFv2
	AP1f6ZlXxP318INGIORCnqtr26TmBiFgT3QPkHy3HkAvu2FNRwFdJQJ9t5NFMFXc
	9DCljjYdSSMVl5hADU+imPL9qVC//bITJRUyi5xtHA==
X-ME-Sender: <xms:er8LZnejrXriasx7668fHN_HzPR0VyXZAtRiRSM4fBInkExmGBFyuw>
    <xme:er8LZtOfdWgcwRJ_NVkHYTr5qOLpgAy25P-xc1SqJLY4dl7wsi9xVE3mP-_yPZIjk
    qif60UxQt1-b_J9WZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefvddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:er8LZgj3kG8DZxj_SBKNkK1M9l4UHvanD4dklSWWsZXb7Kqmv98J4g>
    <xmx:er8LZo_K7a79ZqoPMCuTANl0CJ9wNMqT3i-CPVIKo7AjmpZwXrKviA>
    <xmx:er8LZjt9UxkHIc2HeVyrhMyxA2JvpQb664MZf1FYVxrRnIWnE0KdsA>
    <xmx:er8LZnHwWehhA2g7acVFOUcvpfV3t5Qd98hi3_-bjvPi5s08ThRw0Q>
    <xmx:e78LZhKt1svR_SR0iJvwF1QV-0bCeNiHzHClZOCbxFdkTd1iGb6aP6aj>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 788FCB6008F; Tue,  2 Apr 2024 04:19:06 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-333-gbfea15422e-fm-20240327.001-gbfea1542
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <64d8ca78-75e8-4fe7-bc50-fde6af4e7bb2@app.fastmail.com>
In-Reply-To: 
 <CAMj1kXHwW83uNPKZsj1==5Mof+K1k6-N3bbKk-Cn6U6692UzGg@mail.gmail.com>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152556.751891519@linuxfoundation.org>
 <44381e5a-cab6-4abb-b928-ebea7ce3d65b@app.fastmail.com>
 <CAMj1kXHwW83uNPKZsj1==5Mof+K1k6-N3bbKk-Cn6U6692UzGg@mail.gmail.com>
Date: Tue, 02 Apr 2024 10:17:22 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, "Linus Walleij" <linus.walleij@linaro.org>,
 "Nicolas Pitre" <nico@fluxnic.net>, "Jisheng Zhang" <jszhang@kernel.org>,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.8 254/399] ARM: 9352/1: iwmmxt: Remove support for PJ4/PJ4B cores
Content-Type: text/plain

On Tue, Apr 2, 2024, at 09:30, Ard Biesheuvel wrote:
> On Tue, 2 Apr 2024 at 10:19, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Mon, Apr 1, 2024, at 17:43, Greg Kroah-Hartman wrote:
>> > 6.8-stable review patch.  If anyone has any objections, please let me know.
>>
>> I think we should not backport the feature removal, this was
>> intentionally done separately from the bugfix in 303d6da167dc
>> ("ARM: iwmmxt: Use undef hook to enable coprocessor for task")
>> that is indeed needed in stable kernels.
>>
>
> 303d6da167dc is not a bugfix - it moves the undef handling into C code
> for PJ4 but only for ARM not Thumb.
>
> Subsequently, 8bcba70cb5c22 removed the Thumb exception handling,
> leading to the regression.
>
> So without this fix, the Thumb case remains broken unless iwmmxt
> support is disabled in Kconfig.
>
>> It still makes sense for everyone to just turn iwmmxt support
>> off on pj4.
>>
>
> If that is deemed sufficient for stable kernels, then we can drop this
> backport. Otherwise, we need to do something else if this patch is not
> suitable for -stable

My mistake, I misremembered what you did in the end.
Let's keep this one in stable then.

       Arnd
