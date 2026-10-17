Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313D72C026C;
	Sat, 17 Oct 2026 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260267; cv=none; b=TxyWmR33eYrmrhefIAvLALBAOzqwu6+begsE4JmViF8xUXLz88oG6+vf9dEyEDvZ1yEVZJINCIsv0Kews+I1mg1Dqg7PpmJicNueZrf6bhecjho7AW08ka81P8Gh2nFaIh5pFMNMqZYRSc+Xucde6TNUeUlf1xGRPatWHJCJzbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260267; c=relaxed/simple;
	bh=HdzV17VlcMWQOnsUjrAwuBXWUcP8LDVmjAqVL+B7/p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHmTaehzXopqpABj+4BcmY3mKV3d6mQAvQv9WyTu40p+T2mmYD14l7R7hSQaZ+CsHzdQfaSEa8Yqy1ai2H1LsVskeoi36+NYBEUr3sF/vpfaSKHk51DaQTUu+ynTDmSYX1BbniERL7ul6KZ6yVL/eizX8oPXFup+JCe93a95fyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwfGFXbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwfGFXbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893781F000C4;
	Sat, 17 Oct 2026 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260266;
	bh=qyHbMHO7k+Cwia+c7L/dHeJafF4xs1KR/mYGm9JvO0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwfGFXbqC7WSb3ZZwJAFSrRJKTIk4GOpLDTIV6ktiLi71K/kFpfCO+N9M369dwFRK
	 StZUghJu3wMdXfG599aguo6buc/rLgBsopC8955X7cxOpvC/l48tiELZpqLAesP5kA
	 8kKL2L4SmKxLmAeo5M9oXS/emcC/U7io38qc2jC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1487/1674] platform/x86: dell-wmi-base: Fix handling of ultra performance key
Date: Sat, 17 Oct 2026 18:02:39 +0200
Message-ID: <20261017160509.318032975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 713ec2c12a04e..4838992ee5f99 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -442,7 +442,7 @@ static int dell_wmi_process_key(struct wmi_device *wdev, int type, int code, u16
 				      SW_TABLET_MODE, !buffer[0]);
 		return 1;
 	} else if (type == 0x0012 && code == 0x000d && remaining > 0) {
-		value = (buffer[2] == 2);
+		value = (buffer[0] == 2);
 		used = 1;
 	}
 
-- 
2.53.0



