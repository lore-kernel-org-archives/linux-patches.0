Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4AD446AC;
	Mon,  1 Apr 2024 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988036; cv=none; b=buAmzEKyFBjbZFRIiBt5+++jvfaP27fcwR4kKRuIA029g8CT+5Z5yqXhhgI9pGWlm91VGFoMmtas/f44QttA77mT6TuB48AojA7kY5LiVTKMtiGg6BQusJTqOkhroU1ek22PS0yLP6pMCE0Xytja5hinr3BsnB/HWmhHxTBCcBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988036; c=relaxed/simple;
	bh=kVx7DZNudbLZP/xB3aBAYU7xuAzC/HtIAK8Bvyt/e8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL/JwEwkWt/XYpqYVXIkd9fkqake/6lj6hMhagBNr3VyzLOW7oDl0u6ct3P10kOVr9+Ljn7bmZ5izBnfbpkrZzNZvSnuNRIxSptQ++oKY2EJgWJ3lWYNIpHYoAWTMc6DWlsvk2+PsjbQcnaKKo/JTydi4FMsgCOAl9o1AHoBFlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5gphKzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5gphKzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B48EC433C7;
	Mon,  1 Apr 2024 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988036;
	bh=kVx7DZNudbLZP/xB3aBAYU7xuAzC/HtIAK8Bvyt/e8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5gphKznsolUTBUY7ERVaHzLosEQ54aTIEF3Y1rO7jXMP59bfx1DTiHtIDU54cuxk
	 5Nfvm1YONWm0W2lHsb0VKaajMFlaaY/nk2+8hU0lSBFUgy4V7B/80IIcQM5yF9k827
	 grFY1PekSWh6CCtlMrfyqKZ3vnV3xyYqm/IyiC8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 065/432] docs: Restore "smart quotes" for quotes
Date: Mon,  1 Apr 2024 17:40:52 +0200
Message-ID: <20240401152555.064168855@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index dfc19c915d5c4..e385e24fe9e72 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -345,9 +345,9 @@ sys.stderr.write("Using %s theme\n" % html_theme)
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



