Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5A11AE879;
	Thu,  1 Aug 2024 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722526100; cv=none; b=uAQu677nI0gfk+OnuCH25NaaGh92g8ci1yUmWdl9P76fFd5Dqo7kZ0U2c14DHEVb22R+oLcigdCcbkJGVeBbljCKJ4fbsrSKUNS+hXDwHPhx6zJfYXzyLOkhsLkYg1jSD9dkfdOAx42RShkLAH2FtQzvkIYXjVSm+6iEIkkoz4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722526100; c=relaxed/simple;
	bh=vR0GCYpDfGgwHUwaBDWrMwxJHGitKXvoejBTCLYoHLM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcTmXm3g17N0H8yzy4he79CSKPIRQBrr4G51nABR8VYW3d2EsrcROz1/K92Kz+YwtqaazHKf4uIKnz8EeD5Q6i6u9LRCrjhw0asisC/HMXUSlncP2Pr+J5N2t2pBJk6ve/93lVIRUz7Z0l1x6lBRxRTWRL7boUqPGBXb1U5VK3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=myULy7ds; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="myULy7ds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1722526080; x=1723130880; i=s.l-h@gmx.de;
	bh=s5steqZuXqO5dcKmNt0JEiMYsuG6O6pAwh6AEb+ZvVs=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=myULy7dsmfcGO8MS2D8I6pgFVqrKBoJNGe1UG/gVLVTa3CLuC/UgQW3nwnrv/183
	 5sDbbampfXKBQH/bTo1QpIAhdW5havGxueN+rh+NiFeD17hbNOMyuOo1OBm2AFk4H
	 x+IhHmSjCFvTqg6CcTyXWMLHYZyd+I3MQsFwWWNbJHnrGzGWYz6yAOl9kC32/HtiT
	 f3nvoYnsXOrxJmKxYJqPRiQVUD2QBdJYXAR7l4NK6Z/0n5FypdFZyAnmEpwXwIM4t
	 fPko6cpO9CMC6KfEoon87FqgD2AQey7P0/hcO0NZe2TqgTpXGZZyitXP7jrJCwLkb
	 X1Ih9LKeTxsd8TxjQw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.83.155]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MA7GS-1sNx980lII-001dLA; Thu, 01
 Aug 2024 17:28:00 +0200
Date: Thu, 1 Aug 2024 17:27:55 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Zheng Yejian
 <zhengyejian1@huawei.com>, Sean Young <sean@mess.org>, Hans Verkuil
 <hverkuil-cisco@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <20240801172755.63c53206@mir>
In-Reply-To: <20240801165146.38991f60@mir>
References: <20240730151724.637682316@linuxfoundation.org>
	<20240730151735.968317438@linuxfoundation.org>
	<20240801165146.38991f60@mir>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+j1x3XHG4I3fMbmI5DLDqxIh4n70CxyJPv7TMGxTLHLGMgwW7eZ
 Tp0MG51swDtSH+kymX7utFEIBMCvwAGzG66S/5wkMYRC6thrAv2YzKjr68rrhLxkHd8jWZf
 w3eXw+TLFhLDzjuEzogBVQkEGb+1UUZOr2pLWvunXJeOs8XIjFwkxlNgxXzjTicYh4IULRL
 cCbAidEp1OIl1uKHBJiAw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:t8IaiN6Qiog=;F6zmoGBeWdyucjM7mELLpF1BpiB
 I/+YYLUgyRHv4FvsxheLbGl1QEt5LowGPAiFzsPkieE9mX2TByaOr8N3Wh0R83YftPVYS3WLS
 Q6Cggzcom6xuQosVaMS/EnIZOTSF293z7It0338Gi6hiceyIRguOeuX+6iG1D+k5vEcow3TkE
 8fIOYonUDNh3szy1Wv6g3HQtJxyQnfRtN7GV95XLvwUSXmAdFkoJ4iBHOCzS9sFet4CHAsS98
 RBWfm/EGfeY8qgAD14NJPueJG+qS3YndA7i220y8z/9jgMYvwQcPPc6QqxEyePOJHUlgWlMTX
 n480fb281q47XJtrpeIROpCPd5Y5/Hlzo8y6KV/zR/hyQF42nvD5+aD+mJKOAa9gMz0IxQtJe
 CZJi9m2UcL9mZLe2vCNlLKAnh+KfhNpUIp/qTFsB6JYsLHRzxyh8i5fhs3JL8Fg+KHPp4eIsR
 6abcx3WPMfst/xGqCWm+khBGhKAWTB8IDIJpaHJXfg6a+rHgjWUPJLJU6AL2V6olAY7233VZs
 aTlR0S0d7KsJVbG4vwiSNTSxbgxDeuJDT8pfmfeeFfBTC6QUoJxQV2rFhdN3MOfMkryHcKIwG
 PGV8fmrdgkMA4M65L4m5BYexOllvzfUCX+2sIMf1vjjYe/+V1QlAdZwzbh8M4lMNI1jM5QuvO
 EpRoedIPlOvY01QMNahkTfXMJyBNxpN89KB9hxfn66RuYFQYTLQPtBU4nmmp4MnWPAO5PImNj
 hZNFEw17M+mO+CvCGMDCY8zVOpnOta1VHnytMXsClvEn39qi1Gy/dRwoNSkko1d3CTvoyMWuk
 dTkdZciBzGD+d/sXEzNa8qMg==

Hi

On 2024-08-01, Stefan Lippers-Hollmann wrote:
> On 2024-07-30, Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me=
 know.
> >
> > ------------------
> >
> > From: Zheng Yejian <zhengyejian1@huawei.com>
> >
> > [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> >
> > Infinite log printing occurs during fuzz test:
> >
> >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> >   ...
> >   dvb-usb: schedule remote query interval to 100 msecs.
> >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialize=
d ...
> >   dvb-usb: bulk message failed: -22 (1/0)
> >   dvb-usb: bulk message failed: -22 (1/0)
> >   dvb-usb: bulk message failed: -22 (1/0)
> >   ...
> >   dvb-usb: bulk message failed: -22 (1/0)
> >
> > Looking into the codes, there is a loop in dvb_usb_read_remote_control=
(),
> > that is in rc_core_dvb_usb_remote_init() create a work that will call
> > dvb_usb_read_remote_control(), and this work will reschedule itself at
> > 'rc_interval' intervals to recursively call dvb_usb_read_remote_contro=
l(),
> > see following code snippet:
> [...]
>
> This patch, as part of v6.10.3-rc3 breaks my TeVii s480 dual DVB-S2
> card, reverting just this patch from v6.10-rc3 fixes the situation
> again (a co-installed Microsoft Xbox One Digital TV DVB-T2 Tuner
> keeps working).
[...]

Btw. I can also reproduce this (both breakage and 'fix' by reverting
this patch) on a another x86_64 system that only has a single TeVii
s480 dual DVB-S2 card (and no further v4l devices) installed. So I'm
seeing this on both sandy-bridge and raptor-lake x86_64 systems.

Regards
	Stefan Lippers-Hollmann
