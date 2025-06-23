Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0E242D90;
	Mon, 23 Jun 2025 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685465; cv=none; b=LrcXEadd2fK1OWa+eHRwZCmQKL7KHB5oWIlJYxQs/gFb88+biFHq7RdZ1iIS/cQhG3grKbDSs3gT5vH+FhQ8AH80f33Z0BR96KRZv8JH09fiUQkMVdV8e+2bKNQgd0F6M6lL1dyxYO9JqsJmWHNydcJg2p5hLUoqOXQTEZJoxfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685465; c=relaxed/simple;
	bh=xV6Rq1BPmwALaEKOx7xfx2UhR2QJIiYs686RpJozJHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxM4kpyz6TADCR+qU7wOFoae0AtzY2RgMJ6fEBSah4ZqLuKtI2oVO/i7fSSZpwjpoRR4ARkHOYcdodyaK9zPK3NzPO7wYcDI/yVdqOQgRjnWiWpomzXIaQG+ypU7Xxw2+rc2RZ8hKmwTHl2jI1q2Z07tzeQ3Fljh9MFPQqs1r+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/hJCqYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/hJCqYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA18C4CEEA;
	Mon, 23 Jun 2025 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685465;
	bh=xV6Rq1BPmwALaEKOx7xfx2UhR2QJIiYs686RpJozJHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/hJCqYfiHY6otcUbDwcNIzxJKuJJZ5c3ErdvL6hZH3Z2A6SBI9ks2NCm3aSBQo3V
	 EylwRB/T10QpW68wfgxCEaS3qQMyUEslRXoubWFa+e3l1RJr1DXBCLH+OJJyDVs5/z
	 KwuGG8rHKBpas0ZYX9F/iQbjrKhrN7mQrW87AFfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/508] ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"
Date: Mon, 23 Jun 2025 15:01:18 +0200
Message-ID: <20250623130646.061145708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4405e1ca9b97..ae9620757865b 100644
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



