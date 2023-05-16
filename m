Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C583823D6
	for <patches@lists.linux.dev>; Tue, 16 May 2023 07:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D896FC433EF;
	Tue, 16 May 2023 07:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684221574;
	bh=wmYkRYF+yvLqVr17NTcRzLuGmJoYEiXBVSA6nlwZa/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yWDAfthObouQH2Q6b3T03jnrd18pQVwk1QpB2A/o1rsSsRxe3EOsgEMQDPaxTdOIS
	 m/+BMisJ7Afsp4QZnYwJk1K0x9hqeEAAqTYaW7GUQXQ8RosY1dQVqaRe7fxxr5RBPp
	 i81B460/GSrTD6O3834RXmtzmXzYGI1vusKxSGLQ=
Date: Tue, 16 May 2023 09:19:31 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Sripada, Radhakrishna" <radhakrishna.sripada@intel.com>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"Manna, Animesh" <animesh.manna@intel.com>,
	"Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>,
	"Souza, Jose" <jose.souza@intel.com>
Subject: Re: [PATCH 6.2 213/242] drm/i915/mtl: update scaler source and
 destination limits for MTL
Message-ID: <2023051607-rocker-refinish-8c6c@gregkh>
References: <20230515161721.802179972@linuxfoundation.org>
 <20230515161728.319620707@linuxfoundation.org>
 <51bf59b96c22c2e79d81e38c3dc1b006959a14c8.camel@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51bf59b96c22c2e79d81e38c3dc1b006959a14c8.camel@intel.com>

On Tue, May 16, 2023 at 07:13:42AM +0000, Coelho, Luciano wrote:
> On Mon, 2023-05-15 at 18:28 +0200, Greg Kroah-Hartman wrote:
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
> v6.2 yet, so I don't think we need to cherry-pick it to v6.2.

Does it break anything on 6.2?  If not, I think you want it as it is a
dependancy for another fix, right?

thanks,

greg k-h
