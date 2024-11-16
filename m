Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A223C9;
	Sat, 16 Nov 2024 02:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731724464; cv=none; b=Ffnt+Ohoi0aNtR/kFsbPT6fYvxOBqF7IQ90kJYyrvjPqTXoh591/p5SXkU4pygL1jscryfs3swrz1LqlaAg1G9o150kF1QnTT9W1zHQlAVx467Gz5VAsk6YXRK31zAzEJszbfs9WLkMGRm4NlYBjHgJaM0VYbGN7ZJsSBkT+6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731724464; c=relaxed/simple;
	bh=ya+vhYwhUfjQ4xrFFeeMm8nVtaqHetmuWmueZEJDbGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myhaLlEyfAeBl3bjwzKu9aLMl9FTzakG2kW5x8hmj0e25nG3cMM8ERVS/PVX2xjEMQ+5oBa69UBDscQontP5+7u+jCZxBpslBtB13N4RAkZK/OJOkS4EbasxNRaZ61eAdEDk7nTT6makjupDUO6e87kF6iVLbmYiS1HHTxnodlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwPadPhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwPadPhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B19C4CECF;
	Sat, 16 Nov 2024 02:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731724463;
	bh=ya+vhYwhUfjQ4xrFFeeMm8nVtaqHetmuWmueZEJDbGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uwPadPhO8zekdW5oWegMrQiSomFmjIQBDmG7Q8dSSVK8PXB/X6rL2l02W+QuIdO/C
	 7BPY7YU5kov+PvpLP6F8C/tg0XmAkVwMaKaCki4F/Ylu0HQciWIa7K6HBV7eVUGILj
	 1OUgHYNwvb/9xfr4LVliVUdgIjNMMOJEUkcHoasLh0JgbWDZfdZBfqMvP/XZR2oPG7
	 cXFLwX+D6U5i816ts24qLzDxAmVMn6pJ2oSfo/iBSbQr3iFYXB2z+fdA2c9jmxJPse
	 G6M3DR8kmRRYK5te4H1zWe3QYXkmBGhLxXaPi+9Hjho+489/KTJCCSXC2pVVLnTC6E
	 en92QUOfmR6rw==
Date: Fri, 15 Nov 2024 19:34:21 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: John Johansen <john.johansen@canonical.com>
Cc: Ryan Lee <ryan.lee@canonical.com>, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] apparmor: Add empty statement between label and
 declaration in profile_transition(()
Message-ID: <20241116023421.GA1215050@thelio-3990X>
References: <20241111-apparmor-fix-label-declaration-warning-v1-1-adb64ab6482b@kernel.org>
 <7cc38d2d-5e4f-4b03-a1a8-e0b89f4005b8@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cc38d2d-5e4f-4b03-a1a8-e0b89f4005b8@canonical.com>

On Fri, Nov 15, 2024 at 06:17:11PM -0800, John Johansen wrote:
> thanks for the patch, but I went with an alternate version, that I did last Sunday
> (sorry I guess I forgot to push the tree). Since I hadn't pushed the tree I did
> consider replacing my patch with it but in the end decided to not go with
> the C99 variable declaration, moving the var to the top of the outer block (what
> my Sunday patch did).

Thanks for the information, I considered doing the same thing but went
with the minimal fix just for ease of acceptance. Appreciate you getting
this resolved now.

> The reason being that while I don't think the style guideline forbid them, I end
> up getting patches for them anyways, as some compiler flag sets will warn about
> them.

For what it's worth, commit b5ec6fd286df ("kbuild: Drop
-Wdeclaration-after-statement") dropped the option that warns about
that, so you should not have to worry about that anymore.

Cheers,
Nathan
