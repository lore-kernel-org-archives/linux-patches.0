Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203601B85DA
	for <patches@lists.linux.dev>; Tue, 24 Sep 2024 02:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727145192; cv=none; b=Me2i+dyGlgCBzDOHJ8c1ZNEt0XhyyC57T3FYDELD95asjYFjh5Z6kJasLT0XeIR5dkZNFsRubd6nlU2TbGq+VKyWZxcBlciBWjV95MM7UY7cMg+FnIl3bEvb80vOYRJ4fiy2L7R+NnNzrnGfp+gs4splxNLfrqc2cphpeXbDJDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727145192; c=relaxed/simple;
	bh=fSWKpyrDtbfGlcyDOCQAati8/wwNmKaz4bBmsWzvIl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7iW+2zDKXkYGlZhxpAzuaF7L7qSBKBNMQMCBn4e5NCcYE2L7jRy1QfCfTvsbl6WoAJn+dO6SX40vq3y6BQtv5J+RXL+jBlGQ1O+Aq7+o3fNkTAKZgniMRHEg6dSJaHXPXBE45wphgCzOPaEYzA6+HHGI+Vg5x8pI9/V3viBR7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HC/i5l95; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HC/i5l95"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7193010d386so4056257b3a.1
        for <patches@lists.linux.dev>; Mon, 23 Sep 2024 19:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727145190; x=1727749990; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9sz24t9DaFcJ/J9khgquQwJaacywf5cMp9UGIeKwXsA=;
        b=HC/i5l95g21wqqXQM+ISda+DVuAqRJofbU/k29Y8sxyXSib8oY082LVbQN0zkTH788
         eVrprfPVIFx2BvqOGMUkUlzgitlEhDyH0jMG8xPbDlr0jUtYvSXqWg3klRo5HbqZQ2Rf
         NE+cKozpKQssD2GKy6N9IKu+2oRJg/Q/wDZIfDmWiSn5KL7BNtjk6E+vd6Rh5o+7/3ac
         OPNPOWkt4kAE0vhA9rWbzXVGO+HNPXiFX3D2f95Q6ZLHX9wsCGvDNK9UjMGlki9ge4iv
         iXcaaBh/ZaTicT82cI+XVmEwkuXskwTgjAFDdu2kFcZjPwwzg+356ixB1qj1Ql7/+f5z
         yvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727145190; x=1727749990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9sz24t9DaFcJ/J9khgquQwJaacywf5cMp9UGIeKwXsA=;
        b=lDxQj2y+ggPHvmsMoKntJUkt1zBh+4SmHL/SCuPdBxjN8uU/Cg93y3R+IIG6lrC3nC
         yLR7KgXu8FMDMNX7hkomzuSvxpkzNZKzOn+eDFZlOTp8cT5ll5ndJaMOM4THmC1pUihh
         W9kVBtbQP6NA2l8S6Bs3Ve2KbTNpB4mzJ+qKIkPNv6NQ6eJ1Jpyqu0ZoLKuZcSpePjhN
         ZOdeS1w1GBpyfguujoPiKoEGfIbStZ6e35a1X+VxeQegX5qJ7S1Wp+1hb8TM23d6hGtt
         9TD05uHJ1vPD6tZIwIhBtCGNTcGScSj/ITTOrK963VEf0yULpaAVZZOho2NPi7Lul6pX
         2qLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGxl6krVu781+1fSX2WgxTWLsZlCJPjbpuBd973W7dSAsU65Pnjwe5cL6gHrD3OKr+/KOc2tYO@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2dnVi2wP/RgsW7CsS+KYMvAxgdzMuOvb4F+gMBGDllWpCRtDG
	b3jsu3X4zgA1D4z0huOI8VsPTUlo00b3EIWD0e454ZMQbAUsbWDK
X-Google-Smtp-Source: AGHT+IFff0oxYvwZTNJKVB9E1Su/vyAp8+fLbEvC4GJfDf6oLpmBS0eQHCHQefYBbC/olvp27zHs1A==
X-Received: by 2002:a05:6a00:18a8:b0:717:87d6:fdd2 with SMTP id d2e1a72fcca58-7199c9392a8mr21643938b3a.4.1727145190308;
        Mon, 23 Sep 2024 19:33:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6b7c3f161sm214194a12.27.2024.09.23.19.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 19:33:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Sep 2024 19:33:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev, kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Daniel Latypov <dlatypov@google.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH v8 5/8] platform: Add test managed platform_device/driver
 APIs
