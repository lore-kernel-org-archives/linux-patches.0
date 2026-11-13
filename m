Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591347;
	b=EwRPbevgAF1uRROYBqDSS/yKkMnpmjvmkddKSJGaPDkfvI64N9IL/GqRRm8dZggI8o2g
	 S0O+Saxx9JDFx6E3IbioHViolrUAks5TcoqorsMJW/mPAMtSahYmH0J3CRcr9aRaSDo7E
	 MOIqxpsVcbtR/NssElW781Z5IDnqFqCc0hcANilpZFbSy5VFmoTm0iWlp/bv1sda3K7eY
	 lszTvnuR89Pw+wI3a0HHf7lBJFzbvOTMbsxD7CamvrHA3BBHgNJJvjScuA96oe1cnJbgJ
	 egY2dKFb4LlhLgxecMsSE8ASI3a6N8g3YsaAgwMMrFOmezCsu3ZYo/mlYgd9mcbx0BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=atFO0SZCUVHG56QZ95ITUSfU77q7c3I4Vigfckj8GkY=;
	b=U75lkZp99mOlopapiDaGB3lY/6biUm0hgxWSPeMYOB42b3I1cmhPYlZAt19iPZKhJbsS
	 loICvkJZSbArao//fop6kQ2eDUZkp2Zts9hS9dI3rUItEokvxsF0AjW60+SRn19/hxVFI
	 MwQrjf2h4Hjb7W3yicAZJ7gbagpMjcfcFZlbXMl9kbNjcCaGPA+6EWE5VtTlesR6xihGd
	 Ixzqn2l7FV7AeyhCCH5F6CtpOC7KxpFYwiC8bbOaZNZkdiC9HQbFo7gg8miXzy8MfzyCU
	 v2mmsebgmQqOF4MPQwBjhVnEGkY/YAOizKrBXYaAqz1eIOK2axqVg022Mp2FO8Iw6gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqxHqoSC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5951606CEDD;
	Fri, 13 Nov 2026 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqxHqoSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714781F000C4;
	Fri, 13 Nov 2026 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591347;
	bh=atFO0SZCUVHG56QZ95ITUSfU77q7c3I4Vigfckj8GkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqxHqoSCN+lWtiOE9QHnZ35njR+YTUJVjLC8yrbjpb+OWfDaHYTs2215onYChfHx+
	 ZvdVWaZLaSUVK5c+4km0onGoScC7GrXymcn2YV2wMlA2wGVwHrs+4euW/SU/NiIQgj
	 V8ak4WjqgMFM7o5Dk4SCU+V2PfVl+uUgJ5VHl9/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/670] media: i2c: og01a1b: power off sensor on remove
Date: Fri, 13 Nov 2026 10:50:18 -0500
Message-ID: <20261113153827.291699959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 95ead31dda278..cc8ff6ffd29ac 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -1042,6 +1042,11 @@ static void og01a1b_remove(struct i2c_client *client)
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



