Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4CF2ECE8D;
	Tue, 17 Jun 2025 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174329; cv=none; b=lhwr/km9QnqU+pwRpvzs37mgdOUzlLpieggVBFZLgEMvlRYpI09u/LRqoqGLMYWj7kBjjEkBQCaTH06p4GufYjwNNUQZYEYJLa+u7PMi2v8bEtotGozgPIQjVK3I4VdX6Dk3K6/XD5EUgSWa8cYJblHEI6EuHZzslqEuWHUDI0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174329; c=relaxed/simple;
	bh=/LOF4cs0Bn4+pJU6BoauHj5G5W8xHZygp9v3kf/I0HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fkzp0Np5+A5ZmsDmLmisRjYtWyWUr/5xOOy29O50VC5SyprQPrFIjpTmNRrISoW/8i9CYO4DjGtJ2LFrdqHWNhIP98P8m0YRF6TqL4B+98kf7dmUyjAmbGsomhcvi0WFUlyC1PhqyZn7SLBeR/g3c9pARW74uPnedEOwynMY8Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtxytr9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtxytr9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDCEC4CEF1;
	Tue, 17 Jun 2025 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174329;
	bh=/LOF4cs0Bn4+pJU6BoauHj5G5W8xHZygp9v3kf/I0HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtxytr9QfNeWEO6+tHK4z05tQHJc2oGJxDZGiFQ1JV87IujuIMfNyVM5iFhDi6GF0
	 m4x8Z/4mOaNE05Y0K0SY1eWfUUHjpxumWSnlThXcIskh0KoN+4AkawdhVFLtLGIdyr
	 Djp5nX2Kxbc5TH5x9t8pICTOaI5VJ4YohR6kO0Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/356] ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"
Date: Tue, 17 Jun 2025 17:22:47 +0200
Message-ID: <20250617152340.328741003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



