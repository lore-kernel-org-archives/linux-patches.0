Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C1817DA2E;
	Wed,  3 Jul 2024 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005455; cv=none; b=Tt7VJI/kPAvswg8HQLvzTumq3p+goy+o7ZvClbzW/0k97zeHILrnDVJxizqbQCox5Mh/Fa/Vb+NdDQ95cHCpmNkn1iEfiF1WznpCKF+iMhPMYxvPgv/IgSAhBUt7G4POmRWlYeSXyuVJN+gHZmT597MZow+47RpPN7ywHlSFcek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005455; c=relaxed/simple;
	bh=D9FTbvAv/drAdFoY5ZLpESZsE80X8j3BZvo6AIbiW5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz2Kcx+PeUNfb7Zxx7+FlhJZcAb2qPnxzg1TdvweHmbroVnC3/DB2cYXC4epQ+ueMQ3k+YLXkIvlN/BDX3Z4Ec7ZsYMJ3uta/4+WvNaooiGua58uv/auguyTqpmJxQSzKrNToaq1JflrwxR6k25f8lkwTV+HDIfQK3OWj4Cx3is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAwnWWp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAwnWWp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6854C32781;
	Wed,  3 Jul 2024 11:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005455;
	bh=D9FTbvAv/drAdFoY5ZLpESZsE80X8j3BZvo6AIbiW5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAwnWWp1h8xw0YNX/hk3QXyoxoAfesZJril4rYi/baQUHgZB5ZLDahvfa6Eslw4xd
	 8fNgYPQBUoiRHecbHhDoKq6VG0oV072v1oyJ1YQfj0IgwY/F6Fze6nutAZF1pdR9bz
	 /LEb6thgVwiDevx34sUd5LgH4Oniz56LcpAmbw/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/356] platform/x86: dell-smbios-base: Use sysfs_emit()
Date: Wed,  3 Jul 2024 12:37:03 +0200
Message-ID: <20240703102916.393565571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit bbfa903b4f9a0a76719f386367fed5e64187f577 ]

Replace the open-code with sysfs_emit() to simplify the code.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Link: https://lore.kernel.org/r/20220923063233.239091-1-ye.xingchen@zte.com.cn
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 1981b296f858 ("platform/x86: dell-smbios: Fix wrong token data in sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-smbios-base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-smbios-base.c b/drivers/platform/x86/dell/dell-smbios-base.c
index fc086b66f70b3..e61bfaf8b5c48 100644
--- a/drivers/platform/x86/dell/dell-smbios-base.c
+++ b/drivers/platform/x86/dell/dell-smbios-base.c
@@ -441,7 +441,7 @@ static ssize_t location_show(struct device *dev,
 
 	i = match_attribute(dev, attr);
 	if (i > 0)
-		return scnprintf(buf, PAGE_SIZE, "%08x", da_tokens[i].location);
+		return sysfs_emit(buf, "%08x", da_tokens[i].location);
 	return 0;
 }
 
@@ -455,7 +455,7 @@ static ssize_t value_show(struct device *dev,
 
 	i = match_attribute(dev, attr);
 	if (i > 0)
-		return scnprintf(buf, PAGE_SIZE, "%08x", da_tokens[i].value);
+		return sysfs_emit(buf, "%08x", da_tokens[i].value);
 	return 0;
 }
 
-- 
2.43.0



