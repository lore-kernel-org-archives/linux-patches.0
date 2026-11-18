Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058000;
	b=MJwXK6Gbed3AWtTtEEONyUpM22gl8w5ZpO3XH77i0EFkZgxPPaO0qf1yzrfyxqJOFxe0
	 pwDmTjL2j4uPRtAFpmVJ1btromh33zxvOCYsFktJeRbHbqKvEGxk4pZN7xPIeW+035ErX
	 EgYsguzSxCiJ2YJ2/dC9jmeOhqfD/dlH54BgEzz0GRAukWms/DPmMynRHQZQE/YmaSIeb
	 W/dlvBjUf64J1LYI7rHJwLzTKkOM/ke8ytDHm+J5W9sUTDZ4f1NZEjJIfN8NBKqgwE6ZN
	 bDXJCTT4EOkG32dYWndb38F9Z3YN4sgQwGkmHF3XZKhXdkuw7OepdvBZEZ56rmfmamA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3k0a3WLEiGjG/Q6UXCfW+p1AkHH7+3K2jFSKR4D9OiE=;
	b=slsZHFGlEiVGteajaVFv1wQsgm4zJxq7zUnfHFjmr9EGXYS2A5bFEu7hwg9DFl98QSAW
	 FOGWVgYHbSVcc8TV6A80ZuoX7oqP5T7aygaBydm66MbAPnR6YVA6U9V0NxwwfQQzVWl7V
	 3IzKXESYPhdLqsWw3DR64gWL/Fqm2IXI/+6r3rAuFO4tlXHWjXOTGWHitHuyQ+DdRwrRr
	 NU/E0WI2Br64BbX11Q23QCbIRUWdc9t9eLo6MnpE/4KVR8zwFT5jV4NvSqoiU8NP4ySpb
	 uTmRHpjT2LdBR7Btg8d2eZ1/JgugiJInC3UBI9Ga/yn+AE0OCwH85FfxZbiAqiH7YRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n13XOh5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA3606A320;
	Thu, 19 Nov 2026 03:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n13XOh5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D284D1F000C4;
	Thu, 19 Nov 2026 03:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058000;
	bh=3k0a3WLEiGjG/Q6UXCfW+p1AkHH7+3K2jFSKR4D9OiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n13XOh5oUG9jx5HpSupaiYcuAMwexNxJo74o2KSWNOl9+Vn8cmHY7FQxJPN2h33LD
	 IEFc2qjFz3mOPYmJS4SAy3iQeKqxDLe48Ewx42Ew0k5jjQ/mzvm452qztDsHYL1Hhf
	 7viVFsfmcWNYT0BPill0eCbEIL5Wyj5m6iEwzpm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0330/1848] driver core: Limit the messages on a refused uevent
Date: Wed, 18 Nov 2026 15:39:28 +0100
Message-ID: <20261118145926.002523098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a01c8e5b1dff1ce489e6b339139e744db36b8bb3 ]

A write to a "uevent" file which is no valid action makes
kobject_synth_uevent() print a warning and uevent_store() an error every
time.  This is generally considered a bad thing so rate limit these
messages.

Fixes: b0e37c0d8a6a ("net-sysfs: make sure objects belong to container's owner")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/2026102718-conduit-glorious-a8dc@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adjusted context for the existing dev_err() message, which lacked the return code ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c  | 4 +++-
 lib/kobject_uevent.c | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a900bde641491..5bdf76e2c14f0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2032,7 +2032,9 @@ static ssize_t uevent_store(struct device *dev, struct device_attribute *attr,
 	rc = kobject_synth_uevent(&dev->kobj, buf, count);
 
 	if (rc) {
-		dev_err(dev, "uevent: failed to send synthetic uevent\n");
+		dev_err_ratelimited(dev,
+				    "uevent: failed to send synthetic uevent: %d\n",
+				    rc);
 		return rc;
 	}
 
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 38716b2eb671d..99de6689ccc21 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -224,9 +224,9 @@ int kobject_synth_uevent(struct kobject *kobj, const char *buf, size_t count)
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
-- 
2.53.0



