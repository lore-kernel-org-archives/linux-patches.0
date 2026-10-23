Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773949;
	b=QID/YMPgnueK3jGZxDB38BrpYFRxkWwOoUcmKd3dK3DJOBX8TLiA8t8qbNF8+EQwATYj
	 DpsleoBgF5h/pNKqtYwQESIDu0U9YS9l16ydsYspxy1Ona+b6fZHCNVNu5VFNb5zW6Wpr
	 DKU1Ro9fUHmYfSkq8I441gjXUYG2cXqGdX5nZiuUfM9AdHjoDY4NJcVhs5YirYk8eTJdZ
	 1hqYXVPz4Jloc4fFXwCl1LwbftZ4SuiX9kAa5tjgTQ7ZbvneBj+sp8S0d0as9hYtV0fFw
	 UwRf4XTYLugQeyNPdyv6Pzf7uzbb/VpLZFZDNGqolql5qqLD9cUhWl+RbzjPr/VN3Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QbKX+0yuImIs+pGi1XvE8VZhobSujsq+FCT1C1wBDk0=;
	b=GXZEPWu/EBBhJp5Hh9qG5/Ekv6Or5V+MO6ADUFEv/fNWZFNKgE7myfDE0y1LavgptP8m
	 w54vq+bBFlPXDFTwDnfAbokDGHSIZddDzkXGnw52Wpt7EB0+6Jh2fEdTjW6pLNqUhRrT1
	 7frq6euLwBKPG8IOBpmnCdY7SquqbxhD9b6DfxIBKV9ERRjlvaTKoyuo0DJmCBPhK7N34
	 V28aXz1vTo4wjGblLnNmDOp05EM03NjOXLhNG3nubZbEkWadFEwXIQqgYp0SGgw/aAEJ+
	 5x4cexDC3iVnzFNJjD2gxbPgMog4Ie3KCknAWptL5ulA+LFCEz6PTOMm6WY7ygviK4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbH5Et6e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB34606A31A;
	Fri, 23 Oct 2026 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbH5Et6e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622301F01825;
	Fri, 23 Oct 2026 16:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773949;
	bh=QbKX+0yuImIs+pGi1XvE8VZhobSujsq+FCT1C1wBDk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbH5Et6eRgYDmi+YIUs4dFdO0wL/JCCp9RgQvhxFyQBO3ZCX6xGUxU/2drTZBGkjB
	 T/D302zLVHgUa35ZMZk/PL1S3SKifFZCpm2z4wsMMjjANUePFikwyewMaQBDugX/Fr
	 j74926i+oNuoD4NJCgcTjLod5cSFF6mBej6iu7Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH 6.18 071/193] accel/rocket: search every core slot when a core is removed
Date: Fri, 23 Oct 2026 18:35:48 +0200
Message-ID: <20261023163715.883397432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Paunovic <royalnet026@gmail.com>

commit 6eff1d69dae808a1518aee5a58d0853a8db3f1be upstream.

rocket_remove() decrements rdev->num_cores for each core it removes,
while find_core_for_dev() searches slots 0 to num_cores - 1. Unbinding
the cores in the order they were bound therefore loses the last one: by
the time it is removed the search range has already shrunk past its
slot, so find_core_for_dev() returns -1 and rocket_remove() gives up
without doing anything.

num_cores never reaches zero, rocket_device_fini() never runs, and the
file-scoped rdev keeps pointing at a device that is going away. Binding
the cores again starts from that stale count, because rocket_probe()
takes rdev->num_cores as the slot to fill. On an RK3588, which describes
three cores, the second round lands on slots 1, 2 and 3 while rdev->cores
was allocated with room for three:

  rocket fdab0000.npu: Rockchip NPU core 1 version: 1179210309
  rocket fdac0000.npu: Rockchip NPU core 2 version: 1179210309
  rocket fdad0000.npu: Rockchip NPU core 3 version: 1179210309

The write to rdev->cores[3] is past the end of the array.

Nothing in tree reads the core array often enough to notice, so the
overrun is silent today. It turned up while testing a devfreq series on
top of this, where a worker walks every core a few times a second, and
UBSAN caught the first bool it read out of the overrun entry:

  UBSAN: invalid-load in drivers/accel/rocket/rocket_devfreq.c:47:10
  load of value 5 is not a valid value for type '_Bool'
  Workqueue: devfreq_wq devfreq_monitor

Record how many slots were allocated and search all of them. Every core
is then found on removal, num_cores reaches zero, the device is torn down
and a later bind starts from a clean rdev.

This does not make unbinding a single core out of several work. probe
still takes num_cores as the slot to fill, so rebinding one core while
its siblings stay bound would write over a slot that is already in use,
and rocket_open() still reaches for cores[0] whether or not anything is
there. Both of those want more thought than a fix should carry.

Found by unbinding and rebinding all three cores on an Orange Pi 5 Plus.
With this applied, 25 unbind/rebind rounds and 5 module unload/reload
rounds run clean there: the cores land in slots 0, 1 and 2 every time,
whichever order they are bound in, and the shared supply goes back to a
single user after each round.

Fixes: ed98261b4168 ("accel/rocket: Add a new driver for Rockchip's NPU")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Paunovic <royalnet026@gmail.com>
Assisted-by: LLM sparse checkpatch
Tested-by: Jiaxing Hu <gahing@gahingwoo.com> # RK3576, two cores
Tested-by: Sidong Yang <sidong.yang@furiosa.ai> # RK3588, 3 cores
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260904125936.26234-1-royalnet026@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/rocket/rocket_device.c |    2 ++
 drivers/accel/rocket/rocket_device.h |    1 +
 drivers/accel/rocket/rocket_drv.c    |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/accel/rocket/rocket_device.c
+++ b/drivers/accel/rocket/rocket_device.c
@@ -31,6 +31,8 @@ struct rocket_device *rocket_device_init
 		if (of_device_is_available(core_node))
 			num_cores++;
 
+	rdev->max_cores = num_cores;
+
 	rdev->cores = devm_kcalloc(dev, num_cores, sizeof(*rdev->cores), GFP_KERNEL);
 	if (!rdev->cores)
 		return ERR_PTR(-ENOMEM);
--- a/drivers/accel/rocket/rocket_device.h
+++ b/drivers/accel/rocket/rocket_device.h
@@ -19,6 +19,7 @@ struct rocket_device {
 
 	struct rocket_core *cores;
 	unsigned int num_cores;
+	unsigned int max_cores;
 };
 
 struct rocket_device *rocket_device_init(struct platform_device *pdev,
--- a/drivers/accel/rocket/rocket_drv.c
+++ b/drivers/accel/rocket/rocket_drv.c
@@ -225,7 +225,7 @@ static int find_core_for_dev(struct devi
 {
 	struct rocket_device *rdev = dev_get_drvdata(dev);
 
-	for (unsigned int core = 0; core < rdev->num_cores; core++) {
+	for (unsigned int core = 0; core < rdev->max_cores; core++) {
 		if (dev == rdev->cores[core].dev)
 			return core;
 	}


