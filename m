Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3A64CDEC;
	Mon,  1 Apr 2024 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986751; cv=none; b=TfgKVJnt0dcnpm8fctyBamDQXtzd+Xk6Z3aO5bSAoCuYz4aGGGpgJeJ/3vkxdyoKW/z7g/CYK2bTGyTMUtvCFB4tON5tI5DJ6ZM36/no4kw4EhSCfoE/tfzCI6ZMhchfGg+mAOj/ojYI0gh8wS/FHCXEPDnYKIE2ClMJui6uhjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986751; c=relaxed/simple;
	bh=uaQ6baqu59sMe6NhXpNsfK5N8cWQv6UULdM3AzZoRic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afBIG3oWoNYPGEvCX1KJAXwos5jA2ncSzsPE/fJ7qY3zXZSBRiFUK8BrbrrNI6pbfdrOQj67K9lK3vOqR8YQNenyb2Z+6uNyvJ9doxfjUubZu6qq7noSEkwXV5YxFXzZ2se4zuo7VkpgyckftFrO2gKzKH+yxrpfEIeZpj239Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGYA+Y1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGYA+Y1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5530C433F1;
	Mon,  1 Apr 2024 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986751;
	bh=uaQ6baqu59sMe6NhXpNsfK5N8cWQv6UULdM3AzZoRic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGYA+Y1l1Mx3PbX26pkxT9sWDhYrvrVWFJAN9/E2ZbBdfQpGMVm5Yzy/a/UxphVFP
	 89B/Phcdd+pGSKkWtld7kPS2pUplixayy4nZ6KXtqqhS5PDYED68rAUSHoG6TH7JSW
	 tcGjt97u3AUoEZ8PafaTJYyo6FghlY/Lz4SDDmZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 066/399] docs: Restore "smart quotes" for quotes
Date: Mon,  1 Apr 2024 17:40:32 +0200
Message-ID: <20240401152551.156773966@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Yokosawa <akiyks@gmail.com>

[ Upstream commit fe2562582bffe675721e77e00b3bf5bfa1d7aeab ]

Commit eaae75754d81 ("docs: turn off "smart quotes" in the HTML build")
disabled conversion of quote marks along with that of dashes.
Despite the short summary, the change affects not only HTML build
but also other build targets including PDF.

However, as "smart quotes" had been enabled for more than half a
decade already, quite a few readers of HTML pages are likely expecting
conversions of "foo" -> “foo” and 'bar' -> ‘bar’.

Furthermore, in LaTeX typesetting convention, it is common to use
distinct marks for opening and closing quote marks.

To satisfy such readers' expectation, restore conversion of quotes
only by setting smartquotes_action [1].

Link: [1] https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-smartquotes_action
Cc: stable@vger.kernel.org  # v6.4
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20240225094600.65628-1-akiyks@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/conf.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index da64c9fb7e072..d148f3e8dd572 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -346,9 +346,9 @@ sys.stderr.write("Using %s theme\n" % html_theme)
 html_static_path = ['sphinx-static']
 
 # If true, Docutils "smart quotes" will be used to convert quotes and dashes
-# to typographically correct entities.  This will convert "--" to "—",
-# which is not always what we want, so disable it.
-smartquotes = False
+# to typographically correct entities.  However, conversion of "--" to "—"
+# is not always what we want, so enable only quotes.
+smartquotes_action = 'q'
 
 # Custom sidebar templates, maps document names to template names.
 # Note that the RTD theme ignores this
-- 
2.43.0



