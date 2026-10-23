Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774611;
	b=Hu7TWyMXyNJE4LGaC2JsM+TX16LEn/cn0y2QxzkahMOQ21WHS2sb/2exvYxYF4THaFSN
	 EMk/JmwY5XDhhkLbfUsHSV+MUMKfyEia+NNCYl01THEaEOTjfxz/gj/KOEazyvzFvJmTj
	 14yqM2HU6RWxGA0kHVRAyYt0L9aUmnDSfOLgmJg7Zvu9rDuHB5pWKgfJdSwiCj9NQlRvp
	 s9Ho9CpW+sNUulsM/WgRvXVyJblbr1uOoj++FZIt8MIwhc3F8MutVnIq+HQ+hcOwgNECV
	 EIyOeslwGbGFiIY3u3xqg+eiDZCRUuF7F4jrFDYWJReol5J7ZRx0CEboBOhsVdf3Bfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AJBzOA57A6S2cLUx/KbDVHgACH6Vfx0Bo3k4t3fkdB0=;
	b=02jUnoAslpA4rwD6qlutnz+PbVZbA5KfSzhKi0qpgSQOTpXOQ1h/WtbYBCrDlVbglCua
	 PsDzkFCM9NvxtkogofBTUXAkUloTQMPyvAIecpFbgarAd2BbmNVS0lCt6CInMV+fXuAdo
	 ZlnDpBG5WoDyIjkOHr7Ku5GgVoaNznzpIJSIwqrO5O8KnvgX/tLXM9d8YGozjdeaFMIJJ
	 OcMesFrJ1hU+5M/EXEw986scAvLmY/f7UiHZ+pZpiTHgis9moA0UQFIHH1Fqio7KuxomQ
	 sF2AheVCSVA3yhzOCWGyqffSDuNDKPolJC+XD46xoBjWq+/ZoSgaE9psRgr4F7pq2Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpWXFLUf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BAB606A31A;
	Fri, 23 Oct 2026 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpWXFLUf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C101F01829;
	Fri, 23 Oct 2026 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774611;
	bh=AJBzOA57A6S2cLUx/KbDVHgACH6Vfx0Bo3k4t3fkdB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpWXFLUfRXZa5QCUJ7jfwQ7ADZmFNvvoiVw7B270Ix43pPXGkOz06DOPrrHO1JL3l
	 Gbgjbo7VhLPbGY7SVUYeSNeqBvcfgXYyp0Q3ucCKuD9lni6kPeR0q+QSvHgYDzKUoy
	 7wZ1BmL+xyV5ncSsoUlGvuiFZwcJhmkN5lZ4Qvlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH 7.2 100/242] accel/rocket: search every core slot when a core is removed
Date: Fri, 23 Oct 2026 18:39:02 +0200
Message-ID: <20261023163716.145725731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -226,7 +226,7 @@ static int find_core_for_dev(struct devi
 {
 	struct rocket_device *rdev = dev_get_drvdata(dev);
 
-	for (unsigned int core = 0; core < rdev->num_cores; core++) {
+	for (unsigned int core = 0; core < rdev->max_cores; core++) {
 		if (dev == rdev->cores[core].dev)
 			return core;
 	}


