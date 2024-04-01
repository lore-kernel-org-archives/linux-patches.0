Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79784778E;
	Mon,  1 Apr 2024 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986853; cv=none; b=RjBx8KDQ5wm9wrX3xqd7mQpePLArM7UYaQDnL09EEvKBnyObML6BK1TMySod1dvYbqHF+5X9wjFn2tizw9RlqUURIv3bFGkLQ76hsMjHIL5ks/e2TzK7EOhDmSmEIQXXL8caf5bQdsTlSGmzCkdaMzNuKMsuKQ9+xgfXxGrdkR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986853; c=relaxed/simple;
	bh=fN7MsE6SdYUY3OhJ8dlc71bX6GldCeADOfdYCTxq0YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYC+E9buTLG10HVwHLBY7q7H8QnDXFil9VPRcuV3xTHPjU6UBgxD04WzqV8obL581sgsqDZj0PfM796TlgBYduifS7OIf2ez/7B7WslytxvAh1a9aSQiB9c3wc30xmF+0Q8O0m5wMx7/Dc7WwWZnPackcfzjqYnP9+hK0e1VWgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srndzm/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srndzm/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320D1C433F1;
	Mon,  1 Apr 2024 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986853;
	bh=fN7MsE6SdYUY3OhJ8dlc71bX6GldCeADOfdYCTxq0YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srndzm/6upNiMQYoLeV6O+CXNCDWfJdovla+3CJUGHY7M/dueO9CxhX4OVcaPfsI1
	 mm7SMojwksKkqKwGQGSZGcN++hiRd1zo/aYYyX+LXGuU3Ghjs80HmEvaX0haY2PtMR
	 R5Tcy75R941ewwIIkn00ill9fIeKBV0Spf78CeqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 099/399] docs: Makefile: Add dependency to $(YNL_INDEX) for targets other than htmldocs
Date: Mon,  1 Apr 2024 17:41:05 +0200
Message-ID: <20240401152552.139094229@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Yokosawa <akiyks@gmail.com>

[ Upstream commit a304fa1d10fcb974c117d391e5b4d34c2baa9a62 ]

Commit f061c9f7d058 ("Documentation: Document each netlink family")
added recipes for YAML -> RST conversion.
Then commit 7da8bdbf8f5d ("docs: Makefile: Fix make cleandocs by
deleting generated .rst files") made sure those converted .rst files
are cleaned by "make cleandocs".

However, they took care of htmldocs build only.

If one of other targets such as latexdocs or epubdocs is built
without building htmldocs, missing .rst files can cause additional
WARNINGs from sphinx-build as follow:

    ./Documentation/userspace-api/netlink/specs.rst:18: WARNING: undefined label: 'specs'
    ./Documentation/userspace-api/netlink/netlink-raw.rst:64: WARNING: unknown document: '../../networking/netlink_spec/rt_link'
    ./Documentation/userspace-api/netlink/netlink-raw.rst:64: WARNING: unknown document: '../../networking/netlink_spec/tc'
    ./Documentation/userspace-api/netlink/index.rst:21: WARNING: undefined label: 'specs'

Add dependency to $(YNL_INDEX) for other targets and allow any targets
to be built cleanly right after "make cleandocs".

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: stable@vger.kernel.org  # v6.7
Cc: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Reviwed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <e876e3c8-109d-4bc8-9916-05a4bc4ee9ac@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 3885bbe260eb2..99cb6cbccb135 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -111,7 +111,9 @@ $(YNL_INDEX): $(YNL_RST_FILES)
 $(YNL_RST_DIR)/%.rst: $(YNL_YAML_DIR)/%.yaml $(YNL_TOOL)
 	$(Q)$(YNL_TOOL) -i $< -o $@
 
-htmldocs: $(YNL_INDEX)
+htmldocs texinfodocs latexdocs epubdocs xmldocs: $(YNL_INDEX)
+
+htmldocs:
 	@$(srctree)/scripts/sphinx-pre-install --version-check
 	@+$(foreach var,$(SPHINXDIRS),$(call loop_cmd,sphinx,html,$(var),,$(var)))
 
-- 
2.43.0



