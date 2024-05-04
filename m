Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380871755C
	for <patches@lists.linux.dev>; Sat,  4 May 2024 08:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714811449; cv=none; b=q0K1g8UJ5QIqDmIfQrWjgFmPlIIkeXNgnIwm+wAAxuvxeBhTv1x9x/IEpYKpGT8qStS/Z2upu65D4JD/UDD16tgfwvXx91hzbaixDdNB/JOw9f0V9h+zCCEjUEX2gO5V6KnW4kOou8re3u1xI6Z3rbjrjUnkXEbrEciOwZW5vLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714811449; c=relaxed/simple;
	bh=8X0TQiqFoq7AhP7+zJ1x2c++gXuj9VNx8CmbHEQiDuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBH3LqHkweWRc0ytaAoWJaq+LRN7hSuRDAyFcnV5xFetwIhJnQFiWCmIxO/+ZPv2toD707DflPDAmEqfNlxHZLl0BTxxvT++k9BRJ7ZkY+uTb4YGj5IEbIxMG7oul+02xY/qTf3Bq6B+l0p592/7YkpNs0ZH6O5Qiu2cnfYjMbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=33dmtmDl; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="33dmtmDl"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-43989e6ca42so139981cf.0
        for <patches@lists.linux.dev>; Sat, 04 May 2024 01:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714811446; x=1715416246; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dto0aKkQijx2iIkLFZoIowCY0Fuk6th2aZZv6i+dLeM=;
        b=33dmtmDlIl3kLZwIb4l6KwNwxwH2zEnjUeMwhPqX2X5Af12hPRW6mjIRBRzfNarHee
         CnMLpkyr3WD6uDhXNLYZKLSHwAx47/6gvqBOsYo45qHj/AQ2VCHoNlH0SYGE7pa9X3O5
         LamAh8NIjVOwaWnpYOTuFSx2QWMpWVckvYsSKrShfOqqUXqS0WAVz019vgI/AeKW5OHz
         OlUaUQwPeBCuSi5cy0u4Ou2lgBfyJL8gprLWbYbvSRNNbcVZb5/lrXYK8N2ddsi9PLnr
         KLo9JvgPRR3eHtV8QOPtFQwHHJz/NYuTVO5UmunjKqgcysIqmRwMX4FzOYQAXnXohPrw
         2msA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714811446; x=1715416246;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dto0aKkQijx2iIkLFZoIowCY0Fuk6th2aZZv6i+dLeM=;
        b=VMvXv8T7+UEgjTeqp60+CIj4yx/ssVtahIj4UB7Boyc6x6cUyBD81SpdD21NgUzM8R
         UFlOdTqv1Q3Vs8mPyf8ELf2spf69AumeAxiKHo7A/oFJCk4hZO5YoOJzIMZt3G0M3Mmt
         EQBdg+mkjvz/89Ppw+5BHyi40/tQHgiU1N/NeCqLEWDrVQeBwD07/01mh1sS8HxgfQKP
         aSudxyDxoEMMkv436ZERSMK89KU0TkQ/GRdSSG6pZaG5jJITiV5gtMfeUPoefL71D/54
         E+Z0GskNIM9SfLb+2n16kqfFhg1VH6OcoVSfpphJhvBM7Fbt6SSI/80nmKaBmELD5Eyk
         Om/A==
X-Forwarded-Encrypted: i=1; AJvYcCUG93fZzA3eNKx8WM581xiVfUFlQEjB+hvSWu4P8QMVT+Y5CLAr6U3j3i1ePao9vY2//kvH5viraPzT2kqhySlvXENyDGkiHA==
X-Gm-Message-State: AOJu0YzyU/2qzuCVugXC9sMyc/dDCVcUBI9AtehJjsGvW8CrXBuIeAIC
	fbhBeXi/m3AFqGxtte9bWWmszfOFv5Q7I/YB6puS8qEo2wGAIvpH3BZk6tcOetAvE16Etz1tGVQ
	mCYdyA6AaVD1/vqXRfPakvknEb70MIJiolHFi
