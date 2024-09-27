Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B3318BC29;
	Fri, 27 Sep 2024 12:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440011; cv=none; b=M6RWC9MFSv082/Au1zq6/E1deXE5oFUKrJE9MRCowMvBXA+CEktqN57vlkPBrPHVvDc6DE3scE9mfT2LQiAYdRypsgJv3QnfvONc7CkmlxbcThg4N+vXHWYTwqZQcMkuVNf7RtKOw1/Ze5npbneI51coNG5pUULAI5MXMmcJVXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440011; c=relaxed/simple;
	bh=p7a3UZJq26pqK/yVpD6c2J7YyURpGC9NhRsY1HGt9kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffGhKREF0wZvWeFhnjK+3ej1EXxQKvJ4NWFykr/Z9FmVrbtE58VuBzx/Tdp87Bv3PEvu51wlPoxew6hMki1OJTMmzxuumKerlIZRVcIGyCRqpsP9wFujyHXwS+VpsAzY+YCdlX0KIzwJwskXteoHVUQT+H0lsQncvzqu2gF2frI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+xWn0Ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+xWn0Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD6C4CEC4;
	Fri, 27 Sep 2024 12:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440011;
	bh=p7a3UZJq26pqK/yVpD6c2J7YyURpGC9NhRsY1HGt9kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+xWn0Ed52i3yQYk1mpwbsiKT1qsgCGtyMg5sQUDZgTQLh4sELxq0YPkyF2mIVles
	 3KsTQwiLA8GQ07PxhXSrsgl4z0mLGBl+jklftMW1pwAOpsQaUdNArbEB6O9Gfw6Xgz
	 WXrmr8PC692ODLNzhTkgEFHTNNtjdEnN00HaQ5OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/54] tools: hv: rm .*.cmd when make clean
Date: Fri, 27 Sep 2024 14:23:26 +0200
Message-ID: <20240927121721.128097678@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 5e5cc1eb65256e6017e3deec04f9806f2f317853 ]

rm .*.cmd when make clean

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240902042103.5867-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240902042103.5867-1-zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/hv/Makefile b/tools/hv/Makefile
index fe770e679ae8f..5643058e2d377 100644
--- a/tools/hv/Makefile
+++ b/tools/hv/Makefile
@@ -47,7 +47,7 @@ $(OUTPUT)hv_fcopy_daemon: $(HV_FCOPY_DAEMON_IN)
 
 clean:
 	rm -f $(ALL_PROGRAMS)
-	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete
+	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete -o -name '\.*.cmd' -delete
 
 install: $(ALL_PROGRAMS)
 	install -d -m 755 $(DESTDIR)$(sbindir); \
-- 
2.43.0



