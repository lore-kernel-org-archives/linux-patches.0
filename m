Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215919;
	b=aAKx+ClZ9IS/6ydT09eZJXgYv69Jglo4hOoFCB63qAMVng5rkDgtpCrB9Mmd/TifdgTI
	 JnaNfcYPylHBQWYk6/F07K1shZyquc7FaHPHZzY33NlgTKEK7jo7uXP7p+RLbPXNqGGtr
	 4ibEDZ4MOUr4SsoSTqpVBV6ghaHpDo6JRVZF9ALpgJ5oo3rY13j6KtWb8oddLY8vFoaUM
	 UelOHBoz/poypWO7op8etDnnBG4ULuCkMpP8xhavMchZX9kv6xhKUk8KbeqSskwh3SmKX
	 6C8QXTpK58i3cIF8EBAP1slILCsC2dlDnecpueDMXzqIZ0L3DzCLW8O1urJXczHPGRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VoYDmtnlTUPtAhBvpDnVXdY0FrqQpp2d2/1kUynzS24=;
	b=tBzQFZx5H+dnBTn/0McoiTLaXxMR7zO25zJJr+TmczwAUYLYPUs2loFTXRZP2cIVdsB5
	 ObvZ2ywS2PTTvxVN/q2brfZ3WhsDVqu5JSUX6x2HAL9tFaJ+GAMfIaUP+KqfrMNQJhx5k
	 /K8ww2tTBatfxjyuZspeLvXf4y282ktLaZ6ziEN4i3SXDrL2LJIKOa7b7t8SLgLurEo0a
	 l9fqRdhtE92FbGffmTCZrWb5C8X2Mdip0Xw6kOu1LmD6HFVh8H/aFgobJoTrqww6vFdTE
	 8hTP0SQsc80lldQwijIKxlkzFlunMDANbQdJ7b4gyHaIWX0wisWYU42Wf+grMe5RUSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6o432x5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B8F606A31A;
	Wed, 28 Oct 2026 19:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6o432x5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F2B1F01825;
	Wed, 28 Oct 2026 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215919;
	bh=VoYDmtnlTUPtAhBvpDnVXdY0FrqQpp2d2/1kUynzS24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6o432x52Kcumz1+G9v5v2VotvgGDo1/ak/OW4Z1Pinyx7Lg4nM7Obx1INO7gRU0Y
	 HPi+tPuJk+RfycjZ+OlTKf2hKYV/u/MmA2kuvHbYOnXx4R759glJO87j3PnjZqVPET
	 +iwDSVea0gZfXE3HO7jwbh2iXXO0NMLjQ1u5T1wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1379/1887] platform/x86: intel_sar: Check ACPI_HANDLE() against NULL
Date: Wed, 28 Oct 2026 17:57:55 +0100
Message-ID: <20261028170530.827724619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2765f16c12af7c2533763e46b8113b727354012d ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_HANDLE() check against NULL to the
platform/x86 intel_sar driver.

Fixes: dcfbd31ef4bc ("platform/x86: BIOS SAR driver for Intel M.2 Modem")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/14023870.uLZWGnKmhe@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 30c906cff490 ("platform/x86: int1092: Fix potential memory leak in sar_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int1092/intel_sar.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/int1092/intel_sar.c b/drivers/platform/x86/intel/int1092/intel_sar.c
index e03943e6380a6..8ddfcfbbf3fcc 100644
--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -246,15 +246,20 @@ static void sar_get_data(int reg, struct wwan_sar_context *context)
 static int sar_probe(struct platform_device *device)
 {
 	struct wwan_sar_context *context;
+	acpi_handle handle;
 	int reg;
 	int result;
 
+	handle = ACPI_HANDLE(&device->dev);
+	if (!handle)
+		return -ENODEV;
+
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
 	context->sar_device = device;
-	context->handle = ACPI_HANDLE(&device->dev);
+	context->handle = handle;
 	dev_set_drvdata(&device->dev, context);
 
 	result = guid_parse(SAR_DSM_UUID, &context->guid);
-- 
2.53.0



