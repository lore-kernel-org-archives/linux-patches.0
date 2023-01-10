Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4B417EF
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 08:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB4AC433D2;
	Wed, 11 Jan 2023 08:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673427551;
	bh=6iFVV81L49bpmIaYNQ32xiK9kXUYo4MV/uaBZYW1tIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fn/B/BUyC1W1zxDdN4L+PXJIXxmYql9ecdtSTTVc05C+hdco/SSBnAzOx+TEZRzgY
	 XfBtBLCjxbwZZHyDVul2uslTV9bGc4bFr+XrpbV7UKeUz1qTvnJ4NA15bXLA2ZobGc
	 bezTkDteDBdYrygdTvTsDW75KWBsIVPTUmLLFWU8=
Date: Tue, 10 Jan 2023 19:34:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 5.15 057/290] rcu-tasks: Simplify
 trc_read_check_handler() atomic operations
Message-ID: <Y72vxOQxqtoztLO+@kroah.com>
References: <20230110180031.620810905@linuxfoundation.org>
 <20230110180033.597780936@linuxfoundation.org>
 <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
 <CAEXW_YQeDCfP-2cJ5Qwx5gAiPxzn4uTEqKB6m3BsCwzpM43qAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YQeDCfP-2cJ5Qwx5gAiPxzn4uTEqKB6m3BsCwzpM43qAA@mail.gmail.com>

On Tue, Jan 10, 2023 at 01:27:02PM -0500, Joel Fernandes wrote:
> On Tue, Jan 10, 2023 at 1:26 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > On Tue, Jan 10, 2023 at 1:23 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Paul E. McKenney <paulmck@kernel.org>
> > >
> > > commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.
> >
> > Thanks Greg, I had sent the same patch earlier for 5.15. Just so I
> > learn, anything I did wrong or should have done differently?
> 
> Never mind, I think it is just coming from your queue after you picked
> mine up...

Yes, this is the one you sent me to have applied :)
