Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97873126A1;
	Tue, 11 Nov 2025 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825241; cv=none; b=ZqLzJ835iOk1BWEaCKvf2yvh29QeptJ4k1j1jj4tGaZhR8oacI4u9ra1L3hUN0ORR8iHcUZF73Ub6RDadY2Fr8XBtAuGmq20hde09AFmbT1Osq6N2TllANpKw9+gBRA6mYnVJ65gAnLhHh7vQViIfMvYV/H15gnQz1gseDpeOmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825241; c=relaxed/simple;
	bh=soSyhefjvtpCJN3/Z+v4m1tprzhk3U7tRJCyNxpL/Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej56AxVqix4M94UXJASS2puODcArUJ1KBHJAkMuxQPMFcCYuV2c8Cmx+giqKLmdKSvwC5H6Lf84LUk8NODlhTg/CDAmudoBPMPjZHLtzFQD9s3Jettw4zd9DUlsL5UuDVIv8XP3Iw/9aMFGaRF5DFK6KfZ2plSdiAPE9Erwn1dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJLaN0bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJLaN0bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D3BC16AAE;
	Tue, 11 Nov 2025 01:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825241;
	bh=soSyhefjvtpCJN3/Z+v4m1tprzhk3U7tRJCyNxpL/Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJLaN0bw57V97n1HblcaJ2R2H6lWPBkBFIAvER3+3Wp/SBPnrrzjHgvKoOWgQw6FW
	 cqipA4o6fZ7OLgecyzSIThuSI1dmaQw7QBsfFTFfUARZjVB3/pfJvEY0LUYxC/4CXV
	 RqXkUi8Udof7i/OkxIbJSrQFJg0XJ8eIMkaQ8Bpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Dahl Juhl <juhl.emildahl@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 721/849] tools: lib: thermal: dont preserve owner in install
Date: Tue, 11 Nov 2025 09:44:51 +0900
Message-ID: <20251111004553.864963227@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Dahl Juhl <juhl.emildahl@gmail.com>

[ Upstream commit 1375152bb02ab2a8435e87ea27034482dbc95f57 ]

Instead of preserving mode, timestamp, and owner, for the object files
during installation, just preserve the mode and timestamp.

When installing as root, the installed files should be owned by root.
When installing as user, --preserve=ownership doesn't work anyway. This
makes --preserve=ownership rather pointless.

Signed-off-by: Emil Dahl Juhl <juhl.emildahl@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/thermal/Makefile b/tools/lib/thermal/Makefile
index a1f5e388644d3..ac918e98cd033 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -134,7 +134,7 @@ endef
 install_lib: libs
 	$(call QUIET_INSTALL, $(LIBTHERMAL_ALL)) \
 		$(call do_install_mkdir,$(libdir_SQ)); \
-		cp -fpR $(LIBTHERMAL_ALL) $(DESTDIR)$(libdir_SQ)
+		cp -fR --preserve=mode,timestamp $(LIBTHERMAL_ALL) $(DESTDIR)$(libdir_SQ)
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-- 
2.51.0



