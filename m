Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644D815218A;
	Tue,  2 Jul 2024 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940977; cv=none; b=NKAE2YvnlwC8PNuLP7T56kPHcIxPLI+XthqX9xiFaidDlIVZMBbVfcqWMuhtDWBwfiDVfI7IsQScftWJylB9cr1qE4OoqyO9d/ZJvwZrfE1VA7QsdrpjdmnqmdZO+j+B7Pckb4mTHvkIglMuA+76uxD8tirmSDL/WTcefEklceo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940977; c=relaxed/simple;
	bh=IcKNDgVxNde2WNV4JMPeB0f8xlqoplJPdMYVEERD7Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm2YKb/uPGrpK0W56j1bqKKfuPUa/p8wx5oMihGLeDzwGQ/mBjg9IC90FuVgW8KcP1aYmvEdr+Jk4TBTmN7X7zhtLdzmF8XQzjkkRSLSKiX1lNDiZAlFcqOmE5dQP8tYrCqcvQUBp6+U+qlwuRnvY3PMbLB9rSIHMIz7nRWOxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBgp9x2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBgp9x2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7868C116B1;
	Tue,  2 Jul 2024 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940977;
	bh=IcKNDgVxNde2WNV4JMPeB0f8xlqoplJPdMYVEERD7Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBgp9x2VpcPv9q3nRs9sTKXJf8lRDxNGXiDcEzNZ3xlYZAwaQvklk7KmkgKFr8L99
	 gVH44RXU9XaZDe6n3urJ8kStIb8aHs4YjCeX6PJ0kBwv2skngMRdnHpReKs5X3R1P/
	 5fytLnJefhwPV278ggjXG7ybm8tCaVNDfTPUn43U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/163] kbuild: doc: Update default INSTALL_MOD_DIR from extra to updates
Date: Tue,  2 Jul 2024 19:03:26 +0200
Message-ID: <20240702170236.544835407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>

[ Upstream commit 07d4cc2e7444356faac6552d0688a1670cc9d749 ]

The default INSTALL_MOD_DIR was changed from 'extra' to
'updates' in commit b74d7bb7ca24 ("kbuild: Modify default
INSTALL_MOD_DIR from extra to updates").

This commit updates the documentation to align with the
latest kernel.

Fixes: b74d7bb7ca24 ("kbuild: Modify default INSTALL_MOD_DIR from extra to updates")
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/kbuild/modules.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/kbuild/modules.rst b/Documentation/kbuild/modules.rst
index a1f3eb7a43e23..131863142cbb3 100644
--- a/Documentation/kbuild/modules.rst
+++ b/Documentation/kbuild/modules.rst
@@ -128,7 +128,7 @@ executed to make module versioning work.
 
 	modules_install
 		Install the external module(s). The default location is
-		/lib/modules/<kernel_release>/extra/, but a prefix may
+		/lib/modules/<kernel_release>/updates/, but a prefix may
 		be added with INSTALL_MOD_PATH (discussed in section 5).
 
 	clean
@@ -417,7 +417,7 @@ directory:
 
 And external modules are installed in:
 
-	/lib/modules/$(KERNELRELEASE)/extra/
+	/lib/modules/$(KERNELRELEASE)/updates/
 
 5.1 INSTALL_MOD_PATH
 --------------------
@@ -438,10 +438,10 @@ And external modules are installed in:
 -------------------
 
 	External modules are by default installed to a directory under
-	/lib/modules/$(KERNELRELEASE)/extra/, but you may wish to
+	/lib/modules/$(KERNELRELEASE)/updates/, but you may wish to
 	locate modules for a specific functionality in a separate
 	directory. For this purpose, use INSTALL_MOD_DIR to specify an
-	alternative name to "extra."::
+	alternative name to "updates."::
 
 		$ make INSTALL_MOD_DIR=gandalf -C $KDIR \
 		       M=$PWD modules_install
-- 
2.43.0



