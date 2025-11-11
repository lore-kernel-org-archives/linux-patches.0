Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8CB4C97;
	Tue, 11 Nov 2025 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822301; cv=none; b=VkWW2Egcf6P8YFzsI1tbmHJscN/zYWoEBLyc5kWhoDC/VZswQkreUeFIWNW5gowZZwsZOHvHqBJpwXHrGGiHOWvnPUF0LOSPLCYQMgLFjpGnRbeNywyOMfUZHzMbUs5NBQZ/NAx6f1IAx01tAUub3hMl7KEqY9V48XjwtYWXp00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822301; c=relaxed/simple;
	bh=ew3SR2q4pCAr9Chx0IMFMVd9Xo6LHMiS4dLcB7zXDig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQRtGP9TLAYXY6gC6Sr3nKgafdao+3I1ssCqbhhfasIE2jYh8dEj02DsEcR1XzHppSR23ZBuBsAwb/1dSaGt4wFUaHpgBAf3ca8zR0w0WuprTKdHWLw5znHHdszzOIDwl6vE6d0siBnr1LNz+srfnADSpBs6T81sQ49i9EiM1Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHiU0HpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHiU0HpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D2EC4CEF5;
	Tue, 11 Nov 2025 00:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822301;
	bh=ew3SR2q4pCAr9Chx0IMFMVd9Xo6LHMiS4dLcB7zXDig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHiU0HpJToMXFe1P3dZwDV2HNAJ5R4k7mO08CxQ+LSH9DzIf93RJdBxBOgLdI9zLs
	 KYdYm5kHQY+mdoNWYqd1Hk/keSRb4uXwARu6RQErHKiC6O5dN+wN8enndg0+A6ybEt
	 q7yMOpx0cK60V1KOaSfGlb1j3BspWxOJxMP9kAzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 076/849] dpll: spec: add missing module-name and clock-id to pin-get reply
Date: Tue, 11 Nov 2025 09:34:06 +0900
Message-ID: <20251111004538.260203057@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 520ad9e96937e825a117e9f00dd35a3e199d67b5 ]

The dpll.yaml spec incorrectly omitted module-name and clock-id from the
pin-get operation reply specification, even though the kernel DPLL
implementation has always included these attributes in pin-get responses
since the initial implementation.

This spec inconsistency caused issues with the C YNL code generator.
The generated dpll_pin_get_rsp structure was missing these fields.

Fix the spec by adding module-name and clock-id to the pin-attrs reply
specification to match the actual kernel behavior.

Fixes: 3badff3a25d8 ("dpll: spec: Add Netlink spec in YAML")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20251024185512.363376-1-poros@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/dpll.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
index 5decee61a2c4c..0159091dde966 100644
--- a/Documentation/netlink/specs/dpll.yaml
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -599,6 +599,8 @@ operations:
         reply: &pin-attrs
           attributes:
             - id
+            - module-name
+            - clock-id
             - board-label
             - panel-label
             - package-label
-- 
2.51.0



