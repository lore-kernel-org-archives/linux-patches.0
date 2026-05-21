Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FBB2D12F3;
	Thu, 21 May 2026 13:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371373; cv=none; b=S6iMTS65Ymoaqqtqq7jRirrKGHnXmgW0ljSQksyNVIXlrGxTG3VUlAssk7ROH/MxmE3IgPTuG9bNb/x61ChRq4NYjgS8kTAqpGAM5/1+Hk+t7vEvjWvujlOghiHVABlESnuVW5nAQ3lxrjuKLt71wU6oVcWrnFbZ0jbGqIt6xxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371373; c=relaxed/simple;
	bh=D8pkSP+mj73HtQFC6AT/3TJbMQ9vBvkfZa3GfEUn7WU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mv6NSfKkT8AFVd6TQNGBjcu9WwvGW/Jvh1FAEt36lX/XHk9jaTY2OjKJfndFfV6GjsfipFlZ5NQQru7K6y4JcwlVaCfFUtT7yXxV2hnwnlploFnje90jdsZu5NnHOCj8/QWftrpUSnVMFsqokiWACg9hJc8ZTNpMOF+solJBu4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxklz89q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxklz89q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10041F000E9;
	Thu, 21 May 2026 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779371372;
	bh=9vGVawvws7fBAKL9Kh0WruRDCPy652JeJMlY3clL/0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fxklz89qIKkCozgPurmI+CtnQXXe8UScPYtY3uUoVeIOBbEhDFXEgsNEI/TLIzFzT
	 PGYZdAlq7axfILQghdOVM5oX5RsQ6vrRk70r/yAaZt9nj2Kmf++p5llYTbgAuTQtgR
	 eyZbTl2QKo+fadwyZUDU5VcTVpgw9OMXH6iKGqfW2m28YPVwheEFKeSyRSxwel7NBH
	 2Ux/19YTYRgYsIzVQAcEHtUZ73C1fMgNlqcj0YiIdYs5laomkDzSzIFyaOqU1bYYY6
	 zvNp+5hzGkv5N1g/4TXybirprVBZzOi/GwH6223sH2wXZYmK/fvQ41mTBbIQiebMH+
	 G426WHRUkL4vQ==
Date: Thu, 21 May 2026 09:49:30 -0400
From: Sasha Levin <sashal@kernel.org>
To: Biju Das <biju.das.jz@bp.renesas.com>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	"jacopo.mondi" <jacopo.mondi@ideasonboard.com>,
	Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	"laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
	"kieran.bingham+renesas@ideasonboard.com" <kieran.bingham+renesas@ideasonboard.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 7.0-6.12] media: renesas: vsp1: brx: Fix format
 propagation
Message-ID: <ag8NauKvccv-O4Ec@laps>
References: <20260420132314.1023554-1-sashal@kernel.org>
 <20260420132314.1023554-285-sashal@kernel.org>
 <TY3PR01MB11346755439FD654CDA404744862F2@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <TY3PR01MB11346755439FD654CDA404744862F2@TY3PR01MB11346.jpnprd01.prod.outlook.com>

On Mon, Apr 20, 2026 at 04:12:43PM +0000, Biju Das wrote:
>Hi Sasha Levin,
>
>Thanks for the patch.
>
>This patch breaks on RZ/G2L based on LCDC. See[1]

I'll drop it, thanks.

-- 
Thanks,
Sasha
