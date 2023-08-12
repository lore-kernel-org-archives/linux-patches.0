Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69A1CCCC
	for <patches@lists.linux.dev>; Sat, 12 Aug 2023 12:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AF7C433C7;
	Sat, 12 Aug 2023 12:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691842905;
	bh=+fmrwhFofl2rv4r4Ta/Ymtc/OCCGQFS6TBp0M9a1944=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MSIbWtecrEwlB5IL1NBDC3gvrzo1HMpSCS8RYMBFFyX9f+YyfTqzWFEi8AUZhwSw6
	 ZfQg4hVDhwwLvPF0dIVSIUN3CUllhyi44BlpEVXMdgtYStmK19MHyNBOmghcLlKPRn
	 3ZRS76eAuuxh1s+0I1iACPsUe6HShvuOD/iRBs9cAOOGcmp1tupAva82tjjcSV/UAJ
	 uXliG3EvzyIEfuW82SuetzinmWlojmIuuAwTAotPJm5CQ+WESkL3720snIL+HACzGW
	 cWxt7kjtEsbL9YHQyZtOHq53LSIQswzYE5aR5KgrMVoX8bcEibdx/nIXJr01HaGOjv
	 /Yde+oPhJeXKg==
Message-ID: <0b69bd4142afc5be0a8d76d00373d93317f609c3.camel@kernel.org>
Subject: Re: Mailing list request for kdevops enable persistent disks
From: Jeff Layton <jlayton@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>, rt@kernel.org, 
	chandan.babu@oracle.com, amir73il@gmail.com, josef@toxicpanda.com, 
	a.manzanares@samsung.com
Cc: patches <patches@lists.linux.dev>
Date: Sat, 12 Aug 2023 08:21:43 -0400
In-Reply-To: <ZMwi5oDiAKGpPh8B@bombadil.infradead.org>
References: <ZMwi5oDiAKGpPh8B@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2023-08-03 at 14:57 -0700, Luis Chamberlain wrote:
> kdevops [0]  has picked up momentum over the years to the point we now ha=
ve
> a community and reviewing patches is becoming more important. Although
> we are on github and gitlab and share an organization together I just
> noticed 3 pull requests have gone unnoticed for a while. So I'd prefer
> to just avoid web GUI pull requests and instead we deal with patches
> and whoever of us can first review patches and:
>=20
> b4 am -s message-id
> git am foo.mbx
>=20
> Will get to apply patches. We can simply divide an conquer later and
> if needed send pull request etc, but the web gui crap, I'd really love
> to avoid it.
>=20
> But we need a list. Otherwise we gotta start Cc'ing everyone.
>=20
> Although we could abuse patches@lists.linux.dev it seems the timing
> is right for a mailing list dedicated for kdevops. Could we have one?
>=20
> [0] https://github.com/linux-kdevops/kdevops
>=20

+1 from me on requesting a mailing list. Discord is OK and all, but it's
not really a replacement for a mailing list for development. I think
this will help encourage more people to get involved as well.

I believe all we need to do is ask helpdesk@kernel.org:

    https://subspace.kernel.org/lists.linux.dev.html#requesting-list-hostin=
g

I like "kdevops@lists.linux.dev" .

I'm willing to be co-owner if you want a backup. I can't imagine it
involves a lot of administration anyway.
--=20
Jeff Layton <jlayton@kernel.org>
