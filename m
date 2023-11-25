Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6DFBE9;
	Sat, 25 Nov 2023 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw6roHdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882A0C433C7;
	Sat, 25 Nov 2023 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700926359;
	bh=dF/dY+qUpBZxMvTcmaU2gtJRxpP8Ttc+XPxQ/FMAbI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hw6roHdk8f5iCe5H3HWxzOmy+HCikeMmZeeFaiEOHvKsL2bDbeR+DOQVqAxq+ocE7
	 7E/M4xmWtOTjp/CF8r74MlhQgGMeYfmHTGLUF2fftC4/IR/5A4X35WbffLtSsV1TRl
	 0jjqWP091RirYiIAa/QLPROWDhRAKTnJe4HcQSBA=
Date: Sat, 25 Nov 2023 15:32:37 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	=?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
	Lizhi Hou <lizhi.hou@amd.com>, Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 369/491] of: dynamic: Add interfaces for creating
 device node dynamically
Message-ID: <2023112558-catering-quail-aa4b@gregkh>
References: <20231124172024.664207345@linuxfoundation.org>
 <20231124172035.663205241@linuxfoundation.org>
 <20231124225341.3288322f@windsurf>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231124225341.3288322f@windsurf>

On Fri, Nov 24, 2023 at 10:53:41PM +0100, Thomas Petazzoni wrote:
> Hello,
> 
> On Fri, 24 Nov 2023 17:50:05 +0000
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> 
> Isn't it quite strange to take this patch, which is clearly a feature
> patch, into a stable branch?
> 
> > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
> > Link: https://lore.kernel.org/r/1692120000-46900-2-git-send-email-lizhi.hou@amd.com
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > Stable-dep-of: c9260693aa0c ("PCI: Lengthen reset delay for VideoPropulsion Torrent QN16e card")
> 
> This looks very odd. I don't see how c9260693aa0c (which is the trivial
> addition of a PCIe fixup) can have a dependency on this complex patch
> that allows to create device nodes in the Device Tree dynamically.
> 
> Am I missing something obvious here?

No, I thought I caught this already, this is the "stable-dep-of" bot
going a bit crazy.  I'll go fix this up for the next -rc release, by
dropping this, thanks!

greg k-h
