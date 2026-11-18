Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052022;
	b=SfpBcBLZXYNKXqzMZjtLC1KKmsrAWXNdINd70GyT8Oyl9hbgY/FrslsfnMm2Z2BGimVW
	 Q9n0dkD0WOaSUaEJeMfoC/7M9Jj9Ov/X7g53wNv1aPPSlWlKdITFycdkYkMm4XMkQ26GY
	 iZtyjAejhyT6VHWO7nTDGLNhyR7VttR4wyIBsfr7cPXSOWiojDFVye1DYKK9lI19loWVx
	 p6fbYB8/c853cFqJ6PmOT6V8PtWKA24DgHgWAWSN/4TizJIyyvzE7PgWFro54iYH6G1LM
	 uV9YgKi+EgJZKNbTqmuEhCTmpFFhePCekE39iP6s9Uil1udCl0CgX9IH6J5OLJZfz8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4nVmFxePXRe7NdzKArUg7hC9J5+/1nxB0jCtwCQCsg=;
	b=D7bvQia9D/etp0m4Vbc5qkXWN/64mkkoGNPhiKyv/QyQq6oAP4bTUOKTUnmDKjFW2qCr
	 TkKgl1OVfqcy3h4CC6hD/1xrJJ2r9HjhnUtaLCdMp2tF5WU6G9NQRzrVQQgOQu28dERDD
	 i0Df0NP8HyQwVTr54AJlk/+IPi5uszc+TmAHq3AMc6g5xW3HWOXSfEobaVAjlZoEnH9Q/
	 CTGh97h0FaW+3hlWfuzTdEjbA4VnAttGYy7qaG1Wg9/yMhzoidl5ZNiXUSfbwREjn/0IF
	 apYdbDTvqsYMssIeOFHPvCRcGAdyTga7F6FCmxPMH+ySNQclraOUl4w7scoB2YsQsSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2EXB9Qpm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4130A606A32A;
	Thu, 19 Nov 2026 01:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2EXB9Qpm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9848A1F000C5;
	Thu, 19 Nov 2026 01:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052022;
	bh=Y4nVmFxePXRe7NdzKArUg7hC9J5+/1nxB0jCtwCQCsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2EXB9QpmyifjQV1ugKHW2JWrZOE+ALrOIe7eOrMiQABIxIWLclBmtWXwPDdrwJwfT
	 CqATo4TYhI8d3b5tNLl2Tigb/jbXyiJs5QhP9zm+V/Tdsst6JgbGBtYGmp+yz1DDqA
	 nl/PNKjEDnNX1mVdSt2VbzXx/S/sVMy3buU7ALOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0413/2214] driver core: Limit the messages on a refused uevent
Date: Wed, 18 Nov 2026 15:34:49 +0100
Message-ID: <20261118150027.319566663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted uevent_store() context because the existing error message lacked the numeric error code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c  | 4 +++-
 lib/kobject_uevent.c | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d11cf07e1441c..dda2bc47bc81a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2428,7 +2428,9 @@ static ssize_t uevent_store(struct device *dev, struct device_attribute *attr,
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



