Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590633;
	b=xrmOQTaBpXCyHAn2ETuIjWs0HixJqjPMIxQaSIj0xwdJpqFiC2irUoRUWc2gmH3DDAOe
	 fGX5EN8tivwb1R2b3xeuCY7yyBRMwxp4ebsoHo4pvhEOl1jcu756gel0Yl1UzADX41Czp
	 s5jVlhRATWT+xILguoZxE/tlswBXURBBb0NhWlnlte3e6Hl0mQVtvc6kjjO//Jso0Sd5M
	 PtVxjlXnjBMy0sd6xxOt+3z1+8HX2nCq7ToAhqrHNIofaQ9pqIS+180K8WjRVIUfqYcUL
	 S/4VJ7NAajP1j24l5RKKMxQoJdJ6lSMHZm2SHnfAFVp/A85HZcKVf42DzzMOFyp6V/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WIg64jgg5dWp4miUZNoBzUZz+DdPyIBTp9d7iDhN8bQ=;
	b=GMJ+S5XMopSrI/1mw5NmxXrE2afcPOCIhXc4DX2JSYTHvmpHNVwmXcBvZmAcxVYNzgww
	 56djiEWV27hVlKvdbyJxFeNFt6GQGe6KToQcEXv7mxm/FPoa06Jcw30JEfmit09Jhw/Mh
	 vd7kCdn4WA++2J5HxjXpH0sDH7n4ZSce9OWUa1z51BGK97sOBGglzBIbO1Ect2INA80Lc
	 U7hX3LBPBUwD0hHcXAZXdHjT/Y21eO6URrCcGQB6eRYN/N8fwjmYzFHviLagQRte/Yux6
	 9r1GivNPoe9q3RltZeYbzZ+EyhMJdkBF86k+EYoUXUuhzo7V/szxsjC1rgP6TIcDjtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyIGSU8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A160A263F;
	Fri, 13 Nov 2026 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyIGSU8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B001F000C4;
	Fri, 13 Nov 2026 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590633;
	bh=WIg64jgg5dWp4miUZNoBzUZz+DdPyIBTp9d7iDhN8bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyIGSU8AwmXM5BM1+xJJFx2qtmqpDgXerR8EMq7k3/E2z0R0R56WtfOm0q+p2Y1c9
	 6J9t9mKBfI/582QWCYg/eWRvtCnlPJVlSCDKXgtsyUWKPOk0XtQgvdqDgwrcnegKA5
	 KxJMK4mDKsJF8skHRYqH5/Pg3b9MSB4oHASRep1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/686] media: i2c: og01a1b: power off sensor on remove
Date: Fri, 13 Nov 2026 10:50:45 -0500
Message-ID: <20261113153838.318479013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a26c5ac46191ae34b3413f7a45d6241f63e15d42 ]

og01a1b_probe() powers the sensor on explicitly before identifying and
initializing it. After a successful probe, runtime PM is enabled and
pm_runtime_idle() is used to allow the runtime suspend callback to
power the sensor off.

The probe error path explicitly calls og01a1b_power_off(), but the
normal remove path only disables runtime PM. pm_runtime_disable() does
not guarantee that an active device is runtime suspended, so the
sensor can remain powered when the driver is removed. This also leaves
the xvclk enable performed by og01a1b_power_on() unbalanced.

After disabling runtime PM, check whether the device is already
suspended. If it is still active, power the sensor off explicitly and
update the runtime PM state accordingly. Avoid powering it off again
when runtime suspend has already done so.

This issue was found by manual code inspection.

Fixes: a95ffde28783 ("media: i2c: og01a1b: Add support of xvclk supply clock in power management")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/og01a1b.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/og01a1b.c b/drivers/media/i2c/og01a1b.c
index 4b6b9ac24594b..68ebf44876781 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -1026,6 +1026,11 @@ static void og01a1b_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	pm_runtime_disable(og01a1b->dev);
+
+	if (!pm_runtime_status_suspended(og01a1b->dev)) {
+		og01a1b_power_off(og01a1b->dev);
+		pm_runtime_set_suspended(og01a1b->dev);
+	}
 }
 
 static int og01a1b_probe(struct i2c_client *client)
-- 
2.53.0



