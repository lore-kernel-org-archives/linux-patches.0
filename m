Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B67420F090;
	Tue, 17 Jun 2025 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174921; cv=none; b=CLXC2pDtp5uyCI0fpcMxYJF8NpGouEY74HrQBAXBfxqXaDzLffyMTeDPaPzXIh8/f3r2L7YSY8TzzUkekfEDRuRgxqzAUyHXfDDPTgKg+63Zl1ZE0CbZlhyhTT2yQchjn3fxL/mTU2yOBmP0pRHIicOdKx+okrC+bJgfm8mnXTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174921; c=relaxed/simple;
	bh=4tXelUGmqGmZYQSrzbeZq1A14okw6CAeMhWG5LMrwNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMptGXQ/sK0BrsnNbMlE96S89P10+CcmFL5wauCVV8HdfB8Q3e7CocLB+1ysAFOxC4/e2iSdPBSlQ6TUhaOAd4wMnKNOlxjAUTPe+1dJfoDx1oemzjoVCNjH0cKoMMGUQrZ2wHTxdvmAi7enpnGYppwNwhCT7FLgd2IRp9jaPK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnv+OSEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnv+OSEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4872C4CEE7;
	Tue, 17 Jun 2025 15:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174921;
	bh=4tXelUGmqGmZYQSrzbeZq1A14okw6CAeMhWG5LMrwNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnv+OSEwL0vmoi85IkblR6K+eRHu2SpjHe2NjBcEekatZ7hC+UNPmu+xMT/XSA/Pw
	 rcSyGJHuiMQOjwPklrklurM2V3Xfa0VQDzZhAJumRP0nMeVb0hK93XJMJVF5KVuvHr
	 lRxW0oiqLt7b3mEy6K6q8h0H0PlMavNwV905NRdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/512] ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"
Date: Tue, 17 Jun 2025 17:20:21 +0200
Message-ID: <20250617152421.767319124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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



