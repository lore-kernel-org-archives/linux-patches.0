Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B537D103;
	Mon,  9 Feb 2026 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647944; cv=none; b=HDJ6+Xiuk8pU31ilP4W/v1/5CU8ZJl7MhhlGeTYbaKGF9Eeh9iYDdcngLuOVxI6Dy9fkXADu0FcnHJcvDS5nlFWypH2FRZ8Ei/cebJ7zW5fV9TO+hd/nQ7h7zDF2xeCXoSRODygUxqzjG/4FECfjPk9c35APp3aRFqWleeKXW7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647944; c=relaxed/simple;
	bh=FZPNG9XEVk7cqQEnqFVz1dQuYagDEc2fdduWaJw8O5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urCeagOa/ewz9ZsVum2SWkCGO+ViS6evT8eU2iSmvY+FohRVjHEDpuq2Kr8JqdZz7jiEY8rI0eGC13rpndhQE7f89AQs5HShDk20A91LI1OridQvdh4Hxh60jXZQdrnBgKq6/eckycJJYQTP2u94QKcyGmc/IJdy9qCfaQYu1M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdDHzobD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdDHzobD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4D4C16AAE;
	Mon,  9 Feb 2026 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647944;
	bh=FZPNG9XEVk7cqQEnqFVz1dQuYagDEc2fdduWaJw8O5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdDHzobDSPHv56fd/Fi+LOH72Zznkja4uATyhfk7hm8pyFQKBSq8r60e1L9p5EcFt
	 8aGNaHab16dLykn5EdMq/pH3S8o13/ib8ALJ8eNk3vDiYLd7noenSQQtMV+Lqk8Hnc
	 SmbHJjYRD6lGYTpabJwJYZ0mJNYyqy4tWW7jtVe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Cousinie <alain.cousinie@laposte.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/113] platform/x86: hp-bioscfg: Skip empty attribute names
Date: Mon,  9 Feb 2026 15:23:44 +0100
Message-ID: <20260209142312.881185987@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 405b248442ab0..3571780f5ef89 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -699,6 +699,11 @@ static int hp_init_bios_package_attribute(enum hp_wmi_data_type attr_type,
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



