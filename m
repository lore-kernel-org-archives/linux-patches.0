Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E93101C3
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BE3C433C9;
	Mon,  3 Jul 2023 18:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410562;
	bh=etqMsFn4RSS5ug2q9deNG4dwM6wEb7mVP8RpGSIbIXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwKfvRbSnbkilPFXQXXgAUiJkv4WYK11maEAN71ctt7W5SM53IFcYJiQGFSnBraJm
	 8EHMT/+bP+DXfpUvluYug7LVbmVhU8shzPGmMTPA27Rd0PAh2Y7N0WffRzbrUW5ys+
	 ol/CMQwHgS22OvkXcNqV4YiWr+GSPnYvRsrCHmA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.3 11/13] docs: Set minimal gtags / GNU GLOBAL version to 6.6.5
Date: Mon,  3 Jul 2023 20:54:21 +0200
Message-ID: <20230703184519.535934727@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.206275653@linuxfoundation.org>
References: <20230703184519.206275653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ahmed S. Darwish <darwi@linutronix.de>

commit b230235b386589d8f0d631b1c77a95ca79bb0732 upstream.

Kernel build now uses the gtags "-C (--directory)" option, available
since GNU GLOBAL v6.6.5.  Update the documentation accordingly.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lists.gnu.org/archive/html/info-global/2020-09/msg00000.html
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/changes.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/process/changes.rst
+++ b/Documentation/process/changes.rst
@@ -60,6 +60,7 @@ openssl & libcrypto    1.0.0
 bc                     1.06.95          bc --version
 Sphinx\ [#f1]_         1.7              sphinx-build --version
 cpio                   any              cpio --version
+gtags (optional)       6.6.5            gtags --version
 ====================== ===============  ========================================
 
 .. [#f1] Sphinx is needed only to build the Kernel documentation
@@ -174,6 +175,12 @@ You will need openssl to build kernels 3
 enabled.  You will also need openssl development packages to build kernels 4.3
 and higher.
 
+gtags / GNU GLOBAL (optional)
+-----------------------------
+
+The kernel build requires GNU GLOBAL version 6.6.5 or later to generate
+tag files through ``make gtags``.  This is due to its use of the gtags
+``-C (--directory)`` flag.
 
 System utilities
 ****************


