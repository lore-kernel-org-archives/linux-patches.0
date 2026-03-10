Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590B1387587;
	Tue, 10 Mar 2026 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142025; cv=none; b=V2Heo2n+f1AkOXRrfEkAxvPE9GRMCRoDfIDYGq0CBUdwYREbVMXXmGrZcBFWSj8oLXBCinwXfgmYJ4sjrZJOJdpzLD2smY7qs/BMNloMRI8AUrT6wOB/RA1qab2abEf9+v8NJMJmyDBhOcrGuxCsu+lOtNboaM+yM7yQLWbQrC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142025; c=relaxed/simple;
	bh=MO+DTedvHfeYd+fOzqnm2kL95nJK7R6tAgaybookIcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L6X5mqQeY+w+5FKBotTe9UyD/lZYZ2JjWYUQBneweI2Jkh9afR1iz9dlLvHk3nG7XZ2aY2ZFKx7IcTwrCcMzVidaHPSxAhPwXv1H6FFMXQvX8nA0eYupvMWeNk7QQ8bVzM0Fh/c1BrCviGSLbnW6dSGQGq/ZJPM49x2oW7BeCA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEIiffkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEIiffkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE43C19423;
	Tue, 10 Mar 2026 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142025;
	bh=MO+DTedvHfeYd+fOzqnm2kL95nJK7R6tAgaybookIcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEIiffknpV97CoUp/EBncfi6FeZLB66R18jiZCwRY5syhQeunI5p5B2LC5YbXk1WJ
	 e15Meqgw2zX4/vVXD5kLexU9IfbvD559ybnInFxiLqxtp7Iq+1YT63j/DVic5nu9tI
	 OfABZuxLxNvDnC6Gko8/b10LBiRYOYLN2YCGTaAmeH5qgyYTimhcMhZ4IC2jOH6q8l
	 2FivO9DF/rsnp2Edgeu25sAxCwSeJB4S9cz8YQwx6E0uLsmtgtnn2ob9X9HgLM5f6h
	 urUjhr25yv4zO8v/FwMC18kUwfVRmqYdh9L1j51RKzKhOlL7rp9+2i/LeZprLIbRVJ
	 6cPdb0JIwSKEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 151/314] platform/x86: dell-wmi-sysman: Don't hex dump plaintext password data
Date: Tue, 10 Mar 2026 07:16:50 -0400
Message-ID: <5cb9b9a6bc26be66e85548835464758aa7b058eb.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit d1a196e0a6dcddd03748468a0e9e3100790fc85c upstream.

set_new_password() hex dumps the entire buffer, which contains plaintext
password data, including current and new passwords. Remove the hex dump
to avoid leaking credentials.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260303113050.58127-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c   | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c b/drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c
index 86ec962aace9b..e586f7957946b 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c
@@ -93,7 +93,6 @@ int set_new_password(const char *password_type, const char *new)
 	if (ret < 0)
 		goto out;
 
-	print_hex_dump_bytes("set new password data: ", DUMP_PREFIX_NONE, buffer, buffer_size);
 	ret = call_password_interface(wmi_priv.password_attr_wdev, buffer, buffer_size);
 	/* on success copy the new password to current password */
 	if (!ret)
-- 
2.51.0

