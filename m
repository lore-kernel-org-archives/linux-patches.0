Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827026;
	b=oThboCOPz3chzKvsHajE+UKcJq3pnmXZL0t+t4929ttCTjJfk1ok/6W5U/NbZ4dDBZKW
	 RCK0aXcbc1FqOrOV3eQfPZQMrbudXz90RrHCY4wXRle1ci4AqdGPqlXYRIsDcSmBzZK17
	 MjQL/W/v5wIBvM3fRTrRNhsPzc7cuICUPmUSiPzOgnQkJPj1+ML+5RQovm6CAguI+Szug
	 /v/pnk81x2iQDHpNKG0XFYFSv3HYjN43WSSeXxlHq9IdgYjid3W4D7Tc8xUPjTHP/5Ied
	 m7p4kHiTh8b1GNFBIb6Jeg4eXZNTTR2gOIHcHngnUEp48nRTHlmbWAvnRiMKP8jFpyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pv09KNf04NaAk5A0cAyuZw5dClmLNLk7SnSV1QkpKm4=;
	b=Zj40PEIJTJSit5Wbpew7RUDSt0NUBu9lg564B9Jb/+8EVklg69yCxJSd2PW776kbZFG6
	 AvPfqfzms7dlfC6KHyocrpTdc7FeQ1Gg9z9ucsvS+nwy7iv1Yd8dfgdcIB125pKERpmZ7
	 vt7WOSxu+gsBzMb7KtEAg3GW57Wf9vGROCZVQf9rRQ/6qZ+sltJdHjV2Gb2gPiun2g1L3
	 bCAE9s5qXq2c+Bbht8ux10hgy7mW92SL2dlaALl6WrPgnH555Uua+8scjxl0sGv9xIY2t
	 MWpRrGYOB+TslK0d4TKz+Pl4XE19a3liHhtTH/imnlf/i6hfnp8SXgpG5PUA9iFUAHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zP8dQaP9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41303606A86B;
	Wed,  4 Nov 2026 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zP8dQaP9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9371F00A02;
	Wed,  4 Nov 2026 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827026;
	bh=pv09KNf04NaAk5A0cAyuZw5dClmLNLk7SnSV1QkpKm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zP8dQaP9XNj9VqJLaIXTrs/iHs551gAEdS7yu7zNw0/PCqop1ut0yMxfMqS3d06fz
	 TF8/2Ggp4J5EXjzpc/gHEQaqkIUc7zqygj1eE9/q7sbmE77pT0lMim5W6runOMtH6X
	 ObFxxW/6+x7BjEX5rvOWqOiUS5HH6niUbJ85+Amw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Baigue <hugobaigue2004@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.3 151/547] platform/x86: asus-wmi: fix use-after-free unregistering kbd_led led
Date: Wed,  4 Nov 2026 16:05:35 -0500
Message-ID: <20261104211042.453099561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

commit 639bc2254816b7c4e7a9801a7b3aa71bfa3f915c upstream.

kbd_led_update_all() registers asus->kbd_led with
devm_led_classdev_register() on the platform device, but kbd_led is
embedded in struct asus_wmi, which asus_wmi_remove() frees at its end.
The driver core calls .remove() before devres_release_all(), so the
deferred devres release runs led_classdev_unregister() on memory that
has already been freed. Whether that faults depends on whether the
slab has been reused in between, which makes the crash on module
unload intermittent and silently corrupts the led classdev state in
the remaining runs.

Unregister the led classdev explicitly in asus_wmi_led_exit(), after
the led workqueue has been destroyed: kbd_led_work can then neither
run nor be queued anymore, since asus_ref.asus is NULL too, so
kbd_led_registered is stable and the classdev can be released while
the memory embedding it is still alive. devm_led_classdev_unregister()
also drops the devres entry, leaving nothing to run at unbind cleanup
time; it warns when no devres entry exists, hence the
kbd_led_registered check.

Fixes: fac55d29581f ("platform/x86: asus-wmi: Add support for multiple kbd led handlers")
Closes: https://lore.kernel.org/all/CAO84+x+P2_xyHP89+nGVSMV6bL+dy0P9=vyEEfZGnFhv0hBNWw@mail.gmail.com
Reported-by: Hugo Baigue <hugobaigue2004@gmail.com>
Tested-by: Hugo Baigue <hugobaigue2004@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: zcode:glm-5.3-flash
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260915172608.14234-1-denis.benato@linux.dev
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-wmi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c2af1f049b67..0eb43ca44119 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2088,6 +2088,18 @@ static void asus_wmi_led_exit(struct asus_wmi *asus)
 
 	if (asus->led_workqueue)
 		destroy_workqueue(asus->led_workqueue);
+
+	/*
+	 * kbd_led is registered lazily by kbd_led_work: now that the
+	 * workqueue is destroyed and asus_ref.asus is NULL, the work can
+	 * neither run nor be queued anymore, furthermore leaving it to
+	 * devres would run the unregister from devres_release_all(),
+	 * after .remove() returned and the struct asus_wmi embedding
+	 * kbd_led has been freed.
+	 */
+	if (asus->kbd_led_registered)
+		devm_led_classdev_unregister(&asus->platform_device->dev,
+					     &asus->kbd_led);
 }
 
 static int asus_wmi_led_init(struct asus_wmi *asus)
-- 
2.56.0



