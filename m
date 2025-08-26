Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8CD340DA4;
	Tue, 26 Aug 2025 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214633; cv=none; b=hRUwHX/qCWGSGY5QVmk1GdkfOjD3qQEHNHf3IAh0jZ6626SE5UlupWbyOxaAJbxeKZMfvRPtR/CNseIJIgqORov9hL9OX9bLG+HofiEf5yzvwa2lp25QfO+YcFMPwXh3oN3nmdKv2Ue7U6oYqjZSIbjtmtrLPKI6gYYHb6IBIaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214633; c=relaxed/simple;
	bh=OcGDKtW9vuFaI31DZXX9+EXmWQ+EsvgT/6H4RDW/Kp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcjwnsv4ZwaGhyOFsNaU/Du635pTsVSkbLPtgltuyOa1B/aU8DKlIKkwZfkfDj7zSLpCI71hAU2nmJc6nM/R2S8MLAcaCM92+xI0rUK3l84CcifN5v9uWANIHID+5oR/3B4Q7sf2d0TLkytbEy5FcmfU/1qTe21uNPJrs3xydrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s94zxi7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s94zxi7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD3FC4CEF1;
	Tue, 26 Aug 2025 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214633;
	bh=OcGDKtW9vuFaI31DZXX9+EXmWQ+EsvgT/6H4RDW/Kp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s94zxi7JXjQ0MxokQdduk3/YBg7vZ7m2oLpi708TsCn1aLzuRDr2TdGLPTg24HV9D
	 CguT3p2FC+h5KHQHBOTNoZA9XDgQjOzfsrF6/pWOYbAdtFkjYewFYl26ekHoj/R1v+
	 AtyEjJFmziJE2elvjfoailsVIGTnAXGy7vlfhOCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/482] i3c: add missing include to internal header
Date: Tue, 26 Aug 2025 13:07:43 +0200
Message-ID: <20250826110935.968732652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 3b661ca549b9e5bb11d0bc97ada6110aac3282d2 ]

LKP found a random config which failed to build because IO accessors
were not defined:

   In file included from drivers/i3c/master.c:21:
   drivers/i3c/internals.h: In function 'i3c_writel_fifo':
>> drivers/i3c/internals.h:35:9: error: implicit declaration of function 'writesl' [-Werror=implicit-function-declaration]

Add the proper header to where the IO accessors are used.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507150208.BZDzzJ5E-lkp@intel.com/
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250717120046.9022-2-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/internals.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h
index 86b7b44cfca2..1906c711f38a 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -9,6 +9,7 @@
 #define I3C_INTERNALS_H
 
 #include <linux/i3c/master.h>
+#include <linux/io.h>
 
 extern struct bus_type i3c_bus_type;
 
-- 
2.39.5



