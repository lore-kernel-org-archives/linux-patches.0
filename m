Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217254;
	b=s9pDg+mH8WI1ucQVD4sa4Gd1XBJjgFT5IydeKk0mW033rIfbCPPwQgQbaypr62gE6QKO
	 Lnpq07iAirynHYOmu35GReq2GNMII/yL/h7G0T//dRw+CEmmn6SczjKJqcNZUSGbIznYL
	 cr9ZEkVgzeqvwXTPjgq+0oKQ+0g5yKy5qQUTwsIlAROCWDdEYAkke4AclIN1+nbZIGzxf
	 +nGWXfupwMT37qvDc7tfodlzyaP5dmFz/S2cD78XsUmOJ+WNCDfbft3Es12bOyElFEjK1
	 SSlz9BjZ3JYDB5Om632XU9OiXnpCVQFBMKyMSzdFqCR0Fvuti3jZrRE0XJ2R/WHHIAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6SMs60XAhDnG2/TDR7AOgdwqonm+cvuL6Ba0AAZJRQ=;
	b=Ky4XW6iHnDUYfi4e2cwg6/Yav7/OYyafLvVt8hJ3HuIl2vI7ei+CzMP4PBHU+kW/KloK
	 t4YcWTt3M4QUl88KboXlDH1eN/GHgLZrzLIWWF6FA0GJN3CvKDfaLetZB2r1LTcFY5FmB
	 a2SiJTbeNrhZR0cjocDaYO879Aa5fhek5IOS5f+Q8pOCNlJFp2UyfyPkLKnqfx7Th3m5h
	 lBC+ZpASuDryzVpTDQXX52p7rj4VJ+iDERGu0BInCvcCxD03o/hDTeBsAHWy949vjTD9s
	 FObrU6pTXNdGsHiOLD80glTd/uXNMBQIAhvbPdG0rr2v66zQyHHB4HgPmKgYPOAaRgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1FwgQz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D46606A322;
	Wed, 28 Oct 2026 19:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1FwgQz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914111F01825;
	Wed, 28 Oct 2026 19:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217254;
	bh=x6SMs60XAhDnG2/TDR7AOgdwqonm+cvuL6Ba0AAZJRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1FwgQz35dgcxyLOKemjJ5T6BpE9L0r/b3MF4F0W+VhboViT/pz3QYch9cKKKMZnr
	 m8yq2WF1cKFX66H9Z/g9WVWdEKQb1etoLSESZBhVg/CNlkFEcttxSeTtNRfKUAg8yI
	 rUUsc3ZjsgLnuKIHsyWNgf3xDc5VHNXevfs44Tn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1841/1887] firmware: arm_scmi: Unrequest devices if driver registration fails
Date: Wed, 28 Oct 2026 18:05:37 +0100
Message-ID: <20261028170541.344182247@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 9f7cd6a62aa754ed6b48cbd5d50de40add1bcc86 ]

scmi_driver_register() requests protocol devices before registering the
driver. If driver_register() fails, those requests remain in the global
IDR and retain pointers to the module's ID table. Once the failed module
load releases that storage, later request matching or SCMI device creation
can dereference the stale pointers.

Unrequest the complete protocol table before returning the registration
failure. At this point table registration succeeded, so every entry is
owned by the current registration attempt.

Fixes: d3cd7c525fd2 ("firmware: arm_scmi: Refactor protocol device creation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260722173521.2184378-2-sudeep.holla@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 8ef893957ef2e..ca68cfa931b0b 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -303,10 +303,14 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 	driver->driver.mod_name = mod_name;
 
 	retval = driver_register(&driver->driver);
-	if (!retval)
-		pr_debug("Registered new scmi driver %s\n", driver->name);
+	if (retval) {
+		scmi_protocol_table_unregister(driver->id_table);
+		return retval;
+	}
 
-	return retval;
+	pr_debug("Registered new scmi driver %s\n", driver->name);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(scmi_driver_register);
 
-- 
2.53.0



