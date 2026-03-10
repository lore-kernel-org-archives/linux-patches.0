Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A22D24B7;
	Tue, 10 Mar 2026 11:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141120; cv=none; b=CBYWYuTqIp6gpG57EaUqiWSM12SoDSxqix23JKZ9M3QP80RbBnjZ41teFCez9Gv/bmzlVyfYvwL+g9SKKb2IZqMTyIknwUDfgPScVodynVbHLyi8VUuWnG1vTrxQMo68x+NReyWZ+I7nGtlvpcBcDF6IXttwtl8H62z6opTHnzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141120; c=relaxed/simple;
	bh=ekmfVpfFkeT/x9Bls5lRxgfdW8GDZSZ417PXPDKtKCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KImZEpsViqYazXmtE2bgHj5DEr6HV+y8xb8WE5PMUr6+izVHK+O8fLaDkPiGebANhPA+0km0cTMYWXY/lHBDDzZ4MJxyzbmUgmtxEUxg7YNxg9yntOmNmj/VEaUUuBUWeW4j5+C+Ry9ZHQPm/kJSzajDedv+eO2O3C0uu0zjkXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6C7hl9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6C7hl9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC9AC19423;
	Tue, 10 Mar 2026 11:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141120;
	bh=ekmfVpfFkeT/x9Bls5lRxgfdW8GDZSZ417PXPDKtKCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6C7hl9lRhlqA7f9aKEqyJMzAwHtPADtZQvKdo3j9q90FJnTVkyHyAcTe9I5dbDwB
	 x534Wc7iGMQ+EpZYKQ3j/8muSfpa46eXBpIfJmVZepQ6fBMNCvfgw/214nvBtEL8vv
	 RwquKdHDOJrXj9QHzGnBiKPhRkbFeANOLW7GikReEELtHs5p5ywJrdKAkNC16hWVHb
	 59kPkRQSJ8qGoQKqkflt1c6euYDn4nTESArTgdyUCDjHxX3GEmbFyWLDQxXvSQv1Ms
	 wZF0CBFDJeGLywKoLSPeQ7fUtYSAVzbJY8m+2i++EhjbrSQh6OekUAHD+kgNP97M2G
	 VED6EAmRwX69w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kurt Borja <kuurtb@gmail.com>,
	Olexa Bilaniuk <obilaniu@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 122/311] platform/x86: alienware-wmi-wmax: Add G-Mode support to m18 laptops
Date: Tue, 10 Mar 2026 07:02:49 -0400
Message-ID: <8ce5849acb47c3b81074392457e2cdd58b6bfeff.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kurt Borja <kuurtb@gmail.com>

commit bd5914caeb4b2de233992c31babccda88041b035 upstream.

Alienware m18 laptops support G-Mode. Therefore, match them with
G-Series quirks.

Cc: stable@vger.kernel.org
Tested-by: Olexa Bilaniuk <obilaniu@gmail.com>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20260129-m18-gmode-v1-1-48be521487b9@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/alienware-wmi-wmax.c b/drivers/platform/x86/dell/alienware-wmi-wmax.c
index e69b50162bb1b..d1b4df91401b1 100644
--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -175,7 +175,7 @@ static const struct dmi_system_id awcc_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18"),
 		},
-		.driver_data = &generic_quirks,
+		.driver_data = &g_series_quirks,
 	},
 	{
 		.ident = "Alienware x15",
-- 
2.51.0

