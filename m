Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBC926E71E;
	Wed, 24 Jun 2026 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782291736; cv=none; b=DQyvm91WKBwoHqd/7M4J8jfLA7rwlEgRXKgJmDpQtWsf5wFc2DjxbV7EE5khySJf9hVEAx1CKct1uxjlLCbx32kNz7SkTGqsoYfvp4AiGPSSzbFFFzohmOwPIMPoxjlJtaZuqrY+YB8j42yk9yxo736S9RRCUKbMmSAxxK331uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782291736; c=relaxed/simple;
	bh=Q1eJUiBPMyXO/I3sKWO4XtAQqKuB9o45TUZUXyPAJHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3HvC+j8pWIhgX764eGXiqS9NreOXVg1/dOdHPctUbchP5RIHc48y70dKpVuP6QJSlyu2Yhn9qYoR7hIwYs+iaav8+I3RF+k7QGXXLU0ppmnxtgxwnW2qTQNrE4wJPV3FOiFYsWWVcxC0lO0ytCM1SKNRiDZ34myYvbdECPflsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iz6X31Nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iz6X31Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8034D1F000E9;
	Wed, 24 Jun 2026 09:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782291735;
	bh=MzpkBY9YszNy1v3sP8Rq4XsT3ktn4Jvsz54kXjM8chw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iz6X31NulWUlj2fZZPtIh7OShrv0xcQ3yZ9L6yv3VVfcI16OO06yaw0nd4QAq6yTO
	 MtPk4HCLqU44/LkrDx1ko7hr1+CjC3BFehLriyScliw63deRo+r5N9cJ6Jj2gLFXqk
	 CZS4NbLoR7SJ5ARH4AfGsByTiIoE7RjjSgnxpeZg=
Date: Wed, 24 Jun 2026 11:01:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: iklatzco@gmail.com, 00107082@163.com, patches@lists.linux.dev,
	peterz@infradead.org, sashal@kernel.org, stable@vger.kernel.org,
	yeoreum.yun@arm.com
Subject: Re: perf: Fix dangling cgroup pointer in cpuctx
Message-ID: <2026062455-obtrusive-sandbox-d6d1@gregkh>
References: <20260616145120.525872058@linuxfoundation.org>
 <20260624080310.2502480-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624080310.2502480-1-guanwentao@uniontech.com>

On Wed, Jun 24, 2026 at 04:03:10PM +0800, Wentao Guan wrote:
> Hello, 
> 
> I noticed your backport missed - 'event->pending_disable = 1;',
> which different than upstream version, is that true?

I have no context here at all :(
