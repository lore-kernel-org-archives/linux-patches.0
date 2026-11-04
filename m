Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831365;
	b=cpnYF9Zlkz0bVDfnDyIPtcIbg0o0EqZiXbglMcIwKtEWoHENavTiwYNwXreVlDtdUA6h
	 pfFau3hPAD1v3dAp5xg/qH6lspQ3ENlHfY1neSoTep9NMx603v/WdLBk6+JGlzkIc4Yz1
	 N7j92XQDI93B/iCrImxEU4VL0w5jyDjFA2hjDzDEe3F66spFNq7m8xK5QLQPc9XF4QJnG
	 g5b1vP0Po5QN9tsW18iIxI6pIvL53Ch8X7zLfGQkDL+EPSaPcPAdD29d6Ca18KR2T9p+x
	 fl7srgV8+khwk7Z7smveQgluyyshvA1KK2v9uMz/3GjNphxDf5bnUG7ZmeiTzN5gfUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oK4kbO4aYiRIDuCGeK2W146rYjkilP+Rctui3+pbKeI=;
	b=3n9qN5gTwFO0H/IrvtMYeqtAfqPViIaqLj0BBTVaraMRjeGKAcdwu4ArC93EeT0HbZ3O
	 tX3b+f6G5gic6aGOwvgZxpkuteWMX3V3lzLpMU3FLa7qQS/xMbLwuq6AZbG+dRd41MAxK
	 4TxAxHq9IPqKqMzwrzswUu1ieKIjq/J1f6BZhs/9MTvyPUhtGoMwcbGBrxCM/dmlcrzvs
	 BKSOS2dARO8Jml4XUgv1p6aBIQEFNKMM7GnypaJ7+V5UU9T6KRS8MjoNSiKFzz2vwJodE
	 He7K29/UMqpxDVvLLXUObYEMPZu70NrzmPksm+5Gg+I/J8VBKZEHc5tuHnpMxdd7Zyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eldYHz+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE8606A332;
	Wed,  4 Nov 2026 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eldYHz+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572B61F000C1;
	Wed,  4 Nov 2026 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831364;
	bh=oK4kbO4aYiRIDuCGeK2W146rYjkilP+Rctui3+pbKeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eldYHz+E4rIqvTTVco7TnCmB/Rb1nvtVlCLAWEHMcCQiZlTWIRzpRY67/yaN50sgt
	 68a9+fJDQQpz/B6/Yq02Re2sYmKeJVLbpi+nSa1BRH4PXsgJ8n4HOHZEqzh4AUY1TH
	 Ge4kzmXp2sEfn0zpRiXz+4r5SomOD+g6RJ+s8aeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 0633/1005] driver core: Limit the messages on a refused uevent
Date: Wed,  4 Nov 2026 16:06:06 -0500
Message-ID: <20261104211101.511194606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -2840,7 +2840,9 @@ static ssize_t uevent_store(struct devic
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
@@ -223,9 +223,9 @@ int kobject_synth_uevent(struct kobject
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


