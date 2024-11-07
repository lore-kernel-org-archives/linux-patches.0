Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7931DF72F;
	Thu,  7 Nov 2024 09:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730970401; cv=none; b=DR267T9HhViND0jbxs92R2apfr+PRlVB+nhEuwxS7ikJzw6d8Ku5+iILL15w8XwayCjm+UlFKkGRJzuyJ4HyVSu1/SCeBFQwJpCQQlG7z7id2lCfqX9Hsu75yZSX3q9fC+nBPxCpTeHw34SBV+a6Xkzb2+vZXiwhuxAesFVPXSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730970401; c=relaxed/simple;
	bh=xHL7sWXIsSVb7nzMaapYqJotKYnqvCDEXU+vIkW8/qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzIz6gpqQ3QWJ/mj6+gOMNT6DgRDm3K6oz1ULPVTZxtlmddrfSomupHbEm3oCnVkgA6VFkdTAYOm65FgeKLyCfPtFCwQbO2TzLgcYMHg3sdJ0hIX6diBX5uEji8XGj+H6P/yoT2ePADmU6Qh55FFCMnCvZ2lFBSw2XdOgLQ5qUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heH4a5Xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heH4a5Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C10C4CECC;
	Thu,  7 Nov 2024 09:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730970400;
	bh=xHL7sWXIsSVb7nzMaapYqJotKYnqvCDEXU+vIkW8/qo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=heH4a5Xs4uJb+F+E2C/bouAhCIUwAChTsQPRPE6EScR7uLD4ef/NfmZobLJ+xYq7f
	 2vPKMgsJAZlAB2MVhd2q9Fnaye2Ou3ADkb5hk71g2HYIjTZ2mnVqqQoASqzbsRt7qK
	 nCK1LzkizNP0XMLn9HEVp/OVRfE6cz8TX6TCevCU=
Date: Thu, 7 Nov 2024 10:06:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Biju Das <biju.das@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 312/350] dt-bindings: power: Add r8a774b1 SYSC power
 domain definitions
Message-ID: <2024110709-promotion-july-19a4@gregkh>
References: <20241106120320.865793091@linuxfoundation.org>
 <20241106120328.478044780@linuxfoundation.org>
 <CAMuHMdWoAOzMtFWEukAfAOz-eGub2=7P0hyH2PkZKN6Pkv4LWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWoAOzMtFWEukAfAOz-eGub2=7P0hyH2PkZKN6Pkv4LWQ@mail.gmail.com>

On Wed, Nov 06, 2024 at 01:55:03PM +0100, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Wed, Nov 6, 2024 at 1:22 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 4.19-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Biju Das <biju.das@bp.renesas.com>
> >
> > [ Upstream commit be67c41781cb4c06a4acb0b92db0cbb728e955e2 ]
> >
> > This patch adds power domain indices for the RZ/G2N (a.k.a r8a774b1)
> > SoC.
> 
> Why is this being backported?
> It is (only a small subset of) new hardware support.
> 
> > Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> > Link: https://lore.kernel.org/r/1567666326-27373-1-git-send-email-biju.das@bp.renesas.com
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")
> 
> This is completely unrelated?

Now dropped from both trees, thanks.

greg k-h