X-Google-Smtp-Source: AGHT+IHoD6UrwXDAVfBv2/wStUzfQOUGnc4UOeOSSn/U8Sp4IW3FGsOEWPTR7CJehUA5ddZ7eKwpOiE+4Io+lw6tY6Y=
X-Received: by 2002:ac8:5956:0:b0:43a:c0d8:5a7c with SMTP id
 d75a77b69052e-43d08686971mr1077141cf.5.1714811445759; Sat, 04 May 2024
 01:30:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240422232404.213174-1-sboyd@kernel.org> <20240422232404.213174-6-sboyd@kernel.org>
 <CABVgOSk=jGzj55v+YWzOBCsG7Wdk68pyZr0VdAYftybv+5X67A@mail.gmail.com> <431171223433496db0a85072be5c83ba.sboyd@kernel.org>
In-Reply-To: <431171223433496db0a85072be5c83ba.sboyd@kernel.org>
From: David Gow <davidgow@google.com>
Date: Sat, 4 May 2024 16:30:34 +0800
Message-ID: <CABVgOS=+SnMN6qG4DWRXjbHZB_87nsZdfOmPVv8yHTpCqozkWA@mail.gmail.com>
Subject: Re: [PATCH v4 05/10] platform: Add test managed platform_device/driver
 APIs
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Brendan Higgins <brendan.higgins@linux.dev>, 
	Rae Moar <rmoar@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>, 
	Saravana Kannan <saravanak@google.com>, Daniel Latypov <dlatypov@google.com>, 
	Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Maxime Ripard <maxime@cerno.tech>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000001fcba106179ca772"

--0000000000001fcba106179ca772
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 May 2024 at 09:04, Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting David Gow (2024-05-01 00:55:46)
> > On Tue, 23 Apr 2024 at 07:24, Stephen Boyd <sboyd@kernel.org> wrote:
> > > diff --git a/Documentation/dev-tools/kunit/api/platformdevice.rst b/Documentation/dev-tools/kunit/api/platformdevice.rst
> > > new file mode 100644
> > > index 000000000000..b228fb6558c2
> > > --- /dev/null
> > > +++ b/Documentation/dev-tools/kunit/api/platformdevice.rst
> > > @@ -0,0 +1,10 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +===================
> > > +Platform Device API
> > > +===================
> > > +
> > > +The KUnit platform device API is used to test platform devices.
> > > +
> > > +.. kernel-doc:: drivers/base/test/platform_kunit.c
> > > +   :export:
> > > diff --git a/drivers/base/test/Makefile b/drivers/base/test/Makefile
> > > index e321dfc7e922..740aef267fbe 100644
> > > --- a/drivers/base/test/Makefile
> > > +++ b/drivers/base/test/Makefile
> > > @@ -1,8 +1,11 @@
> > >  # SPDX-License-Identifier: GPL-2.0
> > >  obj-$(CONFIG_TEST_ASYNC_DRIVER_PROBE)  += test_async_driver_probe.o
> > >
> > > +obj-$(CONFIG_KUNIT) += platform_kunit.o
> > > +
> >
> > Do we want this to be part of the kunit.ko module (and hence,
> > probably, under lib/kunit), or to keep this as a separate module.
> > I'm tempted, personally, to treat this as a part of KUnit, and have it
> > be part of the same module. There are a couple of reasons for this:
> > - It's nice to have CONFIG_KUNIT produce only one module. If we want
> > this to be separate, I'd be tempted to put it behind its own kconfig
> > entry.
> > - The name platform_kunit.ko suggests (to me, at least) that this is
> > the test for platform devices, not the implementation of the helper.
>
> I was following *_kunit as "helpers" and *_test as the test. Only
> loosely based on the documentation that mentions to use _test or _kunit
> for test files. Maybe it should have _kunit_helpers postfix?

Yeah, the style guide currently suggests that *_test is the default
for tests, but that _kunit may also be used for tests if _test is
already used for non-KUnit tests:
https://docs.kernel.org/dev-tools/kunit/style.html#test-file-and-module-names

