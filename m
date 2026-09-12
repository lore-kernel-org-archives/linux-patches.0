Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73173859CE;
	Sat, 12 Sep 2026 07:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199894; cv=none; b=Xxfw7lAHSyxPF0JSQldi+KcEM/QZbD9KuNEn7O9E3vTvsZh4mr4oqmFL5ih2VgH8ahEw6XYxn81RBqhnEe7BhmEJWEtJccsuBotBa7zYCjxmc4be1xb3Gr8vG2i87e8k3dykgq+YEB+nApTlXRsiQAqBgr8M8Fe0V+rtXGarmkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199894; c=relaxed/simple;
	bh=ifNi6J/97F47ortvIzaJVecknTK+BnE55K+rx7cBQwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qs5l+KGLbsxGSvYXK8CGnDA3GG7Pc+BOFvlB6jo+0oc1bTgRiE5O7WY1drRaXvtfo1XGuX0MjtxnXo7l+RuXnsoPmx6zm72xEvF8N5BWzcxLkMtqJYy4VRtqXS47AR7GvJQRGQ8MJgUBVDQ3n45Jt8lCnZQarmbhgvoH0ZNDDQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CspGIz3F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CspGIz3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7E21F000FF;
	Sat, 12 Sep 2026 07:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199892;
	bh=Rq28bSlXRdq3ek74C9UWdjWtFDUKJUdzb9kdiCHH6oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CspGIz3F7QntRykhKxa8BkNSRcj9uZwMSfR9EnSLs3dzR2A+SgPrRZf44Ixify8Qq
	 K/MhFUAqQLdidXFRcmDgL/mUuJ7Nc+2acy0DZuFgkW7TcyjmgvzQGjUxK3QR25zDFU
	 zXgR/kEmvwR6x0Fd+jE+b/G3jvihCmmxvOgFj+J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Saverio Miroddi <saverio.pub2@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0676/1815] ACPI: bus: Avoid confusing complaints regarding missing _OSC features
Date: Sat, 12 Sep 2026 08:40:26 +0200
Message-ID: <20260912065704.756647169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 9bfb23e0661be3d6a72aedde08a9f0fec2e8041a ]

The platform firmware on some platforms sets OSC_CAPABILITIES_MASK_ERROR
in _OSC error bits even though it actually acknowledges all of the
requested features which after commit e5322888e6bf ("ACPI: bus: Rework
the handling of \_SB._OSC platform features") causes the kernel to
complain unnecessarily.

Avoid the confusing complaints by explicitly checking for that case
in acpi_osc_handshake().

Fixes: e5322888e6bf ("ACPI: bus: Rework the handling of \_SB._OSC platform features")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Saverio Miroddi <saverio.pub2@gmail.com>
[ rjw: Fixed a typo in the new comment ]
Link: https://patch.msgid.link/6315683.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index a30a904f6535f..8614b8140ef71 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -335,7 +335,7 @@ static int acpi_osc_handshake(acpi_handle handle, const char *uuid_str,
 		.length = bufsize * sizeof(u32),
 	};
 	struct acpi_buffer output;
-	u32 *retbuf, test;
+	u32 *retbuf, test, errors;
 	guid_t guid;
 	int ret, i;
 
@@ -395,10 +395,18 @@ static int acpi_osc_handshake(acpi_handle handle, const char *uuid_str,
 	 * Clear the feature bits in capbuf[] that have not been acknowledged.
 	 * After that, capbuf[] contains the resultant feature mask.
 	 */
-	for (i = OSC_QUERY_DWORD + 1; i < bufsize; i++)
+	for (i = OSC_QUERY_DWORD + 1, test = 0; i < bufsize; i++) {
+		test |= capbuf[i] & ~retbuf[i];
 		capbuf[i] &= retbuf[i];
+	}
 
-	if (retbuf[OSC_QUERY_DWORD] & OSC_ERROR_MASK) {
+	errors = retbuf[OSC_QUERY_DWORD] & OSC_ERROR_MASK;
+	/*
+	 * Some platforms set OSC_CAPABILITIES_MASK_ERROR even though they
+	 * acknowledge all of the requested features, so avoid complaining in
+	 * those cases unless any other error bits are also set.
+	 */
+	if (errors && (test || errors != OSC_CAPABILITIES_MASK_ERROR)) {
 		/*
 		 * Complain about the unexpected errors and print diagnostic
 		 * information related to them.
-- 
2.53.0



