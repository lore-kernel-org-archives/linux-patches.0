Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC73191D2
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864626; cv=pass; b=O5LfblaJPMRANpN1fUEIG6sYEfTHVzR5CaBZtIOL1IhSo3hFOYtm2pPv88Oyw1bltls3DigQCDPc2CnzcTP+g2BRbEFA5nvGLSsK1NjOR8ldU4Lqih2AOrF300bPeYeMaLaKj9KUIhUEVUoJV3j1BaDgYKEZN/JlXmGpe2RYdvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864626; c=relaxed/simple;
	bh=QmuNg1tBtzwmz+wkhgiXHLezpaCUDOCDyd8P/htnkvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDh7nmO0jcCyPBqMvVekN1buDzlJWzRIkWM5d/4DAmQ1YgsjmjxOMcsGYRjLsqsSs+pWNasLU8FEqau4nyKiaqwe0IFR01bci/NdBdxJXD7fXXT5MFB7YqYDRSVRNP4m01k1m78f+YX+E1mCnfFOha9R5HZoWs8SRWUrrRbevHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=landley.net; spf=pass smtp.mailfrom=landley.net; dkim=pass (2048-bit key) header.d=landley.net header.i=@landley.net header.b=E7yTKFH6; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=landley.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=landley.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=landley.net header.i=@landley.net header.b="E7yTKFH6"
X-Sender-Id: dreamhost|x-authsender|rob@landley.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 96639160C57;
	Mon, 23 Feb 2026 16:11:12 +0000 (UTC)
Received: from pdx1-sub0-mail-a229.dreamhost.com (100-103-37-158.trex-nlb.outbound.svc.cluster.local [100.103.37.158])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 13DC4163A9E;
	Mon, 23 Feb 2026 16:11:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1771863070;
	b=D10lQ/C9uKN0awKaoY1DJbyw883z2sXTh1CP2yS9BDRhSH58rsf1CoH5LujX2k7UdyXoBD
	t1bhwmCoGJUp9Vlj46sIobRvYohwXZMku0zgzlMBomVvtklhx9MTfMCq18nqt7BfSfv5sy
	JVyRXMl+RWIB9TE/S+JSDtdPUzvkDAid+ovXQx2YKRnNJmpm5dGpxNqaSlaH32r3Q7Bgj8
	Df91LPvo+OF+8/1j3YKIG3yfMANeWaohaeRJukOVHk0/p9XDuYaSP7vRB736CZPbK9+1uR
	Q5fyNplw8uWgFHsNE6fxqfshimehi1AB1J9EDCVb/DyMbdGOH2nQUoa/y2CAhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1771863070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuD6XCjlTOuLfHYtXzVsTlp4WOA/ge30qcw+P5i9Neg=;
	b=J4JKNO/Aq56Qgvep1jBeLGTX0W4LsZYTzravitWIiHbtcBK53abXlKnP3aSwFPPxC8WCdU
	2HKgwjMY25lyHqUUf86/lzeAksAERcKa5INoAEp/MKbQs0d2mcu9Vh7PZdoezJ3mJP05lD
	9YgRxaG/As8lvZTDA3Ry3nd2hF4QVxeimG3XC4CAgaSbTC3J7Y1U6NJowVojfIyx2Ds9Dw
	JldXum/9uH/Pg/DjU6owlT5lDyq1K7rZYtfgNDqXZbFJf3u6vf8yNkQzu+9oPmutrcJdcE
	eMdaySlElaVd84WcD02Igp0Re0WMlbkG4IY++BztF09xTyEHTrW2wno/ZJNfTw==
ARC-Authentication-Results: i=1;
	rspamd-6fbd58c58b-q6pqj;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=rob@landley.net
X-Sender-Id: dreamhost|x-authsender|rob@landley.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|rob@landley.net
X-MailChannels-Auth-Id: dreamhost
X-Glossy-Stupid: 51eb68441b29b606_1771863072406_1607851710
X-MC-Loop-Signature: 1771863072406:3925674246
X-MC-Ingress-Time: 1771863072404
Received: from pdx1-sub0-mail-a229.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.37.158 (trex/7.1.3);
	Mon, 23 Feb 2026 16:11:12 +0000
Received: from [IPV6:2607:fb90:9a0f:889c:175:8594:632c:fd9c] (unknown [172.56.10.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: rob@landley.net)
	by pdx1-sub0-mail-a229.dreamhost.com (Postfix) with ESMTPSA id 4fKQnm4c9Yz6N;
	Mon, 23 Feb 2026 08:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=landley.net;
	s=dreamhost; t=1771863069;
	bh=XuD6XCjlTOuLfHYtXzVsTlp4WOA/ge30qcw+P5i9Neg=;
	h=Date:Subject:To:Cc:From:Content-Type:Content-Transfer-Encoding;
	b=E7yTKFH61K6Rf3nyxMlL5gJn8Vu7IRd1pAZWYgnNR9pCVRRJUpvhMLFsUk6Xig3sX
	 d6NWEP3DpNrj+DxqHNetE2uHwz9ZJUf/MP/SxA4TNEVqYNX1XyMQxsMbqnOItaYmhx
	 kMG9i8DHBsDuwQZ/6swAy5TFwwx11Zc5Ry3lX1XRq5mq4C6CTDl7cGtAYkgBgq25SO
	 fh7Lt1Up1B6KsjeaobDjAYsrfx59zhVGH+ott0uRMP1JJ71tbhFsbxkxnwXEXqRvlu
	 t7uZaYSEx+P719OVfP3zRy8hYDm/Xq10VI5hBE26ZbFU1tWk0vFK0xtefoKtamHS2O
	 AcHbh4zCO+A7w==
Message-ID: <7e309fc3-7d55-4e95-8dea-f164a7a96b6c@landley.net>
Date: Mon, 23 Feb 2026 10:11:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] init: ensure that /dev/console is (nearly) always
 available in initramfs
To: David Disseldorp <ddiss@suse.de>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 patches@lists.linux.dev
References: <20260219210312.3468980-1-safinaskar@gmail.com>
 <20260219210312.3468980-2-safinaskar@gmail.com>
 <20260220105913.4b62e124.ddiss@suse.de>
 <6d34c95a-a2ea-46a4-b491-45e7cb86049b@landley.net>
 <20260223133357.0c3b8f8e.ddiss@suse.de>
Content-Language: en-US
From: Rob Landley <rob@landley.net>
In-Reply-To: <20260223133357.0c3b8f8e.ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/26 20:33, David Disseldorp wrote:
>> It's an archive format. There are tools that create that archive format
>> from a directory.
>>
>> The kernel itself had a fairly generic one one built-in, which you
>> _could_ use to create cpio archives with /dev/console as a regular
>> user... until the kernel guys decided to break it. I carried a patch to
>> fix that for a little while myself:
>>
>> https://landley.net/bin/mkroot/0.8.10/linux-patches/0011-gen_init_cpio-regression.patch
> 
> This seems like a helpful feature to me.

It was, but I want mkroot to at least be _able_ to build with vanilla 
kernels, so couldn't depend on a feature upstream had abandoned.

The real problem isn't cpio, it's that the kernel interface for 
statically linking a cpio into the kernel wants you to point it at a 
directory of files for _it_ to cpio up, and when you do that you need 
root access (or fakeroot) to mknod.

You used to be able to point it at one of those generated files (and 
thus edit the file yourself to add the extra nodes), but that went away 
the same time they broke the rest of the interface.

> Thanks, David

Rob
