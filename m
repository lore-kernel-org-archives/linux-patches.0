Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674979;
	b=tkzeTe0SMJv1A1j+FEItp2fcekl6IyqmZzvJfdSyNz60HwxY58BpdXiJBYLGfXREE3lC
	 wEjEGWEbEBYS246Mw5txM9qWjX2ReZSa/VL2PYplSv1jYPLzVQEib8NMKbDNgXH8SwOJR
	 PGIJaAIuUg44g5Ao6/w05SfKjM1xurcLjAEwTVHcszfJMv72ZaSbbqILKbFEcp9eK0DM5
	 rem/4pWBdket6BLjiu9GcuBTvibXdRI+1QBfheXuNYLGI32KkcXkNXLACgIu8S4diDp26
	 fQNaEAZcIkxiBCUn5Oaq64K3XrYxm3eBwWX/65XCWMFaqIa+fUnCo/dVQqCnCE5mrkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674979;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=bPcFlMX4M9uk2kA/pIRZuMI4xusR9ISn/WqYnJWXDeg=;
	b=cuY4iI3/QxVZ2uMwn0x3i203U8wsbpsS3kKuySi03P2i+0ZgYJqebSVgrApxUsUa/uMa
	 AX+s1W8u9r2AJH3XE5/Y6WAZgXG4bIVp3op7m1HEQvvbU16ogeVTGBgvuNSYAFNc6/sAD
	 NwFlRMjBzP3MO9u2zgFVhCaM23eMP/I32MQ6a5EWWNPyUuokn53LfJbshylS1HztoGrcE
	 l8OiSyrA759+QqjBVK1MXnWNWVL4ppjgh8FuTVxaKdpnDRY+6pcGPf7oHf59AqI2yMy2o
	 cSGAhaRuh+4zqPetGff38YIP5Emdl08oY7d7P41xmq1h0X0lwZmaHLvem2v6cKW54aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KpbjaNPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7C8606A31C;
	Thu, 26 Nov 2026 06:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KpbjaNPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7911F000C6;
	Thu, 26 Nov 2026 06:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795674978;
	bh=bPcFlMX4M9uk2kA/pIRZuMI4xusR9ISn/WqYnJWXDeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KpbjaNPLVACUR4BF0gkGfsotFIazPO0G8vBl2n3EOaI60CijDJ5P1eV/HayFGJ1h0
	 Xp/Sa8SXte/vRh9k3qX1EFCC0bgb/fNkpQGl61Y7EaFmvmp9ru/HXhQYWSxnSqdVUh
	 VCm95JjtQKzjwRDqJklro3E8eIm4d/c0IYcIcyDk=
Date: Thu, 26 Nov 2026 07:36:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Rahad Bhuiya <rahadbhuiya2021@gmail.com>, Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
Message-ID: <2026112640-recite-tipping-891f@gregkh>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.189554233@linuxfoundation.org>
 <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>

On Thu, Nov 26, 2026 at 07:19:47AM +0100, Jiri Slaby wrote:
> On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
> > 
> > [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
> ...
> > --- a/kernel/sched/ext/ext.c
> > +++ b/kernel/sched/ext/ext.c
> > @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
> >   		args.cancelled = true;
> >   		break;
> >   	case SCX_TASK_READY:
> > +		scx_reset_task_fields(task_rq(p), p);
> 
> This fails to build:
> ../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function
> ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’?

Ugh, I wonder why this code never hits my build tests...  Thanks for
this, and the other report, I'll fix these up after my coffee kicks in
and push out some -rc2 releases...

greg k-h
