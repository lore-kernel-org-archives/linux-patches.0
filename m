Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044266;
	b=NGbf0dnY9NlWmGqgENxcR1zBExjHDgALz9t3+3NhxjVMuypMIHlKyo3Cc15ZCXnedW3a
	 cElXB3OiPhD7Cj6IZ5+JvDSRPe3Nsk4BeG7aVqTYTG8fsSXQok2tlG+iYMTMkL2khIvl9
	 +6tk7ZT9mMWHazZlZyJxIHN7nkYjaBsxvpq9SCLGMwvZwXVY1mWPlZtuAOJr5xg67Flrq
	 iS9OKi6qYCJkNiEzHND/SRP6IZc8V9VhFRsT4nCZ4rpvkrvKWxWFc7uoMpfxaz8v82h8C
	 MZLrLnRG/VHzGgJV82DGSBAdEi/UY1eaRHPci4kHOGCqoKclEBPBsHZFPJ27jNixy6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bYMMaEybOk8+JW2FmFSDmuzRXz6fwRxdNgNu7mWzK24=;
	b=T6AoYzDLCWIKKha46AoBACICA3ymS6SzTI7T1u/Wh/rYd1CO8JcFnU/muEVv48QHcX82
	 nzpHg2vzAQfpoyph5zdcv5SnwP9ZZH13G5Nb5SiYtX3eJU9a/hY5D/kM5V8Mjd/IqamQa
	 M1YcqVQZUrqGq3OmgP9bju4LFY6Fq7x9fPWlXR7GEqDzkkOTqz5AfdEyupakDDpxGS2Sa
	 mmSDHZxLPEMnZlzlzDwrkXVcc9CsLSZ2cT6UIm8MjU4BRMRhp5ghLs02zS6IyL0gOvxD3
	 ymfK3ujeSWe0zX/vvidcPOavKZgUqHmK+xg79sg0lQTwSpiQJ+zooKGr6HwYqEKXbNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CF9lAKZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912FF606A320;
	Wed, 18 Nov 2026 23:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CF9lAKZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A6D1F000C4;
	Wed, 18 Nov 2026 23:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044266;
	bh=bYMMaEybOk8+JW2FmFSDmuzRXz6fwRxdNgNu7mWzK24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CF9lAKZQpS2Iq6FC+SmfoUPVg8Y7bzpMg990hqsBkMgUcQsZozXSoS0cXUfqClDv/
	 F2TdmRAMfwrqrs1RQaNfqY68grezCBZ0QO10JCp77hBOkwtwrmbHHToX4jnE/0rTFi
	 UWPSppFpjNkzyi/brEA5rryR0r8HrpcK/mMM10zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1 0504/2857] driver core: Limit the messages on a refused uevent
Date: Wed, 18 Nov 2026 15:25:38 +0100
Message-ID: <20261118150219.602763018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit a01c8e5b1dff1ce489e6b339139e744db36b8bb3 upstream.

A write to a "uevent" file which is no valid action makes
kobject_synth_uevent() print a warning and uevent_store() an error every
time.  This is generally considered a bad thing so rate limit these
messages.

Fixes: b0e37c0d8a6a ("net-sysfs: make sure objects belong to container's owner")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/2026102718-conduit-glorious-a8dc@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c  |    4 +++-
 lib/kobject_uevent.c |    6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2690,7 +2690,9 @@ static ssize_t uevent_store(struct devic
 	rc = kobject_synth_uevent(&dev->kobj, buf, count);
 
 	if (rc) {
-		dev_err(dev, "uevent: failed to send synthetic uevent: %d\n", rc);
+		dev_err_ratelimited(dev,
+				    "uevent: failed to send synthetic uevent: %d\n",
+				    rc);
 		return rc;
 	}
 
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -224,9 +224,9 @@ int kobject_synth_uevent(struct kobject
 out:
 	if (r) {
 		devpath = kobject_get_path(kobj, GFP_KERNEL);
-		pr_warn("synth uevent: %s: %s\n",
-		       devpath ?: "unknown device",
-		       msg ?: "failed to send uevent");
+		pr_warn_ratelimited("synth uevent: %s: %s\n",
+				    devpath ?: "unknown device",
+				    msg ?: "failed to send uevent");
 		kfree(devpath);
 	}
 	return r;


