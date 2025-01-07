Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989A01DF725
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736252487; cv=none; b=F1FArFVIoTbm4aorUMDLUG/qb74sMotmov1wC3imonSuOSKXroUSwc2BAFrjw6TE0gCu3++1/OZL6OCHc42j1tyMl+i2lLdr7eAVyPMc+db8YCXUyiCJSvN0mIYd6iomNKCMGEEWVshOb1/A+vqWMjJy0nyGBhyFcKCF/R5y+Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736252487; c=relaxed/simple;
	bh=D1Etn3txFhKoQjFizo9oCi0lO+MKHRok+gDKC6yCRaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UAs9U4Ptqbv4h05zVM4j8d8TKrgIVJUob0Fn8JwQTZ7zYdfkkohr46rUJ1g59I8VVJhjHr9EmEHlY0MudpAPTOXrHw+gAY2FkgTEN632Dgr5wKe0JaYRZ7BKd7xNsIJdSZpB2IGrJVrp9sVWHIhiZYU2kcPwgOteYp/W69lzlFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hHtGw6c2; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHtGw6c2"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2efb17478adso22328879a91.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 04:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736252484; x=1736857284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMk5FvMugOn4M96ewqgpsWQainnISa9eVMfptWei7UY=;
        b=hHtGw6c2M9sO3DFNw0eeQRRg5PVSDlbzTF3rexGOoUkrjt47eTR4j3viOvi9MavS//
         9492RwrUUtqt9AjnGzCaPQ/gxGC812sxVJm4dPr4YWSZD/Q1RXESLN8KpSv2amV/U9Tt
         D4HXblWvCVQBXMaS2Dvf5T/mx23HHt54DxQIY5HTdhGlyF1bCWbWKni8YVm2RUf3A7iI
         s3sKKjUtTyCpLOQPuA2cPZUq4W1VHSkttKu2hG5/Mh81RZK2oPCm9OQZ+AXQbALQUBbC
         vC5kJ/aixfMonpFHv7bCTU0xPVeJkqs53DsI4eJfRdUzkLvfIcuwbB+Flr8ye95CQAeE
         dAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736252484; x=1736857284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kMk5FvMugOn4M96ewqgpsWQainnISa9eVMfptWei7UY=;
        b=A2VbzT9QeOpOxowkajR5FiKvOpIxCC+dDZ48oyD3rR/aeu7Y654A9osAFQ99Kga3gK
         eYxxeJTmNjUFBDP+ogoVX2dlxofOcPGr/Kx4sQwWy4D8CmiTxXlo5qyO3d5J+gwDoS26
         P52rzaVbbUTTAGCfqjSHGeHF3+qKoa1p8efLN3aiAA6s/06x0IeX2duv2PCJjEcoGY3b
         6YfcJKh/oi5aKZt6cPEdW10I6Yy/p9aDfLZL4PkhcRhgCgAsaVpO1Lce2rr7AXTqVA5E
         tvLntxBsm9TngvxoA/S5rIypKR/AJ8EVdeuN+l69ipd0zlMoLfW5b5PculqtFAxz6AsC
         PH1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVh4JEj946UGmIH7sGunLOAJUpNaoocQtz/nUwRaRBh8UkdWyBrzXI2CFvmMNAYI/zLoHzBoPf9@lists.linux.dev
X-Gm-Message-State: AOJu0YyWxm6d12Zk8OES1p6tuoByJo8ddleZ+Vt7PuCspbe/f7AyioO4
	fd0rWqy8PlPOD3x24WOvBz7QnJjXkzkMp89QEDEhwFhWJjUhdD+J57lCw1RhagHSlqtBfVeXJA9
	VqU8ko3WZAJvxJWAOXGzxC3H3S7k=
X-Gm-Gg: ASbGncsWhL4kAS/y0Yezcv4rP2eH/oi654ymP8izbRCIQizJQQrnVtkLEybMHpa7x3v
	BYAbqniehxZKbrExutfn01VIEWB/DS7pPiPA+1g==
