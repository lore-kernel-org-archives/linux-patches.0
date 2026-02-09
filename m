Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A29B2BCF4C;
	Mon,  9 Feb 2026 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648563; cv=none; b=sIB+PnaReUzbU1tAZolmrGydI/1m8KL/OjdruD2kO1hfmsmhkJn2/THA+KpkWm9BIZz5tUvzT+9taP/3YOabIPGTIngFVoXG3hGWHQYBbzM0LAFGL5E4tIKVnbdNTSDjuUpkPgUcUV+50Tkj0IqcFb8LWUBFzkf/KnZt/ytfwe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648563; c=relaxed/simple;
	bh=m0xnBI7pmWDRuhnh2KQ7J+5f/+FS3fET22UNnKPugbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kBuOVfZ4bQjMyDGgcas9SqQL7iRAUkXuRclaOzhIJMCcmM72P+ctY+6gRDtBhV0z6ATdoHWbBynvtTD2z56N8au1TSlhujEnixCP01RgXl5WGD7sqXtSxwKEoSed73tUnqO103bhIJLBE3k2NTDp8cmeNWSuohP3D0G0KOdhRXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UODiQzx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UODiQzx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0791C19422;
	Mon,  9 Feb 2026 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648563;
	bh=m0xnBI7pmWDRuhnh2KQ7J+5f/+FS3fET22UNnKPugbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UODiQzx93cJVsBsMNOJuhRUvg31kSHtbfI3kYsKfg61enXpoAcKkjWJcrSJaJkfkl
	 Y40kPQmTVmDOC6ELQ2TUSF0o6GksjpBXTIs2NjW+CBPniKZ/porh1bMGc7QUMIx66o
	 8Fwv3kmStgAU8b/MconWI3gZ3QOb8I/JEu6MMplk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Cousinie <alain.cousinie@laposte.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/86] platform/x86: hp-bioscfg: Skip empty attribute names
Date: Mon,  9 Feb 2026 15:24:21 +0100
Message-ID: <20260209142306.866358404@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 6222883af286e2feb3c9ff2bf9fd8fdf4220c55a ]

Avoid registering kobjects with empty names when a BIOS attribute
name decodes to an empty string.

Fixes: a34fc329b1895 ("platform/x86: hp-bioscfg: bioscfg")
Reported-by: Alain Cousinie <alain.cousinie@laposte.net>
Closes: https://lore.kernel.org/platform-driver-x86/22ed5f78-c8bf-4ab4-8c38-420cc0201e7e@laposte.net/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260128190501.2170068-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index e9bade74997bf..ec7a74bee803a 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -701,6 +701,11 @@ static int hp_init_bios_package_attribute(enum hp_wmi_data_type attr_type,
 		return ret;
 	}
 
+	if (!str_value || !str_value[0]) {
+		pr_debug("Ignoring attribute with empty name\n");
+		goto pack_attr_exit;
+	}
+
 	/* All duplicate attributes found are ignored */
 	duplicate = kset_find_obj(temp_kset, str_value);
 	if (duplicate) {
-- 
2.51.0



