Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370A43D891F;
	Wed, 16 Sep 2026 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549290; cv=none; b=Dqkp83W/RMdKPa26Q4H4c/VBtojl9pBa6qcew5VchP3l1FTJ2W/oiJJ+u8/OKp19q/0J5LhNJlFcHRQr7WNwAe+b+1wxCmkUUN2cVF6EUXKgNRP+AzePikfJQQo6fwg4iXRs7W2QK/tD6gPq90nOAs+c145u2lwc3H91pqXT6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549290; c=relaxed/simple;
	bh=3Kgpp3jeNMGrHGtvrboKvHK8zETxYPGp8c+hppKVrlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xealjpe81hf8tgMCfaPPDe3iDMbAHY8vnRaDxEBGgAWbjAULC6ZbcPftIfvZf+O8mj6ooQwrWJUtG2YBA1Aiw86OBd5UkcFHC/UGQTjMlPwjQBMmg2qB3P3XCjnKM3vYtRz6iKZHG+7Hvbb9FkIMmJyslcXudlxg827EpQziLsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/XkZX5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/XkZX5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8BD1F000FF;
	Wed, 16 Sep 2026 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789549270;
	bh=42Yr16bbbojPEFMNAdduJF1oX0SI/bS31gqMhMqLv2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I/XkZX5iRbfxsmOT1GtTcH1cLKOCKQ7lIYRfEpVBZofGL1BeB8RK2rv06tE51ffGn
	 ow5HrIFX2kVUYJ9m7NI5RMNKp9eXSsaPjKdQRT+VFlVptsAHQX8whRINJY63b0Ylmk
	 n1ZjG6AoZPaeXm6klb7Hg1IxKF0tMljVcz7XLkJA=
Date: Wed, 16 Sep 2026 09:59:16 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 1160/1376] hwmon: (emc1403) Rely on subsystem locking
Message-ID: <2026091653-clamp-rewash-6e3c@gregkh>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065633.406209587@linuxfoundation.org>
 <9e6e50aa-4ddb-408e-b138-c829af813bcb@oracle.com>
 <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>

On Wed, Sep 16, 2026 at 01:50:25AM -0700, Guenter Roeck wrote:
> On 9/16/26 01:38, Harshit Mogalapalli wrote:
> > 
> > 
> > On 12/09/26 12:29 pm, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > [ Upstream commit 61e9b50ffa2390a2927051d335b2ba04b8f791ce ]
> > > 
> > > Attribute access is now serialized in the hardware monitoring core,
> > > so locking in the driver code is no longer necessary. Drop it.
> > > 
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > Stable-dep-of: 75f2c0b36907 ("hwmon: (emc1403) Drop hysteresis for low limit temperature")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Hi Greg/Sasha,
> > 
> > I ran an AI-assisted backport review, and I have verified the report. It
> > looks valid to me.
> > 
> > Upstream hwmon core after 3ad2a7b9b15d:
> > 
> >      struct mutex lock;
> >      guard(mutex)(&hwdev->lock);
> >      ret = hattr->ops->read(dev, hattr->type, hattr->attr,
> >                             hattr->index, &val);
> > 
> > Downstream 6.12.y hwmon core:
> > 
> >      ret = hattr->ops->read(dev, hattr->type, hattr->attr,
> >                             hattr->index, &val);
> > 
> > The downstream core invokes the complete callback without its own lock.
> > 
> > The patch removes the EMC1403 mutex on the premise that hwmon core
> > serializes callbacks. This 6.12 hwmon core has no such mutex and invokes
> > read and write operations unlocked. Regmap locking covers only each
> > individual transfer, not the driver's multi-read or multi-write
> > transactions, so concurrent callbacks can interleave threshold and
> > temperature operations.
> > 
> > I think 6.12.y misses 3ad2a7b9b15d5072139a20be84adb36776eb6c9b, "hwmon:
> > Serialize accesses in hwmon core".
> > 
> Guess I didn't pay close enough attention. Neither this patch nor similar patches
> nor 3ad2a7b9b15d507 were bug fixes and should not be / have been backported,
> not even as prerequisites of other patches.
> 
> I think we are at a point where the automatic backports are way too aggressive.
> Greg, please stop autoselecting hwmon and watchdog patches for backports, and
> only pick patches with explicit Cc: stable going forward.

Not a problem, here's the patch I've applied to our stable-queue.git:


diff --git a/ignore_list b/ignore_list
index afe9bbf8496a..8f5277539965 100644
--- a/ignore_list
+++ b/ignore_list
@@ -46,3 +46,7 @@ drivers/input/*
 # nolibc
 tools/include/nolibc/*
 tools/testing/selftests/nolibc/*
+
+# hwmon and watchdog
+drivers/hwmon/*
+drivers/watchdog/*
