Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDF218C334;
	Fri, 27 Sep 2024 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440287; cv=none; b=spMzPF8SnFVE+IBDB/POcnpSEgbp4slkCWYQ9/wmso8sAdMjFGI55jH6cKie11xXRDQ48r88BapbdvmiAXnKO3VrPnHdsVzhM8+0r8A9WfRvF3IALeNVRdOnMmoVUbh/kaEUPPaK8kQr3UwuX78fV9B4LdR3uw3lkgLDkdVLvkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440287; c=relaxed/simple;
	bh=djND3ORVabGT9RxN4QWB7e7dkiDPkJOffUwHQRMqvFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBeaPUvnBAnSbP/MFqyKJWtZwd1hVAxBKwz1maqRCxVuWOWzYpcZPr9aG9fTGejSUsfWh9W7leUvTtA4E/vWGVjYMnl/ax7i1HZFQSG+8KTf/bsMDtGwKc3D82bAmlK5VHPYEB+A0xA9jocMcBVzVuBA7daAOGXTRQYyZkbHUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHA2Kgrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHA2Kgrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C66C4CEC4;
	Fri, 27 Sep 2024 12:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440287;
	bh=djND3ORVabGT9RxN4QWB7e7dkiDPkJOffUwHQRMqvFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHA2KgrlyL00ECK8jOcasW+DaHy74Qq0JYlDQM4qXpjR3Wt3WHJ0Tlgqo0culIdUy
	 sCrdhhjtUYLMcK4yeupMOEN6pzWrbaBBeuIFHdMVgBoLSvOAqb4EMnTqS+YLDNxtEJ
	 tBm1Q4uHBX64crufyHuKgc2Mw1OgeGielnCso3a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/73] tools: hv: rm .*.cmd when make clean
Date: Fri, 27 Sep 2024 14:23:38 +0200
Message-ID: <20240927121720.991898051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



