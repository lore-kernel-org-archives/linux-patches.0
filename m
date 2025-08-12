Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50E23D994;
	Tue, 12 Aug 2025 19:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025452; cv=none; b=j0G/H8hBl4IiFsmfEZDLLtHLaaMFHeb9ZLSawNCj17OANi+WRUnbCtFb/kvduBLfeEqaF/oirKIPIK4bh8R5sKh6erUqCWjyAJxdvM93HNoHOd6m4x8592tWGd6x7TJp344MHUMzx/eAeqA2FwdNM0TyRPdV4ZeuxVSQ9qrOU0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025452; c=relaxed/simple;
	bh=Q1ZHWEdJIw+xj/w32HgAXXtXvl0fWlqvSfTRabcum1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etJIli4xeczAjChUTB3C3CJO3RF0gp4UuxSYTZI4NR34ckJAzIC0K9RywuzzsQTMMcNs615oFQD8dhVbMWQFWxeXJ1eu80Ao++ILKWd3cO54TEAY3Vg6jowIARy0YBLdaF6O6uZF4VDjlLiEoUyb39cBLEthVCWWH0AgYKg6Ch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/BmK2q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/BmK2q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4F4C4CEF0;
	Tue, 12 Aug 2025 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025452;
	bh=Q1ZHWEdJIw+xj/w32HgAXXtXvl0fWlqvSfTRabcum1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/BmK2q7aPRGYI7X4+Xb+y06c5Uzrj7zcvo3WB3ioZ6LIabX3e9BpGJ7YzIZapB/X
	 43bwROg3bp9KK4rtiOMg6QYWdPKrjSUZ/KbCFfou+jD1kD7HAJHMETFrsGh9jT5Ksz
	 fwCxQaRBZUHAR5fc/W8oLvMLDNAB5IaT3pgQ5csk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 011/480] fs_context: fix parameter name in infofc() macro
Date: Tue, 12 Aug 2025 19:43:39 +0200
Message-ID: <20250812174357.771835979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RubenKelevra <rubenkelevra@gmail.com>

[ Upstream commit ffaf1bf3737f706e4e9be876de4bc3c8fc578091 ]

The macro takes a parameter called "p" but references "fc" internally.
This happens to compile as long as callers pass a variable named fc,
but breaks otherwise. Rename the first parameter to “fc” to match the
usage and to be consistent with warnfc() / errorfc().

Fixes: a3ff937b33d9 ("prefix-handling analogues of errorf() and friends")
Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
Link: https://lore.kernel.org/20250617230927.1790401-1-rubenkelevra@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index a19e4bd32e4d..7773eb870039 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -200,7 +200,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



