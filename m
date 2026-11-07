Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064037;
	b=myeWJ3G08VDQOUKI+kONtX0moXBINYI/xPKzfaiz+Co0I1qH0PCJjgZiWwBhU+A5mjGc
	 Du+ihUQqHhZCowU7hhI1tHVXzIRHfHpD8SFoEfp8mDQf+LhNxeDpVf7paPF/tVu5BmRH/
	 b0Xz8I4ErIM0M3tUrOdmuW+TT4NOiEu5uXvzQBUgdS3bjN706Xa/RqB8GKVuEsS/rDQGt
	 Q9JNyPL46OTz8fCQjV4dKZ8YW7ezatr/7fC+dN+Ziy114CYWSRJyAio1xpuODoGw6G45A
	 0VgiHtr/2k2wLhHqZdgFogYUd6UqXSRFwuL4RZJGQCGeMore2otPT6mbDutLBE8gYnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+inYJf8LY1cjBz+WOo5b1w0SJEf6XQcNsg1mE6RhxI=;
	b=mUmDnZ8drYXiL2+hCaU3De94QBF2FrKRvmdcjGyzE9xZ0PLyoWk/PboaQn8xZprx5GVV
	 SNG8MHIM0jtcrXA8IsBfLXT+ItbnNZUv44NiLDTZk/y/I2JKh2evoBdFENemGerBezk06
	 9as3cY6OO1vpny1HTCwC4W071g5rMNUN12h+MbcPPkaURFIWSfkm4lZw2nCRhHrE//AmR
	 QyTJpiqcRLx7UltOom7UnYigNmFIk5ahCzkOgqTHTI1f+eS15uhtCFIHHVB9wnED1IzCu
	 G8oqaWMTJoWWeY0f7ZsZXfXRM9z3TDJyTl/wbteew4NOZ44G5zGjqmw74Bj/sC4X/3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OR8up4Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED40C606A9CB;
	Sat,  7 Nov 2026 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OR8up4Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA881F008A3;
	Sat,  7 Nov 2026 15:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064036;
	bh=H+inYJf8LY1cjBz+WOo5b1w0SJEf6XQcNsg1mE6RhxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OR8up4QGCWenBjaS+MQsouVDvOzsNwAI4EhufDW432i5cool2fMGLjU+BPXgFGtj
	 rwDO1l+kIq43BEB0DkN2rn9FwpNEeJtvueXR74LB1Dm4BQoSGD6M080V9lbYqAPDO0
	 KrgCVzoZPxWhAY7s3Kdc1dek2WFthVPwK1DKDtFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0173/1257] media: i2c: og01a1b: power off sensor on remove
Date: Sat,  7 Nov 2026 08:41:09 -0500
Message-ID: <20261107134944.130307183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 1675f0460969a..1cece90c59eeb 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -956,6 +956,11 @@ static void og01a1b_remove(struct i2c_client *client)
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



