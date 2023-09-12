Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9897179A7
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 10:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED57C433C7;
	Tue, 12 Sep 2023 10:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694514845;
	bh=LUobv7SluRAhwPkCwsysSqViibZox9UQzgrORWf91hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=itSKEfHZgDCToPGuEf9aCSCneUW5kawklARi1gt9JGYquCuvfgMQE48EsG2GG+dBJ
	 oROQpGgOGeX5a2HrK3Q/GeaDesePdq/h1u12jqtmhGO6K3N9TYsYvmKfZJkH4lLA96
	 DP7Fp0VVyzuAqATw9CIqK/mttWmivYwZ/VMx0oNQ=
Date: Tue, 12 Sep 2023 12:34:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?Q?Ond=C5=99ej?= Jirman <megi@xff.cz>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>, Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 213/600] drm: bridge: dw-mipi-dsi: Fix enable/disable
 of DSI controller
Message-ID: <2023091252-baggage-calorie-e2e8@gregkh>
References: <20230911134633.619970489@linuxfoundation.org>
 <20230911134639.905252752@linuxfoundation.org>
 <6xoqdk4sttjv5pskf67r5gc24ttsuspb6bnip5o35xcfmdtilp@72qguymwyt7y>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6xoqdk4sttjv5pskf67r5gc24ttsuspb6bnip5o35xcfmdtilp@72qguymwyt7y>

On Mon, Sep 11, 2023 at 05:49:30PM +0200, Ondřej Jirman wrote:
> On Mon, Sep 11, 2023 at 03:44:06PM +0200, Greg Kroah-Hartman wrote:
> > 
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> See patch message comment:
> 
>        (But depends on functionality intorduced in Linux 6.3, so this patch will
>         not build on older kernels when applied to older stable branches.)

Ah, missed that, thanks, now dropped.

greg k-h
