Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355515D4
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 07:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52914C433D9;
	Mon, 18 Sep 2023 07:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695020881;
	bh=5cYT6s+W1+FBarzJ57lGL9ZmJ16G6TyPMMoG6llhjo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HFmk4/bEtk8kL34oAphCEgNmqOoJ+m63NPpt36EPmnCuvVkodbvfejfHCuenCI4H2
	 WpkKBYaGdkTd1rMnraF1C4Nd1uz2jbmeTbv0U7K+4DYhLm7tHQ1GRhkpyrOKQBLdkU
	 1vZ3xGn16/qcl7kkUD9O46bV1Yg6eNrSuTKrVSQ0=
Date: Mon, 18 Sep 2023 09:07:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>, stable <stable@vger.kernel.org>,
	patches@lists.linux.dev, Yonghong Song <yonghong.song@linux.dev>,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>, gerhorst@amazon.de
Subject: Re: [PATCH 5.10 294/406] bpf: Fix issue in verifying allow_ptr_leaks
Message-ID: <2023091815-skier-freemason-988c@gregkh>
References: <20230917191101.035638219@linuxfoundation.org>
 <20230917191109.075455780@linuxfoundation.org>
 <276965bc5bb339bc02bbd653072ceb50a7103400.camel@gmail.com>
 <CAADnVQ+OwQzzGC7tP_qbLYi=k6T4dPKrod57iXt2-_JFCdqF4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+OwQzzGC7tP_qbLYi=k6T4dPKrod57iXt2-_JFCdqF4g@mail.gmail.com>

On Sun, Sep 17, 2023 at 06:51:14PM -0700, Alexei Starovoitov wrote:
> On Sun, Sep 17, 2023 at 1:21 PM Eduard Zingerman <eddyz87@gmail.com> wrote:
> >
> > On Sun, 2023-09-17 at 21:12 +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > I believe Luis Gerhorst posted an objection to this patch for 6.1 in [1],
> > for reasons described in [2]. The objection is relevant for 5.10 as well
> > (does not depend on kernel version, actually).
> 
> Yes. Let's delay the backport of this patch until that thread is resolved.

Ok, but note, this is already in a released 6.1.y and 6.5.y release so
we need fixes in there for whatever ends up in Linus's tree to resolve
this.  I'll drop this from the pending queues right now for now.

thanks,

greg k-h
