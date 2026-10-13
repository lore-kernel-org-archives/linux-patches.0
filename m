Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CE23F6C42;
	Tue, 13 Oct 2026 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894263; cv=none; b=MX0EQjzDT3/6FisPlyaKab4Dc5GbtYWK1yueiNmHv3xGsMAV/W1Pp90AuCVgINL1hETfZck6twe0FcZuCnX1ppoHJJbMVV4n/L8/Ue65qb3NNxtl1iROmDAQQYJLY1b518P3bxrfp2UYRPDhbSHHFOCRZQ4UlyaDFwVQLhrkKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894263; c=relaxed/simple;
	bh=AgPgTHhPaqoEXv2fdn+JaZvuVbENAyks/3RUizjxilI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUbX8NMjh1zQaUeChswxi50XO/OgxjQOfeTswvO5IIeOOGnciQZQ0Yragx0nCqFMAImh6arsMuopGuz+2mMtWVmq2Zddq4spAPkR9JglTRusYfKgCbF5Lkpryf8o43wEvH0TYCtfg9xl163vldJ/+khMxeJiIe2nf2n1OxSfXqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRyrjTAO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRyrjTAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B861F000FF;
	Tue, 13 Oct 2026 12:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894260;
	bh=diZ3tidk2l5UVhdV9ktq82/fuZfGFO5NO0DT2VvSPjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRyrjTAO9aRtXTacMQG+g089zh4xmVwAN6JcT25YIe3J/E/O2huSaWUU28aYlI70P
	 Indfa8Rca5yK4/aXxTDekGwYSrXpEfr1ZEmp5M74DYu1F0D1z36jQnqR8A80RKmgI0
	 ecBIoJ+gvP+7Z/fwTYTZIxGcPMa7s+yHA41HjkXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 484/621] platform/x86: dell-wmi-base: Fix handling of ultra performance key
Date: Tue, 13 Oct 2026 13:37:59 +0200
Message-ID: <20261013112932.318227564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit adfd6846bea13667ff28f8aaf00c32fbd69825ab ]

The commit message of commit 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
states that the ultra performance key contains additional data
after the type and code fields. The event data passed to
dell_wmi_process_key() is already parsed, so "buffer" already
starts after those two fields.

Use the correct index for accessing the first data field to avoid
a potential buffer overread.

Fixes: 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260612173451.467629-4-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index ba6c88e2a5ec0..1f922559e92fb 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -454,7 +454,7 @@ static int dell_wmi_process_key(struct wmi_device *wdev, int type, int code, u16
 			key++;
 		used = 1;
 	} else if (type == 0x0012 && code == 0x000d && remaining > 0) {
-		value = (buffer[2] == 2);
+		value = (buffer[0] == 2);
 		used = 1;
 	}
 
-- 
2.53.0



