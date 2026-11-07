Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061810;
	b=o3biXNzLhv3fiLcGWdbN9KBvUEdeYCTOYvumQNJ5h/PwubpfiH2F+2zxCQ0P7KN+g25U
	 IsZWFmrztQrjk+xfFr/tG0g7UQbGEhwhGgvkyKgbB3goINnKr9PN6/VIIqC6LOTslo/Ct
	 ezdqCMI/ISfYzCtZ5chnzWrSeJUXUmb8GiMrWKqotBDa5+EDnIs6vmaiaYau65N1b7inG
	 ac+w1pDe1ZEVMkIW8bzzbXXri4+JggsAREcZD/HQ7dBqIAgE0q5Pnih/GvfvMR7EXrXzm
	 /YD5VDtEjT3/vulsjSlSXC9KF4G/ZAmPWuRT4hCnX0qHaYOCu72BgirNmYZhbKOwqPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0kEB1aNmNWY6LbS9bczFHh8/dRc5uB3+okary6eg8M=;
	b=zdnPWOG0jrvdafpfTbiB+qqyChcH69kZ6XlJsQe/7H77wPKSpzPZpIAgNDoTygXXzfAB
	 +MAgjO3B+Ke6qu0L4tXKUSXDd4yaFmXgt+s52ud53Qrk3ixYY6HTjlq97KGLW2iTGnlyF
	 JZhW/sRET+OWIMrYtsdHcZAS9doI3arH8FgQkHuOhp9fihlwMJBwbbN9+JWxqrGnDwk+n
	 qOVwQvfQ4/umYS98wm0+myRQh5NCISEYEtaSTRFh3ZTyxLqgY7fksPVOxF1YesUU0qseZ
	 KcTRIq/ni0tnIcaVos73IZ0JKAmBCrh5StGuhtCzmRA8QzjlpHgQTr3kqFIhKHWDG0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvHn8qlR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3A3606A337;
	Sat,  7 Nov 2026 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvHn8qlR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239271F0089F;
	Sat,  7 Nov 2026 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061810;
	bh=h0kEB1aNmNWY6LbS9bczFHh8/dRc5uB3+okary6eg8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvHn8qlRLCeoJSg0QhyLJ+GJ9WKPpnaUFPKfwtiJe/Rx3S2znWod0IISaKGodI0QN
	 TNQ+IRxxnoYmXWikWHyvODA61u7Qheyw56nckxfUmKdUPwNOyn4GE5zF1SMI/acC8P
	 OvfsQDglswR0Ad7pZKctAq8H/UO86yANzIs7FjFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.12 0837/1536] media: rc: Fix build failure with CONFIG_LIRC disabled
Date: Sat,  7 Nov 2026 08:47:33 -0500
Message-ID: <20261107135021.057298466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 0c795849fd70d6bdb99aea5dd08d9b43128612f6 upstream.

commit 37efd09ba2c6 ("media: rc: Ensure registered is cleared in error
path") broke the build if CONFIG_LIRC was not enabled.

Fixes: 37efd09ba2c6 ("media: rc: Ensure registered is cleared in error path")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202609230511.Em5Osw74-lkp@intel.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    3 +++
 drivers/media/rc/rc-main.c  |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -775,6 +775,9 @@ void lirc_unregister(struct rc_dev *dev)
 	unsigned long flags;
 	struct lirc_fh *fh;
 
+	if (!device_is_registered(&dev->lirc_dev))
+		return;
+
 	dev_dbg(&dev->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		dev->driver_name, MINOR(dev->lirc_dev.devt));
 
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1981,8 +1981,7 @@ out_lirc:
 	scoped_guard(mutex, &dev->lock)
 		dev->registered = false;
 
-	if (device_is_registered(&dev->lirc_dev))
-		lirc_unregister(dev);
+	lirc_unregister(dev);
 	device_del(&dev->dev);
 	/* registered already cleared above */
 	goto out_free_table;


