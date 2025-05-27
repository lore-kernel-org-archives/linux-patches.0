Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BF427C856;
	Tue, 27 May 2025 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364450; cv=none; b=VgajmZiyp9gEdDKfDB07IPnBDAD9nBqSvhDN0fbGEsZKgLwLr8h+u+clCSHmZFUUtIqgl8IaoW4lsMgGFB5MYcwepIyFmggYVzvcXtbNiBvDc09Ij9GvlWnAcAr6j1oZUqBaOLrVR0n9iS7xCW4VMB2xZq34vCygGBYPANtlA+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364450; c=relaxed/simple;
	bh=WuqFaZs4eE9fa+JjdbXXKqPcovhQHifgGbWf3l57BmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsukfyTQ/W3yVta9BxVQTuG0MwfciUatQlCMGDoYStHzhSzy7eKpKFfNy9G+5H7JNZ0nsLOMpWsOLUefijbBBjKDVnoHJ+VZy6Wa2dXKFzb7y8ZMSQKB/KONlNF41V3H5So6kAhEH9rWYEvSCrcvdrlvOO3jPNf3UYbYYxAfJFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bVzgbA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bVzgbA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77537C4CEEB;
	Tue, 27 May 2025 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364450;
	bh=WuqFaZs4eE9fa+JjdbXXKqPcovhQHifgGbWf3l57BmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bVzgbA++pjqfeMfZyxX6kGqm8Laocx8R/gMaTaLYZ3eSxDeQe70oGP0XU3vL7Qmv
	 dzL++cHCiEE8E5sa6tdWrN8ucnIHg6KA7vB1TTDq2uvHpWzpD8TCmwyuDfu4rHO8Ku
	 P0vWtMSNpX0fxwi9rChaV38R36YuNEqUJuO28+uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@siemens.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/626] ACPI: PNP: Add Intel OC Watchdog IDs to non-PNP device list
Date: Tue, 27 May 2025 18:19:13 +0200
Message-ID: <20250527162447.498524685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@siemens.com>

[ Upstream commit f06777cf2bbc21dd8c71d6e3906934e56b4e18e4 ]

Intel Over-Clocking Watchdogs are described in ACPI tables by both the
generic PNP0C02 _CID and their ACPI _HID. The presence of the _CID then
causes the PNP scan handler to attach to the watchdog, preventing the
actual watchdog driver from binding. Address this by adding the ACPI
_HIDs to the list of non-PNP devices, so that the PNP scan handler is
bypassed.

Note that these watchdogs can be described by multiple _HIDs for what
seems to be identical hardware. This commit is not a complete list of
all the possible watchdog ACPI _HIDs.

Signed-off-by: Diogo Ivo <diogo.ivo@siemens.com>
Link: https://patch.msgid.link/20250317-ivo-intel_oc_wdt-v3-2-32c396f4eefd@siemens.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pnp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 01abf26764b00..3f5a1840f5733 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -355,8 +355,10 @@ static bool acpi_pnp_match(const char *idstr, const struct acpi_device_id **matc
  * device represented by it.
  */
 static const struct acpi_device_id acpi_nonpnp_device_ids[] = {
+	{"INT3F0D"},
 	{"INTC1080"},
 	{"INTC1081"},
+	{"INTC1099"},
 	{""},
 };
 
-- 
2.39.5



