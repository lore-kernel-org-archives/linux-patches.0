Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC21CFA9;
	Tue, 27 Feb 2024 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040885; cv=none; b=m8mP74VquW2BZBeih5bv92jQNa2fGY1VmHotAFY8UdcGlAj+E98lv9jNOwzvUwfbVwTlMBjYwFaSgwNIqB+3ydcnu4SFG3kWu0mMl/GmOU7vKwyyXMy3G+nKd+uyHdegZkhAFKCKyCR4zNoOWMS3NhLjElrRZn/6KBVrLCT5/4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040885; c=relaxed/simple;
	bh=7b4flmXNTcTrUlCo/hflOx612je4k3vYyjtLuc0w/Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPGbvtfIF/UThE8cFfuauYBGx8XQnqhTuDsjR4aRNPnJah3bRlNGYdEO1AV79Bi/Tk41Fc0JltaV3r8gCwVN3HIDGLE92JPw16i7aBTE2p6s/HkgzsP4RG9efMx1O0LHG39mUsr4KM7BwSX1fGpjCLcLl66upW4TtcmZjVcmgeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=firuoonl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="firuoonl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D01DC43390;
	Tue, 27 Feb 2024 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040884;
	bh=7b4flmXNTcTrUlCo/hflOx612je4k3vYyjtLuc0w/Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=firuoonlN2dVr1BEwP9Ooq6sQOddSJMRhWFIC0PJKjD+/D77QqeskjsHuowQeLQ44
	 /vsSwOIPbfq/54J0hyJWYOU1DwvU6vNz0RtwbMNcIb2RbJsiMZpXLIdqCLTt7lghJH
	 nH5F0pKhPhBbYMxGff51qrRceBsjel8QKStd3PFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.7 143/334] docs: Instruct LaTeX to cope with deeper nesting
Date: Tue, 27 Feb 2024 14:20:01 +0100
Message-ID: <20240227131635.071069568@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Corbet <corbet@lwn.net>

commit 0df8669f69a8638f04c6a3d1f3b7056c2c18f62c upstream.

The addition of the XFS online fsck documentation starting with
commit a8f6c2e54ddc ("xfs: document the motivation for online fsck design")
added a deeper level of nesting than LaTeX is prepared to deal with.  That
caused a pdfdocs build failure with the helpful "Too deeply nested" error
message buried deeply in Documentation/output/filesystems.log.

Increase the "maxlistdepth" parameter to instruct LaTeX that it needs to
deal with the deeper nesting whether it wants to or not.

Suggested-by: Akira Yokosawa <akiyks@gmail.com>
Tested-by: Akira Yokosawa <akiyks@gmail.com>
Cc: stable@vger.kernel.org # v6.4+
Link: https://lore.kernel.org/linux-doc/67f6ac60-7957-4b92-9d72-a08fbad0e028@gmail.com/
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/conf.py |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -383,6 +383,12 @@ latex_elements = {
         verbatimhintsturnover=false,
     ''',
 
+    #
+    # Some of our authors are fond of deep nesting; tell latex to
+    # cope.
+    #
+    'maxlistdepth': '10',
+
     # For CJK One-half spacing, need to be in front of hyperref
     'extrapackages': r'\usepackage{setspace}',
 


