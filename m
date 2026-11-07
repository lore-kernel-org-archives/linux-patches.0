Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061476;
	b=dOzjGcAD7svsUV/u4IxKhoO5JsfYCip1U/tT2Im6P+pEIpCQ33VvNZN8eLrnP+nbATRa
	 ai71dUAjaFnZ8fq7CpDZpjNxC+6mwgjAmyYyv1LDH6z7xtP4WDBR8u1OGbnrZLh//Ky2w
	 E5rKbsa2e45itT0ySmJDfL/Q75YoAnkzmY99zgjAonBShCdAZFH33+vI7enny8d5Rghdo
	 iWGEhwFrAqO2IZSdjST2sYVLtOcwHEResxXK6RuPPJTdnX1DMT9n0WHWbZNCK1KO2/088
	 86oqNKunWLnpTsNrGNFtALhgmfX7U9eJ4n2LmENxn7bmSMPBIoEo0YU1NbpfpF1FtlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C7MFv1NLBO3Y7lU726ElK9wLu8OgqS1H6KM0vLFqSJ0=;
	b=OIH/vdfojC1utWNdo2nCcHJcvRlTSqniW/SxK/1Yk3Nz5W8jsFBiFo1coPcME1561fuK
	 WKp1nhKC6N9mqeLxn5uyTHnjUfyxChYtPeTTF3OZngNSzkN9fmT4+tqrsLZ5t/Kbeizjg
	 AmJVqHI3vMk1qkPRps6eIOBL9gMP1/qzuSdr5apMSxLAOAFhJRASlOsdUYbkoZ5Tacob3
	 ALLi8xoo6LrQ7XQpsh1wNenn6V+n0PfLSYmkkGj7NaxMFBrT1miBP5uP7RD+FNuxATxrP
	 AOECehV+fus8NXL+1mK+pyOPO6KtxoK7NYeR+KOWnlCrW1gJdW1i+AIpXQj2U2nqkgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UiYyCwiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69C606A326;
	Sat,  7 Nov 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UiYyCwiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A8A1F0089F;
	Sat,  7 Nov 2026 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061476;
	bh=C7MFv1NLBO3Y7lU726ElK9wLu8OgqS1H6KM0vLFqSJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiYyCwiBv0mhyQYnn7uKmMenTQf6rT7oM0Y6myX9A2bMHVFayhp/fsQ+YZ9Ph5njU
	 hjoVe+GCITaVMQ402B5Rpt+albO58e9p6QQJ6PZ5reM8PQijqBYBUyM3mJyVaWoUcp
	 bASU3lY+CqwOY89VW/99ptTMJuW8ZTdCtjfTUWTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 0575/1536] driver core: Limit the messages on a refused uevent
Date: Sat,  7 Nov 2026 08:43:11 -0500
Message-ID: <20261107135013.712050367@linuxfoundation.org>
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


