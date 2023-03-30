Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED83210EB
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 08:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8FAC433EF;
	Thu, 30 Mar 2023 08:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680165077;
	bh=i03g/+IiYS/vXG0yeL+qmZTIyYwpBoUK497JFQSVZQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=al1nhc7wCV66jo8ISedX5zSzz3JQDxeFieynGXaEb4+qYU9fCHCXlZ9q8oHJILhc6
	 N6+gZjPpLXLAOImfkP0YjpzwIT0Q2Cpa82/uQ3C41LpLAgyJ3xLl5Lmi937S/aeQOA
	 v1rMZGLQS5QodYoqAiyCaZAqF0pbLTI8E51kd3C4=
Date: Thu, 30 Mar 2023 10:31:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrien Thierry <athierry@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 5.15 082/146] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCVI08p-yaaKG8T0@kroah.com>
References: <20230328142602.660084725@linuxfoundation.org>
 <20230328142606.118680029@linuxfoundation.org>
 <ZCR5Zef4oHYFkAss@fedora>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCR5Zef4oHYFkAss@fedora>

On Wed, Mar 29, 2023 at 01:46:13PM -0400, Adrien Thierry wrote:
> A possible regression was found with this patch [1]
> 
> [1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Ok, I've dropped it from everywhere now.  When it gets resolved, please
let us know what commits to pull into the stable trees.

thanks,

greg k-h
