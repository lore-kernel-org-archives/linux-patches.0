Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795153084;
	b=X44i6MgWcnm6gKPV8i9EDThhA7/ZwH2Xo/2XfG4Kfwvfy2zN4ZvHR1VobqteJwsh3ara
	 AlE+0hztOxPj5TAZTruSLuFCCyYpH4IMRlPGo6peol2dPLc4JVEfYjJCAVkHcCC6Anv5o
	 i4HWj3JFx7+FENNu0fR6ho1v+pmKz0yutJmQAOrODss3M/5Ia5cMd8fvOQw43rz9dJCrD
	 m9EyKgNnFplrse8l48ko+u3cgKIU00vc3HLzEOlm7K+lSa0//Dsahtgta0kb8obQ6TNN4
	 YHZ4aWKVRFS8bpcGPSoI7NUIHttjZZDu3RcpjQKZ72GBOT0CM767GthR8NTidUtSlpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795153084;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ioY3rptUAE3ymL8xGREciAp2IrF11zNf7eQrGfFr9II=;
	b=1CC76Ib57sNqEw3GR+CIVof0Z5wQOBWqAICvl7jcclmYQhZaEEX1ftF0lORRklPWLKBP
	 bcS3H9POIpZyz3GsmshRRgQ3rZwL1JuM2QedPcUJiJX+UrqdVOe3heTIZMviLOt/g+i7Z
	 SGKOrt2pPhXWVnAzkHc69Z7xl7KbY2Oj/Os4t9LztnIr338PAAKEVf6RCuZmEeh/jJqiY
	 WZ5PG4sqpLpMpVX4CYgADT8D5TvktB/FE/RhdsCP3sDhrH0lOfLG/xVTCQT57E/iUJUpT
	 MRnPzIGEMlycR2N6zFwSnL9oUlvGaRxXl9KbOaLxmP499cL3y+dmbvojwTbNcjpwpBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+LJDsmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E84606A320;
	Fri, 20 Nov 2026 05:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+LJDsmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3E51F000C6;
	Fri, 20 Nov 2026 05:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795153084;
	bh=ioY3rptUAE3ymL8xGREciAp2IrF11zNf7eQrGfFr9II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g+LJDsmVwPN24MY5gmwWfGz5oNYm1l2LmOwtx6wtYaSYZW7Th5FVccgvAIUBTVbLq
	 ChclDwAP/IsXxIem0fXV+iRpCyO6ihAVsfuBGTcym+fU1X11mzNLi5IkNAVT5ghQ7x
	 I5L7zbw5skqr/vaf7+5b01Po5B1jvw6ZGcVgCFn8=
Date: Fri, 20 Nov 2026 06:38:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 2347/2651] gpiolib: Propagate emulated drive errors
 when setting arrays
Message-ID: <2026112047-gently-subatomic-7bd2@gregkh>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150409.562185124@linuxfoundation.org>
 <9d7a979a-59ad-4e88-964c-573b31778fff@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d7a979a-59ad-4e88-964c-573b31778fff@kernel.org>

On Thu, Nov 19, 2026 at 06:03:51AM +0100, Jiri Slaby wrote:
> On 18. 11. 26, 15:59, Greg Kroah-Hartman wrote:
> > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Baek Kyu, Kim <pocj8ur4in@gmail.com>
> > 
> > [ Upstream commit 15665047024e30f9c2227563d03034061c99ac2c ]
> > 
> > gpiod_set_array_value_complex() ignores errors from the open-drain and
> > open-source emulation helpers. If a direction change fails,
> > GPIO_V2_LINE_SET_VALUES_IOCTL still reports success, including when
> > updating a single line.
> > 
> > Return the first emulation error after freeing the temporary bitmaps.
> > Keep updates already made to earlier lines and stop processing the
> > remaining lines, as for errors from gpiochip_set_multiple().
> > 
> > Fixes: 8ce258f62f90 ("gpiolib: make value setters have return values")
> > Signed-off-by:
> 
> How much illegal is to have this without the author's proper S-O-B?

Not good, but that's what the commit looks like in Linus's tree :(

