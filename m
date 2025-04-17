Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC622E3E6;
	Thu, 17 Apr 2025 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913649; cv=none; b=iNtUWgPFrLdGAEIJw1j10WCBLkFoXNBTuub9/EuKkl3Qu6stB/Z6ClwK9UTe5WRP3JBjKPoXLrHptbfUX22tI0+Kjgx2QJxrHrpP11XeNz+ts1DSfmrYu6xAjagR/++h2rRg6JWX7FUxnEJtjaWvkUErGGegJTwT3ozh4I48+Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913649; c=relaxed/simple;
	bh=8BpxlkHn4FrxDSIusNmemUJqbuXHZLzXQlsJ/ZKk7Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qO0rIMOz+B0Meo3T0TAozz9bEiohLfMelnq64sgb1NkKhZ/uXt/WUGOsqLCmr9lvMwEA5bD0gh7A6vau341H4ueGXYCWWMIrGa+AWhRrqYy8J1lLHZXk/bSVEBXbp1ss9NOhOTxZj4DG4Vvmxualj37CtrWvOwkveuFfiOFDNSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYxzKx2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYxzKx2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD53C4CEE4;
	Thu, 17 Apr 2025 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913649;
	bh=8BpxlkHn4FrxDSIusNmemUJqbuXHZLzXQlsJ/ZKk7Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYxzKx2hoZ5wgo0pSZLIitw1NuqfDFpt6W3cudfTFYXFde0IlehU3uUxnPeAVDYR7
	 fHtSnuzJFEJTg6aHqeW6lGu4pO3n/RWTP7/jvp/IT9kvp4w4u0tmrW1JrYDpUYPuWy
	 l6WE23MmYspfbiEcbfXZukF2HwIidtejGfrxuMwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.14 408/449] landlock: Add erratum for TCP fix
Date: Thu, 17 Apr 2025 19:51:36 +0200
Message-ID: <20250417175134.697680432@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 security/landlock/errata/abi-4.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 security/landlock/errata/abi-4.h

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