X-Google-Smtp-Source: AGHT+IF/oo8IEKv/OpOv7Nts3WwiuFWPiAadrA9W8YOOQSaDPIVl9tifEfOEYCOU9txhDO7q88i/wtHWiiqZWz6vIyU=
X-Received: by 2002:a17:90b:534b:b0:2ee:c91a:acf7 with SMTP id
 98e67ed59e1d1-2f452dfccdcmr91045475a91.4.1736252483836; Tue, 07 Jan 2025
 04:21:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org> <20250106151155.069105214@linuxfoundation.org>
In-Reply-To: <20250106151155.069105214@linuxfoundation.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 7 Jan 2025 13:21:12 +0100
Message-ID: <CAOi1vP9_s3oW8XP6bytvKm3JocPO0-odkv9LQFuuEU==JBgfaw@mail.gmail.com>
Subject: Re: [PATCH 6.6 118/222] ceph: print cluster fsid and client global_id
 in all debug logs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Xiubo Li <xiubli@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Milind Changire <mchangir@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 4:28=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Xiubo Li <xiubli@redhat.com>
>
> [ Upstream commit 38d46409c4639a1d659ebfa70e27a8bed6b8ee1d ]
>
> Multiple CephFS mounts on a host is increasingly common so
> disambiguating messages like this is necessary and will make it easier
> to debug issues.
>
> At the same this will improve the debug logs to make them easier to
> troubleshooting issues, such as print the ino# instead only printing
> the memory addresses of the corresponding inodes and print the dentry
> names instead of the corresponding memory addresses for the dentry,etc.
>
> Link: https://tracker.ceph.com/issues/61590
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> Reviewed-by: Milind Changire <mchangir@redhat.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Stable-dep-of: 550f7ca98ee0 ("ceph: give up on paths longer than PATH_MAX=
")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ceph/acl.c        |   6 +-
>  fs/ceph/addr.c       | 279 +++++++++--------
>  fs/ceph/caps.c       | 710 +++++++++++++++++++++++++------------------
>  fs/ceph/crypto.c     |  39 ++-
>  fs/ceph/debugfs.c    |   6 +-
>  fs/ceph/dir.c        | 218 +++++++------
>  fs/ceph/export.c     |  39 +--
>  fs/ceph/file.c       | 245 ++++++++-------
>  fs/ceph/inode.c      | 485 ++++++++++++++++-------------
>  fs/ceph/ioctl.c      |  13 +-
>  fs/ceph/locks.c      |  57 ++--
>  fs/ceph/mds_client.c | 558 +++++++++++++++++++---------------
>  fs/ceph/mdsmap.c     |  24 +-
>  fs/ceph/metric.c     |   5 +-
>  fs/ceph/quota.c      |  29 +-
>  fs/ceph/snap.c       | 174 ++++++-----
>  fs/ceph/super.c      |  70 +++--
>  fs/ceph/super.h      |   6 +
>  fs/ceph/xattr.c      |  96 +++---
>  19 files changed, 1747 insertions(+), 1312 deletions(-)

Hi Greg,

This is a huge patch, albeit mostly mechanical.  Commit 550f7ca98ee0
("ceph: give up on paths longer than PATH_MAX") for which this patch is
a dependency just removes the affected log message, so it could be
backported with a trivial conflict resolution instead of taking in
5c5f0d2b5f92 ("libceph: add doutc and *_client debug macros support")
and 38d46409c463 ("ceph: print cluster fsid and client global_id in all
debug logs") to arrange for a "clean" backport.

Were these cherry picks done in an automated fashion by a tool that
tries to identify and pull prerequisite patches based on "git blame"
output?  The result appears to go against the rules laid out in
Documentation/process/stable-kernel-rules.rst (particularly the limit
on the number of lines), so I wanted to clarify the expected workflow
of the stable team in this area.  Are "clean" backports considered to
justify additional prerequisite patches of this size even when the
conflict resolution is "take ours" or otherwise trivial?

Thanks,

                Ilya
