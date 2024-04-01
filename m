Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652411E86C;
	Mon,  1 Apr 2024 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989578; cv=none; b=T33YkiIIPIDzIBshuGyuWvMhe3NHIPgo+h/6MuaEuoFjROISHL5lrklkCWU7eueIU4Pd3Zo13i/5eMn7H9Y2/lZC31R+iYjO/68vynjUjd6Q7VsIpM+xrym51sJUGuGd1yh+KTGQycXKbnBC4wZO6R3oNELznm5b9oGDUm0Tw8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989578; c=relaxed/simple;
	bh=Li3rMVHiVwxn+YQ5PpW9j9gWojv1k2xG2i5tqHCkDkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BsWLzOa+g1yActUI+s2vqqPQk4k7J2xz4vK7FYYRSatsASGCh+f+wfsw1GRL9jVkT3yOUYdh23y/zK4jFz1A054KKeJCB1MzBRCzeLU5rnw1C/wz3jWmB6IiOTIA6LAM4w/41NBgjTl75kNLheEhFN2+4ZIsPxVCFcZ0QZulmis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl4A5wGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl4A5wGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA02AC433F1;
	Mon,  1 Apr 2024 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989578;
	bh=Li3rMVHiVwxn+YQ5PpW9j9gWojv1k2xG2i5tqHCkDkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl4A5wGQ6KHlIJi+7Ukor3jnc/4jAFIkHaNnGO+bUeKZQUlpyE/eYIlsA9K71SlGQ
	 7iFtXcXwGDjwSylNS0eutIwoGbD7a0uFjxD6Ajd4iy/bcK1fujp565rZKTJuhgp996
	 iLcs55419vl5LemiA1cSQb+nbYclBBQuZA2P5e7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/396] docs: Restore "smart quotes" for quotes
Date: Mon,  1 Apr 2024 17:41:51 +0200
Message-ID: <20240401152549.772639647@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



