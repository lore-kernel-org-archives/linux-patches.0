Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5E5371CEA;
	Wed, 20 May 2026 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302536; cv=none; b=B/cCs0IxJzyPLC8cKlMr1BHDot5zzNGEOO1aWhx72zAREFBJuJ8wZo9Vn8iqtl++OfxpBilwtOZzk855OprjGzALVK8J6QgVIzBgau5c1Q41f+/x3Xf5wLm/ct7cqa8M+qzMXKNbosCFoVxl4AhmTJnNFm8g1Wc5VzjCW2LNvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302536; c=relaxed/simple;
	bh=Ku84J4QbyqjXPkJL+/hgfIxQEL9iKiMPNTguQj4dkVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JgH9AZ5lpBS2koU8iKnGE45D10Xvwlqg34Qsz+X73UMjjUbmvGl71QZgpMzT+Fv1ezrs+V8s5b7KZYzOGLjl7Otm7nkIbpx6j7nD6uEQqnFRuz+ibyvWD5i/1vZurZ4/3Y+WB2NqqikIhgHiQOF5jCrO4kKj0Dv7y3yFjxyO5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMbMmTH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMbMmTH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A21F000E9;
	Wed, 20 May 2026 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302535;
	bh=KaueG1DFh4yZI0lpTV4G1pcQixjGRo2U7D90FcseRqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMbMmTH7N5ZkUf1eXBVy9JU1qohQ/Dn5qOxDQEoVuSxIJgpKG6+8TeB8t3LU69mtX
	 hzdkuDhq74hhTpJsv47kZrZeQ2eHTVS0PSHyjz7SJaMkU2G+xUzRaG0r5naIY+dyuw
	 FMwHM4bU8zXgVExNRXDNd6WrQ5LM+FMN3TggHL7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/508] platform/surface: surfacepro3_button: Drop wakeup source on remove
Date: Wed, 20 May 2026 18:21:25 +0200
Message-ID: <20260520162104.322074261@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1410a228ab2d36fe2b383415a632ae12048d4f3a ]

The wakeup source added by device_init_wakeup() in surface_button_add()
needs to be dropped during driver removal, so update the driver to do
that.

Fixes: 19351f340765 ("platform/x86: surfacepro3: Support for wakeup from suspend-to-idle")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4368848.1IzOArtZ34@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surfacepro3_button.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/surface/surfacepro3_button.c b/drivers/platform/surface/surfacepro3_button.c
index 2755601f979cd..7c7622f8f8716 100644
--- a/drivers/platform/surface/surfacepro3_button.c
+++ b/drivers/platform/surface/surfacepro3_button.c
@@ -243,6 +243,7 @@ static void surface_button_remove(struct acpi_device *device)
 {
 	struct surface_button *button = acpi_driver_data(device);
 
+	device_init_wakeup(&device->dev, false);
 	input_unregister_device(button->input);
 	kfree(button);
 }
-- 
2.53.0



