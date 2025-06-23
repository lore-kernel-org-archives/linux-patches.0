Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0A1253B56;
	Mon, 23 Jun 2025 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684730; cv=none; b=eHnk+ZMjx5hD1lujDDGEkVfQ4eNHGAMbWBdp192X/AdkoNBh+PCU31PGK0QBbrBUUOfm9TRTSh93MQZ0ezO+sRYwJ9GupzczRx+xV425e+GmCV91Ll2GHGYgRFYK/IIxsOxpE/Y/aouCCmXVhZ43BcF5HVDivwG9udEPtqgygWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684730; c=relaxed/simple;
	bh=zedNR3/NHmgljUtZWD9cnbSjUVNSShzktN1hlLiNm/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/v5/NPtFz2so91ftlG5pPTqgExsMUZE33hekWFUzIERQfrc3FpoQSoq0O07ZULBfPNlRK3DF+e8hhrLscQ7coVYMYE5fOz8Vto/x7hmlPskw/NMyeT/+ZCfXvsVp8vbHWoALUoy2eN4WHS37W/c/bLQw1HL6o0XrKBC61nennM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOpz7Cgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOpz7Cgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D13EC4CEF3;
	Mon, 23 Jun 2025 13:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684730;
	bh=zedNR3/NHmgljUtZWD9cnbSjUVNSShzktN1hlLiNm/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOpz7CgkwsMFW6TCwXUtJCqgl2xOqokvPWFQy79y9ajuAVZHRfXaoDAIqc3r20MYV
	 cJrR1o5deRY/hiR9jTckS/YdynXnA6ndhecaPolMuokN9PMvdY8MVz2ItEMgMFYpfT
	 2HvM5gb/0Jxi3pbNg7healjxtKwdFT12nLOiHu+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/222] ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"
Date: Mon, 23 Jun 2025 15:05:52 +0200
Message-ID: <20250623130612.419662182@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bec0bebc7f52b..763d4b8045110 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -42,7 +42,6 @@ static struct acpi_osi_entry
 osi_setup_entries[OSI_STRING_ENTRIES_MAX] __initdata = {
 	{"Module Device", true},
 	{"Processor Device", true},
-	{"3.0 _SCP Extensions", true},
 	{"Processor Aggregator Device", true},
 	/*
 	 * Linux-Dell-Video is used by BIOS to disable RTD3 for NVidia graphics
-- 
2.39.5



