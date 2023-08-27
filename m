Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC351361
	for <patches@lists.linux.dev>; Sun, 27 Aug 2023 09:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D1C433C9;
	Sun, 27 Aug 2023 09:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693127535;
	bh=HM3WKQ5OxVgWwzF+fZk+JF992E4jrGxxso+nB/vwuqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OozhuMfF38EE67aqxmVwTU4PcUlUc0k7CSkrneYxKL/Cd4QojwDuzanY4PtqeClxR
	 eisLWxOHnsPqwhmmXs342jhVvTcZvbD0uCL1wvsQl+BsLkK2PTKGNoul7ANHpuobau
	 hniYqPSMkuyCwOywF1fqjNbXhggZPOonp3snepkM=
Date: Sun, 27 Aug 2023 11:12:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Srish Srinivasan <ssrish@vmware.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	borrello@diag.uniroma1.it, peterz@infradead.org, pauld@redhat.com,
	rostedt@goodmis.org, sashal@kernel.org, mingo@redhat.com,
	linux-kernel@vger.kernel.org, akaher@vmware.com,
	vsirnapalli@vmware.com, amakhalov@vmware.com, tkundu@vmware.com,
	keerthanak@vmware.com, srinidhir@vmware.com,
	kashwindayan@vmware.com, vbrahmajosyula@vmware.com
Subject: Re: [PATCH v4.19.y] sched/rt: pick_next_rt_entity(): check list_entry
Message-ID: <2023082757-granny-dilute-b0d3@gregkh>
References: <20230826021535.9065-1-ssrish@vmware.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230826021535.9065-1-ssrish@vmware.com>

On Sat, Aug 26, 2023 at 07:45:35AM +0530, Srish Srinivasan wrote:
> From: Pietro Borrello <borrello@diag.uniroma1.it>
> 
> commit 7c4a5b89a0b5a57a64b601775b296abf77a9fe97 upstream.

Now queued up, thanks.

greg k-h
