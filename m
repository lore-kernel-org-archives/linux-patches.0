Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704313;
	b=YKz9xpPntHviStHSwl1r2mUf+UWbGXJZ6ZhC9xUk41YGlsy+2/hqQ7DZN3Dvib5nhV+2
	 F3flSk4NyEDb5XCPLt6r/hSrdK+YyT3UGczeA3e6E04xdz8eNliAl8xyebf4D8qUH0OdP
	 Y3is6mg5XblgTGoXTxCg21gxcUJYyS6C1S8DI1lw6IuE3xNaMdUTPWAjdbeB6kv+8rJdW
	 AMtN1iI/85cWqc12Wucg9FtCROzQM33WDtlzCWzm/Zw/ZDAHmuOr9Fs1l9Sd2JYUY9caG
	 vzV5wYN2G9bUkkuf3n7l+7UVWrnoZ+aqM+hIbV2JYpBjiclSk+Gv/JigBqpS5we68gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiD3A8ZOI5XkSUaz50dErXcu2K15ohEe9wwWhbO0ZL8=;
	b=MkIU4j05RJ0r5b+LtWKG20IMBYA4jXK7XUAdFQDtJamvfVWMbRs06LFOoXL7VLFZLBwQ
	 QjVXd4379/rDaKu8E4ZJcd5TnJ1s47stacXZ5iuJLH3biZrBA2e5KIXe5sf6hpDaXm8Yv
	 XWSCvjWY27gr8+MikOrnYNGpUTxReZF8xX0Ax3YTxqaAVYb+Pul65yfnuedrej2CjFgT2
	 Bg0bH8ZaAq7jkztMTm1zlWuk+XIG7X1JBrAEC5TNV40CTx4AOOW0jEyg0OpiHvtY1obLf
	 4Zh5pKotcPRIBYwzonSSZgDpVMVOTXlKaNs/zolVSe0yGNAGAmhxZA9tGciVvP6y7Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtDzOr3f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF61A606A31E;
	Thu, 26 Nov 2026 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtDzOr3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7821F000C6;
	Thu, 26 Nov 2026 14:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704313;
	bh=xiD3A8ZOI5XkSUaz50dErXcu2K15ohEe9wwWhbO0ZL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtDzOr3fSHlEc6n2h6zXKhOK7Pu842W6Noken9dcpPYaVunJnck6jEAFsScBlpeZV
	 jnhhmHIf22L80kAqYsqG1p72AAg5AmMVNlmsykbKcYL4yNlzQqksYBKgTjsDJyj8BK
	 qkQqSTQEmEj0yF6lVjn1jFZzpdUGI4gO4KtrZpHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 079/265] ACPI: scan: Print the offline failure message in acpi_bus_offline()
Date: Thu, 26 Nov 2026 15:36:49 +0100
Message-ID: <20261126143610.568484752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit b9ea1e921c2721546f53270cffdc6866e20576dd ]

When a physical node of an ACPI device being hot-removed cannot be
offlined, acpi_bus_offline() passes the physical device back to
acpi_scan_try_to_offline() through ret_p and the latter prints
"Offline failed." for it after the namespace walk.  By then
physical_node_lock is not held anymore, so the device may have been
unbound from its ACPI companion and freed in the meantime.

Print the message in acpi_bus_offline() when device_offline() fails in
the second pass, while physical_node_lock keeps the device bound to its
ACPI companion and so the reference taken by acpi_bind_one() is still
held.  acpi_scan_try_to_offline() only needs to know that something
could not be offlined, so pass the ACPI device back through ret_p
instead, like in the "Offline disabled." case.

Fixes: 303bfdb1a14d ("ACPI / scan: Add second pass of companion offlining to hot-remove code")
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261029034507.2721580-2-sashal@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 08a43d1393e0e..745a9d42307b7 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -169,8 +169,9 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 		if (ret >= 0) {
 			pn->put_online = !ret;
 		} else {
-			*ret_p = pn->dev;
+			*ret_p = &device->dev;
 			if (second_pass) {
+				dev_warn(pn->dev, "Offline failed.\n");
 				status = AE_ERROR;
 				break;
 			}
@@ -239,7 +240,6 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
 					 (void **)&errdev);
 
 		if (errdev) {
-			dev_warn(errdev, "Offline failed.\n");
 			acpi_bus_online(handle, 0, NULL, NULL);
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
 					    ACPI_UINT32_MAX, acpi_bus_online,
-- 
2.53.0