Message-ID: <1ccfca2b-5f17-4f1e-92ae-1426c6d2352f@roeck-us.net>
References: <20240718210513.3801024-1-sboyd@kernel.org>
 <20240718210513.3801024-6-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718210513.3801024-6-sboyd@kernel.org>

On Thu, Jul 18, 2024 at 02:05:04PM -0700, Stephen Boyd wrote:
> Introduce KUnit resource wrappers around platform_driver_register(),
> platform_device_alloc(), and platform_device_add() so that test authors
> can register platform drivers/devices from their tests and have the
> drivers/devices automatically be unregistered when the test is done.
> 
> This makes test setup code simpler when a platform driver or platform
> device is needed. Add a few test cases at the same time to make sure the
> APIs work as intended.
> 
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Reviewed-by: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

This patch adds another intentional warning traceback seen whenever
CONFIG_KUNIT_TEST is enabled.

sysfs: cannot create duplicate filename '/devices/platform/kunit-platform-add-2'
CPU: 0 UID: 0 PID: 421 Comm: kunit_try_catch Tainted: G                 N 6.11.0-mac-09967-g2ece55614b92 #1
Tainted: [N]=TEST
Stack from 015a9de0:
        015a9de0 006168ac 006168ac 0158c000 026e8ea0 00c4a6b8 004bbe32 006168ac
        00166cd4 005fa210 0158c000 026e8ea0 ffffffef 00c4a6b8 0067a18c 00166dc0
        00c4a6b8 026e8ea0 01a6ac0e 006cb3c8 01a6ac0a 006cb3c8 00000000 00000000
        0049b6de 01a6ac0a 00000000 01a6ac0a 00000000 006cb3c8 01a6ac0a 006cb3c8
        01a6ac0a 015a9e78 0049b8b4 01a6ac0a 01a6ac00 01a6ac0a 0001bbfa 00321592
        01a6ac0a 006cb3c8 00000000 01a6ac00 00000000 0067a18c 0002d21c 00000000
Call Trace: [<004bbe32>] dump_stack+0xc/0x10
 [<00166cd4>] sysfs_warn_dup+0x52/0x64
 [<00166dc0>] sysfs_create_dir_ns+0x9a/0xac
 [<0049b6de>] kobject_add_internal+0xdc/0x238
 [<0049b8b4>] kobject_add+0x7a/0x7e
 [<0001bbfa>] insert_resource+0x0/0x1a
 [<00321592>] device_add+0x104/0x588
 [<0002d21c>] list_del_init+0x0/0x2a
 [<0001bbfa>] insert_resource+0x0/0x1a
 [<00326358>] platform_device_add+0x58/0x180
 [<00326378>] platform_device_add+0x78/0x180
 [<00273234>] IS_ERR_OR_NULL+0x0/0x1c
 [<00270c58>] kunit_platform_device_add+0x14/0x118
 [<0002d21c>] list_del_init+0x0/0x2a
 [<00270c44>] kunit_platform_device_add+0x0/0x118
 [<00273234>] IS_ERR_OR_NULL+0x0/0x1c
 [<002733de>] kunit_platform_device_add_twice_fails_test+0x118/0x170
 [<00050e44>] ktime_get_ts64+0x0/0xd8
 [<00050e44>] ktime_get_ts64+0x0/0xd8
 [<004b04d0>] memset+0x0/0x8c
 [<0026cc3e>] kunit_try_run_case+0xa0/0x176
 [<0002d21c>] list_del_init+0x0/0x2a
 [<0002cfaa>] kthread_exit+0x0/0x14
 [<0026e3d0>] kunit_generic_run_threadfn_adapter+0x0/0x2a
 [<0026e3e6>] kunit_generic_run_threadfn_adapter+0x16/0x2a
 [<0002d2d6>] kthread+0x90/0x9a
 [<0002d246>] kthread+0x0/0x9a
 [<0000252c>] ret_from_kernel_thread+0xc/0x14
kobject: kobject_add_internal failed for kunit-platform-add-2 with -EEXIST, don't try to register things with the same name in the same directory.
    # kunit_platform_device_add_twice_fails_test: pass:1 fail:0 skip:0 total:1
    ok 3 kunit_platform_device_add_twice_fails_test
    # kunit_platform_device_add_cleans_up: pass:1 fail:0 skip:0 total:1
    ok 4 kunit_platform_device_add_cleans_up
# kunit_platform_device: pass:4 fail:0 skip:0 total:4

I have said several times that my test system can and will not handle
intentional warning backtraces. I strongly believe that it is wrong to
expect that testbed maintainers have to keep track of intentional
backtraces. That means that I now also disabled CONFIG_KUNIT_TEST
in my testbed.

Guenter
