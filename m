Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619694;
	b=vDCNGH342nixOcAV038hYsOPYuJNVpACI4O1iyWCfxivw9gkfqZXu0HvGociTC6on5yA
	 4NumMN9LpGQiQm5N5MBoPErx1zQfz/sYZLXkU1qzS6oijY/E6xmXxZMp6auH+7cLin6bb
	 U6vqWwsXWkt1pjYUv52WFLG5ljSg56FwFoPkz26lQLk/UJHMSD0/NuUmsDC+DOdlHZcOY
	 CzUrieqxGTIXo3ctKorws2e7h0smuoxSEodgT0a25Im16+5TxNsh1A3XQVIkx1o6utRiI
	 IFi2nxzabMZ9o90T2DzB+YDwKHS7c+K4d/OOxdgm342JS0Bk8/FtGzkMJQBRo6LesBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yUIOUfI2y3f3YH5HWlOY0Uht+axQViVpso7qOv/PhcU=;
	b=NTSidCTv6Qxar6IlT/nMP9sKiEKg6cDzwgivb64uT5y2ZPAA4yLvuNi7AEwLokLGvRFb
	 y5Vh8v1t7uwmCdI+pApyiNU41Ad1E95N8jOFLmVIZ/ibBY6/VFvo0XpwaaGAMC7m2w6DA
	 H8q0wTrWm6hyVLOiEwSc2NnR03LYhdU8+Qh0biuxQylhcjTVZ/2/1zVrfdKm/Juf3miqp
	 Sx832uRPd90U/jklacQ+ERlv/LW/yd63IdaHngKVau4Og723vA+9H7WANQdQ5bLngP/SE
	 kUjtaE43vMaJ679sxGFt0LwFl9s+8O5jN7Zr3eX0zpaqaGsoWl6ECMD5mNBC1Xnl9Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/LCZUk2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F41606A321;
	Wed, 25 Nov 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/LCZUk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364DC1F000ED;
	Wed, 25 Nov 2026 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619693;
	bh=yUIOUfI2y3f3YH5HWlOY0Uht+axQViVpso7qOv/PhcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/LCZUk2OeiczGKUr0Pn/LILrPCVK3499mnB2WHL2JAmOUDqF5lbRb4/3MBjYdN6i
	 pGOIPyh832W4FbvNcJVRJcXLipxDQMFffMkLgnZ5TLtsopgZ+Ugk7OQwAf7Ioz5R2l
	 oJXkNs7RcxY0dI6yZuuZVdxsVngiljgCvROu2lW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.3 0678/1005] PM: runtime: Update last_busy in rpm_resume() for active devices
Date: Wed, 25 Nov 2026 15:33:36 +0100
Message-ID: <20261125143837.638346180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 55b2b8af704f845e01fa2f31ee259b07641ce3a9 upstream.

Setting an autosuspend delay for a device can be expected to cause a
runtime suspend of the device after calling, say, pm_runtime_put() to
be deferred, so the time between the last successful attempt to resume
the device and its subsequent suspend is at least equal to the
autosuspend delay.

However, that expectation is only met after the device has been actually
resumed in rpm_resume() by invoking its runtime resume callback.  If the
runtime PM status of the device is already "active" when rpm_resume()
runs for it, the device's last_busy timestamp is not updated which may
allow a subsequent pm_runtime_put() invocation (or similar) to suspend
it right away.

This is arguably inconsistent and confusing, so make rpm_resume() also
update the device's last_busy timestamp when it finds that the device is
already "active" and it is about to return 1 early.

Fixes: 56f487c78015 ("PM / Runtime: Update last_busy in rpm_resume")
Link: https://lore.kernel.org/linux-pm/CAJZ5v0jTX1FgeS9FCV=+V4uacSgLQBVsSPnU27ybgUGg57GUOA@mail.gmail.com/
Reported-by: Brian Norris <briannorris@chromium.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/13032301.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -822,6 +822,12 @@ static int rpm_resume(struct device *dev
 		pm_runtime_deactivate_timer(dev);
 
 	if (dev->power.runtime_status == RPM_ACTIVE) {
+		/*
+		 * The attempt to resume the device means that it is needed for
+		 * something, so update its last_busy timestamp as in the case
+		 * in which it actually resumes below.
+		 */
+		pm_runtime_mark_last_busy(dev);
 		retval = 1;
 		goto out;
 	}


