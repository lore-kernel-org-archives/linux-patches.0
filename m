Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED402D0C8F
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 10:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792318878; cv=none; b=c8O104ulZ84uRLKz6wC4wdE6l+heZETopEbrhp2qx+XkfVetUAHeMAMj+YdaALWZDDTO5frD471W0i/GtqhsAKlhmAqHhVsBbtMaJaHkzwnTrkagcvu9JDao+E6w/Vj6oIxeNCLLBnmO93TZ6GVFYYLlJcEZD+hsvmNEtUZkmMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792318878; c=relaxed/simple;
	bh=rQZYBRnwItqMgDEQCgK+aU9yFlbsMszBnHN1UbMX6SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEpgSWOh1CyNmb4Eav/zZNDjDhDIpwx/h9xwDXz0DVWoR03SSw9cTOTI8akASILtkOp3Ro5MGRAxNrjqw6h6eHJGmRoSjyvRp6gBiPbPz/mKhgg99vNtei73FvLFGd8z/frvDVjZESebB+LxImVIOalqRD6xPmwZ8rOVVlC/k0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ametros.net; spf=pass smtp.mailfrom=ametros.net; dkim=pass (2048-bit key) header.d=ametros.net header.i=kernel@ametros.net header.b=GieMFgu4; arc=none smtp.client-ip=212.227.126.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ametros.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ametros.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ametros.net header.i=kernel@ametros.net header.b="GieMFgu4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ametros.net;
	s=s1-ionos; t=1792318757; x=1792923557; i=kernel@ametros.net;
	bh=LCKM0eQxsbocvedXU3BiqvTFdXbr9gWMxfeSvsaIezI=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GieMFgu4362JbvGm3dCbjnS4pTRk1qLr3buQcZBajKwhAoD50JvUXZPhdf0qa4A+
	 79uELRMX5uE8m+dcROMMt8+N/JXXfSX+gIFS3k9TpT2RLqip9fr8yyPvReyhbzM3u
	 1nIQHM2JiF27TwSNArKd93eRJhozzf/XqDbb7s+SXHj8BzgTBO9+Dua2nVQNR2GdM
	 VgVGqv8EAchoFjxCbexfnWUKi2jyi+akDwy4O/mRCWLVjHd//fj5xyXUd7KRui9FJ
	 k4nY04Zy9Xh/b8lx3JSrY87jzOO70i7ykYB1/t4l/l7yIPuw+JEMrffyfVw5kB/Ou
	 7OKg5WxLsFIDCasNOQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue009
 [213.165.67.103]) with ESMTPSA (Nemesis) id 1MLi4W-1x0r8H3ELA-00KeA3; Sun, 18
 Oct 2026 12:19:17 +0200
Date: Sun, 18 Oct 2026 11:19:15 +0100
From: Bob Anderson <kernel@ametros.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wolfgang Walter <linux@stwm.de>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: regression 6.18.57: acpi power button vanished in machines
 running in qemu
Message-ID: <atSdI7buRErdF1jZ@ametros.net>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
 <2026101834-parchment-reps-0bee@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026101834-parchment-reps-0bee@gregkh>
X-Provags-ID: V03:K1:oB6psnwJ8pFGHnVDLRZ1jGFYj1/Bn/jDMcjj3Q8vD8o+fV7akeN
 aScMsq5IhJBogrTmxsMRgIu30wzkbD/M+kVKz5OV8VfvKPzA9sWJGwwC0zeCJU3ivk00MPt
 CgkMhwA5/PP1SVyg7XMe0aaHXhqqajighp/N2WNGUzVkiYLiu2GfV+J2xuUATvS1sUpBFKZ
 mSeywIea7MWwzDlUb/s3w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vaGavyb1HdI=;NyAbci0i39F2aNCm6Ds4BolHEua
 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
 P7fWoAeU8o3fJpiOgqjPSg5hn0+nYlck9PEzA==
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 08:48:03AM +0200, Greg Kroah-Hartman wrote:
> On Sat, Oct 17, 2026 at 07:26:54PM +0200, Wolfgang Walter wrote:
> >=20
> > since 6.18.57 there is no acpi power button any more in virtual qemu b=
ased
> > machines (as far as I can see model doesn't matter).
>=20
> Can you use 'git bisect' to find the offending change?  Does this also
> happen in the latest 7.2.y and 7.3-rc releases?

Reverting 38c79dacc8063ff8a0d75ce2a900fbaff82ad94c makes the problem
go away.

Reverting cleanly required reverting c85f325d9ec3116b0d4ee9d5b76c26aea0ad5=
ce0
and 78677084cd09001c3c815aab80c59708130a65d7 too.

FWIW we also have this problem on hardware (various Dell servers): the
power button and "graceful shutdown" via iDRAC no longer work. We're using
a custom ACPI daemon that looks specifically for ACPI power button events.

thanks,
Bob.
