Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC5A15B0FE;
	Tue,  2 Jul 2024 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940351; cv=none; b=bxK7AdFO+grFfkPYlM1m7End0V/Nvq5YqsxZkkMBmDjgVRrVPRntFRsEHoPtkBWQmFIJYo9NpfKHgDwiWN6+e+E1MXB5ONuakRb0ry7QhMJv7oO94zOKZjVwbCW7byaMgPkuV4oRlL7cM0hzjge5mG7bQOs5PO4K9T2TnPRSQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940351; c=relaxed/simple;
	bh=BJ515ChxV1Ba3PIJthzHAdQFkPYTLorsUFYjijEuK94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVBArNWfrrS8txXy/mbocpFtli+13pK1CIf6kKe6D/8ii11oKHHXAChqGrAss45N9E/mAo3g1j+Ra/oy4IFYwgthtGewuOoPu+A59L0eiHLBcTwK9DF7TS4Gcg1EapPd5l7xkojJM9PtE4EJvtKwckIDYqeyjvvl8PKqW+TbhrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgJ35raZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgJ35raZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5065BC116B1;
	Tue,  2 Jul 2024 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940350;
	bh=BJ515ChxV1Ba3PIJthzHAdQFkPYTLorsUFYjijEuK94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgJ35raZuO8mRJGlCk6WlZMdn7MnUQl0Y+Ogc4J9zv+HAwHlzJPdiBhsn5o3z8wlK
	 4Qwh2/KT8v4KQ1CQ2Nf5K0wFGlWwQvOlw7vGxfemudRhe3CMulfn++vagwCV/rYubI
	 yqb6CF+shtRHtNAaZbYOYeZth0m2JS4lXyC/BkCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 129/222] kbuild: doc: Update default INSTALL_MOD_DIR from extra to updates
Date: Tue,  2 Jul 2024 19:02:47 +0200
Message-ID: <20240702170248.901406118@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



