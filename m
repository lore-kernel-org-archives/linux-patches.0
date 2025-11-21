Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0266334DB41;
	Fri, 21 Nov 2025 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733013; cv=none; b=EzZw3boq3ASwX8G4wWkROqV11mHW748vRxsk74bm4U0cKFPn99KssQGQfF3YHHSTL8N3iU6o2QcVdKEgAO1t1cK453jRTz2dzJweEVfI/OG6c8jP77JjNPJJWO/vrswV9XVwrcBVib+ZF2M3ucvVig9Gz5ApYskalZ4bmTBifY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733013; c=relaxed/simple;
	bh=UtMynFHEn7at+o5F/31uXgdcCguRSgikXYEO3wqo7FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ann7X5y1QAxoUk9On8ZOptYx+DjnQ+C7sOYGfJBDLQRbOUEHr7Si2wHNujr0E8l+skdLT6U5F7wrDXqM5WurNTARWw+t9ZQZddwWutSKOEvnZsJ7Wuuw2B/sfERi4mHF3U94y9XAL04SD9PQpftzVXqzs2lEzE6bNeYCEVCW4n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d53ue0tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d53ue0tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693C8C4CEF1;
	Fri, 21 Nov 2025 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733012;
	bh=UtMynFHEn7at+o5F/31uXgdcCguRSgikXYEO3wqo7FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d53ue0tZh6sMtGZhCYL+oDca8VtordVHj4w7pXacb6jcJmiTkc7bU9JNhFOGRgvJs
	 y0I+PK2DMV88Tldrvem6VX2Ys9C0wY+2mYrSQwZS98r42wVbps108kPeDAYL0gFuvj
	 3J+U+JRt+nog0zsHjO7T1mbb5homI1YaDBiUZQPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Dahl Juhl <juhl.emildahl@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/529] tools: lib: thermal: dont preserve owner in install
Date: Fri, 21 Nov 2025 14:10:20 +0100
Message-ID: <20251121130242.448543192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



