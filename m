Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BE42550C8;
	Thu, 17 Apr 2025 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916171; cv=none; b=Trr+Q+wBSBgb2lFIbDJAIOCPMt0F+q9YACLKf7ffY3/BOyQoEUz94NYDFAFSHp4jwitQm6paa/4uhyfH9Lz/cyvlPFnUpqAbhcq/mUoA0FTlLjBj7mB9Snl2z/1KGidrRZs/bns4mk3AAqH07GH2TkkH+JfDioyYN8cuO1MqpVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916171; c=relaxed/simple;
	bh=0tdx/rTuMziHk6GeX6nbHBDaVTXdYJJiRYj5AtM5K+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2bmdhvduP22bixvHa9j+4tGXlqVv26l+rFIrk/0+cV/FdsLpYDPIvnDTNpvAm+CyA5m1ugPATe2mMQ0pL52ghm4oThMOHuFVxQ51OTQxGOGb6kCRzUstZoY+0ECFSxEW5dX038vNOZN3jg729w4omBQuTU+UbGswVsJoM1FPZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEO5Z9x0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEO5Z9x0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CF6C4CEEA;
	Thu, 17 Apr 2025 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916171;
	bh=0tdx/rTuMziHk6GeX6nbHBDaVTXdYJJiRYj5AtM5K+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEO5Z9x0gqV+ZvnLij04U7t8+2u6jdLrIU0jSMoIf7aJycsBLgYXm6YJWn+JnLJLI
	 GfcMn5ONvVgbD8jmhDVgjnvSNt6Dbm4te2rauUlqYtoEcT4UMtTr9t3mq78VOK55Gb
	 w1XN2OcdXZHUIdJ0ehVZysKGMYCfE5jaTRpka6Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.12 349/393] landlock: Add erratum for TCP fix
Date: Thu, 17 Apr 2025 19:52:38 +0200
Message-ID: <20250417175121.636829117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 48fce74fe209ba9e9b416d7100ccee546edc9fc6 upstream.

Add erratum for the TCP socket identification fixed with commit
854277e2cc8c ("landlock: Fix non-TCP sockets restriction").

Fixes: 854277e2cc8c ("landlock: Fix non-TCP sockets restriction")
Cc: Günther Noack <gnoack@google.com>
Cc: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-4-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/errata/abi-4.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 security/landlock/errata/abi-4.h

diff --git a/security/landlock/errata/abi-4.h b/security/landlock/errata/abi-4.h
new file mode 100644
index 000000000000..c052ee54f89f
--- /dev/null
+++ b/security/landlock/errata/abi-4.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/**
+ * DOC: erratum_1
+ *
+ * Erratum 1: TCP socket identification
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This fix addresses an issue where IPv4 and IPv6 stream sockets (e.g., SMC,
+ * MPTCP, or SCTP) were incorrectly restricted by TCP access rights during
+ * :manpage:`bind(2)` and :manpage:`connect(2)` operations. This change ensures
+ * that only TCP sockets are subject to TCP access rights, allowing other
+ * protocols to operate without unnecessary restrictions.
+ */
+LANDLOCK_ERRATUM(1)
-- 
2.49.0



