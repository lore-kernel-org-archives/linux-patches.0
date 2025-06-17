Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21CC2ECE8E;
	Tue, 17 Jun 2025 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175364; cv=none; b=gG54df74CRGT5xbwbslB/GCC+UCsLJIEN0Zx3iQMo+KXW75P3SXBQMGPOvCR64F0tnqD58+81tW6Jcj8M5t+1w2ELEXgM3UzbosYe9gM2U7gZLs+iLkLZr3qu/f2GKsszuY8WnGaONq4OA7GZTGKELwrjT1sOjrsqUpdhF0dY50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175364; c=relaxed/simple;
	bh=Xyk4IrqXZIeHDmdQog555qyUmr93y2kDAfmQ/JMpaM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emfTvS+VzZO/5pLAdkeJAEOZ2KwM+Do6Yw/WF3cWwMukijFDyVGfzVHvBZx8cA/AwZbexVBz+GRbOPa11kp5H9a6jYbs8CwFEuFSyYYlVWKCAcmc+pzgHoFDhtFNu/qmn39b5qJehuIJTt4e6kqRfP1X9K6q1bm6MDfehoD8Ano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEJSVdh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEJSVdh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21958C4CEE3;
	Tue, 17 Jun 2025 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175364;
	bh=Xyk4IrqXZIeHDmdQog555qyUmr93y2kDAfmQ/JMpaM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEJSVdh3UdMMeGYi1NbEiTzqlI5mmyoVVQBlLMCUZ+tjWymiMCmQvP4RuqbCzPpw3
	 qziqxWJaYLka9OBQc4mNmCoEQ1QXnJdDtcABa2KKaMpNuN4YwV4aDiQK2oBKDkWHrd
	 r9b0qoPRqAr9PCFf5v9QmxJMZuBi62476QoQUPcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 081/780] ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"
Date: Tue, 17 Jun 2025 17:16:29 +0200
Message-ID: <20250617152454.813818454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 8cf4fdac9bdead7bca15fc56fdecdf78d11c3ec6 ]

As specified in section 5.7.2 of the ACPI specification the feature
group string "3.0 _SCP Extensions" implies that the operating system
evaluates the _SCP control method with additional parameters.

However the ACPI thermal driver evaluates the _SCP control method
without those additional parameters, conflicting with the above
feature group string advertised to the firmware thru _OSI.

Stop advertising support for this feature string to avoid confusing
the ACPI firmware.

Fixes: e5f660ebef68 ("ACPI / osi: Collect _OSI handling into one single file")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20250410165456.4173-2-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/osi.c b/drivers/acpi/osi.c
index df9328c850bd3..f2c943b934be0 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -42,7 +42,6 @@ static struct acpi_osi_entry
 osi_setup_entries[OSI_STRING_ENTRIES_MAX] __initdata = {
 	{"Module Device", true},
 	{"Processor Device", true},
-	{"3.0 _SCP Extensions", true},
 	{"Processor Aggregator Device", true},
 };
 
-- 
2.39.5



