Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29524E4C6
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 01:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027449; cv=none; b=U/NXkApNVcsmqhEFpcUY8qmr9Voi2uzDp9BTWVguTjSD8NMKB0CIOSWzjS2F2V+1Cgbtto1Kzv8Z/qGP7EPoN8N6SXuD6bmkwNuZncaq9AuMEFfMA3jCk0dWeIoZxdBi02ctli19kqS3Mn9W0Yids97ft5vupOiXwJ2GAvxcaDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027449; c=relaxed/simple;
	bh=z9IejdQXBKN2xrBOvxqP4WqQ2XxEUBaD7+MG4NCqXFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aR3NPAlZIx74Opj1lgCKX76OFsSN1E+v95V+Xyg1XNrV5pcGW7N91HPOjkT6UaNciCDUOIGDMtEF1kCrbNzQXZfRulive7qiXQ34CuNLD69rddlHDjuCiJ56FqHiwVmjRdmYyV5TtHv1FRh9HrJqPCax8/9t5TbpuuLeGcvX/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NrMnjXpg; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrMnjXpg"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-14394530ec6so3930876c88.1
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 18:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792027447; x=1792632247; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pr3YDdQf42YciJbBmqsTzbdgVNlR+zDd5aklF+kUUxw=;
        b=NrMnjXpgMS/VswaD6fQfAs9uVHeFq8Xd4keN7gybMI7kpH/ZaPvfpdxs+KKIANdWge
         W3qs6Qi62m/iUGjB06zGUeFDp4Z5+QlBU0KazFoSCjFGYEa+gHNVUskrkOxFvs5qqhYB
         WE6QqWMSpPlxatmdkRV08gecgPuyUmnuxzejQLPzWAMmNeidacZvLc3q/JDpJAHLFr02
         XVqZyYCkgmoFd3mzhSUpaxNWcdtSIkmsy1E75fMb62dbjW2aKBmr193z5sX+v5kI5YuW
         BAhq/Y94Ly925ZuUEZiSEbrL8Bx+cE63WuEt/6QJ5bxALezEc6eR782I+UgLnr7xcC9z
         iccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027447; x=1792632247;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pr3YDdQf42YciJbBmqsTzbdgVNlR+zDd5aklF+kUUxw=;
        b=AIKpx+RnOdjfnmgic+hEuPAXywxGw6RUOZ0kIyyECou0BwqjOkDLhqUXPsRbI3yxHE
         qsuoY9M4mru1lpM2qGv2qs+x9o6HtasTZdyXAgX4utKxKiDv+DlolS+rQlaAhpM4KloA
         IVJ040Q30exxzoy3/XvgpZuGZ/fPijOiZ0V8p4XnzPiaNs3TxKFcZ9OwCW3A+gYfl6zn
         Ia4AcmhUehwE6O6IGH2qjoH4URBogizKv4Dlpa/wK/fcVIa3L4TWoWRz2pibVBwn1vr7
         klFBuAhYZK33EhNjrZBTIF+GsnZeDOlBPB0aWdICu4J8v+yMBfoItJOlg7U7W5bbzaKN
         YUUA==
X-Forwarded-Encrypted: i=1; AKwUvByMl9C1PGutPC1HRPjFx2+xGQYMy/O4Lejd3FTNwIHbZrhqUt895kZ+RkKNp6A0ElLD68J05Sr4@lists.linux.dev
X-Gm-Message-State: AFq9FYILHwPTaJHbDDcaxNtQ0PqYiWCWZoaMQEuJ+AUFnOzY+fMRIKGz
	HTSHlLIhjBE3ztLkFgrty8TftyErVCSx962/pQHcqcmeugQzzjIj+3DB
X-Gm-Gg: AYBFou2Z9vK71z3/zHFfEJ4uH0U8+dxVHUqyw8ONOd5l3zynVDos+3yncVs15TO3lkC
	ZspxTUcDGmm12giQFJ7hTMB1PxlqLtBLMhaYy6g079PkRbufCfvMd6ZyYqoiBue/FJSej+PKI18
	mExhktbEDIyp2VCQxjGodkp/c9T7p69ZlS/1T4vyjXuO1ay/nmarWFJHKvzbY57j2B79bTSHzvm
	rF5iWFTv2UWNjas5vqh59Em606kIOU5NlWP7OXHUASWH4IhseporPiGRNfggTTEg07M18AW5b0g
	ymTrkIIxP2iCbLEkKq/dMyArIz/qK70JHxLeMGeTJc5ZT/G4pqOkJDPUX0bpHneQdiiaKGVLZB2
	LXWLGABIjr9Ax46xStQGda2QeN5atv1bZRTaHmgp6Ag+CqW9r6i6JO7rQUtQRynFeofdejkFAMD
	rXOYokstWgxkpon+Iu/PAjkQ35iChbgc9v2zbDK+FyxEGOcaKC0IDRybHJzUAmIMvWcHKlwqBl9
	cJ6trlxTInEO0u2/mt+JoH6t4ddit6Y4CRA64g=
X-Received: by 2002:a05:7022:5f11:b0:14b:cf58:ce15 with SMTP id a92af1059eb24-16a638513c8mr22744863c88.43.1792027447321;
        Wed, 14 Oct 2026 18:24:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2ebe:8:821:261c:74c2:4177])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1761ed641ddsm24901872c88.1.2026.10.14.18.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:24:06 -0700 (PDT)
Date: Wed, 14 Oct 2026 18:24:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Daniel Salmun <salmundani@gmail.com>, =?utf-8?Q?Rapha=C3=ABl?= Larocque <rlarocque@disroot.org>
Subject: Re: [PATCH 6.12 130/497] Input: synaptics - limit T440p InterTouch
 quirk to LEN0036
Message-ID: <atAmS2YluELR8LVH@google.com>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112910.975677311@linuxfoundation.org>
 <8868e018-3be3-4de1-a066-5bcdf7aaf124@oracle.com>
 <2d3bf713f9e7457f884f1908@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d3bf713f9e7457f884f1908@kernel.org>

On Wed, Oct 14, 2026 at 08:08:43PM -0400, Sasha Levin wrote:
> > An earlier allowlist match can succeed while this second match fails,
> > allowing board 2722/LEN0036 to reach SMBus setup. The parent rejected
> 
> Keeping this one in the queue. The kstrndup() failure only matters on board
> 2722, and only under allocation failure, so c1df7e4e4951 is not needed.

In practice such small allocation will never return failure. 

Thanks.

-- 
Dmitry
