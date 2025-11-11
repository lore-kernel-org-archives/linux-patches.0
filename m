Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A15343D6D;
	Tue, 11 Nov 2025 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824657; cv=none; b=FPOscq4YE4cGAbFwcbImEY8TmjzlaOs6mPDaOPIXDTC9XL2LDNXE0e5CaFGFJIO1EqKv8M0oM5jMfbTQnyvAkZS74lc0afQqRp0JSsvbYLkI/Tw3Hkpe/1yMVNyPvlpTIJ8bUAY60T8M4bBoy99qjxo0HGfmpBzuHoMI6pvi/74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824657; c=relaxed/simple;
	bh=buFIL69bNZOu6JQWyMwJCrK9z+t4SpsHt5ZZgqy6agM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTfVKDJKuUClW05dCSxw7Js6fF6r+bPTMjyj/fUfhSKhMbZCPHOXLovwysP542CeuGTuA+1sYDAq+beelEBVngdjC/HhPGWC5o7Udsb3xAEKYQ6KFk5sznm+9Zee7uTjLRqI2SQwtH2tf8Z+M05z36+6CrboddteQCSI5v1I7DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFfBoHha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFfBoHha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B233C4CEFB;
	Tue, 11 Nov 2025 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824657;
	bh=buFIL69bNZOu6JQWyMwJCrK9z+t4SpsHt5ZZgqy6agM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFfBoHha39f6rXnQbMAm+mjXplxgmvdwmzyGtCxWxhFajUdaKxWX+usBZzrVcyYEC
	 ScZ9T+1uD5GPPsGGLzzdsI8PrPSN8zbdiEh2vPNPkuR0DFxHLTlTUoksqPhTxU9kKa
	 Iy2jEBddA9Kn20R0oO1xIVvIYwG4cC7A/E8drqOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Dahl Juhl <juhl.emildahl@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 484/565] tools: lib: thermal: dont preserve owner in install
Date: Tue, 11 Nov 2025 09:45:40 +0900
Message-ID: <20251111004537.814876591@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8890fd57b110c..1694889847caf 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -147,7 +147,7 @@ endef
 install_lib: libs
 	$(call QUIET_INSTALL, $(LIBTHERMAL_ALL)) \
 		$(call do_install_mkdir,$(libdir_SQ)); \
-		cp -fpR $(LIBTHERMAL_ALL) $(DESTDIR)$(libdir_SQ)
+		cp -fR --preserve=mode,timestamp $(LIBTHERMAL_ALL) $(DESTDIR)$(libdir_SQ)
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-- 
2.51.0