DRM has drm_kunit_helpers, so _kunit_helpers seems like a good suffix
to settle on.

> Following the single module design should I merge the tests for this
> code into kunit-test.c? And do the same sort of thing for clk helpers?
> That sounds like it won't scale very well if everything is in one module.

I don't think it's as important that the tests live in the same
module. It's nice from an ergonomic point-of-view to only have to
modprobe the one thing, but we've already let that ship sail somewhat
with string-stream-test.

Either way, splitting up kunit-test.c is something we'll almost
certainly want to do at some point, and we can always put them into
the same module even if they're different source files if we have to.

>
> Shouldn't the wrapper code for subsystems live in those subsystems like
> drm_kunit_helpers.c does? Maybe the struct device kunit wrappers should
> be moved out to drivers/base/? lib/kunit can stay focused on providing
> pure kunit code then.

I tend to agree that wrapper code for subsystems should live in those
subsystems, especially if the subsystems are relatively self-contained
(i.e., the helpers are used to test that subsystem itself, rather than
exported for other parts of the kernel to use to test interactions
with said subsystem). For 'core' parts of the kernel, I think it makes
it easier to make these obviously part of KUnit (e.g. kunit_kzalloc()
is easier to have within KUnit, rather than as a part of the
allocators).

The struct device wrappers have the problem that they rely on the
kunit_bus being registered, which is currently done when the kunit
module is loaded. So it hooks more deeply into KUnit than is
comfortable to do from drivers/base. So we've treated it as a 'core'
part of the kernel.

Ultimately, it's a grey area, so I can live with this going either
way, depending on the actual helpers, so long as we don't end up with
lots of half-in/half-out helpers, which behave a bit like both. (For
example, at the moment, helpers which live outside lib/kunit are
documented and have headers in the respective subsystems'
directories.)

FWIW, my gut feeling for what's "most consistent" with what we've done
so far is:
1. platform_device helpers should live alongside the current managed
device stuff, which is currently in lib/kunit
2. clk helpers should probably live in clk
3. of/of_overlay sits a bit in the middle, but having thought more
about it, it'd probably lean towards having it be part of 'of', not
'kunit.

But all of this is, to some extent, just bikeshedding, so as long as
we pick somewhere to put them, and don't mix things up too much, I
don't think it matters exactly what side of this fuzzy line they end
up on.

