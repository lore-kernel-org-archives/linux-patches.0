Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D9C1A4F3B;
	Thu, 15 Aug 2024 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732945; cv=none; b=Eyf9UjoKbbFbuv8TljQTu+V8T9Cq1LHjwzhQMEMlrYvhBb3wC9g1VTZzVxOrOm5YWlIW1K8LsKGs8Um4HXn2uv2jqnijdnDmp5mi/2F46CkK1wg78sm9o+VWgl616Vt6i7OjIQBXJYBHmfgnyO+TYrSkvhwqSUB1kLHSid3d6fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732945; c=relaxed/simple;
	bh=RRTmiSLN2Z0o3Y3T+VN7CoFpg43YSGeu/zxffhnhlO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUxj8VsUQ45Z8g4CkJd09uEOaFG1+OzexqSZtlnCqkqSfOkGq0lyfd0KYQoF1XbhELYtaezXnpeLofzsoQBFJO+8ivDVot5UyDEkIEVNgfzBzCVPeBDXPL47jKmp8VyAENLWZwPoWscuStTQ+ngVSvvA7Xa51BqZOR9F9pG5K6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqRqma1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqRqma1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23DBC32786;
	Thu, 15 Aug 2024 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732945;
	bh=RRTmiSLN2Z0o3Y3T+VN7CoFpg43YSGeu/zxffhnhlO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqRqma1g+FKhZrBTkyb//0vxKGSgWNBWONBkXJOd7a9zEfagYWN6tJTY++RZaKepu
	 0YfsKodWBYthYy1RykSKe5g4uXNXbEF+zW2kLqL386D+Uvz3NL/r6IWCrQQ/T1pYBV
	 fotRL4GUGVzpAKxuYyzLG8/pSsNGLf/NVAuOqtUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 335/352] samples: Make fs-monitor depend on libc and headers
Date: Thu, 15 Aug 2024 15:26:41 +0200
Message-ID: <20240815131932.409254875@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 8fc70b3a142f97f7859bf052151df896933d2586 ]

Prevent build errors when headers or libc are not available, such as on
kernel build bots, like the below:

samples/fanotify/fs-monitor.c:7:10: fatal error: errno.h: No such file
or directory
  7 | #include <errno.h>
    |          ^~~~~~~~~

Link: https://lore.kernel.org/r/87fsslasgz.fsf@collabora.com
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -122,7 +122,7 @@ config SAMPLE_CONNECTOR
 
 config SAMPLE_FANOTIFY_ERROR
 	bool "Build fanotify error monitoring sample"
-	depends on FANOTIFY
+	depends on FANOTIFY && CC_CAN_LINK && HEADERS_INSTALL
 	help
 	  When enabled, this builds an example code that uses the
 	  FAN_FS_ERROR fanotify mechanism to monitor filesystem


