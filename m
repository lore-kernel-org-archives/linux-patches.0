Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034974;
	b=FwOtN4Tt3jCXC49qal5LU+GiHx0TC2pwJ4Oocgd92GzhHHwbs5t9MqeSwtbxglp63eiY
	 rlZUqXd2R0WXCqZEaD43IkPlbo1gS1HaYdOpyDnecPYivaxT1VBMZYpkBJ5A6BSdfro77
	 zQuB6zM+zBwKieG/nH84IniOw1Z8UPw/Eb0U8gpKisyU4oJ7iPlqkYZU07BPt5w9R+xFK
	 5OqFMdr9kIbrCcnWZriFQHg5/ZH6khk/NVzf/6k7iEkZCCUy0fT+dnB+4wBx18xTpEM8/
	 rawj88Ix9+rfZ6H9N4wA3VUl2P0iONux59XCy2OTscNElwRNf3iFiV0P3ZY/plqNchg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pnh4wJEMGXSld+VGkxUX1ysQ25mE4U4JmEmXeFxINA4=;
	b=oUZC4fVI4tipsPvr3vnLABNAjPLZTt8tNrau2f6ZRYpn1bUQHxHur3fSaX3cxPe/cn0I
	 nNSKKkGWt5IEUSzI7+U/UxqabeOl6qszYsRnJxPbZcjbL1+zhUYFfWWP29yTl1yAx3clE
	 rHVPAshpYl1B2HgSW3jrywA/3DEdrx9QFnlxx7PETzTOJAcDACFXhLEg2YEnnb4QPsW5J
	 NBqXSFzKx3s1G8glUc/4qgN2zrdEFqhfbaeAOdXLrFo0TUHgfa1Br5fcwPe2qalOcX4Qh
	 l5OSydMKb0HmfRVdz2RdV0yIdOTZSaif8pzWEyYKWETBlpfRDAL1fJOdRmViQSLPN6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKnyZvsN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D595606A31C;
	Wed, 18 Nov 2026 20:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKnyZvsN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C911F000C5;
	Wed, 18 Nov 2026 20:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034974;
	bh=pnh4wJEMGXSld+VGkxUX1ysQ25mE4U4JmEmXeFxINA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKnyZvsNZTMO7JO7LEz9RdI7M7EyQn28OUdCvCvSFOR7ZyIlIZvZO5jjETS4V5Yg0
	 EliUOcJQpd1HZBgvGyPqUeZMZFdwvWrKmURlh0FrbkAdmeBxvEjYtbK7SbFebgXN7B
	 Zo5xOBW1xaTCw79Fz/8z1XzLo1+YOSb8yosCfpJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6 0560/3318] driver core: Limit the messages on a refused uevent
Date: Wed, 18 Nov 2026 15:19:42 +0100
Message-ID: <20261118150334.162489093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2791,7 +2791,9 @@ static ssize_t uevent_store(struct devic
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


