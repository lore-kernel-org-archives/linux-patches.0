Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0CC49503F;
	Mon, 21 Sep 2026 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993519; cv=none; b=hHAWSAns11K1iN3TVYo9gvLjqRczNpzt0iVrTpgL+jx0xFXgVxhphD/Be1rABQiq481bMLOZ6Ni8LF3XhnlmN3K63e2ia2+YCikqsvckJUr15gt0RudI7Yw/0nZFOK3H0Aw2cchrbRGHWZ3IjGIfa/Iq62EwGXs5aA1OzP5YKtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993519; c=relaxed/simple;
	bh=uUazBsUigVLHBFKO2qV0FqU18ZZ4mjjxL1hmyJJJONU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAhWq0LIl55fe3VtiCAP8hMEbcTYt9rfQCpS4Ltg16N922n1I68GukuZo4Gl3xGf3UEKMXnC0fh1qGrA/HdWlQV3AIwJNriDk2V5Q5GI1Mv14MDviFZy0skne3M2079BTynUzbAeGd4wOhbrpISLDD2dPO1PcrUpqT+OFkYEs34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=be2pzNxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="be2pzNxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BF41F000FF;
	Mon, 21 Sep 2026 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789993514;
	bh=TklTerFpr1vvVco9knU4ObXWsPjd4HeFgWhIuPJe1zw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=be2pzNxnBl8Jmu8+9GIznBiNHwkfgilM7pDlJnWTO4ZLx39YK40CLJ9wo6AYsaJ3A
	 rPAYkZjQKwOokv4vGMBpCiFceVVO8XgRIqaAEYnsi92T+CnaUzwnbVX+L815bqH8zs
	 m8BgM8moLjUgyEm4WvWEcacDG97bsQ9tMIInH5CQ=
Date: Mon, 21 Sep 2026 14:24:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Leo Yan <leo.yan@arm.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>, Ben Hutchings <benh@debian.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 6.1 0705/1191] perf cs-etm: Flush thread stacks after
 decoder reset
Message-ID: <2026092151-varnish-jasmine-8246@gregkh>
References: <aq-D15YcGtltATrG@eldamar.lan>
 <2026-09-20-daily-reply-0007-re-perf-cs-etm-build-break@kernel.org>
 <2c193adb-5c84-469b-9499-1e9b54066e87@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c193adb-5c84-469b-9499-1e9b54066e87@arm.com>

On Mon, Sep 21, 2026 at 09:48:44AM +0100, Leo Yan wrote:
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> 

Now deleted.
