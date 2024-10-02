Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C6C1A2561;
	Wed,  2 Oct 2024 09:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727862713; cv=none; b=DKEbVWdw1jjqTM5SGs3bCMHKJw+0cToPaSeXiOHL0lS6ikAjKPmbnMN9UtoqCf4y0x9eCITEKGWjARTAhVrzsgq2lY1/2BksFKYbS0YSndkx1vjJ74frz5oYBGW0MerMthZ6vjAia8egOUS7KqqnESnlpWvaD7vi9eXT/Vk5rHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727862713; c=relaxed/simple;
	bh=oYWy7FXEI1QBLLJJEz8QY8YzcBJIzeu5d7jKvv2jiHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpJZnwqqlZ5j9KGGBq4CjCALp2QlFtKVkbDrNaoMDEGXVfD/nsS1Wtbh1jC0CU2BJxT8BwWmmtVFp9tD4lz59Qil1zZj3+gEtba/Wqb4ToyHnQk68skON1sY/9FLOG9d+ZGUnH1wXO6JKTOFTz0250lYHxvxEsUNcEq3ay4g/9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDvNc/3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDvNc/3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697E6C4CEC5;
	Wed,  2 Oct 2024 09:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727862712;
	bh=oYWy7FXEI1QBLLJJEz8QY8YzcBJIzeu5d7jKvv2jiHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dDvNc/3Zz018aNCMs5mDmiJeHxnFJ0SRlQ/IJU8tfGCu6dFi5eHJuGT5adcwhtvcF
	 f6GIupdrTF4umlekv+lF9MhHAOv7q+9DNmexZ1/iu7foRoD/3Nx0i7WA72Yoj1b+zX
	 H/kBnU3zLdC15c0Ocy17Nq18MY3UKxnHEjqJnhKU=
Date: Wed, 2 Oct 2024 11:51:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 033/440] arm64: dts: qcom: sm8250: switch UFS QMP PHY
 to new style of bindings
Message-ID: <2024100238-margarine-strongbox-d096@gregkh>
References: <20240730151615.753688326@linuxfoundation.org>
 <20240730151617.057892121@linuxfoundation.org>
 <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>
 <F1136AC5-0860-4070-B4FA-86BAEFC070FB@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1136AC5-0860-4070-B4FA-86BAEFC070FB@linaro.org>

On Tue, Oct 01, 2024 at 09:01:09PM +0300, Dmitry Baryshkov wrote:
> On October 1, 2024 8:27:55 PM GMT+03:00, Sumit Semwal <sumit.semwal@linaro.org> wrote:
> >Hello Greg,
> >
> >On Tue, 30 Jul 2024 at 21:25, Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >>
> >> 6.1-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> ------------------
> >>
> >> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> >>
> >> [ Upstream commit ba865bdcc688932980b8e5ec2154eaa33cd4a981 ]
> >>
> >> Change the UFS QMP PHY to use newer style of QMP PHY bindings (single
> >> resource region, no per-PHY subnodes).
> >
> >This patch breaks UFS on RB5 - it got caught on the merge with
> >android14-6.1-lts.
> >
> >Could we please revert it? [Also on 5.15.165+ kernels].
> 
> Not just this one. All "UFS newer style is bindings" must be reverted from these kernels.

How many got backported?

thanks,

greg k-h