> >
> > I probably can be persuaded otherwise if you've got a strong
> > preference for it to stay as-is, though.
> >
> > > diff --git a/drivers/base/test/platform_kunit.c b/drivers/base/test/platform_kunit.c
> > > new file mode 100644
> > > index 000000000000..54af6db2a6d8
> > > --- /dev/null
> > > +++ b/drivers/base/test/platform_kunit.c
> > > @@ -0,0 +1,174 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Test managed platform driver
> > > + */
> > > +
> > > +#include <linux/device/driver.h>
> > > +#include <linux/platform_device.h>
> > > +
> > > +#include <kunit/platform_device.h>
> > > +#include <kunit/resource.h>
> > > +
> > > +/**
> > > + * platform_device_alloc_kunit() - Allocate a KUnit test managed platform device
> > > + * @test: test context
> > > + * @name: device name of platform device to alloc
> > > + * @id: identifier of platform device to alloc.
> > > + *
> > > + * Allocate a test managed platform device. The device is put when the test completes.
> > > + *
> > > + * Return: Allocated platform device on success, NULL on failure.
> > > + */
> > > +struct platform_device *
> > > +platform_device_alloc_kunit(struct kunit *test, const char *name, int id)
> >
> > I'd prefer, personally, this be named something like
> > kunit_platform_device_alloc(), to match the existing
> > kunit_device_register() functions.
> >
> >
> > > +{
> > > +       struct platform_device *pdev;
> > > +
> > > +       pdev = platform_device_alloc(name, id);
> > > +       if (!pdev)
> > > +               return NULL;
> > > +
> > > +       if (kunit_add_action_or_reset(test, (kunit_action_t *)&platform_device_put, pdev))
> >
> > Alas, casting function pointers to kunit_action_t* breaks CFI. It's
> > worth using a wrapper, which can be created with the
> > KUNIT_DEFINE_ACTION_WRAPPER() macro, e.g.
> >
> > KUNIT_DEFINE_ACTION_WRAPPER(platform_device_put_wrapper,
> > platform_device_put, struct platform_device *);
>
> Thanks. I missed that.
>
> >
> > > +               return NULL;
> > > +
> > > +       return pdev;
> > > +}
> > > +EXPORT_SYMBOL_GPL(platform_device_alloc_kunit);
> > > +
> > > +static void platform_device_add_kunit_exit(struct kunit_resource *res)
> > > +{
> > > +       struct platform_device *pdev = res->data;
> > > +
> > > +       platform_device_unregister(pdev);
> > > +}
> > > +
> > > +static bool
> > > +platform_device_alloc_kunit_match(struct kunit *test,
> > > +                                 struct kunit_resource *res, void *match_data)
> > > +{
> > > +       struct platform_device *pdev = match_data;
> > > +
> > > +       return res->data == pdev;
> > > +}
> > > +
> > > +/**
> > > + * platform_device_add_kunit() - Register a KUnit test managed platform device
> > > + * @test: test context
> > > + * @pdev: platform device to add
> > > + *
> > > + * Register a test managed platform device. The device is unregistered when the
> > > + * test completes.
> > > + *
> > > + * Return: 0 on success, negative errno on failure.
> > > + */
> > > +int platform_device_add_kunit(struct kunit *test, struct platform_device *pdev)
> >
> > As above, I'd lean towards naming this kunit_platform_device_add() for
> > consistency with the other KUnit device helpers.
> >
> > > +{
> > > +       struct kunit_resource *res;
> > > +       int ret;
> > > +
> > > +       ret = platform_device_add(pdev);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       res = kunit_find_resource(test, platform_device_alloc_kunit_match, pdev);
> > > +       if (res) {
> > > +               /*
> > > +                * Transfer the reference count of the platform device if it was
> > > +                * allocated with platform_device_alloc_kunit(). In that case,
> > > +                * calling platform_device_put() leads to reference count
> > > +                * underflow because platform_device_unregister() does it for
> > > +                * us and we call platform_device_unregister() from
> > > +                * platform_device_add_kunit_exit().
> > > +                *
> > > +                * Usually callers transfer the refcount from
> > > +                * platform_device_alloc() to platform_device_add() and simply
> > > +                * call platform_device_unregister() when done, but with kunit
> > > +                * we have to keep this straight by redirecting the free
> > > +                * routine for the resource.
> > > +                */
> > > +               res->free = platform_device_add_kunit_exit;
> > > +               kunit_put_resource(res);
> > > +       } else if (kunit_add_action_or_reset(test,
> > > +                                            (kunit_action_t *)&platform_device_unregister,
> > > +                                            pdev)) {
> >
> > Nit: We don't want to cast directly to kunit_action_t *, as that
> > breaks CFI. Can we use KUNIT_DEFINE_ACTION_WRAPPER()?
> >
> > > +               return -ENOMEM;
> >
> > Nit: This is fine, as kunit_add_action_or_reset() only returns 0 or
> > -ENOMEM at the moment, but it could cause problems down the line if we
> > ever want to return a different error. I don't think that's
> > particularly likely, but it might be nicer to properly propagate the
> > error.
>
> I will propagate the return value.
>
> >
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(platform_device_add_kunit);
> > > +
> > > +/**
> > > + * platform_driver_register_kunit() - Register a KUnit test managed platform driver
> > > + * @test: test context
> > > + * @drv: platform driver to register
> > > + *
> > > + * Register a test managed platform driver. This allows callers to embed the
> > > + * @drv in a container structure and use container_of() in the probe function
> > > + * to pass information to KUnit tests. It can be assumed that the driver has
> > > + * probed when this function returns.
> > > + *
> > > + * Example
> > > + *
> > > + * .. code-block:: c
> > > + *
> > > + *     struct kunit_test_context {
> > > + *             struct platform_driver pdrv;
> > > + *             const char *data;
> > > + *     };
> > > + *
> > > + *     static inline struct kunit_test_context *
> > > + *     to_test_context(struct platform_device *pdev)
> > > + *     {
> > > + *             return container_of(to_platform_driver(pdev->dev.driver),
> > > + *                                 struct kunit_test_context,
> > > + *                                 pdrv);
> > > + *     }
> > > + *
> > > + *     static int kunit_platform_driver_probe(struct platform_device *pdev)
> > > + *     {
> > > + *             struct kunit_test_context *ctx;
> > > + *
> > > + *             ctx = to_test_context(pdev);
> > > + *             ctx->data = "test data";
> > > + *
> > > + *             return 0;
> > > + *     }
> > > + *
> > > + *     static void kunit_platform_driver_test(struct kunit *test)
> > > + *     {
> > > + *             struct kunit_test_context *ctx;
> > > + *
> > > + *             ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
> > > + *             KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
> > > + *
> > > + *             ctx->pdrv.probe = kunit_platform_driver_probe;
> > > + *             ctx->pdrv.driver.name = "kunit-platform";
> > > + *             ctx->pdrv.driver.owner = THIS_MODULE;
> > > + *
> > > + *             KUNIT_EXPECT_EQ(test, 0, platform_driver_register_kunit(test, &ctx->pdrv));
> > > + *             KUNIT_EXPECT_STREQ(test, ctx->data, "test data");
> > > + *     }
> > > + *
> > > + * Return: 0 on success, negative errno on failure.
> > > + */
> > > +int platform_driver_register_kunit(struct kunit *test,
> > > +                                  struct platform_driver *drv)
> >
> > As above, I'd prefer kunit_platform_driver_register()
> >
> > > +{
> > > +       int ret;
> > > +
> > > +       ret = platform_driver_register(drv);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       /*
> > > +        * Wait for the driver to probe (or at least flush out of the deferred
> > > +        * workqueue)
> > > +        */
> > > +       wait_for_device_probe();
> >
> > Personally, I don't mind if this wrapper waits here (even if it makes
> > it less of a 'pure' wrapper), so long as we document it. Can you think
> > of any cases where we explicitly want _not_ to wait in a test?
> >
>
> I don't like it because it's not deterministic. The function doesn't
> take any struct device to wait for. I've already written the code to use
> a completion, and it works well enough so I'll just do that. Then we
> don't have to worry if this API goes away, or that it doesn't actually
> determine if the driver has probed the device.

Sounds good!

Cheers,
-- David

--0000000000001fcba106179ca772
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPqgYJKoZIhvcNAQcCoIIPmzCCD5cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg0EMIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
LmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5n
bG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEANyYcO+9JZYyqQt41
TMwvFWAw3vLoLOQIfIn48/yea/ekOcParTb0mbhsvVSZ6sGn+txYAZb33wIb1f4wK4xQ7+RUYBfI
TuTPL7olF9hDpojC2F6Eu8nuEf1XD9qNI8zFd4kfjg4rb+AME0L81WaCL/WhP2kDCnRU4jm6TryB
CHhZqtxkIvXGPGHjwJJazJBnX5NayIce4fGuUEJ7HkuCthVZ3Rws0UyHSAXesT/0tXATND4mNr1X
El6adiSQy619ybVERnRi5aDe1PTwE+qNiotEEaeujz1a/+yYaaTY+k+qJcVxi7tbyQ0hi0UB3myM
A/z2HmGEwO8hx7hDjKmKbDCCA18wggJHoAMCAQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUA
MEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9vdCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWdu
MRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEg
MB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzAR
BgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4
Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0EXyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuu
l9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+JJ5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJ
pij2aTv2y8gokeWdimFXN6x0FNx04Druci8unPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh
6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTvriBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti
+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5NUPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEA
S0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigHM8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9u
bG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmUY/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaM
ld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88
q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcya5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/f
hO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/XzCCBOMwggPLoAMCAQICEAFsPHWl8lqMEwx3lAnp
ufYwDQYJKoZIhvcNAQELBQAwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01JTUUgQ0EgMjAyMDAeFw0yNDA1MDIx
NjM4MDFaFw0yNDEwMjkxNjM4MDFaMCQxIjAgBgkqhkiG9w0BCQEWE2RhdmlkZ293QGdvb2dsZS5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCTXdIWMQF7nbbIaTKZYFFHPZMXJQ+E
UPQgWZ3nEBBk6iSB8aSPiMSq7EAFTQAaoNLZJ8JaIwthCo8I9CKIlhJBTkOZP5uZHraqCDWArgBu
hkcnmzIClwKn7WKRE93IX7Y2S2L8/zs7VKX4KiiFMj24sZ+8PkN81zaSPcxzjWm9VavFSeMzZ8oA
BCXfAl7p6TBuxYDS1gTpiU/0WFmWWAyhEIF3xXcjLSbem0317PyiGmHck1IVTz+lQNTO/fdM5IHR
zrtRFI2hj4BxDQtViyXYHGTn3VsLP3mVeYwqn5IuIXRSLUBL5lm2+6h5/S/Wt99gwQOw+mk0d9bC
weJCltovAgMBAAGjggHfMIIB2zAeBgNVHREEFzAVgRNkYXZpZGdvd0Bnb29nbGUuY29tMA4GA1Ud
DwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFDNpU2Nt
JEfDtvHU6wy3MSBE3/TrMFcGA1UdIARQME4wCQYHZ4EMAQUBATBBBgkrBgEEAaAyASgwNDAyBggr
BgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/
BAIwADCBmgYIKwYBBQUHAQEEgY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNp
Z24uY29tL2NhL2dzYXRsYXNyM3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgw
FoAUfMwKaNei6x4schvRzV2Vb4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9i
YWxzaWduLmNvbS9jYS9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEB
AGwXYwvLVjByVooZ+uKzQVW2nnClCIizd0jfARuMRTPNAWI2uOBSKoR0T6XWsGsVvX1vBF0FA+a9
DQOd8GYqzEaKOiHDIjq/o455YXkiKhPpxDSIM+7st/OZnlkRbgAyq4rAhAjbZlceKp+1vj0wIvCa
4evQZvJNnJvTb4Vcnqf4Xg2Pl57hSUAgejWvIGAxfiAKG8Zk09I9DNd84hucIS2UIgoRGGWw3eIg
GQs0EfiilyTgsH8iMOPqUJ1h4oX9z1FpaiJzfxcvcGG46SCieSFP0USs9aMl7GeERue37kBf14Pd
kOYIfx09Pcv/N6lHV6kXlzG0xeUuV3RxtLtszQgxggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIz
IFNNSU1FIENBIDIwMjACEAFsPHWl8lqMEwx3lAnpufYwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZI
hvcNAQkEMSIEIEdB/LFzsNFKNeMTvsfijDLjGcHYDseL5eHwCfdvLH43MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDUwNDA4MzA0NlowaQYJKoZIhvcNAQkPMVww
WjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkq
hkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCLW7GF
qT+yiMKea76vi66ZsXKu/KVvY+JWUV4Cf46rffrp0Y2yIq48NiR2v6npwLGcSQIG9QmWaUS9aqj0
GxqMvd4uxyeYqRhlU0dUXWgp2jG+rI++dO/sUTeU55QLAG+FSyjaYk0MbuX4fFO3bRjReRlfefZW
GjStHKE+hVMo/MIAONzrbbwODQZKMRD8d2L30/34DcVPkmiX7ky10SPcD6AiFMP/OT3JD1hWDnB/
7VHbKrKSMVSuvwk2zwU01M15YPJj5+qNwMB8O/IwaUDrGGiRYNBFrQfdyxEfD2Yp98NayyNKxS8d
8LpWzE8V73PAVvhOjPWgpuTeV8EFsLkd
--0000000000001fcba106179ca772--
