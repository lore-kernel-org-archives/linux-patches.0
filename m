Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E81A23D6
	for <patches@lists.linux.dev>; Tue, 16 May 2023 07:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E89DC433D2;
	Tue, 16 May 2023 07:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684221624;
	bh=Qu52g/Pzv/8QqouVKWHSuOZf3mL4XggmKpomj4KjwiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WSlfBcTq3jA/CWiQEdEeUTtKM/YVlM0oSOcSc7Vb3csB15uCH2JL8HObtyOq3LkOm
	 rU8tT6faqBXd4pBpzkMZRNFpJRIBplAonoNTIhVoAqttKWex6TaPN9U554vPmz70dM
	 96Ncuq6NdM/u3I8SvOjNRISxeeIusRcq9qgjY7UA=
Date: Tue, 16 May 2023 09:20:22 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Sripada, Radhakrishna" <radhakrishna.sripada@intel.com>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"Manna, Animesh" <animesh.manna@intel.com>,
	"Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>,
	"Souza, Jose" <jose.souza@intel.com>
Subject: Re: [PATCH 6.1 197/239] drm/i915/mtl: update scaler source and
 destination limits for MTL
Message-ID: <2023051652-corrode-grape-809e@gregkh>
References: <20230515161721.545370111@linuxfoundation.org>
 <20230515161727.643480643@linuxfoundation.org>
 <d3bb810d9b1bc5d210ab414d7eed140be62e97e2.camel@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3bb810d9b1bc5d210ab414d7eed140be62e97e2.camel@intel.com>

On Tue, May 16, 2023 at 07:13:05AM +0000, Coelho, Luciano wrote:
> On Mon, 2023-05-15 at 18:27 +0200, Greg Kroah-Hartman wrote:
> > From: Animesh Manna <animesh.manna@intel.com>
> > 
> > [ Upstream commit f840834a8b60ffd305f03a53007605ba4dfbbc4b ]
> > 
> > The max source and destination limits for scalers in MTL have changed.
> > Use the new values accordingly.
> > 
> > Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
> > Signed-off-by: Animesh Manna <animesh.manna@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> > Signed-off-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20221223130509.43245-3-luciano.coelho@intel.com
> > Stable-dep-of: d944eafed618 ("drm/i915: Check pipe source size when using skl+ scalers")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> This patch is only relevant for MTL, which is not fully supported on
> v6.1 yet, so I don't think we need to cherry-pick it to v6.1.

Again, this is a dependency for a different fix, which I think is
relevant for 6.1.y, right?

thanks,

greg k-h
